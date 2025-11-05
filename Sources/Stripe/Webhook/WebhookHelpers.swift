//
//  WebhookHelpers.swift
//  swift-stripe
//
//  Reusable webhook helper functions for Stripe event processing
//

import Foundation
import Stripe_Events_Types
import Stripe_Types_Shared

// MARK: - Event Type Name Extraction

extension Stripe.Events.Event.Typed {
    /// Returns the Stripe event type string for this typed event
    public var eventType: String {
        switch self {
        case .checkoutSession(let event):
            return "checkout.session.\(event.eventName)"
        case .subscription(let event):
            return "subscription.\(event.eventName)"
        case .invoice(let event):
            return "invoice.\(event.eventName)"
        case .customer(let event):
            return "customer.\(event.eventName)"
        case .paymentIntent(let event):
            return "payment_intent.\(event.eventName)"
        case .unhandled(let event):
            return event.type?.rawValue ?? "unknown"
        default:
            // For other event types, return a generic format
            // This covers all the other cases without having to implement each one
            return "event.unknown"
        }
    }

    /// Generates a unique event ID for idempotency tracking
    public var eventId: Stripe.Events.Event.ID {
        switch self {
        case .unhandled(let event):
            return event.id
        default:
            // For typed events, generate a UUID-based ID
            return "evt_\(UUID().uuidString)"
        }
    }

    /// Extracts the resource ID from the event (e.g., subscription ID, customer ID)
    public var resourceId: String? {
        switch self {
        case .checkoutSession(let event):
            return event.resourceId
        case .subscription(let event):
            return event.resourceId
        case .invoice(let event):
            return event.resourceId
        case .customer(let event):
            return event.resourceId
        case .paymentIntent(let event):
            return event.resourceId
        default:
            return nil
        }
    }
}

// MARK: - Checkout Session Events

extension Stripe.Events.Event.Typed.CheckoutSessionEvent {
    public var eventName: String {
        switch self {
        case .completed: return "completed"
        case .expired: return "expired"
        case .asyncPaymentSucceeded: return "async_payment_succeeded"
        case .asyncPaymentFailed: return "async_payment_failed"
        }
    }

    public var resourceId: String? {
        switch self {
        case .completed(let session),
            .expired(let session),
            .asyncPaymentSucceeded(let session),
            .asyncPaymentFailed(let session):
            return session.id.rawValue
        }
    }
}

// MARK: - Subscription Events

extension Stripe.Events.Event.Typed.SubscriptionEvent {
    public var eventName: String {
        switch self {
        case .created: return "created"
        case .updated: return "updated"
        case .deleted: return "deleted"
        case .paused: return "paused"
        case .resumed: return "resumed"
        case .pendingUpdateApplied: return "pending_update_applied"
        case .pendingUpdateExpired: return "pending_update_expired"
        case .trialWillEnd: return "trial_will_end"
        }
    }

    public var resourceId: String? {
        switch self {
        case .created(let subscription),
            .updated(let subscription),
            .deleted(let subscription),
            .paused(let subscription),
            .resumed(let subscription),
            .pendingUpdateApplied(let subscription),
            .pendingUpdateExpired(let subscription),
            .trialWillEnd(let subscription):
            return subscription.id.rawValue
        }
    }
}

// MARK: - Invoice Events

extension Stripe.Events.Event.Typed.InvoiceEvent {
    public var eventName: String {
        switch self {
        case .created: return "created"
        case .deleted: return "deleted"
        case .finalizationFailed: return "finalization_failed"
        case .finalized: return "finalized"
        case .markedUncollectible: return "marked_uncollectible"
        case .paid: return "paid"
        case .paymentActionRequired: return "payment_action_required"
        case .paymentFailed: return "payment_failed"
        case .paymentSucceeded: return "payment_succeeded"
        case .sent: return "sent"
        case .upcoming: return "upcoming"
        case .updated: return "updated"
        case .overdue: return "overdue"
        case .voidInvoice: return "voided"
        case .willBeDue: return "will_be_due"
        }
    }

