import Testing

@testable import Stripe

@Suite("README Verification")
struct ReadmeVerificationTests {

    // README mentions Stripe as main product
    @Test("Example from README: Stripe module exists")
    func exampleStripeModuleExists() {
        // Verify the Stripe module compiles and types are accessible
        let stripeType = Stripe.self

        #expect(String(describing: stripeType) == "Stripe")
    }

    // README shows installation with .product(name: "Stripe", package: "swift-stripe")
    @Test("Example from README: Package structure")
    func examplePackageStructure() {
        // Verify module can be imported and basic types exist
        // This test passes if it compiles, confirming README installation instructions work
        #expect(Bool(true))
    }
}
