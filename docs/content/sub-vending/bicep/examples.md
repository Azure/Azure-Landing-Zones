---
title: Examples
weight: 40
geekdocCollapseSection: true
---

The module's examples are documented in it's `README.md` file in the BRM repository [here.](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending#usage-examples)

As the module is published as an AVM module, you can reference it directly from the Bicep public registry as shown in the below snippet:

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  params: { (...) }
}
```

Replace `<version>` with the desired version of the module.