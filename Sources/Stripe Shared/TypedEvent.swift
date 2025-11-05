// MARK: - Typed Event Helper
// Combines Stripe event types with their associated typed data for ergonomic pattern matching

import Foundation
import Stripe_Events_Types
import Stripe_Types_Shared

//import Stripe_Types_Models
//import Stripe_Terminal_Live
//import Stripe_Billing_Live
//import Stripe_Payment_Methods_Live
//import Stripe_Products_Live
//import Stripe_Fraud_Live

extension Stripe.Events.Event {
    /// A helper enum that combines event type with typed data for ergonomic pattern matching
    /// Nested enums are marked as indirect to allocate large Stripe objects on the heap
    public indirect enum Typed: Codable, Hashable, Sendable {
        // Payment Intent events with associated PaymentIntent
        case paymentIntent(PaymentIntentEvent)

        // Charge events with associated Charge
        case charge(ChargeEvent)

        // Customer events with associated Customer
        case customer(CustomerEvent)

        // Subscription events with associated Subscription
        case subscription(SubscriptionEvent)

        // Invoice events with associated Invoice
        case invoice(InvoiceEvent)

        // Checkout Session events
        case checkoutSession(CheckoutSessionEvent)

        // Setup Intent events
        case setupIntent(SetupIntentEvent)

        // Payment Method events
        case paymentMethod(PaymentMethodEvent)

        // Product events
        case product(ProductEvent)

        // Price events
        case price(PriceEvent)

        // Payout events
        case payout(PayoutEvent)

        // Refund events
        case refund(RefundEvent)

        // Payment Link events
        case paymentLink(PaymentLinkEvent)

        // Mandate events
        case mandate(MandateEvent)

        // Account events
        case account(AccountEvent)

        // Application Fee events
        case applicationFee(ApplicationFeeEvent)

        // Balance events
        case balance(BalanceEvent)

        // Billing Portal events
        case billingPortal(BillingPortalEvent)

        // Capability events
        case capability(CapabilityEvent)

        // Cash Balance events
        case cashBalance(CashBalanceEvent)

        // Coupon events
        case coupon(CouponEvent)

        // Credit Note events
        case creditNote(CreditNoteEvent)

        // Discount events (on customers)
        case discount(DiscountEvent)

        // File events
        case file(FileEvent)

        // Financial Connections events
        case financialConnections(FinancialConnectionsEvent)

        // Identity Verification events
        case identity(IdentityEvent)

        // Invoice Item events
        case invoiceItem(InvoiceItemEvent)

        // Issuing events
        case issuing(IssuingEvent)

        // Person events
        case person(PersonEvent)

        // Plan events
        case plan(PlanEvent)

        // Promotion Code events
        case promotionCode(PromotionCodeEvent)

        // Quote events
        case quote(QuoteEvent)

        // Radar events
        case radar(RadarEvent)

        // Reporting events
        case reporting(ReportingEvent)

        // Review events
        case review(ReviewEvent)

        // Sigma events
        case sigma(SigmaEvent)

        // Source events
        case source(SourceEvent)

        // Subscription Schedule events
        case subscriptionSchedule(SubscriptionScheduleEvent)

        // Tax events
        case tax(TaxEvent)

        // Terminal events
        case terminal(TerminalEvent)

        // Test Helpers events
        case testHelpers(TestHelpersEvent)

        // Top-up events
        case topup(TopupEvent)

        // Transfer events
        case transfer(TransferEvent)

        // Unhandled events (for events we don't have specific handling for yet)
        case unhandled(Stripe.Events.Event)

        // MARK: - Event Sub-types

        public indirect enum PaymentIntentEvent: Codable, Hashable, Sendable {
            case succeeded(Stripe.PaymentIntents.PaymentIntent)
            case paymentFailed(Stripe.PaymentIntents.PaymentIntent)
            case created(Stripe.PaymentIntents.PaymentIntent)
            case canceled(Stripe.PaymentIntents.PaymentIntent)
            case processing(Stripe.PaymentIntents.PaymentIntent)
            case requiresAction(Stripe.PaymentIntents.PaymentIntent)
            case amountCapturableUpdated(Stripe.PaymentIntents.PaymentIntent)
            case partiallyFunded(Stripe.PaymentIntents.PaymentIntent)
        }

        public indirect enum ChargeEvent: Codable, Hashable, Sendable {
            case succeeded(Stripe.Charges.Charge)
            case failed(Stripe.Charges.Charge)
            case captured(Stripe.Charges.Charge)
            case refunded(Stripe.Charges.Charge)
            case updated(Stripe.Charges.Charge)
            case pending(Stripe.Charges.Charge)
            case expired(Stripe.Charges.Charge)
            case disputeCreated(Stripe.Charges.Charge)
            case disputeClosed(Stripe.Charges.Charge)
            case disputeFundsReinstated(Stripe.Charges.Charge)
            case disputeFundsWithdrawn(Stripe.Charges.Charge)
            case disputeUpdated(Stripe.Charges.Charge)
        }

        public indirect enum CustomerEvent: Codable, Hashable, Sendable {
            case created(Stripe.Customers.Customer)
            case updated(Stripe.Customers.Customer)
            case deleted(Stripe.Customers.Customer)
            case discountCreated(Stripe.Customers.Customer)
            case discountDeleted(Stripe.Customers.Customer)
            case discountUpdated(Stripe.Customers.Customer)
            case sourceCreated(Stripe.Customers.Customer)
            case sourceDeleted(Stripe.Customers.Customer)
            case sourceExpiring(Stripe.Customers.Customer)
            case sourceUpdated(Stripe.Customers.Customer)
            case subscriptionCreated(Stripe.Billing.Subscription)
            case subscriptionDeleted(Stripe.Billing.Subscription)
            case subscriptionPaused(Stripe.Billing.Subscription)
            case subscriptionPendingUpdateApplied(Stripe.Billing.Subscription)
            case subscriptionPendingUpdateExpired(Stripe.Billing.Subscription)
            case subscriptionResumed(Stripe.Billing.Subscription)
            case subscriptionTrialWillEnd(Stripe.Billing.Subscription)
            case subscriptionUpdated(Stripe.Billing.Subscription)
            case taxIdCreated(Stripe.Customers.Customer)
            case taxIdDeleted(Stripe.Customers.Customer)
            case taxIdUpdated(Stripe.Customers.Customer)
        }

        public indirect enum SubscriptionEvent: Codable, Hashable, Sendable {
            case created(Stripe.Billing.Subscription)
            case deleted(Stripe.Billing.Subscription)
            case paused(Stripe.Billing.Subscription)
            case pendingUpdateApplied(Stripe.Billing.Subscription)
            case pendingUpdateExpired(Stripe.Billing.Subscription)
            case resumed(Stripe.Billing.Subscription)
            case trialWillEnd(Stripe.Billing.Subscription)
            case updated(Stripe.Billing.Subscription)
        }

        public indirect enum InvoiceEvent: Codable, Hashable, Sendable {
            case created(Stripe.Billing.Invoice)
            case deleted(Stripe.Billing.Invoice)
            case finalizationFailed(Stripe.Billing.Invoice)
            case finalized(Stripe.Billing.Invoice)
            case markedUncollectible(Stripe.Billing.Invoice)
            case overdue(Stripe.Billing.Invoice)
            case paid(Stripe.Billing.Invoice)
            case paymentActionRequired(Stripe.Billing.Invoice)
            case paymentFailed(Stripe.Billing.Invoice)
            case paymentSucceeded(Stripe.Billing.Invoice)
            case sent(Stripe.Billing.Invoice)
            case upcoming(Stripe.Billing.Invoice)
            case updated(Stripe.Billing.Invoice)
            case voidInvoice(Stripe.Billing.Invoice)
            case willBeDue(Stripe.Billing.Invoice)
        }

        public indirect enum CheckoutSessionEvent: Codable, Hashable, Sendable {
            case asyncPaymentFailed(Stripe.Checkout.Session)
            case asyncPaymentSucceeded(Stripe.Checkout.Session)
            case completed(Stripe.Checkout.Session)
            case expired(Stripe.Checkout.Session)
        }

        public indirect enum SetupIntentEvent: Codable, Hashable, Sendable {
            case canceled(Stripe.Setup.Intent)
            case created(Stripe.Setup.Intent)
            case requiresAction(Stripe.Setup.Intent)
            case setupFailed(Stripe.Setup.Intent)
            case succeeded(Stripe.Setup.Intent)
        }

        public indirect enum PaymentMethodEvent: Codable, Hashable, Sendable {
            case attached(Stripe.PaymentMethods.PaymentMethod)
            case automaticallyUpdated(Stripe.PaymentMethods.PaymentMethod)
            case detached(Stripe.PaymentMethods.PaymentMethod)
            case updated(Stripe.PaymentMethods.PaymentMethod)
        }

        public indirect enum ProductEvent: Codable, Hashable, Sendable {
            case created(Stripe.Products.Product)
            case deleted(Stripe.Products.Product)
            case updated(Stripe.Products.Product)
        }

        public indirect enum PriceEvent: Codable, Hashable, Sendable {
            case created(Stripe.Products.Price)
            case deleted(Stripe.Products.Price)
            case updated(Stripe.Products.Price)
        }

        public indirect enum PayoutEvent: Codable, Hashable, Sendable {
            case canceled(Stripe.Payouts.Payout)
            case created(Stripe.Payouts.Payout)
            case failed(Stripe.Payouts.Payout)
            case paid(Stripe.Payouts.Payout)
            case reconciliationCompleted(Stripe.Payouts.Payout)
            case updated(Stripe.Payouts.Payout)
        }

        public indirect enum RefundEvent: Codable, Hashable, Sendable {
            case created(Stripe.Refunds.Refund)
            case updated(Stripe.Refunds.Refund)
        }

        public indirect enum PaymentLinkEvent: Codable, Hashable, Sendable {
            case created(Stripe.PaymentLink)
            case updated(Stripe.PaymentLink)
        }

        public indirect enum MandateEvent: Codable, Hashable, Sendable {
            case updated(Stripe.Mandates.Mandate)
        }

        public indirect enum AccountEvent: Codable, Hashable, Sendable {
            case applicationAuthorized(Stripe.Connect.Account)
            case applicationDeauthorized(Stripe.Connect.Account)
            case externalAccountCreated(Stripe.Connect.Account)
            case externalAccountDeleted(Stripe.Connect.Account)
            case externalAccountUpdated(Stripe.Connect.Account)
            case updated(Stripe.Connect.Account)
        }

        public indirect enum ApplicationFeeEvent: Codable, Hashable, Sendable {
            case created(Stripe.Connect.Application.Fee)
            case refunded(Stripe.Connect.Application.Fee)
            case refundUpdated(Stripe.Connect.Application.Fee.Refund)
        }

        public indirect enum BalanceEvent: Codable, Hashable, Sendable {
            case available(Stripe.Balance)
        }

        public indirect enum BillingPortalEvent: Codable, Hashable, Sendable {
            case configurationCreated(Stripe.Billing.Customer.Portal.Configuration)
            case configurationUpdated(Stripe.Billing.Customer.Portal.Configuration)
            case sessionCreated(Stripe.Billing.Customer.Portal.Session)
        }

        public indirect enum CapabilityEvent: Codable, Hashable, Sendable {
            case updated(Stripe.Connect.Capability)
        }

        public indirect enum CashBalanceEvent: Codable, Hashable, Sendable {
            case fundsAvailable(Stripe_Types_Models.CashBalance)
        }

        public indirect enum CouponEvent: Codable, Hashable, Sendable {
            case created(Stripe.Products.Coupon)
            case deleted(Stripe.Products.Coupon)
            case updated(Stripe.Products.Coupon)
        }

        public indirect enum CreditNoteEvent: Codable, Hashable, Sendable {
            case created(Stripe.Billing.Credit.Note)
            case updated(Stripe.Billing.Credit.Note)
            case voided(Stripe.Billing.Credit.Note)
        }

        public indirect enum DiscountEvent: Codable, Hashable, Sendable {
            case customerDiscountCreated(Stripe.Products.Discount)
            case customerDiscountDeleted(Stripe.Products.Discount)
            case customerDiscountUpdated(Stripe.Products.Discount)
        }

        public indirect enum FileEvent: Codable, Hashable, Sendable {
            case created(Stripe.Files.File)
        }

        public indirect enum FinancialConnectionsEvent: Codable, Hashable, Sendable {
            case accountCreated(FinancialConnections.Account)
            case accountDeactivated(FinancialConnections.Account)
            case accountDisconnected(FinancialConnections.Account)
            case accountReactivated(FinancialConnections.Account)
            case accountRefreshedBalance(FinancialConnections.Account)
        }

        public indirect enum IdentityEvent: Codable, Hashable, Sendable {
            case verificationSessionCanceled(Stripe_Types_Models.VerificationSession)
            case verificationSessionCreated(Stripe_Types_Models.VerificationSession)
            case verificationSessionProcessing(Stripe_Types_Models.VerificationSession)
            case verificationSessionRedacted(Stripe_Types_Models.VerificationSession)
            case verificationSessionRequiresInput(Stripe_Types_Models.VerificationSession)
            case verificationSessionVerified(Stripe_Types_Models.VerificationSession)
        }

        public indirect enum InvoiceItemEvent: Codable, Hashable, Sendable {
            case created(Stripe.Billing.Invoice.Item)
            case deleted(Stripe.Billing.Invoice.Item)
        }

        public indirect enum IssuingEvent: Codable, Hashable, Sendable {
            case authorizationCreated(Stripe_Types_Models.Authorization)
            case authorizationRequest(Stripe_Types_Models.Authorization)
            case authorizationUpdated(Stripe_Types_Models.Authorization)
            case cardCreated(Stripe_Types_Models.IssuingCard)
            case cardUpdated(Stripe_Types_Models.IssuingCard)
            case cardholderCreated(Stripe_Types_Models.Cardholder)
            case cardholderUpdated(Stripe_Types_Models.Cardholder)
            case disputeClosed(Stripe_Types_Models.IssuingDispute)
            case disputeCreated(Stripe_Types_Models.IssuingDispute)
            case disputeFundsReinstated(Stripe_Types_Models.IssuingDispute)
            case disputeSubmitted(Stripe_Types_Models.IssuingDispute)
            case disputeUpdated(Stripe_Types_Models.IssuingDispute)
            case transactionCreated(Stripe_Types_Models.Transaction)
            case transactionUpdated(Stripe_Types_Models.Transaction)
        }

        public indirect enum PersonEvent: Codable, Hashable, Sendable {
            case created(Stripe.Connect.Person)
            case deleted(Stripe.Connect.Person)
            case updated(Stripe.Connect.Person)
        }

        public indirect enum PlanEvent: Codable, Hashable, Sendable {
            case created(Stripe.Billing.Plan)
            case deleted(Stripe.Billing.Plan)
            case updated(Stripe.Billing.Plan)
        }

        public indirect enum PromotionCodeEvent: Codable, Hashable, Sendable {
            case created(Stripe_Types_Models.Promotion.Code)
            case updated(Stripe_Types_Models.Promotion.Code)
        }

        public indirect enum QuoteEvent: Codable, Hashable, Sendable {
            case accepted(Stripe.Billing.Quote)
            case canceled(Stripe.Billing.Quote)
            case created(Stripe.Billing.Quote)
            case finalized(Stripe.Billing.Quote)
        }

        public indirect enum RadarEvent: Codable, Hashable, Sendable {
            case earlyFraudWarningCreated(Stripe.Fraud.EarlyFraudWarnings.EarlyFraudWarning)
            case earlyFraudWarningUpdated(Stripe.Fraud.EarlyFraudWarnings.EarlyFraudWarning)
        }

        public indirect enum ReportingEvent: Codable, Hashable, Sendable {
            case reportRunFailed(Stripe_Types_Models.ReportRun)
            case reportRunSucceeded(Stripe_Types_Models.ReportRun)
            case reportTypeUpdated(Stripe_Types_Models.ReportType)
        }

        public indirect enum ReviewEvent: Codable, Hashable, Sendable {
            case closed(Stripe.Fraud.Reviews.Review)
            case opened(Stripe.Fraud.Reviews.Review)
        }

        public indirect enum SigmaEvent: Codable, Hashable, Sendable {
            case scheduledQueryRunCreated(Stripe_Types_Models.ScheduledQueryRun)
        }

        public indirect enum SourceEvent: Codable, Hashable, Sendable {
            case canceled(Source)
            case chargeable(Source)
            case failed(Source)
            case mandateNotification(Source)
            case refundAttributesRequired(Source)
            case transactionCreated(Source)
            case transactionUpdated(Source)
        }

        public indirect enum SubscriptionScheduleEvent: Codable, Hashable, Sendable {
            case aborted(Stripe.Billing.Subscription.Schedule)
            case canceled(Stripe.Billing.Subscription.Schedule)
            case completed(Stripe.Billing.Subscription.Schedule)
            case created(Stripe.Billing.Subscription.Schedule)
            case expiring(Stripe.Billing.Subscription.Schedule)
            case released(Stripe.Billing.Subscription.Schedule)
            case updated(Stripe.Billing.Subscription.Schedule)
        }

        public indirect enum TaxEvent: Codable, Hashable, Sendable {
            case rateCreated(Stripe.Tax.Rate)
            case rateUpdated(Stripe.Tax.Rate)
        }

        public indirect enum TerminalEvent: Codable, Hashable, Sendable {
            case readerActionFailed(Stripe.Terminal.Readers.Reader)
            case readerActionSucceeded(Stripe.Terminal.Readers.Reader)
        }

        public indirect enum TestHelpersEvent: Codable, Hashable, Sendable {
            case testClockAdvancing(Stripe.Billing.TestClocks.TestClock)
            case testClockCreated(Stripe.Billing.TestClocks.TestClock)
            case testClockDeleted(Stripe.Billing.TestClocks.TestClock)
            case testClockInternalFailure(Stripe.Billing.TestClocks.TestClock)
            case testClockReady(Stripe.Billing.TestClocks.TestClock)
        }

        public indirect enum TopupEvent: Codable, Hashable, Sendable {
            case canceled(Stripe.Connect.TopUp)
            case created(Stripe.Connect.TopUp)
            case failed(Stripe.Connect.TopUp)
            case reversed(Stripe.Connect.TopUp)
            case succeeded(Stripe.Connect.TopUp)
        }

        public indirect enum TransferEvent: Codable, Hashable, Sendable {
            case created(Stripe.Connect.Transfer)
            case reversed(Stripe.Connect.Transfer)
            case updated(Stripe.Connect.Transfer)
        }
    }
}

