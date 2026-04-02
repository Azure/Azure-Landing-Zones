<#
.SYNOPSIS
    Generates cost estimates for Azure Landing Zone scenarios using the Azure Retail Prices API.

.DESCRIPTION
    Queries the public Azure Retail Prices API (no authentication required) to build
    monthly cost estimates for each ALZ accelerator scenario. Outputs a comparison
    table and optional per-scenario breakdowns.

.PARAMETER Region
    The Azure region to use for pricing. Defaults to 'westus'.

.PARAMETER Currency
    The currency to use for pricing. Defaults to 'USD'.

.PARAMETER Scenario
    Optional. Filter to a specific scenario name (partial match). If not specified,
    all scenarios are shown.

.PARAMETER OutputMarkdownBreakdowns
    When specified, outputs a markdown breakdown table for each scenario (useful for
    embedding in documentation).

.EXAMPLE
    ./Get-ScenarioCostEstimates.ps1
    ./Get-ScenarioCostEstimates.ps1 -Region 'uksouth' -Currency 'GBP'
    ./Get-ScenarioCostEstimates.ps1 -Scenario 'SMB' -OutputMarkdownBreakdowns
#>

[CmdletBinding()]
param(
    [string]$Region = "westus",
    [string]$Currency = "USD",
    [string]$Scenario = "",
    [switch]$OutputMarkdownBreakdowns
)

$ErrorActionPreference = "Stop"

$HoursPerMonth = 730

function Get-RetailPrice {
    param(
        [string]$Filter,
        [string]$CurrencyCode = $Currency
    )

    $params = @{
        Uri  = "https://prices.azure.com/api/retail/prices"
        Body = @{
            'currencyCode' = $CurrencyCode
            '$filter'      = $Filter
        }
    }

    try {
        $response = Invoke-RestMethod @params
        if ($response.Items.Count -gt 0) {
            $item = $response.Items |
                Where-Object { $_.retailPrice -gt 0 -and $_.type -eq "Consumption" } |
                Select-Object -First 1
            if ($item) {
                return @{
                    Price    = $item.retailPrice
                    Unit     = $item.unitOfMeasure
                    Meter    = $item.meterName
                    Currency = $item.currencyCode
                }
            }
        }
    }
    catch {
        Write-Warning "Failed to query price for filter: $Filter - $_"
    }

    return $null
}

function Get-HourlyMonthlyPrice {
    param([string]$Filter)
    $result = Get-RetailPrice -Filter $Filter
    if ($null -eq $result) { return 0 }
    return [math]::Round($result.Price * $HoursPerMonth, 2)
}

function Get-FixedMonthlyPrice {
    param([string]$Filter)
    $result = Get-RetailPrice -Filter $Filter
    if ($null -eq $result) { return 0 }
    return [math]::Round($result.Price, 2)
}

Write-Host "Querying Azure Retail Prices API for region '$Region' in $Currency..." -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# Query prices for each resource type
# ============================================================================

Write-Host "  Azure Firewall Basic..." -ForegroundColor Gray
$firewallBasic = Get-HourlyMonthlyPrice -Filter "serviceName eq 'Azure Firewall' and meterName eq 'Basic Deployment' and armRegionName eq '$Region'"

Write-Host "  Azure Firewall Premium..." -ForegroundColor Gray
$firewallPremium = Get-HourlyMonthlyPrice -Filter "serviceName eq 'Azure Firewall' and meterName eq 'Premium Deployment' and armRegionName eq '$Region'"

Write-Host "  Firewall Policy (Standard)..." -ForegroundColor Gray
$firewallPolicyStandard = Get-FixedMonthlyPrice -Filter "serviceName eq 'Azure Firewall Manager' and meterName eq 'Standard Policy per Region' and armRegionName eq '$Region'"