    public var resourceId: String? {
        switch self {
        case .created(let invoice),
            .deleted(let invoice),
            .finalizationFailed(let invoice),
            .finalized(let invoice),
            .markedUncollectible(let invoice),
            .paid(let invoice),
            .paymentActionRequired(let invoice),
            .paymentFailed(let invoice),
            .paymentSucceeded(let invoice),
            .sent(let invoice),
            .upcoming(let invoice),
            .updated(let invoice),
            .overdue(let invoice),
            .voidInvoice(let invoice),
            .willBeDue(let invoice):
            return invoice.id?.rawValue
        }
    }
}

// MARK: - Customer Events

extension Stripe.Events.Event.Typed.CustomerEvent {
    public var eventName: String {
        switch self {
        case .created: return "created"
        case .updated: return "updated"
        case .deleted: return "deleted"
        case .discountCreated: return "discount.created"
        case .discountDeleted: return "discount.deleted"
        case .discountUpdated: return "discount.updated"
        case .sourceCreated: return "source.created"
        case .sourceDeleted: return "source.deleted"
        case .sourceExpiring: return "source.expiring"
        case .sourceUpdated: return "source.updated"
        case .subscriptionCreated: return "subscription.created"
        case .subscriptionDeleted: return "subscription.deleted"
        case .subscriptionPaused: return "subscription.paused"
        case .subscriptionPendingUpdateApplied: return "subscription.pending_update_applied"
        case .subscriptionPendingUpdateExpired: return "subscription.pending_update_expired"
        case .subscriptionResumed: return "subscription.resumed"
        case .subscriptionTrialWillEnd: return "subscription.trial_will_end"
        case .subscriptionUpdated: return "subscription.updated"
        case .taxIdCreated: return "tax_id.created"
        case .taxIdDeleted: return "tax_id.deleted"
        case .taxIdUpdated: return "tax_id.updated"
        }
    }

    public var resourceId: String? {
        switch self {
        case .created(let customer),
            .updated(let customer),
            .deleted(let customer),
            .discountCreated(let customer),
            .discountDeleted(let customer),
            .discountUpdated(let customer),
            .sourceCreated(let customer),
            .sourceDeleted(let customer),
            .sourceExpiring(let customer),
            .sourceUpdated(let customer),
            .taxIdCreated(let customer),
            .taxIdDeleted(let customer),
            .taxIdUpdated(let customer):
            return customer.id.rawValue
        case .subscriptionCreated(let subscription),
            .subscriptionDeleted(let subscription),
            .subscriptionPaused(let subscription),
            .subscriptionPendingUpdateApplied(let subscription),
            .subscriptionPendingUpdateExpired(let subscription),
            .subscriptionResumed(let subscription),
            .subscriptionTrialWillEnd(let subscription),
            .subscriptionUpdated(let subscription):
            // For subscription events under customer, return the subscription ID
            return subscription.id.rawValue
        }
    }
}

// MARK: - Payment Intent Events

extension Stripe.Events.Event.Typed.PaymentIntentEvent {
    public var eventName: String {
        switch self {
        case .amountCapturableUpdated: return "amount_capturable_updated"
        case .canceled: return "canceled"
        case .created: return "created"
        case .partiallyFunded: return "partially_funded"
        case .paymentFailed: return "payment_failed"
        case .processing: return "processing"
        case .requiresAction: return "requires_action"
        case .succeeded: return "succeeded"
        }
    }

    public var resourceId: String? {
        switch self {
        case .amountCapturableUpdated(let intent),
            .canceled(let intent),
            .created(let intent),
            .partiallyFunded(let intent),
            .paymentFailed(let intent),
            .processing(let intent),
            .requiresAction(let intent),
            .succeeded(let intent):
            return intent.id.rawValue
        }
    }
}

// MARK: - Other Event Types
// For other event types (PaymentMethod, Charge, File, Mandate, Payout, Refund, SetupIntent, etc.),
// the default implementations in the main extension will handle them.
// Add specific implementations here as needed for your application.
