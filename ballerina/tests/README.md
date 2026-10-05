# Running Tests

## Prerequisites

To run the tests against the live PandaDoc API you need a PandaDoc API key. Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-pandadoc/blob/main/ballerina/README.md#setup-guide) to obtain one, then export it:

```bash
export IS_LIVE_SERVER=true
export PANDADOC_API_KEY="API-Key <your-api-key>"
```

## Test environments

There are two test environments. The default is a mock server for the PandaDoc API. The other is the live PandaDoc API.

 Test Groups | Environment
-------------|------------------------------------------------
 mock_tests  | Mock server for PandaDoc API (default)
 live_tests  | PandaDoc API

## Running tests against the mock server

No configuration is needed. When `IS_LIVE_SERVER` is not set to `true`, the tests run against the mock server on port `9090`.

```bash
./gradlew clean test
```

## Running tests against the live API

Only the read-only tests are part of the `live_tests` group (listing documents, templates, contacts, members, webhook subscriptions, folders, content library items and forms).

```bash
./gradlew clean test -Pgroups=live_tests
```
