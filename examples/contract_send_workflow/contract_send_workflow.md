# Contract send workflow

This example creates a PandaDoc document from a template for a recipient, waits until the document is ready as a draft, optionally sends it for signature, and reads back the final document details.

## Prerequisites

### 1. Set up PandaDoc credentials

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-pandadoc/blob/main/ballerina/README.md#setup-guide) to obtain an API key.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
apiKey = "<api-key>"
templateUuid = "<template-uuid>"
recipientEmail = "<recipient-email>"
recipientFirstName = "<recipient-first-name>"
recipientLastName = "<recipient-last-name>"
recipientRole = "<template-role-name>"
documentName = "<document-name>"
sendDocument = false
```

Set `sendDocument` to `true` to send the document to the recipient.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
