import Dependencies
import Environment_Dependencies
import Foundation
import HTML
import Stripe_Live_Shared
import Stripe_Web_Elements_Types

extension Stripe.WebElements.CurrencySelector {
    public struct View: HTML.View {
        let element: Stripe.WebElements.CurrencySelector

        @Dependency(\.envVars.stripe.publishableKey) var publishableKey
        @Dependency(\.uuid) var uuid

        public init(
            element: Stripe.WebElements.CurrencySelector,
        ) {
            self.element = element
        }

        public var body: some HTML.View {
            let elementId = "currency-selector-\(uuid().uuidString)"

            div {
                div {}
                    .id(elementId)
                    .class("currency-selector-element")

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
                            
                            const currencySelectorOptions = \(generateOptionsJSON());
                            const currencySelector = elements.create('currencySelector', currencySelectorOptions);
                            currencySelector.mount('#\(elementId)');
                            
                            currencySelector.on('change', function(event) {
                                console.log('Currency changed:', event.value);
                            });
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
