_Author_:  Dimuthu Madushan \
_Created_: 2026/10/05 \
_Updated_: 2026/10/05 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from PandaDoc.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/pandadoc/pandadoc/8.20.0/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Make the summaries of the v2 log operations distinct
- **Original**: `GET /public/v2/logs` and `GET /public/v2/logs/{id}` had the same summaries as their v1 counterparts (`List API Log`, `API Log Details`).
- **Updated**: The v2 summaries are `List API Log (v2)` and `API Log Details (v2)`.
- **Reason**: Operation summaries must be unique so that the generated client documents each operation distinctly.

2. Remove the duplicate `pricing_method` property from `ProductCatalogItemResponse` price configurations
- **Original**: The inline price configuration objects under `default_price_configuration` and `variants[].price_configurations[]` combine `$ref: ProductCatalogItemPriceConfiguration` with an `allOf` member that redeclares `pricing_method` as `number`, while the referenced schema already declares it as the `ProductCatalogPricingMethodEnum`.
- **Updated**: The redeclared `pricing_method` property is removed from both `allOf` members.
- **Reason**: The redeclared field has a different type than the included one, which fails to compile in Ballerina (an included field cannot be overridden by an incompatible type).

3. Give request bodies without a description a short description
- **Original**: 51 inline request bodies had no description.
- **Updated**: Each now describes the submitted payload. These descriptions are also applied to the original spec.
- **Reason**: Documents the generated client methods' payload parameters.

4. Replace generic schema names with descriptive ones
- **Original**: Flatten produced `InlineResponse*`, `*Body`, `QuoteUpdateRequestSettings1` and `DocumentAutoRemindersResponse400` schema names.
- **Updated**: They are renamed, for example `InlineResponse201` to `DocumentEditingSessionResponse`, `V1DocumentsuploadBody` to `CreateDocumentFromUploadRequest` and `Oauth2AccessTokenBody` to `AccessTokenRequest`. The decisions are stored in `ai-mappings.json`.
- **Reason**: Public record names should describe their purpose.

5. Rename path-derived and noun-first operationIds
- **Original**: IDs such as `statusDocument`, `detailsDocument`, `documentSettingsGet`, `quoteUpdate` and `getWorkspacesList`.
- **Updated**: Verb-first names (`getDocumentStatus`, `getDocumentDetails`, `getDocumentSettings`, `updateQuote`, `listWorkspaces`). The decisions are stored in `ai-mappings.json`.
- **Reason**: Consistent `list*`/`get*`/`create*`/`update*`/`delete*` naming across the client.

6. Simplify the API description
- **Original**: `info.description` was a multi-paragraph marketing and onboarding text (sandbox keys, pricing plans, getting-started guide links).
- **Updated**: `Client for the PandaDoc API. Create, send and track documents, templates, forms and e-signatures.`
- **Reason**: `info.description` becomes the generated client class's doc comment, which should briefly state what the client does.

7. Add missing parameter, response and property descriptions
- **Original**: The `workspaceId` path parameter of `deactivateWorkspace` and `addMember`, the `order_by` and `owner_ids` query parameters of `listDocumentsByLinkedObject`, and the `no_category` query parameter of `searchCatalogItems` had no description. The success responses of `listForms`, `listDocumentFolders` and `createDocumentFolder` had an empty description. Properties of `RecipientPersonalDetails`, `DocumentDetailsRecipientGroupMember`, `RecipientAssignedTo`, `RecipientsGroupAssignedTo`, `RecipientVerificationSettings` (including its inline `kba_verification` and `id_verification`), the `QuotesBatchUpdateResult*` schemas, `QuoteUpdateRequestSummary`, `CollectFile`, the inline `owner` objects of `DocumentCreateByTemplateRequest`, `DocumentCreateByPdfRequest` and `CreateTemplateRequest`, `CreateUserRequest.user`, `DocumentDetailsResponse.sent_by`, `DocumentFieldOptionCreate.position`, and the inline section, item, options and price settings objects of `QuoteUpdateRequest` had no description.
- **Updated**: Each now has a short description. Where a property was a bare `$ref` (for example `redirect`, `quote`, `selection_type`), it is wrapped as `allOf: [{$ref}]` with a `description` beside it, because a description next to a `$ref` is ignored.
- **Reason**: Removes the `undocumented field`, `undocumented parameter` and `undocumented return parameter` warnings from the generated client, and documents the generated records.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```
Note: The license year is hardcoded to 2026, change if necessary.
