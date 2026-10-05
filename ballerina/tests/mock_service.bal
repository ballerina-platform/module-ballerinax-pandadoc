
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

listener http:Listener ep0 = new (9090);

isolated function getContacts() returns ContactDetailsResponse[] {
    return [
    {id: "cont_8f3a21", firstName: "Ava", lastName: "Morgan", email: "ava.morgan@example.com", company: "Northwind Traders", jobTitle: "Procurement Lead", phone: "+14155550134", city: "Austin", state: "TX", country: "US", postalCode: "78701", streetAddress: "100 Congress Ave"},
    {id: "cont_c91b07", firstName: "Liam", lastName: "Chen", email: "liam.chen@example.com", company: "Contoso Ltd", jobTitle: "Legal Counsel", phone: "+14155550199", city: "Seattle", state: "WA", country: "US", postalCode: "98101", streetAddress: "42 Pine St"}
    ];
}

isolated function getWebhookSubscription() returns WebhookSubscriptionItemResponse {
    return {
    uuid: "9c1d7e52-4a0b-4c1e-8d77-1f2b6a9e3c10",
    name: "Document state tracker",
    url: "https://hooks.example.com/pandadoc",
    active: true,
    status: "ACTIVE",
    sharedKey: "k3y_5f2a9b",
    workspaceId: "ws_41c7d2",
    triggers: ["document_state_changed", "recipient_completed"],
    payload: ["metadata", "fields"]
    };
}

