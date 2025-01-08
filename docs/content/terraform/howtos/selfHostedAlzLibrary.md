---
title: Using a self-hosted ALZ Library
weight: 20
---

the [Azure Landing Zones Library](https://github.com/Azure/Azure-Landing-Zones-Library) is a collection of assets that can be used to deploy Azure Landing Zones of different flavours.
The library is hosted on GitHub and is available for use by anyone.
However, you may want to host your own copy of the library for a variety of reasons.
This guide will walk you through the process of hosting your own copy of the library and using it with the ALZ module.

{{< hint type=note >}}
We currently only support Git repositories as an alternative source for the library.
This does not have to be GitHub, it can be any Git repository.
{{< /hint >}}

## Background

The ALZ module uses the [Azure Landing Zones Library](https://github.com/Azure/Azure-Landing-Zones-Library) to resolve library references supplied to the provider.
These have two formats:

### ALZ Library References

A reference to a specific version of the library in the form of `path` and `ref` (e.g. `platform/alz` and `2024.11.0`).
These correspond to the releases in the [Azure Landing Zones Library](https://github.com/Azure/Azure-Landing-Zones-Library/releases).

### Custom Library References

A reference to a custom library in the form of `custom_url`.
This can eb a simple filepath (e.g. `${path.root}/lib`), or any supported [go-getter URL](https://github.com/hashicorp/go-getter?tab=readme-ov-file#url-format).

## Using a self-hosted ALZ Library

The brains behind the Azure Landing Zones provider is a Go module called [`alzlib`](https://github.com/Azure/alzlib).
This is [configurable](https://github.com/Azure/alzlib?tab=readme-ov-file#configuration) by environment variables, and one of these is `ALZLIB_LIBRARY_GIT_URL`.

This environment variable can be used to point the provider to a self-hosted copy of the library:

{{< tabs "set environment" >}}
{{< tab "Bash" >}}

```bash
export ALZLIB_LIBRARY_GIT_URL="github.com/MyOrg/Azure-Landing-Zones-Library"
```

{{< /tab >}}
{{< tab "PowerShell" >}}

```pwsh
$env:ALZLIB_LIBRARY_GIT_URL="github.com/MyOrg/Azure-Landing-Zones-Library"
```

{{< /tab >}}
{{< /tabs >}}

Or configure in your CI/CD pipeline.
