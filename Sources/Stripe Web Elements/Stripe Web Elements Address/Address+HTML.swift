import Dependencies
import Foundation
import HTML
import Stripe_Web_Elements_Types

extension Stripe.WebElements.Address {
    public struct View: HTML {
        let element: Stripe.WebElements.Address

        @Dependency(\.envVars.stripe.publishableKey) var publishableKey
        @Dependency(\.uuid) var uuid

        public init(
            element: Stripe.WebElements.Address
        ) {
            self.element = element

        }

        public var body: some HTML {
            let elementId = "address-\(uuid().uuidString)"

            div {
                div {}
                    .id(elementId)
                    .class("address-element")

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
                            
                            const addressOptions = \(generateOptionsJSON());
                            const addressElement = elements.create('address', addressOptions);
                            addressElement.mount('#\(elementId)');
                            
                            addressElement.on('change', function(event) {
                                if (event.complete) {
                                    // Address is complete
                                    console.log('Address complete:', event.value);
                                }
                            });
                        });
                    })();
                    """
                }

                Style {
                    """
                    .address-element {
                        padding: 12px;
                        border: 1px solid #e0e0e0;
                        border-radius: 4px;
                        background-color: white;
                    }
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
