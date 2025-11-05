//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 04/01/2025.
//

import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import IssueReporting
import Stripe_Products
import Stripe_Shared
import Testing

@Suite(
    "Price Client Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.continuousClock, ContinuousClock())
)

struct PriceClientTests {

    @Test("Should successfully create a one-time price")
    func testCreateOneTimePrice() async throws {
        @Dependency(Stripe.Products.Prices.self) var prices
        @Dependency(Stripe.Products.Products.self) var products

        // First create a product to attach the price to
        let product = try await products.client.create(
            .init(
                name: "Test Product",
                description: "Test product for price"
            )
        )

        let response = try await prices.client.create(
            .init(
                currency: Stripe.Currency.usd,
                metadata: ["type": "one_time"],
                product: product.id,
                unitAmount: 2000
            )
        )

        #expect(response.currency == Stripe.Currency.usd)
        #expect(response.metadata?["type"] == "one_time")
        #expect(response.product == product.id)
        #expect(response.unitAmount == 2000)
        #expect(response.type == .oneTime)
        #expect(!(response.livemode == true))

        // Cleanup - archive product (can't delete if it has prices)
        _ = try await products.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully create a recurring price")
    func testCreateRecurringPrice() async throws {
        @Dependency(Stripe.Products.Prices.self) var prices
        @Dependency(Stripe.Products.Products.self) var products

        let product = try await products.client.create(
            .init(
                name: "Test Subscription Product",
                description: "Test product for recurring price"
            )
        )

        let response = try await prices.client.create(
            .init(
                currency: Stripe.Currency.usd,
                metadata: ["type": "subscription"],
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1,
                    usageType: .licensed
                ),
                unitAmount: 2000
            )
        )

        #expect(response.currency == Stripe.Currency.usd)
        #expect(response.metadata?["type"] == "subscription")
        #expect(response.product == product.id)
        #expect(response.unitAmount == 2000)
        #expect(response.type?.rawValue == "recurring")
        #expect(response.recurring?.interval == .month)
        #expect(!(response.livemode == true))

        // Cleanup
        _ = try await products.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully retrieve a price")
    func testRetrievePrice() async throws {
        @Dependency(Stripe.Products.Prices.self) var prices
        @Dependency(Stripe.Products.Products.self) var products

        let product = try await products.client.create(
            .init(
                name: "Test Product Retrieve",
                description: "Test product for price retrieval"
            )
        )

        let created = try await prices.client.create(
            .init(
                currency: Stripe.Currency.usd,
                metadata: ["test": "retrieve"],
                product: product.id,
                unitAmount: 1500
            )
        )

        let retrieved = try await prices.client.retrieve(created.id)

        #expect(retrieved.id == created.id)
        #expect(retrieved.currency == created.currency)
        #expect(retrieved.metadata?["test"] == "retrieve")
        #expect(retrieved.unitAmount == created.unitAmount)

        // Cleanup
        _ = try await products.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully update a price")
    func testUpdatePrice() async throws {
        @Dependency(Stripe.Products.Prices.self) var prices
        @Dependency(Stripe.Products.Products.self) var products

        let product = try await products.client.create(
            .init(
                name: "Test Product Update",
                description: "Test product for price update"
            )
        )

        let created = try await prices.client.create(
            .init(
                currency: Stripe.Currency.usd,
                metadata: ["original": "true"],
                nickname: "Original Price",
                product: product.id,
                unitAmount: 2000
            )
        )

        let updated = try await prices.client.update(
            created.id,
            .init(
                metadata: ["updated": "true"],
                nickname: "Updated Price"
            )
        )

        #expect(updated.id == created.id)
        #expect(updated.nickname == "Updated Price")
        #expect(updated.metadata?["updated"] == "true")

        // Cleanup
        _ = try await products.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully list prices")
    func testListPrices() async throws {
        @Dependency(Stripe.Products.Prices.self) var prices
        @Dependency(Stripe.Products.Products.self) var products

        let product = try await products.client.create(
            .init(
                name: "Test Product List",
                description: "Test product for price listing"
            )
        )

        // Create test prices
        for i in 1...3 {
            _ = try await prices.client.create(
                .init(
                    currency: Stripe.Currency.usd,
                    nickname: "Test Price \(i)",
                    product: product.id,
                    unitAmount: 1000 * i
                )
            )
        }

        let response = try await prices.client.list(
            .init(
                limit: 5,
                product: product.id
            )
        )

        #expect(response.object == "list")
        #expect(response.data.count >= 3)
        if !response.data.isEmpty {
            #expect(response.data[0].object == "price")
        }

        // Cleanup
        _ = try await products.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully search prices")
    func testSearchPrices() async throws {
        @Dependency(Stripe.Products.Prices.self) var prices
        @Dependency(Stripe.Products.Products.self) var products

        let product = try await products.client.create(
            .init(
                name: "Test Product Search",
                description: "Test product for price searching"
            )
        )

        // Create price with unique metadata
        let uniqueId = UUID().uuidString
        _ = try await prices.client.create(
            .init(
                currency: Stripe.Currency.usd,
                metadata: ["search_test_id": uniqueId],
                product: product.id,
                unitAmount: 2500
            )
        )

        let response = try await prices.client.search(
            .init(
                query: "metadata['search_test_id']:'\(uniqueId)'",
                limit: 3
            )
        )

        #expect(response.object == "search_result")
        if !response.data.isEmpty {
            #expect(response.data[0].metadata?["search_test_id"] == uniqueId)
        }

        // Cleanup
        _ = try await products.client.update(product.id, .init(active: false))
    }

    @Test("Should handle price workflow")
    func testPriceWorkflow() async throws {
        @Dependency(Stripe.Products.Prices.self) var prices
        @Dependency(Stripe.Products.Products.self) var products

        let product = try await products.client.create(
            .init(
                name: "Test Product Workflow",
                description: "Test product for price workflow"
            )
        )

        // Step 1: Create price
        let created = try await prices.client.create(
            .init(
                currency: Stripe.Currency.usd,
                metadata: ["test": "workflow"],
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 1500
            )
        )
        #expect(created.unitAmount == 1500)

        // Step 2: Update price
        let updated = try await prices.client.update(
            created.id,
            .init(
                metadata: ["updated": "true"],
                nickname: "Updated Workflow Price"
            )
        )
        #expect(updated.nickname == "Updated Workflow Price")
        #expect(updated.metadata?["updated"] == "true")

        // Cleanup
        _ = try await products.client.update(product.id, .init(active: false))
    }
}
