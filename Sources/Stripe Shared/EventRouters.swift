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
    /// Router for parsing raw Stripe webhook events from request body
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public func parse(_ input: inout URLRequestData) throws -> Stripe.Events.Event {
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

        public func print(_ output: Stripe.Events.Event, into input: inout URLRequestData) throws {
            // Encode the event back to JSON
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .secondsSince1970

            let data = try encoder.encode(output)
            input.body = data
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
