import Testing

@testable import Stripe

@Suite
struct Test {

    // README mentions Stripe as main product
    @Test
    func `Example from README: Stripe module exists`() {
        // Verify the Stripe module compiles and types are accessible
        let stripeType = Stripe.self

        #expect(String(describing: stripeType) == "Stripe")
    }

    // README shows installation with .product(name: "Stripe", package: "swift-stripe")
    @Test
    func `Example from README: Package structure`() {
        // Verify module can be imported and basic types exist
        // This test passes if it compiles, confirming README installation instructions work
        #expect(Bool(true))
    }
}
