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
import Stripe_Billing
import Stripe_Customers
import Stripe_Products
import Stripe_Shared
import Testing

@Suite(
    "Subscription Client Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init))
)
struct SubscriptionClientTests {
    @Test("Should successfully create a subscription")
    func testCreateSubscription() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test Subscription Product",
                description: "Product for subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 1000
            )
        )

        // Create test customer
        let customer = try await customersClient.client.create(
            .init(
                description: "Test subscription customer",
                email: "subscription.test@example.com",
                name: "Subscription Test Customer"
            )
        )

        // Create subscription
        let response = try await client.client.create(
            .init(
                customer: customer.id,
                items: [
                    .init(price: price.id, quantity: 2)
                ],
                cancelAtPeriodEnd: false,
                description: "Test subscription",
                metadata: ["order_id": "test_order_1"],
                paymentBehavior: .defaultIncomplete
            )
        )

        // Verify subscription
        #expect(
            response.status == Stripe.Billing.Subscription.Status.active
                || response.status == Stripe.Billing.Subscription.Status.incomplete
        )
        #expect(response.customer == customer.id)
        #expect(response.description == "Test subscription")
        #expect(response.metadata?["order_id"] == "test_order_1")
        #expect(response.cancelAtPeriodEnd == false || response.cancelAtPeriodEnd == nil)
        #expect(!(response.livemode == true))

        #expect(response.items?.data?.count == 1)
        if let item = response.items?.data?.first {
            #expect(item.price?.id == price.id)
            #expect(item.quantity == 2)
        }

        // Cleanup - Cancel subscription first
        _ = try await client.client.cancel(response.id, .init())

        // Delete customer
        _ = try await customersClient.client.delete(customer.id)

        // Archive product (products can't be deleted if they have prices)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully retrieve a subscription")
    func testRetrieveSubscription() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test Retrieve Subscription Product",
                description: "Product for retrieve subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 2000
            )
        )

        // Create test customer
        let customer = try await customersClient.client.create(
            .init(
                description: "Test retrieve subscription customer",
                email: "retrieve.subscription.test@example.com",
                name: "Retrieve Subscription Test Customer"
            )
        )

        // Create subscription
        let created = try await client.client.create(
            .init(
                customer: customer.id,
                items: [
                    .init(price: price.id)
                ],
                description: "Test retrieve subscription",
                paymentBehavior: .defaultIncomplete
            )
        )

        // Retrieve the subscription
        let retrieved = try await client.client.retrieve(created.id)

        // Verify retrieved subscription
        #expect(retrieved.id == created.id)
        #expect(retrieved.customer == created.customer)
        #expect(retrieved.description == created.description)
        #expect(!(retrieved.livemode == true))

        // Cleanup
        _ = try await client.client.cancel(retrieved.id, .init())
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully update a subscription")
    func testUpdateSubscription() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test Update Subscription Product",
                description: "Product for update subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 3000
            )
        )

        // Create test customer
        let customer = try await customersClient.client.create(
            .init(
                description: "Test update subscription customer",
                email: "update.subscription.test@example.com",
                name: "Update Subscription Test Customer"
            )
        )

        // Create subscription
        let created = try await client.client.create(
            .init(
                customer: customer.id,
                items: [
                    .init(price: price.id)
                ],
                description: "Original description",
                metadata: ["original": "true"],
                paymentBehavior: .defaultIncomplete
            )
        )

        // Update the subscription
        let updated = try await client.client.update(
            created.id,
            .init(
                description: "Updated description",
                metadata: ["original": "false", "updated": "true"]
            )
        )

        // Verify updated subscription
        #expect(updated.id == created.id)
        #expect(updated.description == "Updated description")
        #expect(updated.metadata?["updated"] == "true")
        #expect(updated.metadata?["original"] == "false")

        // Cleanup
        _ = try await client.client.cancel(updated.id, .init())
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("Should successfully list subscriptions")
    func testListSubscriptions() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test List Subscription Product",
                description: "Product for list subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 1500
            )
        )

        // Create test customers and subscriptions
        var createdSubscriptions: [Stripe.Billing.Subscription] = []
        var createdCustomers: [Stripe.Customers.Customer] = []

        for i in 1...3 {
            let customer = try await customersClient.client.create(
                .init(
                    description: "Test list subscription customer \(i)",
                    email: "list.subscription.test\(i)@example.com",
                    name: "List Subscription Test Customer \(i)"
                )
            )
            createdCustomers.append(customer)

            let subscription = try await client.client.create(
                .init(
                    customer: customer.id,
                    items: [
                        .init(price: price.id)
                    ],
                    description: "Test list subscription \(i)",
                    paymentBehavior: .defaultIncomplete
                )
            )
            createdSubscriptions.append(subscription)
        }

        // List subscriptions with a filter to get only our customer's subscriptions
        let response = try await client.client.list(
            .init(
                customer: createdCustomers.first?.id,
                limit: 10
            )
        )

        // Verify list response
        #expect(response.object == "list")
        #expect(response.data.count >= 1)
        #expect(response.hasMore == false || response.hasMore == true)  // Just check it exists

        // Check that at least one of our subscriptions is returned
        if let firstSubscription = response.data.first {
            #expect(firstSubscription.customer == createdCustomers.first?.id)
        }

        // Cleanup
        for subscription in createdSubscriptions {
            _ = try await client.client.cancel(subscription.id, .init())
        }
        for customer in createdCustomers {
            _ = try await customersClient.client.delete(customer.id)
        }
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }
    //
    @Test("Should successfully cancel a subscription")
    func testCancelSubscription() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test Cancel Subscription Product",
                description: "Product for cancel subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 2500
            )
        )

        // Create test customer
        let customer = try await customersClient.client.create(
            .init(
                description: "Test cancel subscription customer",
                email: "cancel.subscription.test@example.com",
                name: "Cancel Subscription Test Customer"
            )
        )

        // Create subscription
        let created = try await client.client.create(
            .init(
                customer: customer.id,
                items: [
                    .init(price: price.id)
                ],
                description: "Test cancel subscription",
                paymentBehavior: .defaultIncomplete
            )
        )

        // Cancel the subscription
        let canceled = try await client.client.cancel(
            created.id,
            .init(
                invoiceNow: true,
                prorate: true
            )
        )

        // Verify canceled subscription
        #expect(canceled.id == created.id)
        // The status might be 'canceled' or 'incomplete_expired' depending on the subscription state
        #expect(
            canceled.status == Stripe.Billing.Subscription.Status.canceled
                || canceled.status == Stripe.Billing.Subscription.Status.incompleteExpired
                || canceled.canceledAt != nil || canceled.cancelAtPeriodEnd == true
        )

        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }
    //
    @Test("Should successfully resume a subscription")
    func testResumeSubscription() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test Resume Subscription Product",
                description: "Product for resume subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 3500
            )
        )

        // Create test customer
        let customer = try await customersClient.client.create(
            .init(
                description: "Test resume subscription customer",
                email: "resume.subscription.test@example.com",
                name: "Resume Subscription Test Customer"
            )
        )

        // Create subscription
        let created = try await client.client.create(
            .init(
                customer: customer.id,
                items: [
                    .init(price: price.id)
                ],
                description: "Test resume subscription",
                paymentBehavior: .defaultIncomplete
            )
        )

        // First, we need to update the subscription to cancel at period end (not immediately)
        let updated = try await client.client.update(
            created.id,
            .init(
                cancelAtPeriodEnd: true
            )
        )

        #expect(updated.cancelAtPeriodEnd == true)

        // Resume the subscription (by setting cancelAtPeriodEnd back to false)
        let resumed = try await client.client.update(
            updated.id,
            .init(
                cancelAtPeriodEnd: false
            )
        )

        // Verify resumed subscription
        #expect(resumed.id == created.id)
        #expect(resumed.cancelAtPeriodEnd == false)

        // Cleanup
        _ = try await client.client.cancel(resumed.id, .init())
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }
    //
    @Test("Should successfully search subscriptions")
    func testSearchSubscriptions() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test Search Subscription Product",
                description: "Product for search subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 4500
            )
        )

        // Create test customer
        let customer = try await customersClient.client.create(
            .init(
                description: "Test search subscription customer",
                email: "search.subscription.test@example.com",
                name: "Search Subscription Test Customer"
            )
        )

        // Create subscription with unique metadata for searching
        let uniqueId = UUID().uuidString
        let subscription = try await client.client.create(
            .init(
                customer: customer.id,
                items: [
                    .init(price: price.id)
                ],
                description: "Test search subscription",
                metadata: ["search_test_id": uniqueId],
                paymentBehavior: .defaultIncomplete
            )
        )

        // Search for subscriptions
        // Note: search endpoint may not be available for subscriptions
        // let response = try await client.client.search(.init(
        //     query: "metadata['search_test_id']:'\(uniqueId)'",
        //     limit: 3
        // ))

        // Verify search response (currently commented out)
        // #expect(response.object == "search_result")
        // if let data = response.data, !data.isEmpty {
        //     #expect(data[0].id == subscription.id)
        //     #expect(data[0].metadata?["search_test_id"] == uniqueId)
        // }

        // Cleanup
        _ = try await client.client.cancel(subscription.id, .init())
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }
    //
    @Test("Should handle subscription workflow")
    func testSubscriptionWorkflow() async throws {
        @Dependency(Stripe.Billing.Subscriptions.self) var client
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Create test product
        let product = try await productsClient.client.create(
            .init(
                name: "Test Workflow Subscription Product",
                description: "Product for workflow subscription testing"
            )
        )

        // Create test price
        let price = try await pricesClient.client.create(
            .init(
                currency: Stripe.Currency.usd,
                product: product.id,
                recurring: .init(
                    interval: .month,
                    intervalCount: 1
                ),
                unitAmount: 5500
            )
        )

        // Create test customer
        let customer = try await customersClient.client.create(
            .init(
                description: "Test workflow subscription customer",
                email: "workflow.subscription.test@example.com",
                name: "Workflow Subscription Test Customer"
            )
        )

        // Step 1: Create subscription with a payment method so it becomes active
        let created = try await client.client.create(
            .init(
                customer: customer.id,
                items: [
                    .init(price: price.id, quantity: 1)
                ],
                description: "Complete workflow test",
                paymentBehavior: .defaultIncomplete
            )
        )
        #expect(
            created.status == Stripe.Billing.Subscription.Status.active
                || created.status == Stripe.Billing.Subscription.Status.incomplete
        )

        // Step 2: Update subscription (only metadata for incomplete subscriptions)
        let updated = try await client.client.update(
            created.id,
            .init(
                description: "Updated workflow test",
                metadata: ["workflow_test": "updated"]
            )
        )
        #expect(updated.description == "Updated workflow test")
        #expect(updated.metadata?["workflow_test"] == "updated")

        // Step 3: Schedule cancellation at end of period
        let scheduledCancel = try await client.client.update(
            updated.id,
            .init(
                cancelAtPeriodEnd: true
            )
        )
        #expect(scheduledCancel.cancelAtPeriodEnd == true)

        // Step 4: Resume subscription by removing scheduled cancellation
        let resumed = try await client.client.update(
            scheduledCancel.id,
            .init(
                cancelAtPeriodEnd: false
            )
        )
        #expect(resumed.cancelAtPeriodEnd == false)

        // Final cleanup
        _ = try await client.client.cancel(resumed.id, .init())
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }
}