extension Stripe.Events.Event.Typed {
    // MARK: - Initialization from Event

    /// Create a TypedEvent from an Event
    public init(from event: Stripe.Events.Event) {

        guard let type = event.type,
            let data = event.data?.object
        else {
            self = .unhandled(event)
            return
        }

        switch type {
        // Payment Intent events
        case .paymentIntentSucceeded:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.succeeded(paymentIntent))
                return
            }

        case .paymentIntentPaymentFailed:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.paymentFailed(paymentIntent))
                return
            }

        case .paymentIntentCreated:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.created(paymentIntent))
                return
            }

        case .paymentIntentCanceled:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.canceled(paymentIntent))
                return
            }

        case .paymentIntentProcessing:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.processing(paymentIntent))
                return
            }

        case .paymentIntentRequiresAction:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.requiresAction(paymentIntent))
                return
            }

        case .paymentIntentAmountCapturableUpdated:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.amountCapturableUpdated(paymentIntent))
                return
            }

        case .paymentIntentPartiallyFunded:
            if let paymentIntent = data.paymentIntent {
                self = .paymentIntent(.partiallyFunded(paymentIntent))
                return
            }

        // Charge events
        case .chargeSucceeded:
            if let charge = data.charge {
                self = .charge(.succeeded(charge))
                return
            }

        case .chargeFailed:
            if let charge = data.charge {
                self = .charge(.failed(charge))
                return
            }

        case .chargeCaptured:
            if let charge = data.charge {
                self = .charge(.captured(charge))
                return
            }

        case .chargeRefunded:
            if let charge = data.charge {
                self = .charge(.refunded(charge))
                return
            }

        case .chargeUpdated:
            if let charge = data.charge {
                self = .charge(.updated(charge))
                return
            }

        case .chargePending:
            if let charge = data.charge {
                self = .charge(.pending(charge))
                return
            }

        case .chargeExpired:
            if let charge = data.charge {
                self = .charge(.expired(charge))
                return
            }

        case .chargeDisputeCreated:
            if let charge = data.charge {
                self = .charge(.disputeCreated(charge))
                return
            }

        case .chargeDisputeClosed:
            if let charge = data.charge {
                self = .charge(.disputeClosed(charge))
                return
            }

        case .chargeDisputeFundsReinstated:
            if let charge = data.charge {
                self = .charge(.disputeFundsReinstated(charge))
                return
            }

        case .chargeDisputeFundsWithdrawn:
            if let charge = data.charge {
                self = .charge(.disputeFundsWithdrawn(charge))
                return
            }

        case .chargeDisputeUpdated:
            if let charge = data.charge {
                self = .charge(.disputeUpdated(charge))
                return
            }

        // Customer events
        case .customerCreated:
            if let customer = data.customer {
                self = .customer(.created(customer))
                return
            }

        case .customerUpdated:
            if let customer = data.customer {
                self = .customer(.updated(customer))
                return
            }

        case .customerDeleted:
            if let customer = data.customer {
                self = .customer(.deleted(customer))
                return
            }

        case .customerDiscountCreated:
            if let customer = data.customer {
                self = .customer(.discountCreated(customer))
                return
            }

        case .customerDiscountDeleted:
            if let customer = data.customer {
                self = .customer(.discountDeleted(customer))
                return
            }

        case .customerDiscountUpdated:
            if let customer = data.customer {
                self = .customer(.discountUpdated(customer))
                return
            }

        case .customerSourceCreated:
            if let customer = data.customer {
                self = .customer(.sourceCreated(customer))
                return
            }

        case .customerSourceDeleted:
            if let customer = data.customer {
                self = .customer(.sourceDeleted(customer))
                return
            }

        case .customerSourceExpiring:
            if let customer = data.customer {
                self = .customer(.sourceExpiring(customer))
                return
            }

        case .customerSourceUpdated:
            if let customer = data.customer {
                self = .customer(.sourceUpdated(customer))
                return
            }

        case .customerSubscriptionCreated:
            if let subscription = data.subscription {
                self = .customer(.subscriptionCreated(subscription))
                return
            }

        case .customerSubscriptionDeleted:
            if let subscription = data.subscription {
                self = .customer(.subscriptionDeleted(subscription))
                return
            }

        case .customerSubscriptionPaused:
            if let subscription = data.subscription {
                self = .customer(.subscriptionPaused(subscription))
                return
            }

        case .customerSubscriptionPendingUpdateApplied:
            if let subscription = data.subscription {
                self = .customer(.subscriptionPendingUpdateApplied(subscription))
                return
            }

        case .customerSubscriptionPendingUpdateExpired:
            if let subscription = data.subscription {
                self = .customer(.subscriptionPendingUpdateExpired(subscription))
                return
            }

        case .customerSubscriptionResumed:
            if let subscription = data.subscription {
                self = .customer(.subscriptionResumed(subscription))
                return
            }

        case .customerSubscriptionTrialWillEnd:
            if let subscription = data.subscription {
                self = .customer(.subscriptionTrialWillEnd(subscription))
                return
            }

        case .customerSubscriptionUpdated:
            if let subscription = data.subscription {
                self = .customer(.subscriptionUpdated(subscription))
                return
            }

        case .customerTaxIdCreated:
            if let customer = data.customer {
                self = .customer(.taxIdCreated(customer))
                return
            }

        case .customerTaxIdDeleted:
            if let customer = data.customer {
                self = .customer(.taxIdDeleted(customer))
                return
            }

        case .customerTaxIdUpdated:
            if let customer = data.customer {
                self = .customer(.taxIdUpdated(customer))
                return
            }

        // Invoice events
        case .invoiceCreated:
            if let invoice = data.invoice {
                self = .invoice(.created(invoice))
                return
            }

        case .invoiceDeleted:
            if let invoice = data.invoice {
                self = .invoice(.deleted(invoice))
                return
            }

        case .invoiceFinalizationFailed:
            if let invoice = data.invoice {
                self = .invoice(.finalizationFailed(invoice))
                return
            }

        case .invoiceFinalized:
            if let invoice = data.invoice {
                self = .invoice(.finalized(invoice))
                return
            }

        case .invoiceMarkedUncollectible:
            if let invoice = data.invoice {
                self = .invoice(.markedUncollectible(invoice))
                return
            }

        case .invoiceOverdue:
            if let invoice = data.invoice {
                self = .invoice(.overdue(invoice))
                return
            }

        case .invoicePaid:
            if let invoice = data.invoice {
                self = .invoice(.paid(invoice))
                return
            }

        case .invoicePaymentActionRequired:
            if let invoice = data.invoice {
                self = .invoice(.paymentActionRequired(invoice))
                return
            }

        case .invoicePaymentFailed:
            if let invoice = data.invoice {
                self = .invoice(.paymentFailed(invoice))
                return
            }

        case .invoicePaymentSucceeded:
            if let invoice = data.invoice {
                self = .invoice(.paymentSucceeded(invoice))
                return
            }

        case .invoicePaymentPaid:
            // Legacy event type - treat as payment succeeded
            if let invoice = data.invoice {
                self = .invoice(.paymentSucceeded(invoice))
                return
            }

        case .invoiceSent:
            if let invoice = data.invoice {
                self = .invoice(.sent(invoice))
                return
            }

        case .invoiceUpcoming:
            if let invoice = data.invoice {
                self = .invoice(.upcoming(invoice))
                return
            }

        case .invoiceUpdated:
            if let invoice = data.invoice {
                self = .invoice(.updated(invoice))
                return
            }

        case .invoiceVoided:
            if let invoice = data.invoice {
                self = .invoice(.voidInvoice(invoice))
                return
            }

        case .invoiceWillBeDue:
            if let invoice = data.invoice {
                self = .invoice(.willBeDue(invoice))
                return
            }

        // Checkout Session events
        case .checkoutSessionAsyncPaymentFailed:
            if let checkoutSession = data.checkoutSession {
                self = .checkoutSession(.asyncPaymentFailed(checkoutSession))
                return
            }

        case .checkoutSessionAsyncPaymentSucceeded:
            if let checkoutSession = data.checkoutSession {
                self = .checkoutSession(.asyncPaymentSucceeded(checkoutSession))
                return
            }

        case .checkoutSessionCompleted:
            if let checkoutSession = data.checkoutSession {
                self = .checkoutSession(.completed(checkoutSession))
                return
            }

        case .checkoutSessionExpired:
            if let checkoutSession = data.checkoutSession {
                self = .checkoutSession(.expired(checkoutSession))
                return
            }

        // Setup Intent events
        case .setupIntentCanceled:
            if let setupIntent = data.setupIntent {
                self = .setupIntent(.canceled(setupIntent))
                return
            }

        case .setupIntentCreated:
            if let setupIntent = data.setupIntent {
                self = .setupIntent(.created(setupIntent))
                return
            }

        case .setupIntentRequiresAction:
            if let setupIntent = data.setupIntent {
                self = .setupIntent(.requiresAction(setupIntent))
                return
            }

        case .setupIntentSetupFailed:
            if let setupIntent = data.setupIntent {
                self = .setupIntent(.setupFailed(setupIntent))
                return
            }

        case .setupIntentSucceeded:
            if let setupIntent = data.setupIntent {
                self = .setupIntent(.succeeded(setupIntent))
                return
            }

        // Payment Method events
        case .paymentMethodAttached:
            if let paymentMethod = data.paymentMethod {
                self = .paymentMethod(.attached(paymentMethod))
                return
            }

        case .paymentMethodAutomaticallyUpdated:
            if let paymentMethod = data.paymentMethod {
                self = .paymentMethod(.automaticallyUpdated(paymentMethod))
                return
            }

        case .paymentMethodDetached:
            if let paymentMethod = data.paymentMethod {
                self = .paymentMethod(.detached(paymentMethod))
                return
            }

        case .paymentMethodUpdated:
            if let paymentMethod = data.paymentMethod {
                self = .paymentMethod(.updated(paymentMethod))
                return
            }

        // Product events
        case .productCreated:
            if let product = data.product {
                self = .product(.created(product))
                return
            }

        case .productDeleted:
            if let product = data.product {
                self = .product(.deleted(product))
                return
            }

        case .productUpdated:
            if let product = data.product {
                self = .product(.updated(product))
                return
            }

        // Price events
        case .priceCreated:
            if let price = data.price {
                self = .price(.created(price))
                return
            }

        case .priceDeleted:
            if let price = data.price {
                self = .price(.deleted(price))
                return
            }

        case .priceUpdated:
            if let price = data.price {
                self = .price(.updated(price))
                return
            }

        // Payout events
        case .payoutCanceled:
            if let payout = data.payout {
                self = .payout(.canceled(payout))
                return
            }

        case .payoutCreated:
            if let payout = data.payout {
                self = .payout(.created(payout))
                return
            }

        case .payoutFailed:
            if let payout = data.payout {
                self = .payout(.failed(payout))
                return
            }

        case .payoutPaid:
            if let payout = data.payout {
                self = .payout(.paid(payout))
                return
            }

        case .payoutReconciliationCompleted:
            if let payout = data.payout {
                self = .payout(.reconciliationCompleted(payout))
                return
            }

        case .payoutUpdated:
            if let payout = data.payout {
                self = .payout(.updated(payout))
                return
            }

        // Refund events
        case .refundCreated:
            if let refund = data.refund {
                self = .refund(.created(refund))
                return
            }

        case .refundUpdated:
            if let refund = data.refund {
                self = .refund(.updated(refund))
                return
            }

        // Payment Link events
        case .paymentLinkCreated:
            if let paymentLink = data.paymentLink {
                self = .paymentLink(.created(paymentLink))
                return
            }

        case .paymentLinkUpdated:
            if let paymentLink = data.paymentLink {
                self = .paymentLink(.updated(paymentLink))
                return
            }

        // Mandate events
        case .mandateUpdated:
            if let mandate = data.mandate {
                self = .mandate(.updated(mandate))
                return
            }

        // Account events
        case .accountApplicationAuthorized:
            if let account = data.account {
                self = .account(.applicationAuthorized(account))
                return
            }

        case .accountApplicationDeauthorized:
            if let account = data.account {
                self = .account(.applicationDeauthorized(account))
                return
            }

        case .accountExternalAccountCreated:
            if let account = data.account {
                self = .account(.externalAccountCreated(account))
                return
            }

        case .accountExternalAccountDeleted:
            if let account = data.account {
                self = .account(.externalAccountDeleted(account))
                return
            }

        case .accountExternalAccountUpdated:
            if let account = data.account {
                self = .account(.externalAccountUpdated(account))
                return
            }

        case .accountUpdated:
            if let account = data.account {
                self = .account(.updated(account))
                return
            }

        // Application Fee events
        case .applicationFeeCreated:
            if let applicationFee = data.applicationFee {
                self = .applicationFee(.created(applicationFee))
                return
            }

        case .applicationFeeRefunded:
            if let applicationFee = data.applicationFee {
                self = .applicationFee(.refunded(applicationFee))
                return
            }

        case .applicationFeeRefundUpdated:
            if let applicationFeeRefund = data.applicationFeeRefund {
                self = .applicationFee(.refundUpdated(applicationFeeRefund))
                return
            }

        // Balance events
        case .balanceAvailable:
            if let balance = data.balance {
                self = .balance(.available(balance))
                return
            }

        // Billing Portal events
        case .billingPortalConfigurationCreated:
            if let configuration = data.configuration {
                self = .billingPortal(.configurationCreated(configuration))
                return
            }

        case .billingPortalConfigurationUpdated:
            if let configuration = data.configuration {
                self = .billingPortal(.configurationUpdated(configuration))
                return
            }

        case .billingPortalSessionCreated:
            if let billingPortalSession = data.billingPortalSession {
                self = .billingPortal(.sessionCreated(billingPortalSession))
                return
            }

        // Capability events
        case .capabilityUpdated:
            if let capability = data.capability {
                self = .capability(.updated(capability))
                return
            }

        // Cash Balance events
        case .cashBalanceFundsAvailable:
            if let cashBalance = data.cashBalance {
                self = .cashBalance(.fundsAvailable(cashBalance))
                return
            }

        // Coupon events
        case .couponCreated:
            if let coupon = data.coupon {
                self = .coupon(.created(coupon))
                return
            }

        case .couponDeleted:
            if let coupon = data.coupon {
                self = .coupon(.deleted(coupon))
                return
            }

        case .couponUpdated:
            if let coupon = data.coupon {
                self = .coupon(.updated(coupon))
                return
            }

        // Credit Note events
        case .creditNoteCreated:
            if let creditNote = data.creditNote {
                self = .creditNote(.created(creditNote))
                return
            }

        case .creditNoteUpdated:
            if let creditNote = data.creditNote {
                self = .creditNote(.updated(creditNote))
                return
            }

        case .creditNoteVoided:
            if let creditNote = data.creditNote {
                self = .creditNote(.voided(creditNote))
                return
            }

        // File events
        case .fileCreated:
            if let file = data.file {
                self = .file(.created(file))
                return
            }

        // Financial Connections events - FinancialConnections.Account type is not available in Event.Object, fallback to unhandled
        case .financialConnectionsAccountCreated,
            .financialConnectionsAccountDeactivated,
            .financialConnectionsAccountDisconnected,
            .financialConnectionsAccountReactivated,
            .financialConnectionsAccountRefreshedBalance:
            self = .unhandled(event)

        // Identity Verification events
        case .identityVerificationSessionCanceled:
            if let verificationSession = data.verificationSession {
                self = .identity(.verificationSessionCanceled(verificationSession))
                return
            }

        case .identityVerificationSessionCreated:
            if let verificationSession = data.verificationSession {
                self = .identity(.verificationSessionCreated(verificationSession))
                return
            }

        case .identityVerificationSessionProcessing:
            if let verificationSession = data.verificationSession {
                self = .identity(.verificationSessionProcessing(verificationSession))
                return
            }

        case .identityVerificationSessionRedacted:
            if let verificationSession = data.verificationSession {
                self = .identity(.verificationSessionRedacted(verificationSession))
                return
            }

        case .identityVerificationSessionRequiresInput:
            if let verificationSession = data.verificationSession {
                self = .identity(.verificationSessionRequiresInput(verificationSession))
                return
            }

        case .identityVerificationSessionVerified:
            if let verificationSession = data.verificationSession {
                self = .identity(.verificationSessionVerified(verificationSession))
                return
            }

        // Invoice Item events
        case .invoiceitemCreated:
            if let invoiceItem = data.invoiceItem {
                self = .invoiceItem(.created(invoiceItem))
                return
            }

        case .invoiceitemDeleted:
            if let invoiceItem = data.invoiceItem {
                self = .invoiceItem(.deleted(invoiceItem))
                return
            }

        // Issuing events
        case .issuingAuthorizationCreated:
            if let issuingAuthorization = data.issuingAuthorization {
                self = .issuing(.authorizationCreated(issuingAuthorization))
                return
            }

        case .issuingAuthorizationRequest:
            if let issuingAuthorization = data.issuingAuthorization {
                self = .issuing(.authorizationRequest(issuingAuthorization))
                return
            }

        case .issuingAuthorizationUpdated:
            if let issuingAuthorization = data.issuingAuthorization {
                self = .issuing(.authorizationUpdated(issuingAuthorization))
                return
            }

        case .issuingCardCreated:
            if let issuingCard = data.issuingCard {
                self = .issuing(.cardCreated(issuingCard))
                return
            }

        case .issuingCardUpdated:
            if let issuingCard = data.issuingCard {
                self = .issuing(.cardUpdated(issuingCard))
                return
            }

        case .issuingCardholderCreated:
            if let issuingCardHolder = data.issuingCardHolder {
                self = .issuing(.cardholderCreated(issuingCardHolder))
                return
            }

        case .issuingCardholderUpdated:
            if let issuingCardHolder = data.issuingCardHolder {
                self = .issuing(.cardholderUpdated(issuingCardHolder))
                return
            }

        case .issuingDisputeClosed:
            if let issuingDispute = data.issuingDispute {
                self = .issuing(.disputeClosed(issuingDispute))
                return
            }

        case .issuingDisputeCreated:
            if let issuingDispute = data.issuingDispute {
                self = .issuing(.disputeCreated(issuingDispute))
                return
            }

        case .issuingDisputeFundsReinstated:
            if let issuingDispute = data.issuingDispute {
                self = .issuing(.disputeFundsReinstated(issuingDispute))
                return
            }

        case .issuingDisputeSubmitted:
            if let issuingDispute = data.issuingDispute {
                self = .issuing(.disputeSubmitted(issuingDispute))
                return
            }

        case .issuingDisputeUpdated:
            if let issuingDispute = data.issuingDispute {
                self = .issuing(.disputeUpdated(issuingDispute))
                return
            }

        case .issuingTransactionCreated:
            if let issuingTransaction = data.issuingTransaction {
                self = .issuing(.transactionCreated(issuingTransaction))
                return
            }

        case .issuingTransactionUpdated:
            if let issuingTransaction = data.issuingTransaction {
                self = .issuing(.transactionUpdated(issuingTransaction))
                return
            }

        // Person events
        case .personCreated:
            if let person = data.person {
                self = .person(.created(person))
                return
            }

        case .personDeleted:
            if let person = data.person {
                self = .person(.deleted(person))
                return
            }

        case .personUpdated:
            if let person = data.person {
                self = .person(.updated(person))
                return
            }

        // Plan events
        case .planCreated:
            if let plan = data.plan {
                self = .plan(.created(plan))
                return
            }

        case .planDeleted:
            if let plan = data.plan {
                self = .plan(.deleted(plan))
                return
            }

        case .planUpdated:
            if let plan = data.plan {
                self = .plan(.updated(plan))
                return
            }

        // Promotion Code events
        case .promotionCodeCreated:
            if let promotionCode = data.promotionCode {
                self = .promotionCode(.created(promotionCode))
                return
            }

        case .promotionCodeUpdated:
            if let promotionCode = data.promotionCode {
                self = .promotionCode(.updated(promotionCode))
                return
            }

        // Quote events
        case .quoteAccepted:
            if let quote = data.quote {
                self = .quote(.accepted(quote))
                return
            }

        case .quoteCanceled:
            if let quote = data.quote {
                self = .quote(.canceled(quote))
                return
            }

        case .quoteCreated:
            if let quote = data.quote {
                self = .quote(.created(quote))
                return
            }

        case .quoteFinalized:
            if let quote = data.quote {
                self = .quote(.finalized(quote))
                return
            }

        // Radar events
        case .radarEarlyFraudWarningCreated:
            if let earlyFraudWarning = data.earlyFraudWarning {
                self = .radar(.earlyFraudWarningCreated(earlyFraudWarning))
                return
            }

        case .radarEarlyFraudWarningUpdated:
            if let earlyFraudWarning = data.earlyFraudWarning {
                self = .radar(.earlyFraudWarningUpdated(earlyFraudWarning))
                return
            }

        // Reporting events
        case .reportingReportRunFailed:
            if let reportRun = data.reportRun {
                self = .reporting(.reportRunFailed(reportRun))
                return
            }

        case .reportingReportRunSucceeded:
            if let reportRun = data.reportRun {
                self = .reporting(.reportRunSucceeded(reportRun))
                return
            }

        case .reportingReportTypeUpdated:
            if let reportType = data.reportType {
                self = .reporting(.reportTypeUpdated(reportType))
                return
            }

        // Review events
        case .reviewClosed:
            if let review = data.review {
                self = .review(.closed(review))
                return
            }

        case .reviewOpened:
            if let review = data.review {
                self = .review(.opened(review))
                return
            }

        //            // Sigma events
        case .sigmaScheduledQueryRunCreated:
            if let scheduledQueryRun = data.scheduledQueryRun {
                self = .sigma(.scheduledQueryRunCreated(scheduledQueryRun))
                return
            }
        //
        // Source events - Source type is not available in Event.Object, fallback to unhandled
        case .sourceCanceled,
            .sourceChargeable,
            .sourceFailed,
            .sourceMandateNotification,
            .sourceRefundAttributesRequired,
            .sourceTransactionCreated,
            .sourceTransactionUpdated:
            self = .unhandled(event)

        // Subscription Schedule events
        case .subscriptionScheduleAborted:
            if let subscriptionSchedule = data.subscriptionSchedule {
                self = .subscriptionSchedule(.aborted(subscriptionSchedule))
                return
            }

        case .subscriptionScheduleCanceled:
            if let subscriptionSchedule = data.subscriptionSchedule {
                self = .subscriptionSchedule(.canceled(subscriptionSchedule))
                return
            }

        case .subscriptionScheduleCompleted:
            if let subscriptionSchedule = data.subscriptionSchedule {
                self = .subscriptionSchedule(.completed(subscriptionSchedule))
                return
            }

        case .subscriptionScheduleCreated:
            if let subscriptionSchedule = data.subscriptionSchedule {
                self = .subscriptionSchedule(.created(subscriptionSchedule))
                return
            }

        case .subscriptionScheduleExpiring:
            if let subscriptionSchedule = data.subscriptionSchedule {
                self = .subscriptionSchedule(.expiring(subscriptionSchedule))
                return
            }

        case .subscriptionScheduleReleased:
            if let subscriptionSchedule = data.subscriptionSchedule {
                self = .subscriptionSchedule(.released(subscriptionSchedule))
                return
            }

        case .subscriptionScheduleUpdated:
            if let subscriptionSchedule = data.subscriptionSchedule {
                self = .subscriptionSchedule(.updated(subscriptionSchedule))
                return
            }

        // Tax events
        case .taxRateCreated:
            if let taxRate = data.taxRate {
                self = .tax(.rateCreated(taxRate))
                return
            }

        case .taxRateUpdated:
            if let taxRate = data.taxRate {
                self = .tax(.rateUpdated(taxRate))
                return
            }

        //            // Terminal events
        case .terminalReaderActionFailed:
            if let reader = data.reader {
                self = .terminal(.readerActionFailed(reader))
                return
            }
        //
        case .terminalReaderActionSucceeded:
            if let reader = data.reader {
                self = .terminal(.readerActionSucceeded(reader))
                return
            }
        //
        //            // Test Helpers events
        case .testHelpersTestClockAdvancing:
            if let testClock = data.testClock {
                self = .testHelpers(.testClockAdvancing(testClock))
                return
            }

        case .testHelpersTestClockCreated:
            if let testClock = data.testClock {
                self = .testHelpers(.testClockCreated(testClock))
                return
            }

        case .testHelpersTestClockDeleted:
            if let testClock = data.testClock {
                self = .testHelpers(.testClockDeleted(testClock))
                return
            }

        case .testHelpersTestClockInternalFailure:
            if let testClock = data.testClock {
                self = .testHelpers(.testClockInternalFailure(testClock))
                return
            }

        case .testHelpersTestClockReady:
            if let testClock = data.testClock {
                self = .testHelpers(.testClockReady(testClock))
                return
            }

        //             Top-up events
        case .topupCanceled:
            if let topup = data.topup {
                self = .topup(.canceled(topup))
                return
            }

        case .topupCreated:
            if let topup = data.topup {
                self = .topup(.created(topup))
                return
            }

        case .topupFailed:
            if let topup = data.topup {
                self = .topup(.failed(topup))
                return
            }

        case .topupReversed:
            if let topup = data.topup {
                self = .topup(.reversed(topup))
                return
            }

        case .topupSucceeded:
            if let topup = data.topup {
                self = .topup(.succeeded(topup))
                return
            }

        // Transfer events
        case .transferCreated:
            if let transfer = data.transfer {
                self = .transfer(.created(transfer))
                return
            }

        case .transferReversed:
            if let transfer = data.transfer {
                self = .transfer(.reversed(transfer))
                return
            }

        case .transferUpdated:
            if let transfer = data.transfer {
                self = .transfer(.updated(transfer))
                return
            }

        case .billingAlertTriggered:
            self = .unhandled(event)
            return

        case .chargeRefundUpdated:
            self = .unhandled(event)
            return

        case .customerCashBalanceTransactionCreated:
            self = .unhandled(event)
            return

        case .unknownEvent:
            self = .unhandled(event)
            return

        }
        self = .unhandled(event)
        return
    }
}
