# Webhook subscription setup

This example makes sure a PandaDoc webhook subscription exists. It looks for a subscription by name, creates it for document state changes and recipient completion when it is missing, reads it back, and optionally deletes it.

## Prerequisites

### 1. Set up PandaDoc credentials

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-pandadoc/blob/main/ballerina/README.md#setup-guide) to obtain an API key.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
apiKey = "<api-key>"
webhookName = "<subscription-name>"
webhookUrl = "<https-endpoint-that-receives-events>"
deleteAfterCheck = false
```

Set `deleteAfterCheck` to `true` to remove the subscription at the end of the run.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
