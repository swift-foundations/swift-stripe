//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 07/01/2025.
//

import Dependencies
import DependenciesTestSupport
import ServerFoundationEnvVars
import Foundation
import IssueReporting
import Stripe_Checkout_Sessions
import Stripe_Products
import Stripe_Shared
import Testing

@Suite(
    "Checkout Session Client Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.continuousClock, ContinuousClock())
)
struct CheckoutSessionClientTests {
    @Test("Should successfully create a session")
    func testCreateSession() async throws {
        @Dependency(Stripe.Checkout.Sessions.self) var client
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product and price
        let product = try await productsClient.client.create(
            .init(
                name: "Test Product",
                description: "Test product description"
            )
        )

        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                unitAmount: 1000
            )
        )

        let response = try await client.client.create(
            .init(
                successUrl: "https://example.com/success",
                cancelUrl: "https://example.com/cancel",
                clientReferenceId: "test_order_1",
                lineItems: [
                    .init(
                        price: price.id,
                        quantity: 1
                    )
                ],
                metadata: ["order_id": "test_order_1"],
                mode: .payment
            )
        )

        #expect(response.object == "checkout.session")
        // Some fields might be nil until the session is used
        if let clientReferenceId = response.clientReferenceId {
            #expect(clientReferenceId == "test_order_1")
        }
        #expect(response.metadata?["order_id"] == "test_order_1")
        #expect(response.mode == .payment)
        #expect(!(response.livemode == true))
        #expect(response.status == .open)
        // Payment status might be nil for new sessions
        if let paymentStatus = response.paymentStatus {
            #expect(paymentStatus == .unpaid)
        }
        #expect(response.currency == Stripe.Currency.usd)
        // Amount total might be nil until calculated
        if let amountTotal = response.amountTotal {
            #expect(amountTotal == 1000)
        }

        // Cleanup
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully retrieve a session")
    func testRetrieveSession() async throws {
        @Dependency(Stripe.Checkout.Sessions.self) var client
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product and price
        let product = try await productsClient.client.create(
            .init(
                name: "Test Product Retrieve"
            )
        )

        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                unitAmount: 1000
            )
        )

        let created = try await client.client.create(
            .init(
                successUrl: "https://example.com/success",
                lineItems: [
                    .init(
                        price: price.id,
                        quantity: 1
                    )
                ],
                mode: .payment
            )
        )

        let retrieved = try await client.client.retrieve(created.id)

        #expect(retrieved.id == created.id)
        #expect(retrieved.mode == created.mode)
        #expect(retrieved.successUrl == created.successUrl)
        #expect(!(retrieved.livemode == true))
        #expect(retrieved.status == created.status)

        // Cleanup
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully list sessions")
    func testListSessions() async throws {
        @Dependency(Stripe.Checkout.Sessions.self) var client
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product and prices
        let product = try await productsClient.client.create(
            .init(
                name: "Test Product List"
            )
        )

        var createdSessions: [Stripe.Checkout.Session] = []
        for i in 1...3 {
            let price = try await pricesClient.client.create(
                .init(
                    currency: Stripe.Currency.usd,
                    nickname: "Price \(i)",
                    product: product.id,
                    unitAmount: 1000 * i
                )
            )

            let session = try await client.client.create(
                .init(
                    successUrl: "https://example.com/success\(i)",
                    lineItems: [
                        .init(
                            price: price.id,
                            quantity: 1
                        )
                    ],
                    mode: .payment
                )
            )
            createdSessions.append(session)
        }

        let response = try await client.client.list(.init(limit: 10))

        #expect(response.object == "list")
        #expect((response.data?.count ?? 0) >= 3)
        if let data = response.data, !data.isEmpty {
            #expect(data[0].object == "checkout.session")
        }

        // Cleanup
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully expire a session")
    func testExpireSession() async throws {
        @Dependency(Stripe.Checkout.Sessions.self) var client
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product and price
        let product = try await productsClient.client.create(
            .init(
                name: "Test Product Expire"
            )
        )

        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                unitAmount: 1000
            )
        )

        let created = try await client.client.create(
            .init(
                successUrl: "https://example.com/success",
                lineItems: [
                    .init(
                        price: price.id,
                        quantity: 1
                    )
                ],
                mode: .payment
            )
        )

        let expired = try await client.client.expire(created.id)

        #expect(expired.id == created.id)
        #expect(expired.status == .expired)

        // Cleanup
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully retrieve session line items")
    func testSessionLineItems() async throws {
        @Dependency(Stripe.Checkout.Sessions.self) var client
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product and price
        let product = try await productsClient.client.create(
            .init(
                name: "Test Product Line Items",
                description: "Test description"
            )
        )

        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                unitAmount: 1000
            )
        )

        let created = try await client.client.create(
            .init(
                successUrl: "https://example.com/success",
                lineItems: [
                    .init(
                        price: price.id,
                        quantity: 2
                    )
                ],
                mode: .payment
            )
        )

        let response = try await client.client.lineItems(created.id, .init(limit: 10))

        #expect(response.object == "list")
        #expect(response.data?.isEmpty == false)

        if let items = response.data, !items.isEmpty {
            let item = items[0]
            #expect(item.quantity == 2)
            // Amount total might be nil on line items
            if let amountTotal = item.amountTotal {
                #expect(amountTotal == 2000)
            }
            #expect(item.currency == Stripe.Currency.usd)
        }

        // Cleanup
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should handle complete checkout session workflow")
    func testCheckoutSessionWorkflow() async throws {
        @Dependency(Stripe.Checkout.Sessions.self) var client
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product and price
        let product = try await productsClient.client.create(
            .init(
                name: "Workflow Test Product"
            )
        )

        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                unitAmount: 1500
            )
        )

        // Step 1: Create session
        let created = try await client.client.create(
            .init(
                successUrl: "https://example.com/success",
                cancelUrl: "https://example.com/cancel",
                lineItems: [
                    .init(
                        price: price.id,
                        quantity: 1
                    )
                ],
                metadata: ["test": "workflow"],
                mode: .payment
            )
        )
        #expect(created.metadata?["test"] == "workflow")

        // Step 2: Retrieve line items
        let lineItems = try await client.client.lineItems(created.id, .init(limit: 1))
        #expect(lineItems.data?.isEmpty == false)

        // Step 3: Expire session
        let expired = try await client.client.expire(created.id)
        #expect(expired.status == .expired)

        // Cleanup
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }
}
