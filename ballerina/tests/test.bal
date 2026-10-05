
// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.pandadoc.com" : "http://localhost:9090";
final string apiKey = isLiveServer ? os:getEnv("PANDADOC_API_KEY") : "API-Key test_key";

final Client pandadoc = check new ({auth: {authorization: apiKey}, httpVersion: http:HTTP_1_1}, serviceUrl);

const string DOCUMENT_ID = "BhVzRcxH9Z2LgfPPGXFUBa";

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListDocuments() returns error? {
    DocumentListResponse response = check pandadoc->listDocuments();
    test:assertTrue(response?.results is DocumentListResponseResults[]);
    test:assertTrue((response?.results ?: []).length() > 0);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateDocument() returns error? {
    DocumentCreateByTemplateRequest payload = {
        name: "Sales Agreement - Northwind",
        templateUuid: "tpl_Hm4k2LpQ9r",
        recipients: [{email: "liam.chen@example.com", firstName: "Liam", lastName: "Chen", role: "Client"}]
    };
    DocumentCreateResponse response = check pandadoc->createDocument(payload);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetDocumentStatus() returns error? {
    DocumentStatusResponse response = check pandadoc->getDocumentStatus(DOCUMENT_ID);
    test:assertEquals(response?.id, DOCUMENT_ID);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetDocumentDetails() returns error? {
    DocumentDetailsResponse response = check pandadoc->getDocumentDetails(DOCUMENT_ID);
    test:assertEquals(response?.id, DOCUMENT_ID);
    test:assertTrue(response?.name is string);
}

@test:Config {groups: ["mock_tests"]}
isolated function testSendDocument() returns error? {
    DocumentSendResponse response = check pandadoc->sendDocument(DOCUMENT_ID, {subject: "Please sign", message: "Agreement attached"});
    test:assertEquals(response?.status, "document.sent");
}

@test:Config {groups: ["mock_tests"]}
isolated function testDeleteDocument() returns error? {
    DocumentCreateByTemplateRequest payload = {
        name: "Sales Agreement - Northwind",
        templateUuid: "tpl_Hm4k2LpQ9r",
        recipients: [{email: "liam.chen@example.com", firstName: "Liam", lastName: "Chen", role: "Client"}]
    };
    DocumentCreateResponse created = check pandadoc->createDocument(payload);
    error? response = pandadoc->deleteDocument(created?.id ?: DOCUMENT_ID);
    test:assertTrue(response is ());
}

@test:Config {groups: ["mock_tests"]}
isolated function testListDocumentAttachments() returns error? {
    DocumentAttachmentResponse[] response = check pandadoc->listDocumentAttachments(DOCUMENT_ID);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListTemplates() returns error? {
    TemplateListResponse response = check pandadoc->listTemplates();
    test:assertTrue(response?.results is TemplateCreateResponse[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetTemplateDetails() returns error? {
    TemplateDetailsResponse response = check pandadoc->getTemplateDetails("tpl_Hm4k2LpQ9r");
    test:assertEquals(response?.id, "tpl_Hm4k2LpQ9r");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListTemplateFolders() returns error? {
    TemplatesFolderListResponse response = check pandadoc->listTemplateFolders();
    test:assertTrue(response?.results is TemplatesFolderListResponseResults[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListContacts() returns error? {
    ContactListResponse response = check pandadoc->listContacts();
    test:assertTrue(response?.results is ContactDetailsResponse[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateContact() returns error? {
    ContactDetailsResponse response = check pandadoc->createContact({firstName: "Noah", lastName: "Reed", email: "noah.reed@example.com"});
    test:assertEquals(response?.email, "noah.reed@example.com");
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetContactDetails() returns error? {
    ContactDetailsResponse response = check pandadoc->getContactDetails("cont_8f3a21");
    test:assertEquals(response?.id, "cont_8f3a21");
}

@test:Config {groups: ["mock_tests"]}
isolated function testUpdateContact() returns error? {
    ContactDetailsResponse response = check pandadoc->updateContact("cont_8f3a21", {firstName: "Ava", lastName: "Stone"});
    test:assertEquals(response?.lastName, "Stone");
}

@test:Config {groups: ["mock_tests"]}
isolated function testDeleteContact() returns error? {
    ContactDetailsResponse created = check pandadoc->createContact({firstName: "Noah", lastName: "Reed", email: "noah.reed@example.com"});
    error? response = pandadoc->deleteContact(created?.id ?: "cont_d27e55");
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListMembers() returns error? {
    MemberListResponse response = check pandadoc->listMembers();
    test:assertTrue(response?.results is MemberDetailsResponse[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetCurrentMemberDetails() returns error? {
    MemberDetailsResponse response = check pandadoc->getCurrentMemberDetails();
    test:assertTrue(response?.membershipId is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListWebhookSubscriptions() returns error? {
    WebhookSubscriptionListResponse response = check pandadoc->listWebhookSubscriptions();
    test:assertTrue(response?.items is WebhookSubscriptionItemResponse[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateWebhookSubscription() returns error? {
    WebhookSubscriptionItemResponse response = check pandadoc->createWebhookSubscription({
        name: "Document state tracker",
        url: "https://hooks.example.com/pandadoc",
        triggers: ["document_state_changed"]
    });
    test:assertEquals(response?.name, "Document state tracker");
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetWebhookSubscriptionDetails() returns error? {
    WebhookSubscriptionItemResponse response = check pandadoc->getWebhookSubscriptionDetails("9c1d7e52-4a0b-4c1e-8d77-1f2b6a9e3c10");
    test:assertEquals(response?.uuid, "9c1d7e52-4a0b-4c1e-8d77-1f2b6a9e3c10");
}

@test:Config {groups: ["mock_tests"]}
isolated function testDeleteWebhookSubscription() returns error? {
    WebhookSubscriptionItemResponse created = check pandadoc->createWebhookSubscription({
        name: "Document state tracker",
        url: "https://hooks.example.com/pandadoc",
        triggers: ["document_state_changed"]
    });
    error? response = pandadoc->deleteWebhookSubscription(created?.uuid ?: "9c1d7e52-4a0b-4c1e-8d77-1f2b6a9e3c10");
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListDocumentFolders() returns error? {
    DocumentsFolderListResponse response = check pandadoc->listDocumentFolders();
    test:assertTrue(response?.results is DocumentsFolderListResponseResults[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateDocumentFolder() returns error? {
    DocumentsFolderCreateResponse response = check pandadoc->createDocumentFolder({name: "Q2 Contracts"});
    test:assertEquals(response?.name, "Q2 Contracts");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListContentLibraryItems() returns error? {
    ContentLibraryItemListResponse response = check pandadoc->listContentLibraryItems();
    test:assertTrue(response?.results is ContentLibraryItemListResponseResults[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListForms() returns error? {
    FormListResponse response = check pandadoc->listForms();
    test:assertTrue(response?.results is FormListResponseResults[]);
}