@http:ServiceConfig {treatNilableAsOptional: true}
service / on ep0 {

    # Delete Contact
    #
    # + id - Contact ID
    # + return - Contact deleted
    resource function delete 'public/v1/contacts/[string id]() returns http:NoContent {
        return http:NO_CONTENT;
    }

    # Delete Document
    #
    # + id - Document ID
    # + return - Document deleted
    resource function delete 'public/v1/documents/[string id]() returns http:NoContent {
        return http:NO_CONTENT;
    }

    # List Templates Folders
    #
    # + parentUuid - Parent folder UUID
    # + page - Page number
    # + count - Page size
    # + return - List of template folders
    resource function get 'public/v1/templates/folders(@http:Query {name: "parent_uuid"} string? parentUuid, int:Signed32? page, int:Signed32 count = 50) returns TemplatesFolderListResponse {
        return {
            results: [
                {uuid: "e1f2a3b4-4444-4555-8666-777788889999", name: "Legal Templates", dateCreated: "2026-01-10T08:00:00.000000Z", hasFolders: false, hasItems: true}
            ]
        };
    }

    # Delete Webhook Subscription
    #
    # + id - Webhook subscription ID
    # + return - Subscription deleted
    resource function delete 'public/v1/webhook\-subscriptions/[string id]() returns http:NoContent {
        return http:NO_CONTENT;
    }

    # List contacts
    #
    # + email - Filter by email
    # + return - List of contacts
    resource function get 'public/v1/contacts(string? email) returns ContactListResponse {
        return {results: getContacts()};
    }

    # Contact Details
    #
    # + id - Contact ID
    # + return - Contact details
    resource function get 'public/v1/contacts/[string id]() returns ContactDetailsResponse {
        ContactDetailsResponse contact = getContacts()[0];
        contact.id = id;
        return contact;
    }

    # List Content Library Items
    #
    # + q - Search query
    # + id - Item ID filter
    # + deleted - Return deleted items
    # + folderUuid - Folder UUID filter
    # + count - Page size
    # + page - Page number
    # + tag - Tag filter
    # + return - List of content library items
    resource function get 'public/v1/content\-library\-items(string? q, string? id, boolean? deleted, @http:Query {name: "folder_uuid"} string? folderUuid, int:Signed32? count, int:Signed32? page, string? tag) returns ContentLibraryItemListResponse {
        return {
            results: [
                {id: "cli_73ab10", name: "Standard Payment Terms", dateCreated: "2026-03-02T09:15:00.000000Z", dateModified: "2026-03-10T14:20:11.000000Z", version: "2"},
                {id: "cli_88de42", name: "Confidentiality Clause", dateCreated: "2026-02-11T08:00:00.000000Z", dateModified: "2026-02-11T08:00:00.000000Z", version: "1"}
            ]
        };
    }

    # List Documents
    #
    # + templateId - Template ID filter
    # + formId - Form ID filter
    # + folderUuid - Folder UUID filter
    # + contactId - Contact ID filter
    # + count - Page size
    # + page - Page number
    # + createdFrom - Created after
    # + createdTo - Created before
    # + deleted - Return deleted documents
    # + id - Document ID filter
    # + completedFrom - Completed after
    # + completedTo - Completed before
    # + membershipId - Owner membership ID
    # + metadata - Metadata filter
    # + modifiedFrom - Modified after
    # + modifiedTo - Modified before
    # + q - Search query
    # + status - Status filter
    # + statusNe - Exclude status
    # + tag - Tag filter
    # + orderBy - Ordering field
    # + return - List of documents
    resource function get 'public/v1/documents(@http:Query {name: "template_id"} string? templateId, @http:Query {name: "form_id"} string? formId, @http:Query {name: "folder_uuid"} string? folderUuid, @http:Query {name: "contact_id"} string? contactId, int? count, int? page, @http:Query {name: "created_from"} string? createdFrom, @http:Query {name: "created_to"} string? createdTo, boolean? deleted, string? id, @http:Query {name: "completed_from"} string? completedFrom, @http:Query {name: "completed_to"} string? completedTo, @http:Query {name: "membership_id"} string? membershipId, string[]? metadata, @http:Query {name: "modified_from"} string? modifiedFrom, @http:Query {name: "modified_to"} string? modifiedTo, string? q, DocumentStatusRequestEnum? status, @http:Query {name: "status__ne"} DocumentStatusRequestEnum? statusNe, string? tag, @http:Query {name: "order_by"} DocumentOrderingFieldsEnum orderBy = "date_status_changed") returns DocumentListResponse {
        return {
            results: [
                {id: "BhVzRcxH9Z2LgfPPGXFUBa", name: "Sales Agreement - Northwind", status: "document.sent", dateCreated: "2026-04-01T10:00:00.000000Z", dateModified: "2026-04-02T12:30:00.000000Z", version: "2"},
                {id: "Ycq3WmLk7TnVbH4dZpQe8s", name: "NDA - Contoso", status: "document.completed", dateCreated: "2026-03-15T08:45:00.000000Z", dateModified: "2026-03-16T09:10:00.000000Z", dateCompleted: "2026-03-16T09:10:00.000000Z", version: "2"}
            ]
        };
    }

    # Document Status
    #
    # + id - Document ID
    # + return - Document status
    resource function get 'public/v1/documents/[string id]() returns DocumentStatusResponse {
        return {
            id,
            uuid: "3f1c9a52-7d44-4b0e-9a1f-52c1e0b8d6a7",
            name: "Sales Agreement - Northwind",
            status: "document.sent",
            dateCreated: "2026-04-01T10:00:00.000000Z",
            dateModified: "2026-04-02T12:30:00.000000Z",
            expirationDate: "2026-12-31T00:00:00.000000Z",
            version: "2"
        };
    }

    # List Document Attachments
    #
    # + id - Document ID
    # + return - List of attachments
    resource function get 'public/v1/documents/[string id]/attachments() returns DocumentAttachmentResponse[] {
        return [
            {
                uuid: "a1b2c3d4-0000-4000-8000-aabbccddeeff",
                name: "pricing-sheet.pdf",
                dateCreated: "2026-04-01T10:05:00.000000Z",
                createdBy: {id: "usr_29af", firstName: "Ava", lastName: "Morgan", email: "ava.morgan@example.com"}
            }
        ];
    }

    # Document Details
    #
    # + id - Document ID
    # + return - Document details
    resource function get 'public/v1/documents/[string id]/details() returns DocumentDetailsResponse {
        return {
            id,
            name: "Sales Agreement - Northwind",
            status: "document.sent",
            version: "2",
            refNumber: "PD-0042",
            dateCreated: "2026-04-01T10:00:00.000000Z",
            dateModified: "2026-04-02T12:30:00.000000Z",
            contentDateModified: "2026-04-01T10:20:00.000000Z",
            expirationDate: "2026-12-31T00:00:00.000000Z",
            tags: ["sales", "q2"],
            createdBy: {id: "usr_29af", membershipId: "mem_51c0", firstName: "Ava", lastName: "Morgan", email: "ava.morgan@example.com"}
        };
    }

    # List Documents Folders
    #
    # + parentUuid - Parent folder UUID
    # + page - Page number
    # + count - Page size
    # + return - List of folders
    resource function get 'public/v1/documents/folders(@http:Query {name: "parent_uuid"} string? parentUuid, int:Signed32? page, int:Signed32 count = 50) returns DocumentsFolderListResponse {
        return {
            results: [
                {uuid: "f0a1b2c3-1111-4222-8333-444455556666", name: "Sales Contracts", dateCreated: "2026-01-12T08:00:00.000000Z", hasFolders: false, hasItems: true},
                {uuid: "f9e8d7c6-2222-4333-8444-555566667777", name: "HR Documents", dateCreated: "2026-01-20T09:30:00.000000Z", hasFolders: true, hasItems: true}
            ]
        };
    }

    # List Forms
    #
    # + count - Page size
    # + page - Page number
    # + status - Status filter
    # + orderBy - Ordering field
    # + asc - Ascending order
    # + name - Name filter
    # + return - List of forms
    resource function get 'public/v1/forms(int:Signed32? count, int:Signed32? page, ("draft"|"active"|"disabled")[]? status, @http:Query {name: "order_by"} "name"|"responses"|"status"|"created_date"|"modified_date"? orderBy, boolean? asc, string? name) returns FormListResponse {
        return {
            hasNextPage: false,
            results: [
                {id: "frm_5d21a8", name: "Customer Onboarding Form", status: "active", dateCreated: "2026-02-01T10:00:00.000000Z", dateModified: "2026-02-05T11:00:00.000000Z"}
            ]
        };
    }

    # List Members
    #
    # + return - List of members
    resource function get 'public/v1/members() returns MemberListResponse {
        return {
            results: [
                {membershipId: "mem_51c0", userId: "usr_29af", firstName: "Ava", lastName: "Morgan", email: "ava.morgan@example.com", role: "Admin", isActive: true, emailsVerified: true, workspace: "ws_41c7d2", workspaceName: "Acme Sales", userLicense: "Business", dateCreated: "2025-11-01T08:00:00.000000Z", dateModified: "2026-01-04T08:00:00.000000Z"}
            ]
        };
    }

    # Current Member Details
    #
    # + return - Current member
    resource function get 'public/v1/members/current() returns MemberDetailsResponse {
        return {membershipId: "mem_51c0", userId: "usr_29af", firstName: "Ava", lastName: "Morgan", email: "ava.morgan@example.com", role: "Admin", isActive: true, emailsVerified: true, workspace: "ws_41c7d2", workspaceName: "Acme Sales", userLicense: "Business", dateCreated: "2025-11-01T08:00:00.000000Z", dateModified: "2026-01-04T08:00:00.000000Z"};
    }

    # List Templates
    #
    # + q - Search query
    # + shared - Return shared templates
    # + deleted - Return deleted templates
    # + page - Page number
    # + id - Template ID filter
    # + folderUuid - Folder UUID filter
    # + tag - Tag filter
    # + fields - Additional fields to return
    # + count - Page size
    # + return - List of templates
    resource function get 'public/v1/templates(string? q, boolean? shared, boolean? deleted, int:Signed32? page, string? id, @http:Query {name: "folder_uuid"} string? folderUuid, string[]? tag, ("content_date_modified")[]? fields, int:Signed32 count = 50) returns TemplateListResponse {
        return {
            results: [
                {id: "tpl_Hm4k2LpQ9r", name: "Master Services Agreement", version: "3", dateCreated: "2026-01-05T09:00:00.000000Z", dateModified: "2026-02-01T10:00:00.000000Z", contentDateModified: "2026-02-01T10:00:00.000000Z"},
                {id: "tpl_Wz8n5TxB3c", name: "Non-Disclosure Agreement", version: "1", dateCreated: "2026-01-07T09:30:00.000000Z", dateModified: "2026-01-07T09:30:00.000000Z", contentDateModified: "2026-01-07T09:30:00.000000Z"}
            ]
        };
    }

    # Template Details
    #
    # + id - Template ID
    # + return - Template details
    resource function get 'public/v1/templates/[string id]/details() returns TemplateDetailsResponse {
        return {
            id,
            name: "Master Services Agreement",
            version: "3",
            tags: ["legal"],
            dateCreated: "2026-01-05T09:00:00.000000Z",
            dateModified: "2026-02-01T10:00:00.000000Z",
            contentDateModified: "2026-02-01T10:00:00.000000Z",
            createdBy: {id: "usr_29af", firstName: "Ava", lastName: "Morgan", email: "ava.morgan@example.com"}
        };
    }

    # List Webhook Subscriptions
    #
    # + return - List of subscriptions
    resource function get 'public/v1/webhook\-subscriptions() returns WebhookSubscriptionListResponse {
        return {items: [getWebhookSubscription()]};
    }

    # Webhook Subscription Details
    #
    # + id - Subscription ID
    # + return - Subscription details
    resource function get 'public/v1/webhook\-subscriptions/[string id]() returns WebhookSubscriptionItemResponse {
        WebhookSubscriptionItemResponse subscription = getWebhookSubscription();
        subscription.uuid = id;
        return subscription;
    }

    # Update Contact
    #
    # + id - Contact ID
    # + payload - Contact fields to update
    # + return - Updated contact
    resource function patch 'public/v1/contacts/[string id](@http:Payload ContactUpdateRequest payload) returns ContactDetailsResponse {
        ContactDetailsResponse contact = getContacts()[0];
        contact.id = id;
        contact.firstName = payload?.firstName ?: "Ava";
        contact.lastName = payload?.lastName ?: "Morgan";
        return contact;
    }

    # Create contact
    #
    # + payload - Contact details
    # + return - Created contact
    resource function post 'public/v1/contacts(@http:Payload ContactCreateRequest payload) returns ContactDetailsResponse {
        return {id: "cont_d27e55", firstName: payload?.firstName, lastName: payload?.lastName, email: payload?.email};
    }

    # Create Document
    #
    # + editorVer - Editor version
    # + useFormFieldProperties - Use form field properties
    # + payload - Document creation details
    # + return - Created document
    resource function post 'public/v1/documents(@http:Query {name: "editor_ver"} string? editorVer, @http:Query {name: "use_form_field_properties"} string? useFormFieldProperties, @http:Payload json payload) returns DocumentCreateResponse {
        return {
            id: "BhVzRcxH9Z2LgfPPGXFUBa",
            uuid: "3f1c9a52-7d44-4b0e-9a1f-52c1e0b8d6a7",
            name: "Sales Agreement - Northwind",
            status: "document.uploaded",
            dateCreated: "2026-04-01T10:00:00.000000Z",
            dateModified: "2026-04-01T10:00:00.000000Z",
            expirationDate: (),
            version: "2",
            infoMessage: "Document is being processed",
            links: [{rel: "self", href: "https://api.pandadoc.com/public/v1/documents/BhVzRcxH9Z2LgfPPGXFUBa", 'type: "GET"}]
        };
    }

    # Send Document
    #
    # + id - Document ID
    # + payload - Message and send options
    # + return - Sent document
    resource function post 'public/v1/documents/[string id]/send(@http:Payload DocumentSendRequest payload) returns DocumentSendResponse {
        return {
            id,
            uuid: "3f1c9a52-7d44-4b0e-9a1f-52c1e0b8d6a7",
            name: "Sales Agreement - Northwind",
            status: "document.sent",
            dateCreated: "2026-04-01T10:00:00.000000Z",
            dateModified: "2026-04-02T12:30:00.000000Z",
            expirationDate: "2026-12-31T00:00:00.000000Z",
            version: "2",
            recipients: [
                {id: "rcp_71e0", firstName: "Liam", lastName: "Chen", email: "liam.chen@example.com", signingOrder: 1, sharedLink: "https://app.pandadoc.com/s/BhVzRcxH9Z2LgfPPGXFUBa"}
            ]
        };
    }

    # Create Documents Folder
    #
    # + payload - Folder details
    # + return - Created folder
    resource function post 'public/v1/documents/folders(@http:Payload DocumentsFolderCreateRequest payload) returns DocumentsFolderCreateResponse {
        return {uuid: "f5a6b7c8-3333-4444-8555-666677778888", name: payload.name, dateCreated: "2026-04-03T09:00:00.000000Z"};
    }

    # Create Webhook Subscription
    #
    # + payload - Subscription details
    # + return - Created subscription
    resource function post 'public/v1/webhook\-subscriptions(@http:Payload WebhookSubscriptionCreateRequest payload) returns WebhookSubscriptionItemResponse {
        WebhookSubscriptionItemResponse subscription = getWebhookSubscription();
        subscription.name = payload.name;
        subscription.url = payload.url;
        return subscription;
    }
}