Write-Host "  VPN Gateway (VpnGw2AZ)..." -ForegroundColor Gray
$vpnGateway = Get-HourlyMonthlyPrice -Filter "serviceName eq 'VPN Gateway' and meterName eq 'VpnGw2AZ' and armRegionName eq '$Region'"

Write-Host "  ExpressRoute Gateway (ErGw2AZ)..." -ForegroundColor Gray
$erGateway = Get-HourlyMonthlyPrice -Filter "serviceName eq 'ExpressRoute' and meterName eq 'ErGw2AZ Gateway' and armRegionName eq '$Region'"

Write-Host "  Azure Bastion (Standard)..." -ForegroundColor Gray
$bastion = Get-HourlyMonthlyPrice -Filter "serviceName eq 'Azure Bastion' and meterName eq 'Standard Gateway' and armRegionName eq '$Region'"

Write-Host "  DDoS Network Protection Plan..." -ForegroundColor Gray
# DDoS Protection Plan is not available through the Retail Prices API.
# Using the published price from https://azure.microsoft.com/pricing/details/ddos-protection/
$ddos = 2944.00
Write-Host "    (Using published price: $ddos $Currency/month - not in Retail API)" -ForegroundColor DarkGray

Write-Host "  Private DNS Resolver (Inbound Endpoint)..." -ForegroundColor Gray
$dnsResolver = Get-FixedMonthlyPrice -Filter "serviceName eq 'Azure DNS' and meterName eq 'Private Resolver Inbound Endpoint' and armRegionName eq ''"

Write-Host "  Private DNS Zone (per zone)..." -ForegroundColor Gray
$dnsZonePrice = Get-FixedMonthlyPrice -Filter "serviceName eq 'Azure DNS' and meterName eq 'Private Zone' and armRegionName eq ''"

Write-Host "  Public IP Address (Standard Static)..." -ForegroundColor Gray
$publicIp = Get-HourlyMonthlyPrice -Filter "serviceName eq 'Virtual Network' and meterName eq 'Standard IPv4 Static Public IP' and armRegionName eq '$Region'"

Write-Host "  Log Analytics (pay-per-GB)..." -ForegroundColor Gray
$logAnalyticsResult = Get-RetailPrice -Filter "serviceName eq 'Log Analytics' and meterName eq 'Pay-as-you-go Data Ingestion' and armRegionName eq '$Region'"
$logAnalyticsNote = if ($logAnalyticsResult) { "$($logAnalyticsResult.Price)/GB ingested" } else { "varies" }

Write-Host ""

# ============================================================================
# Define scenarios
# ============================================================================

$privateDnsZoneCount = 110

