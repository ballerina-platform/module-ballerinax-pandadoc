## Overview

[PandaDoc](https://www.pandadoc.com/) is a document automation platform for creating, sending, e-signing and tracking proposals, quotes and contracts from reusable templates.

The PandaDoc connector lets Ballerina applications work with the PandaDoc Public API (version 8.20.0). It covers documents, templates, content library items, folders, contacts, recipients, webhooks, notarization, the product catalog, quotes and workspace administration.

### Key features

- Create documents from templates or uploaded files, send them for signature and track their status
- Manage templates, content library items and the folders that organize them
- Add, update and reassign recipients, fields, attachments and linked objects on documents
- Subscribe to document and template events through webhooks and read webhook event history
- Administer workspaces, users, members and API keys, and manage the product catalog and quotes

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

The `PandaDoc` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](../examples/), covering the following use cases:

1. [Contract send workflow](../examples/contract_send_workflow/contract_send_workflow.md) - Create a document from a template, wait until it is ready, optionally send it for signature and read back its details.
2. [Webhook subscription setup](../examples/webhook_subscription_setup/webhook_subscription_setup.md) - Make sure a webhook subscription exists, read it back and optionally remove it.
