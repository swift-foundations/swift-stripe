import Dependencies
import Environment_Dependencies
import Foundation
import HTML
import Stripe_Live_Shared
import Stripe_Web_Elements_Types

extension Stripe.WebElements.PaymentMethodMessaging {
    public struct View: HTML.View {
        let element: Stripe.WebElements.PaymentMethodMessaging

        @Dependency(\.uuid) var uuid
        @Dependency(\.envVars.stripe.publishableKey) var publishableKey

        public init(
            element: Stripe.WebElements.PaymentMethodMessaging,
        ) {
            self.element = element
        }

        public var body: some HTML.View {
            let elementId = "payment-method-messaging-\(uuid().uuidString)"

            div {
                div {}
                    .id(elementId)
                    .class("payment-method-messaging-element")

                script {
                    """
                    (function() {
                        function waitForStripe(callback) {
                            if (window.Stripe) {
                                callback();
                            } else {
                                setTimeout(function() {
                                    waitForStripe(callback);
                                }, 50);
                            }
                        }
                        
                        waitForStripe(function() {
                            const stripe = Stripe('\(publishableKey)');
                            const elements = stripe.elements();
                            
                            const messagingOptions = \(generateOptionsJSON());
                            const paymentMethodMessaging = elements.create('paymentMethodMessaging', messagingOptions);
                            paymentMethodMessaging.mount('#\(elementId)');
                        });
                    })();
                    """
                }
            }
        }

        private func generateOptionsJSON() -> String {
            guard let options = element.options else { return "{}" }

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]

            return (try? encoder.encode(options))
                .flatMap { String(data: $0, encoding: .utf8) }
                ?? "{}"
        }
    }
}
