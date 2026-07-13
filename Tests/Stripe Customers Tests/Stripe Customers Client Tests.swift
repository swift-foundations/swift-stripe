//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//

import Dependencies
import Dependencies_Test_Support
import ServerFoundationEnvVars
import Foundation
import Stripe_Customers
import Stripe_Shared
import Testing

@Suite(
    "Customer Client Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init))
)
struct CustomerClientTests {
    @Test("Should successfully create a customer")
    func testCreateCustomer() async throws {
        @Dependency(Stripe.Customers.self) var client

        let response = try await client.client.create(
            Stripe.Customers.Create.Request(
                description: "Test customer creation",
                email: "test@example.com",
                metadata: ["order_id": "test_order_1"],
                name: "Test Customer",
                phone: "+1234567890"
            )
        )

        #expect(response.email == "test@example.com")
        #expect(response.name == "Test Customer")
        #expect(response.description == "Test customer creation")
        #expect(response.metadata?["order_id"] == "test_order_1")
        #expect(response.phone == "+1234567890")
        #expect(!(response.livemode == true))

        // Cleanup
        let delete = try await client.client.delete(response.id)
        #expect(delete.id == response.id)
        #expect(delete.deleted == true)
    }

    @Test("Should successfully retrieve a customer")
    func testRetrieveCustomer() async throws {
        @Dependency(Stripe.Customers.self) var client

        let created = try await client.client.create(
            Stripe.Customers.Create.Request(
                description: "Test customer retrieval",
                email: "retrieve@example.com",
                name: "Test Retrieve"
            )
        )

        let retrieved = try await client.client.retrieve(created.id)

        #expect(retrieved.id == created.id)
        #expect(retrieved.email == created.email)
        #expect(retrieved.name == created.name)
        #expect(retrieved.description == created.description)
        #expect(!(retrieved.livemode == true))

        // Cleanup
        let delete = try await client.client.delete(retrieved.id)
        #expect(delete.id == retrieved.id)
        #expect(delete.deleted == true)
    }

    @Test("Should successfully update a customer")
    func testUpdateCustomer() async throws {
        @Dependency(Stripe.Customers.self) var client

        let created = try await client.client.create(
            Stripe.Customers.Create.Request(
                description: "Original description",
                email: "update@example.com",
                name: "Original Name"
            )
        )

        let updated = try await client.client.update(
            created.id,
            Stripe.Customers.Update.Request(
                description: "Updated description",
                metadata: ["updated": "true"],
                name: "Updated Name"
            )
        )

        #expect(updated.id == created.id)
        #expect(updated.name == "Updated Name")
        #expect(updated.description == "Updated description")
        #expect(updated.metadata?["updated"] == "true")

        // Cleanup
        let delete = try await client.client.delete(updated.id)
        #expect(delete.id == updated.id)
        #expect(delete.deleted == true)
    }

    @Test("Should successfully list customers")
    func testListCustomers() async throws {
        @Dependency(Stripe.Customers.self) var client

        // Create test customers
        var createdCustomers: [Stripe.Customers.Customer] = []
        for i in 1...3 {
            let customer = try await client.client.create(
                .init(
                    description: "Test Customer \(i)",
                    email: "test\(i)@example.com",
                    name: "Test Customer \(i)"
                )
            )
            createdCustomers.append(customer)
        }

        let response = try await client.client.list(.init(limit: 10))

        #expect(response.object == "list")
        #expect(response.data.count >= 3)
        if !response.data.isEmpty {
            #expect(response.data[0].object == "customer")
        }

        // Cleanup
        for customer in createdCustomers {
            let deleted = try await client.client.delete(customer.id)
            #expect(deleted.deleted == true)
        }
    }

    @Test("Should successfully delete a customer")
    func testDeleteCustomer() async throws {
        @Dependency(Stripe.Customers.self) var client

        let created = try await client.client.create(
            Stripe.Customers.Create.Request(
                email: "delete@example.com",
                name: "Delete Test"
            )
        )

        let deleted = try await client.client.delete(created.id)

        #expect(deleted.id == created.id)
        #expect(deleted.deleted == true)
        #expect(deleted.object == "customer")
    }

    @Test("Should successfully search customers")
    func testSearchCustomers() async throws {
        @Dependency(Stripe.Customers.self) var client

        // Create customer with unique metadata for searching
        let uniqueId = UUID().uuidString
        let created = try await client.client.create(
            Stripe.Customers.Create.Request(
                email: "search.test@example.com",
                metadata: ["search_test_id": uniqueId],
                name: "Search Test Customer"
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
        _ = try await client.client.delete(created.id)
    }

    @Test("Should handle customer workflow")
    func testCustomerWorkflow() async throws {
        @Dependency(Stripe.Customers.self) var client

        // Step 1: Create customer
        let created = try await client.client.create(
            Stripe.Customers.Create.Request(
                description: "Complete workflow test",
                email: "workflow@example.com",
                metadata: ["test": "workflow"],
                name: "Workflow Test"
            )
        )
        #expect(created.email == "workflow@example.com")

        // Step 2: Update customer
        let updated = try await client.client.update(
            created.id,
            Stripe.Customers.Update.Request(
                description: "Updated workflow test",
                metadata: ["updated": "true"],
                name: "Updated Workflow"
            )
        )
        #expect(updated.name == "Updated Workflow")
        #expect(updated.description == "Updated workflow test")

        // Step 3: Delete customer
        let deleted = try await client.client.delete(updated.id)
        #expect(deleted.deleted == true)
        #expect(deleted.id == updated.id)
    }
}
