// MARK: - Stripe Event Routers
// Custom URLRouting parsers for extracting Stripe webhook events from request bodies

import Dependencies
import Foundation
import ServerFoundation
import Stripe_Events_Types
import Stripe_Live_Shared
import URLRouting

// MARK: - Routing Errors

public enum StripeRoutingError: Swift.Error {
    case missingBody
    case missingWebhookSecret
    case missingSignatureHeader
    case invalidSignature(Swift.Error)
    case parseError(Swift.Error)
    case unhandledEventType(String)
}

// MARK: - Event Router

extension Stripe.Events.Event {
    /// Router for parsing raw Stripe webhook events from request body.
    ///
    /// Institute-idiom respell (run-arc 2026-07-13): manual parse/print with
    /// function-level typed throws and `Body = Never`, per the vended
    /// `RFC_6750.Bearer.Router` shape (swift-url-routing/Authenticating) and
    /// stripe-live's StripeAuthRouter unification (90cce3a). Conforms to
    /// `Parser.Bidirectional` directly — NOT `ParserPrinter` — because
    /// `ParserPrinter` pins `Failure == RFC_3986.URI.Routing.Error`, whose
    /// initializer is internal to URLRouting (`@usableFromInline`), so this
    /// module cannot construct it for its domain failures (missing body /
    /// missing secret / signature verification). The honest vended-idiom
    /// failure type is the domain error `StripeRoutingError`. (Bearer.Router
    /// itself is declared `Parser.Bidirectional` for the same reason of shape.)
    public struct Router: Parser.Bidirectional, Sendable {
        public typealias Input = URLRequestData
        public typealias Output = Stripe.Events.Event
        public typealias Failure = StripeRoutingError
        public typealias Body = Never

        public init() {}

        public func parse(_ input: inout URLRequestData) throws(StripeRoutingError) -> Stripe.Events.Event {
            // Get raw body
            guard let body = input.body else {
                throw StripeRoutingError.missingBody
            }

            // Get webhook secret
            @Dependency(\.envVars.stripe.webhookSecret) var webhookSecret
            guard let webhookSecret else {
                throw StripeRoutingError.missingWebhookSecret
            }

            // Get Stripe signature header
            // Note: The header may be split into array elements by HTTP parsing
            guard
                let signatureArray = input.headers["Stripe-Signature"],
                !signatureArray.isEmpty
            else {
                throw StripeRoutingError.missingSignatureHeader
            }

            // Join all parts if split by comma parsing
            let signature = signatureArray.compactMap { $0 }.joined(separator: ",")

            // Verify webhook signature
            do {
                try StripeWebhookSignature.verify(
                    payload: body,
                    header: signature,
                    secret: webhookSecret,
                    tolerance: 300
                )
            } catch {
                throw StripeRoutingError.invalidSignature(error)
            }

            // Parse the event
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970

            let event: Stripe.Events.Event
            do {
                event = try decoder.decode(Stripe.Events.Event.self, from: body)
            } catch {
                throw StripeRoutingError.parseError(error)
            }

            // Event received (logging handled by webhook processor)

            // Note: We don't consume the body from input as other middleware might need it

            return event
        }

        public func print(_ output: Stripe.Events.Event, into input: inout URLRequestData) throws(StripeRoutingError) {
            // Encode the event back to JSON
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .secondsSince1970

            do {
                input.body = try encoder.encode(output)
            } catch {
                throw StripeRoutingError.parseError(error)
            }
        }
    }
}

// MARK: - Event.Typed Router

//extension Stripe.Events.Event.Typed {
//    /// Router for parsing typed Stripe webhook events from request body
//    public struct Router: ParserPrinter, Sendable {
//        public init() {}
//
//        public func parse(_ input: inout URLRequestData) throws -> Stripe.Events.Event.Typed {
//            // First parse as raw Event using the Event router
//            let eventRouter = Stripe.Events.Event.Router()
//            let event = try eventRouter.parse(&input)
//
//            // Convert to Event.Typed (now always succeeds with unhandled case)
//            let typedEvent = Stripe.Events.Event.Typed.init(from: event)
//
//            return typedEvent
//        }
//
//        public func print(_ output: Stripe.Events.Event.Typed, into input: inout URLRequestData) throws {
//            // Event.Typed is Codable, so we can encode it directly
//            let encoder = JSONEncoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
//            encoder.dateEncodingStrategy = .secondsSince1970
//
//            let data = try encoder.encode(output)
//            input.body = data
//        }
//    }
//}
