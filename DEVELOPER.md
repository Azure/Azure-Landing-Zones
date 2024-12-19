# Developer Guide

## Prerequisites

You will need Hugo installed on your machine to build the documentation. You can download Hugo from the [Hugo website](https://gohugo.io/installation/).
Make sure you install the same version as the one specified in the `.github/workflows/hugo.yml` file.

## Creating a local HTTP server

To create a local HTTP server, if you are on Linux and have GNU make installed, run the following command:

```bash
make server
```

Alternatively, you can run the following commands on Linux or Windows:

```bash
cd docs
hugo server
```

```pwsh
cd docs
hugo server
```

The server will start and you can access the documentation at <http://localhost:1313/Azure-Landing-Zones/>.

You can stop the server by pressing `Ctrl+C`.
