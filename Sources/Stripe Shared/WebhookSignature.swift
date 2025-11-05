// MARK: - Stripe Webhook Signature Verification
// This provides secure webhook signature verification to ensure
// webhook requests are actually from Stripe.

import Crypto
import Foundation
import ServerFoundation

/// Errors that can occur during webhook signature verification
public enum StripeSignatureError: Swift.Error {
    case unableToParseHeader
    case noMatchingSignatureFound
    case timestampNotTolerated
}

/// Stripe webhook signature verification
public struct StripeWebhookSignature {

    /// Verifies a Stripe webhook signature
    /// - Parameters:
    ///   - payload: The raw request body data
    ///   - header: The Stripe-Signature header value
    ///   - secret: Your webhook endpoint secret from Stripe
    ///   - tolerance: Maximum allowed time difference in seconds (default 5 minutes)
    /// - Throws: StripeSignatureError if verification fails
    public static func verify(
        payload: Data,
        header: String,
        secret: String,
        tolerance: Double = 300
    ) throws {
        // Parse signature pairs from header
        let signaturePairs = header.components(separatedBy: ",")

        // Extract v1 signatures
        let signatures = signaturePairs.reduce(into: [String]()) { result, component in
            let kvPair = component.components(separatedBy: "=")
            guard kvPair.count == 2 else { return }
            if kvPair[0] == "v1" {
                result.append(kvPair[1])
            }
        }

        // Extract timestamp
        guard
            let timestamp =
                signaturePairs
                .first(where: { $0.starts(with: "t=") })?
                .components(separatedBy: "=")
                .last
        else {
            throw StripeSignatureError.unableToParseHeader
        }

        // Create signed payload
        guard let payloadString = String(data: payload, encoding: .utf8) else {
            throw StripeSignatureError.unableToParseHeader
        }

        let signedPayload = "\(timestamp).\(payloadString)"

        // Compute expected signature
        guard let secretData = secret.data(using: .utf8),
            let payloadData = signedPayload.data(using: .utf8)
        else {
            throw StripeSignatureError.unableToParseHeader
        }

        let key = SymmetricKey(data: secretData)
        let signature = HMAC<SHA256>.authenticationCode(for: payloadData, using: key)
        let expectedSignature = signature.map { String(format: "%02x", $0) }.joined()

        // Check if any provided signature matches
        guard signatures.contains(expectedSignature) else {
            throw StripeSignatureError.noMatchingSignatureFound
        }

        // Verify timestamp tolerance
        guard let timestampDouble = Double(timestamp) else {
            throw StripeSignatureError.unableToParseHeader
        }

        let timestampDate = Date(timeIntervalSince1970: timestampDouble)
        let timeDifference = Date().timeIntervalSince(timestampDate)

        if tolerance > 0 && abs(timeDifference) > tolerance {
            throw StripeSignatureError.timestampNotTolerated
        }
    }
}
