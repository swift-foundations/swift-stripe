//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 04/01/2025.
//

import Dependencies
import Dependencies_Test_Support
import Environment_Dependencies
import Foundation
import Stripe_Products
import Stripe_Shared
import Testing

@Suite(

    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init))
)
struct Test {
    @Test
    func `Should successfully create a product`() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        let response = try await client.client.create(
            .init(
                name: "Test Product",
                description: "Test product creation",
                metadata: ["category": "test_category"],
                shippable: true
            )
        )

        #expect(response.name == "Test Product")
        #expect(response.description == "Test product creation")
        #expect(response.metadata?["category"] == "test_category")
        #expect(response.shippable == true)
        #expect(!(response.livemode == true))

        // Cleanup - archive the product (can't delete if it has prices)
        _ = try await client.client.update(response.id, .init(active: false))
    }

    @Test
    func `Should successfully retrieve a product`() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        let created = try await client.client.create(
            .init(
                name: "Test Retrieve Product",
                description: "Test product retrieval",
                metadata: ["test": "retrieve"]
            )
        )

        let retrieved = try await client.client.retrieve(created.id)

        #expect(retrieved.id == created.id)
        #expect(retrieved.name == created.name)
        #expect(retrieved.description == created.description)
        #expect(retrieved.metadata?["test"] == "retrieve")
        #expect(!(retrieved.livemode == true))

        // Cleanup
        _ = try await client.client.update(retrieved.id, .init(active: false))
    }

    @Test
    func `Should successfully update a product`() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        let created = try await client.client.create(
            .init(
                name: "Original Product",
                description: "Original description",
                metadata: ["original": "true"]
            )
        )

        let updated = try await client.client.update(
            created.id,
            .init(
                description: "Updated description",
                metadata: ["updated": "true"],
                name: "Updated Product"
            )
        )

        #expect(updated.id == created.id)
        #expect(updated.name == "Updated Product")
        #expect(updated.description == "Updated description")
        #expect(updated.metadata?["updated"] == "true")

        // Cleanup
        _ = try await client.client.update(updated.id, .init(active: false))
    }

    @Test
    func `Should successfully list products`() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        // Create test products
        var createdProducts: [Stripe.Products.Product] = []
        for i in 1...3 {
            let product = try await client.client.create(
                .init(
                    name: "Test Product \(i)",
                    description: "Test product listing \(i)"
                )
            )
            createdProducts.append(product)
        }

        let response = try await client.client.list(.init(limit: 10))

        #expect(response.object == "list")
        #expect(response.data.count >= 3)
        if !response.data.isEmpty {
            #expect(response.data[0].object == "product")
        }

        // Cleanup - archive all test products
        for product in createdProducts {
            _ = try await client.client.update(product.id, .init(active: false))
        }
    }

    @Test
    func `Should successfully delete a product`() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        let created = try await client.client.create(
            .init(
                name: "Delete Test Product",
                description: "Test product deletion"
            )
        )

        let deleted = try await client.client.delete(created.id)

        #expect(deleted.id == created.id)
        #expect(deleted.deleted == true)
        #expect(deleted.object == "product")
    }

    @Test
    func `Should successfully search products`() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        // Create a product with unique metadata for searching
        let uniqueId = UUID().uuidString
        let created = try await client.client.create(
            .init(
                name: "Search Test Product",
                description: "Test product search",
                metadata: ["search_test_id": uniqueId]
            )
        )

        let response = try await client.client.search(
            .init(
                query: "metadata['search_test_id']:'\(uniqueId)'",
                limit: 3
            )
        )

        #expect(response.object == "search_result")
        if !response.data.isEmpty {
            #expect(response.data[0].id == created.id)
            #expect(response.data[0].metadata?["search_test_id"] == uniqueId)
        }

        // Cleanup
        _ = try await client.client.update(created.id, .init(active: false))
    }

    @Test
    func `Should handle product workflow`() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        // Step 1: Create product
        let created = try await client.client.create(
            .init(
                name: "Workflow Test Product",
                description: "Complete workflow test",
                metadata: ["test": "workflow"]
            )
        )
        #expect(created.name == "Workflow Test Product")

        // Step 2: Update product
        let updated = try await client.client.update(
            created.id,
            .init(
                description: "Updated workflow test",
                metadata: ["updated": "true"],
                name: "Updated Workflow Product"
            )
        )
        #expect(updated.name == "Updated Workflow Product")
        #expect(updated.description == "Updated workflow test")

        // Step 3: Delete product
        let deleted = try await client.client.delete(updated.id)
        #expect(deleted.deleted == true)
        #expect(deleted.id == updated.id)
    }
}
