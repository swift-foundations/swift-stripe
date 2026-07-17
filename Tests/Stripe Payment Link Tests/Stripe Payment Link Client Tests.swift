////
////  File.swift
////  coenttb-stripe
////
////  Created by Coen ten Thije Boonkkamp on 09/01/2025.
////
//
//import Stripe_Payment_Link
//import Stripe_Products
//import Dependencies
//import DependenciesTestSupport
//import EnvironmentVariables
//import Foundation
//import IssueReporting
//import Stripe_Shared
//import Testing
//
//@Suite(
//    "Payment Link Client Tests",
//.dependency(\.projectRoot, .stripe),
//.dependency(\.envVars, .development),
//.dependency(\.date, .init(Date.init)),
//.dependency(\.continuousClock, ContinuousClock())
//)
//struct PaymentLinkClientTests {
//    @Dependency(Stripe.PaymentLinks.self) var client
//    @Dependency(Stripe.Products.Products.self) var products
//    @Dependency(Stripe.Products.Prices.self) var prices
//
//    @Test
//    func testCreatePaymentLink() async throws {
//        // Create test product and price
//        let product = try await products.client.create(
//            .init(
//                name: "Test Product for Payment Link",
//                description: "Test product description"
//            )
//        )
//
//        let price = try await prices.client.create(
//            .init(
//                currency: .usd,
//                product: product.id,
//                unitAmount: 1000
//            )
//        )
//        let response = try await client.client.create(
//            .init(
//                lineItems: [
//                    .init(price: price.id, quantity: 2)
//                ],
//                metadata: ["order_id": "test_order_1"],
//                afterCompletion: .init(
//                    redirect: .init(url: "https://example.com/success"),
//                    type: .redirect
//                ),
//                allowPromotionCodes: true,
//                paymentMethodTypes: ["card"]
//            )
//        )
//        #expect(response.metadata?["order_id"] == "test_order_1")
//        #expect(response.allowPromotionCodes == true)
//        #expect(response.paymentMethodTypes?.contains("card") == true)
//        #expect(!(response.livemode == true))
//        #expect(response.active == true)
//        #expect(response.url!.starts(with: "https://"))
//
//        // Cleanup
//        _ = try await products.client.update(product.id, .init(active: false))
//    }
//    @Test
//    func testRetrievePaymentLink() async throws {
//
//
//        // Create test product and price
//        let product = try await products.client.create(
//            .init(
//                name: "Test Product Retrieve"
//            )
//        )
//
//        let price = try await prices.client.create(
//            .init(
//                currency: .usd,
//                product: product.id,
//                unitAmount: 1000
//            )
//        )
//
//        // Create a payment link
//        let created = try await client.client.create(
//            .init(
//                lineItems: [
//                    .init(price: price.id, quantity: 1)
//                ]
//            )
//        )
//
//        let retrieved = try await client.client.retrieve(created.id)
//
//        #expect(retrieved.id == created.id)
//        #expect(retrieved.url == created.url)
//        #expect(retrieved.active == created.active)
//        #expect(!(retrieved.livemode == true))
//
//        // Cleanup
//        _ = try await products.client.update(product.id, .init(active: false))
//    }
//    @Test
//    func testUpdatePaymentLink() async throws {
//
//        // Create test product and price
//        let product = try await products.client.create(
//            .init(
//                name: "Test Product Update"
//            )
//        )
//
//        let price = try await prices.client.create(
//            .init(
//                currency: .usd,
//                product: product.id,
//                unitAmount: 1000
//            )
//        )
//
//        // Create a payment link
//        let created = try await client.client.create(
//            .init(
//                lineItems: [
//                    .init(price: price.id, quantity: 1)
//                ],
//                metadata: ["original": "true"]
//            )
//        )
//
//        let updated = try await client.client.update(
//            created.id,
//            .init(
//                active: false,
//                afterCompletion: .init(
//                    hostedConfirmation: .init(message: "Thank you!"),
//                    type: .hostedConfirmation
//                ),
//                metadata: ["updated": "true"]
//            )
//        )
//
//        #expect(updated.id == created.id)
//        #expect(updated.active == false)
//        #expect(updated.metadata?["updated"] == "true")
//        if case .hostedConfirmation = updated.afterCompletion?.type {
//            #expect(updated.afterCompletion?.hostedConfirmation?.message == "Thank you!")
//        }
//
//        // Cleanup
//        _ = try await products.client.update(product.id, .init(active: false))
//    }
//    @Test
//    func testListPaymentLinks() async throws {
//
//        // Create test product and prices
//        let product = try await products.client.create(
//            .init(
//                name: "Test Product List"
//            )
//        )
//
//        // Create multiple prices
//        var createdPrices: [Stripe.Products.Price] = []
//        for i in 1...2 {
//            let price = try await prices.client.create(
//                .init(
//                    currency: .usd,
//                    nickname: "Price \(i)",
//                    product: product.id,
//                    unitAmount: 1000 * i
//                )
//            )
//            createdPrices.append(price)
//        }
//
//        // Unique metadata for this test
//        let uniqueTestId = UUID().uuidString
//
//        // Create payment links
//        for (index, price) in createdPrices.enumerated() {
//            _ = try await client.client.create(
//                .init(
//                    lineItems: [.init(price: price.id, quantity: 1)],
//                    metadata: ["test_id": uniqueTestId, "test_case": "testListPaymentLinks\(index + 1)"]
//                )
//            )
//        }
//
//        // List payment links
//        let response = try await client.client.list(.init(limit: 10))
//
//        #expect(response.object == "list")
//        #expect((response.data?.count ?? 0) >= 2)
//        if let data = response.data, !data.isEmpty {
//            #expect(data[0].object == "payment_link")
//        }
//
//        // Cleanup
//        _ = try await products.client.update(product.id, .init(active: false))
//    }
//    @Test
//    func testListLineItems() async throws {
//
//        // Create test product and prices
//        let product = try await products.client.create(
//            .init(
//                name: "Test Product Line Items"
//            )
//        )
//
//        let price1 = try await prices.client.create(
//            .init(
//                currency: .usd,
//                nickname: "Price 1",
//                product: product.id,
//                unitAmount: 1000
//            )
//        )
//
//        let price2 = try await prices.client.create(
//            .init(
//                currency: .usd,
//                nickname: "Price 2",
//                product: product.id,
//                unitAmount: 2000
//            )
//        )
//
//        // Create payment link with multiple line items
//        let created = try await client.client.create(
//            .init(
//                lineItems: [
//                    .init(price: price1.id, quantity: 2),
//                    .init(price: price2.id, quantity: 1)
//                ]
//            )
//        )
//
//        // Get line items
//        let lineItems = try await client.client.lineItems(created.id, .init(limit: 10))
//
//        #expect(lineItems.object == "list")
//        #expect(lineItems.data?.isEmpty == false)
//        if let data = lineItems.data {
//            #expect(data.count >= 2)
//            #expect(data[0].object == "item")
//        }
//        #expect(lineItems.url?.contains(created.id) == true)
//
//        // Cleanup
//        _ = try await products.client.update(product.id, .init(active: false))
//    }
//    @Test
//    func testPaymentLinkWorkflow() async throws {
//
//        // Create test product and price
//        let product = try await products.client.create(
//            .init(
//                name: "Test Product Workflow"
//            )
//        )
//
//        let price = try await prices.client.create(
//            .init(
//                currency: .usd,
//                product: product.id,
//                unitAmount: 2000
//            )
//        )
//
//        // 1. Create a payment link
//        let created = try await client.client.create(
//            .init(
//                lineItems: [
//                    .init(price: price.id, quantity: 1)
//                ],
//                metadata: ["workflow": "test"],
//                afterCompletion: .init(
//                    redirect: .init(url: "https://example.com/success"),
//                    type: .redirect
//                ),
//                allowPromotionCodes: true,
//                customerCreation: .always,
//                paymentMethodTypes: ["card"]
//            )
//        )
//        #expect(created.active == true)
//        #expect(created.metadata?["workflow"] == "test")
//
//        // 2. Update the payment link
//        let updated = try await client.client.update(
//            created.id,
//            .init(
//                afterCompletion: .init(
//                    hostedConfirmation: .init(message: "Thank you for your purchase!"),
//                    type: .hostedConfirmation
//                ),
//                metadata: ["workflow": "updated"]
//            )
//        )
//        #expect(updated.metadata?["workflow"] == "updated")
//
//        // 3. Get line items
//        let lineItems = try await client.client.lineItems(updated.id, .init())
//        #expect(lineItems.data?.isEmpty == false)
//
//        // 4. Deactivate the payment link
//        let deactivated = try await client.client.update(
//            updated.id,
//            .init(
//                active: false,
//                metadata: ["status": "completed"]
//            )
//        )
//        #expect(deactivated.active == false)
//        #expect(deactivated.metadata?["status"] == "completed")
//
//        // Cleanup
//        _ = try await products.client.update(product.id, .init(active: false))
//    }
//}