$scenarios = [ordered]@{
    "Multi-Region Hub & Spoke with Azure Firewall" = [ordered]@{
        "Azure Firewall (Premium) x2" = $firewallPremium * 2
        "Firewall Policy (Standard) x2" = $firewallPolicyStandard * 2
        "VPN Gateway (VpnGw2AZ) x2"    = $vpnGateway * 2
        "ExpressRoute GW (ErGw2AZ) x2" = $erGateway * 2
        "Azure Bastion (Standard) x2"  = $bastion * 2
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver x2"      = $dnsResolver * 2
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x8)"     = $publicIp * 8
    }
    "Multi-Region Virtual WAN with Azure Firewall" = [ordered]@{
        "Azure Firewall (Premium) x2" = $firewallPremium * 2
        "Firewall Policy (Standard) x2" = $firewallPolicyStandard * 2
        "VPN Gateway (VpnGw2AZ) x2"    = $vpnGateway * 2
        "ExpressRoute GW (ErGw2AZ) x2" = $erGateway * 2
        "Azure Bastion (Standard) x2"  = $bastion * 2
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver x2"      = $dnsResolver * 2
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x4)"     = $publicIp * 4
    }
    "Multi-Region Hub & Spoke with NVA *" = [ordered]@{
        "VPN Gateway (VpnGw2AZ) x2"    = $vpnGateway * 2
        "ExpressRoute GW (ErGw2AZ) x2" = $erGateway * 2
        "Azure Bastion (Standard) x2"  = $bastion * 2
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver x2"      = $dnsResolver * 2
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x6)"     = $publicIp * 6
    }
    "Multi-Region Virtual WAN with NVA *" = [ordered]@{
        "VPN Gateway (VpnGw2AZ) x2"    = $vpnGateway * 2
        "ExpressRoute GW (ErGw2AZ) x2" = $erGateway * 2
        "Azure Bastion (Standard) x2"  = $bastion * 2
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver x2"      = $dnsResolver * 2
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x2)"     = $publicIp * 2
    }
    "Management Only" = [ordered]@{
        "(No connectivity resources)"  = 0
    }
    "Single-Region Hub & Spoke with Azure Firewall" = [ordered]@{
        "Azure Firewall (Premium)"    = $firewallPremium
        "Firewall Policy (Standard)"   = $firewallPolicyStandard
        "VPN Gateway (VpnGw2AZ)"       = $vpnGateway
        "ExpressRoute GW (ErGw2AZ)"    = $erGateway
        "Azure Bastion (Standard)"     = $bastion
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver"         = $dnsResolver
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x4)"     = $publicIp * 4
    }
    "Single-Region Virtual WAN with Azure Firewall" = [ordered]@{
        "Azure Firewall (Premium)"    = $firewallPremium
        "Firewall Policy (Standard)"   = $firewallPolicyStandard
        "VPN Gateway (VpnGw2AZ)"       = $vpnGateway
        "ExpressRoute GW (ErGw2AZ)"    = $erGateway
        "Azure Bastion (Standard)"     = $bastion
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver"         = $dnsResolver
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x2)"     = $publicIp * 2
    }
    "Single-Region Hub & Spoke with NVA *" = [ordered]@{
        "VPN Gateway (VpnGw2AZ)"       = $vpnGateway
        "ExpressRoute GW (ErGw2AZ)"    = $erGateway
        "Azure Bastion (Standard)"     = $bastion
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver"         = $dnsResolver
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x3)"     = $publicIp * 3
    }
    "Single-Region Virtual WAN with NVA *" = [ordered]@{
        "VPN Gateway (VpnGw2AZ)"       = $vpnGateway
        "ExpressRoute GW (ErGw2AZ)"    = $erGateway
        "Azure Bastion (Standard)"     = $bastion
        "DDoS Protection Plan"         = $ddos
        "Private DNS Resolver"         = $dnsResolver
        "Private DNS Zones (x$privateDnsZoneCount)" = $dnsZonePrice * $privateDnsZoneCount
        "Public IP Addresses (x1)"     = $publicIp
    }
    "SMB Single-Region Hub & Spoke" = [ordered]@{
        "Azure Firewall (Basic)"       = $firewallBasic
        "VPN Gateway (VpnGw2AZ)"       = $vpnGateway
        "Public IP Addresses (x2)"     = $publicIp * 2
    }
    "SMB Single-Region Virtual WAN" = [ordered]@{
        "Azure Firewall (Basic)"       = $firewallBasic
        "VPN Gateway (VpnGw2AZ)"       = $vpnGateway
        "Public IP Addresses (x2)"     = $publicIp * 2
    }
}

$nvaNote = "`n`n\* NVA scenarios do not include the cost of the Network Virtual Appliance itself, which varies by vendor and configuration."

# Filter scenarios if requested
if ($Scenario) {
    $filtered = [ordered]@{}
    foreach ($key in $scenarios.Keys) {
        if ($key -like "*$Scenario*") {
            $filtered[$key] = $scenarios[$key]
        }
    }
    $scenarios = $filtered
    if ($scenarios.Count -eq 0) {
        Write-Error "No scenarios matched filter '$Scenario'"
        return
    }
}

