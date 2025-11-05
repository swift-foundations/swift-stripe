import Dependencies
import Foundation
import HTML
import Stripe_Web_Elements_Types

extension Stripe.WebElements.ExpressCheckout {
    public struct View: HTML {
        let element: Stripe.WebElements.ExpressCheckout
        let returnURL: URL
        let createPaymentIntentEndpoint: URL

        @Dependency(\.uuid) var uuid
        @Dependency(\.envVars.stripe.publishableKey) var publishableKey

        public init(
            element: Stripe.WebElements.ExpressCheckout,
            returnURL: URL,
            createPaymentIntentEndpoint: URL
        ) {
            self.element = element
            self.returnURL = returnURL
            self.createPaymentIntentEndpoint = createPaymentIntentEndpoint
        }

        public var body: some HTML {
            let elementId = "express-checkout-\(uuid().uuidString)"

            div {
                div {}
                    .id(elementId)
                    .class("express-checkout-element")

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
                        
                        waitForStripe(async function() {
                            const stripe = Stripe('\(publishableKey)');
                            
                            // First, create a payment intent to get the clientSecret
                            const response = await fetch('\(createPaymentIntentEndpoint.absoluteURL)', {
                                method: "POST",
                                headers: { "Content-Type": "application/json" },
                                body: JSON.stringify({ items: [] }),
                            });
                            const responseData = await response.json();
                            
                            if (!responseData.success || !responseData.data?.clientSecret) {
                                console.error('Failed to create payment intent:', responseData.message);
                                return;
                            }
                            
                            const clientSecret = responseData.data.clientSecret;
                            
                            // Now create elements with the clientSecret
                            const elements = stripe.elements({ clientSecret });
                            const expressCheckoutOptions = \(generateOptionsJSON());
                            
                            const expressCheckout = elements.create('expressCheckout', expressCheckoutOptions);
                            expressCheckout.mount('#\(elementId)');
                            
                            expressCheckout.on('click', function(event) {
                                const options = {
                                    emailRequired: true
                                };
                                event.resolve(options);
                            });
                            
                            expressCheckout.on('confirm', async function(event) {
                                const {error} = await stripe.confirmPayment({
                                    elements,
                                    confirmParams: {
                                        return_url: '\(returnURL.absoluteString)'
                                    }
                                });
                                
                                if (error) {
                                    console.error('Payment failed:', error);
                                }
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
