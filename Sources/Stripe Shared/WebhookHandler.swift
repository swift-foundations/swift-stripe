// MARK: - Stripe Webhook Handler
// Provides a reusable webhook handler with signature verification
// and event parsing for Stripe webhooks.

import Dependencies
import Foundation
import Stripe_Events_Types

//extension Stripe {
//    /// Handles incoming Stripe webhook events with signature verification
//    /// - Parameters:
//    ///   - request: The incoming webhook request from Stripe
//    ///   - handler: Closure to handle the verified raw event
//    /// - Returns: HTTP Response (200 OK on success)
//    public static func webhookResponseRaw(
//        _ request: Request,
//        handler: (Events.Event) async throws -> Void
//    ) async throws -> Response {
//        // Get webhook secret from environment
//        @Dependency(\.envVars.stripe.webhookSecret) var webhookSecret
//
//        guard let webhookSecret else {
//            throw Abort(.internalServerError, reason: "Missing webhook secret")
//        }
//
//        // Get raw body for signature verification
//        guard let body = request.body.data else {
//            throw Abort(.badRequest, reason: "Missing request body")
//        }
//
//        // Get Stripe signature header
//        guard let signature = request.headers["Stripe-Signature"].first else {
//            throw Abort(.badRequest, reason: "Missing Stripe-Signature header")
//        }
//
//        // Verify webhook signature
//        do {
//            try StripeWebhookSignature.verify(
//                payload: Data(buffer: body),
//                header: signature,
//                secret: webhookSecret,
//                tolerance: 300 // 5 minutes
//            )
//        } catch {
//            print("⚠️ Webhook signature verification failed: \(error)")
//            throw Abort(.unauthorized, reason: "Invalid webhook signature")
//        }
//
//        // Parse the webhook event
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .secondsSince1970
//
//        let event: Stripe.Events.Event
//        do {
//            event = try decoder.decode(Stripe.Events.Event.self, from: Data(buffer: body))
//        } catch {
//            print("❌ Failed to parse webhook event: \(error)")
//            throw Abort(.badRequest, reason: "Invalid webhook payload")
//        }
//
//        // Log the received event
//        print("📮 Received Stripe webhook: \(event.type?.rawValue ?? "unknown") - \(event.id)")
//
//        // Call the user's handler
//        try await handler(event)
//
//        // Return success response to acknowledge receipt
//        return Response(status: .ok, body: .init(string: "Webhook received"))
//    }
//
//    /// Handles incoming Stripe webhook events with automatic Event.Typed conversion
//    /// - Parameters:
//    ///   - request: The incoming webhook request from Stripe
//    ///   - handler: Closure to handle typed events with associated data
//    /// - Returns: HTTP Response (200 OK on success)
//    /// - Note: Unhandled event types are automatically logged and skipped
//    public static func webhookResponse(
//        _ request: Request,
//        handler: (Events.Event.Typed) async throws -> Void
//    ) async throws -> Response {
//        return try await webhookResponseRaw(request) { event in
//            let typedEvent = Events.Event.Typed(from: event)
//            try await handler(typedEvent)
//        }
//    }
//
////    /// Handles incoming Stripe webhook events with Event.Typed conversion and custom unhandled callback
////    /// - Parameters:
////    ///   - request: The incoming webhook request from Stripe
////    ///   - handler: Closure to handle typed events with associated data
////    ///   - unhandled: Optional closure to handle events not yet supported by Event.Typed
////    /// - Returns: HTTP Response (200 OK on success)
////    public static func webhookResponse(
////        _ request: Request,
////        handler: (Events.Event.Typed) async throws -> Void,
////        unhandled: ((Events.Event) async -> Void)? = nil
////    ) async throws -> Response {
////        return try await webhookResponse(request) { event in
////            guard let typedEvent = Events.Event.Typed(from: event) else {
////                if let unhandled = unhandled {
////                    await unhandled(event)
////                } else {
////                    print("ℹ️ Unhandled event type: \(event.type?.rawValue ?? "unknown")")
////                }
////                return
////            }
////
////            try await handler(typedEvent)
////        }
////    }
//}
