import ballerina/io;
import ballerina/lang.runtime;
import ballerinax/pandadoc;

configurable string apiKey = ?;
configurable string templateUuid = ?;
configurable string recipientEmail = ?;
configurable string recipientFirstName = ?;
configurable string recipientLastName = ?;
configurable string recipientRole = ?;
configurable string documentName = "Service agreement";
configurable boolean sendDocument = false;

public function main() returns error? {
    pandadoc:Client pandadoc = check new ({auth: {authorization: "API-Key " + apiKey}});

    // Step 1: Create a document from the template.
    pandadoc:DocumentCreateByTemplateRequest payload = {
        name: documentName,
        templateUuid,
        recipients: [{email: recipientEmail, firstName: recipientFirstName, lastName: recipientLastName, role: recipientRole}]
    };
    pandadoc:DocumentCreateResponse created = check pandadoc->createDocument(payload);
    string documentId = created?.id ?: "";
    if documentId == "" {
        return error("PandaDoc did not return a document ID");
    }
    io:println("Created document: ", documentId);

    // Step 2: Wait until the document has been processed and is a draft.
    string status = created?.status ?: "";
    int attempts = 0;
    while status != "document.draft" && attempts < 20 {
        runtime:sleep(2);
        pandadoc:DocumentStatusResponse current = check pandadoc->getDocumentStatus(documentId);
        status = current?.status ?: "";
        attempts += 1;
    }
    if status != "document.draft" {
        return error("Document " + documentId + " is not ready to send, last status: " + status);
    }

    // Step 3: Send the document only when explicitly enabled.
    if sendDocument {
        pandadoc:DocumentSendResponse sent = check pandadoc->sendDocument(documentId, {subject: documentName, message: "Please review and sign."});
        io:println("Sent document with status: ", sent?.status ?: "unknown");
    } else {
        io:println("Document is ready; set sendDocument = true to send it.");
    }

    // Step 4: Read back the document details.
    pandadoc:DocumentDetailsResponse details = check pandadoc->getDocumentDetails(documentId);
    io:println("Document name: ", details?.name ?: "");
    io:println("Document status: ", details?.status ?: "");
}
