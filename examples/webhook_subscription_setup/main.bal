import ballerina/io;
import ballerinax/pandadoc;

configurable string apiKey = ?;
configurable string webhookName = ?;
configurable string webhookUrl = ?;
configurable boolean deleteAfterCheck = false;
configurable boolean deleteExisting = false;

final pandadoc:WebhookSubscriptionTriggerEnum[] requiredTriggers =
    ["document_state_changed", "recipient_completed", "document_completed_pdf_ready"];

public function main() returns error? {
    pandadoc:Client pandadoc = check new ({auth: {authorization: "API-Key " + apiKey}});

    // Step 1: Look for an existing subscription with the same name.
    pandadoc:WebhookSubscriptionListResponse existing = check pandadoc->listWebhookSubscriptions();
    string subscriptionId = "";
    boolean createdThisRun = false;
    foreach pandadoc:WebhookSubscriptionItemResponse item in existing?.items ?: [] {
        if item?.name == webhookName {
            subscriptionId = item?.uuid ?: "";
            io:println("Found existing subscription: ", subscriptionId);
            // Step 1a: Bring the subscription in line if its URL, triggers or status differ.
            if subscriptionId != "" && !isUsable(item) {
                _ = check pandadoc->updateWebhookSubscription(subscriptionId, {
                    url: webhookUrl,
                    triggers: requiredTriggers,
                    active: true
                });
                io:println("Updated mismatched subscription: ", subscriptionId);
            }
            break;
        }
    }

    // Step 2: Create the subscription when it does not exist yet.
    if subscriptionId == "" {
        pandadoc:WebhookSubscriptionItemResponse created = check pandadoc->createWebhookSubscription({
            name: webhookName,
            url: webhookUrl,
            triggers: requiredTriggers
        });
        subscriptionId = created?.uuid ?: "";
        if subscriptionId == "" {
            return error("PandaDoc did not return a subscription ID");
        }
        createdThisRun = true;
        io:println("Created subscription: ", subscriptionId);
    }

    // Step 3: Read the subscription back.
    pandadoc:WebhookSubscriptionItemResponse details = check pandadoc->getWebhookSubscriptionDetails(subscriptionId);
    io:println("Subscription URL: ", details?.url ?: "");
    io:println("Subscription status: ", details?.status ?: "");

    // Step 4: Remove the subscription only when explicitly enabled. A subscription found by
    // lookup is deleted only when `deleteExisting` is also set.
    if deleteAfterCheck && (createdThisRun || deleteExisting) {
        check pandadoc->deleteWebhookSubscription(subscriptionId);
        io:println("Deleted subscription: ", subscriptionId);
    } else if deleteAfterCheck {
        io:println("Kept pre-existing subscription; set deleteExisting to remove it: ", subscriptionId);
    }
}

// A found subscription is usable when it points at the requested URL, is active, and
// listens to every required trigger.
function isUsable(pandadoc:WebhookSubscriptionItemResponse item) returns boolean {
    pandadoc:WebhookSubscriptionTriggerEnum[] triggers = item?.triggers ?: [];
    foreach pandadoc:WebhookSubscriptionTriggerEnum trigger in requiredTriggers {
        if triggers.indexOf(trigger) is () {
            return false;
        }
    }
    return item?.url == webhookUrl && item?.active == true && item?.status == "ACTIVE";
}
