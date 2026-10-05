import ballerina/io;
import ballerinax/pandadoc;

configurable string apiKey = ?;
configurable string webhookName = ?;
configurable string webhookUrl = ?;
configurable boolean deleteAfterCheck = false;

public function main() returns error? {
    pandadoc:Client pandadoc = check new ({auth: {authorization: "API-Key " + apiKey}});

    // Step 1: Look for an existing subscription with the same name.
    pandadoc:WebhookSubscriptionListResponse existing = check pandadoc->listWebhookSubscriptions();
    string subscriptionId = "";
    foreach pandadoc:WebhookSubscriptionItemResponse item in existing?.items ?: [] {
        if item?.name == webhookName {
            subscriptionId = item?.uuid ?: "";
            io:println("Found existing subscription: ", subscriptionId);
            break;
        }
    }

    // Step 2: Create the subscription when it does not exist yet.
    if subscriptionId == "" {
        pandadoc:WebhookSubscriptionItemResponse created = check pandadoc->createWebhookSubscription({
            name: webhookName,
            url: webhookUrl,
            triggers: ["document_state_changed", "recipient_completed", "document_completed_pdf_ready"]
        });
        subscriptionId = created?.uuid ?: "";
        if subscriptionId == "" {
            return error("PandaDoc did not return a subscription ID");
        }
        io:println("Created subscription: ", subscriptionId);
    }

    // Step 3: Read the subscription back.
    pandadoc:WebhookSubscriptionItemResponse details = check pandadoc->getWebhookSubscriptionDetails(subscriptionId);
    io:println("Subscription URL: ", details?.url ?: "");
    io:println("Subscription status: ", details?.status ?: "");

    // Step 4: Remove the subscription only when explicitly enabled.
    if deleteAfterCheck {
        check pandadoc->deleteWebhookSubscription(subscriptionId);
        io:println("Deleted subscription: ", subscriptionId);
    }
}