$costNote = "Estimated fixed infrastructure costs based on [Azure Retail Prices](https://learn.microsoft.com/rest/api/cost-management/retail-prices/azure-retail-prices) for the **$Region** region in **$Currency** as of **$(Get-Date -Format 'yyyy-MM-dd')**. Consumption-based costs (data processing, log ingestion at $logAnalyticsNote, DNS queries, etc.) are not included and will vary based on usage. DDoS Protection Plan pricing is sourced from the [Azure DDoS Protection pricing page](https://azure.microsoft.com/pricing/details/ddos-protection/). You can generate your own estimates using the [Get-ScenarioCostEstimates.ps1](https://github.com/Azure/Azure-Landing-Zones/blob/main/utl/cost-estimates/Get-ScenarioCostEstimates.ps1) script."

# ============================================================================
# Output detailed breakdown (console)
# ============================================================================

Write-Host "=== Azure Landing Zone Scenario Cost Estimates ===" -ForegroundColor Green
Write-Host "Region: $Region | Currency: $Currency | Date: $(Get-Date -Format 'yyyy-MM-dd')" -ForegroundColor Green
Write-Host ""

foreach ($scenarioName in $scenarios.Keys) {
    $resources = $scenarios[$scenarioName]
    $total = 0

    Write-Host "--- $scenarioName ---" -ForegroundColor Yellow
    foreach ($resource in $resources.GetEnumerator()) {
        $cost = [math]::Round($resource.Value, 2)
        $total += $cost
        Write-Host ("  {0,-45} {1,10:N2} {2}/month" -f $resource.Key, $cost, $Currency)
    }
    Write-Host ("  {0,-45} {1,10:N2} {2}/month" -f "TOTAL", [math]::Round($total, 2), $Currency) -ForegroundColor Cyan
    Write-Host ""
}

# ============================================================================
# Output markdown summary table
# ============================================================================

Write-Host ""
Write-Host "=== Markdown Summary Table ===" -ForegroundColor Green
Write-Host ""

$hasNva = $scenarios.Keys | Where-Object { $_ -like '*NVA*' }

$md = @()
$md += "| Scenario | Estimated Monthly Cost ($Currency) |"
$md += "| - | -: |"

foreach ($scenarioName in $scenarios.Keys) {
    $resources = $scenarios[$scenarioName]
    $total = ($resources.Values | Measure-Object -Sum).Sum
    $md += "| $scenarioName | $([math]::Round($total, 2).ToString('N2')) |"
}

if ($hasNva) {
    $md += ""
    $md += "\* NVA scenarios do not include the cost of the Network Virtual Appliance itself, which varies by vendor and configuration."
}

$md += ""
$md += "> **Note:** $costNote"

$md | ForEach-Object { Write-Host $_ }

# ============================================================================
# Output markdown breakdown tables per scenario (optional)
# ============================================================================

if ($OutputMarkdownBreakdowns) {
    Write-Host ""
    Write-Host "=== Markdown Breakdown Tables ===" -ForegroundColor Green

    foreach ($scenarioName in $scenarios.Keys) {
        $resources = $scenarios[$scenarioName]
        $total = ($resources.Values | Measure-Object -Sum).Sum

        Write-Host ""
        Write-Host "--- $scenarioName ---" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "| Resource | Estimated Monthly Cost ($Currency) |"
        Write-Host "| - | -: |"

        foreach ($resource in $resources.GetEnumerator()) {
            $cost = [math]::Round($resource.Value, 2)
            Write-Host "| $($resource.Key) | $($cost.ToString('N2')) |"
        }

        Write-Host "| **Total** | **$([math]::Round($total, 2).ToString('N2'))** |"

        if ($scenarioName -like '*NVA*') {
            Write-Host ""
            Write-Host "\* Does not include the cost of the Network Virtual Appliance itself, which varies by vendor and configuration."
        }

        Write-Host ""
        Write-Host "> **Note:** $costNote"
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
