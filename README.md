# Ballerina PandaDoc connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-pandadoc/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-pandadoc/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-pandadoc.svg)](https://github.com/ballerina-platform/module-ballerinax-pandadoc/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/pandadoc.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fpandadoc)

## Overview

[PandaDoc](https://www.pandadoc.com/) is a document automation platform for creating, sending, e-signing and tracking proposals, quotes and contracts from reusable templates.

The PandaDoc connector lets Ballerina applications work with the PandaDoc Public API (version 8.20.0). It covers documents, templates, content library items, folders, contacts, recipients, webhooks, notarization, the product catalog, quotes and workspace administration.

## Setup guide

To use the PandaDoc connector you need a PandaDoc account with API access. If you do not have one, sign up at [PandaDoc](https://app.pandadoc.com/a/#/signup).

### Option 1: API key

1. Sign in to PandaDoc and open the **Developer Dashboard** from the account menu.
2. Open the **API Keys** page and generate a key for the Production (or Sandbox) environment.
3. Copy the key. Requests authenticate with the header value `API-Key <your-key>`.

### Option 2: OAuth 2.0

1. In the **Developer Dashboard**, register an application and note its client ID and client secret.
2. Add your redirect URI to the application settings.
3. Send the user to `https://app.pandadoc.com/oauth2/authorize?client_id=<client-id>&redirect_uri=<redirect-uri>&scope=read%20write&response_type=code`.
4. Exchange the returned authorization code at `https://api.pandadoc.com/oauth2/access_token` to obtain an access token and a refresh token.

## Quickstart

To use the `pandadoc` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/pandadoc;
```

### Step 2: Create a new connector instance

Create a `Config.toml` file with your API key.

```toml
apiKey = "<API_KEY>"
```

Then create a `pandadoc:Client` with the API key.

```ballerina
configurable string apiKey = ?;

final pandadoc:Client pandadoc = check new ({auth: {authorization: "API-Key " + apiKey}});
```

### Step 3: Invoke the connector operation

Use the client to list the templates of your workspace.

```ballerina
public function main() returns error? {
    pandadoc:TemplateListResponse _ = check pandadoc->listTemplates();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `PandaDoc` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](examples/), covering the following use cases:

1. [Contract send workflow](examples/contract_send_workflow/contract_send_workflow.md) - Create a document from a template, wait until it is ready, optionally send it for signature and read back its details.
2. [Webhook subscription setup](examples/webhook_subscription_setup/webhook_subscription_setup.md) - Make sure a webhook subscription exists, read it back and optionally remove it.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`pandadoc` package](https://central.ballerina.io/ballerinax/pandadoc/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
