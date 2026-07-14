import Dependencies
import Environment_Dependencies
import Foundation
import HTML
import Stripe_Live_Shared
import Stripe_Web_Elements_Types

extension Stripe.WebElements.LinkAuthentication {
    public struct View: HTML.View {
        let element: Stripe.WebElements.LinkAuthentication

        @Dependency(\.uuid) var uuid
        @Dependency(\.envVars.stripe.publishableKey) var publishableKey

        public init(
            element: Stripe.WebElements.LinkAuthentication
        ) {
            self.element = element
        }

        public var body: some HTML.View {
            let elementId = "link-auth-\(uuid().uuidString)"

            div {
                div {}
                    .id(elementId)
                    .class("link-authentication-element")

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
                            
                            const linkAuthOptions = \(generateOptionsJSON());
                            const linkAuthentication = elements.create('linkAuthentication', linkAuthOptions);
                            linkAuthentication.mount('#\(elementId)');
                            
                            linkAuthentication.on('change', function(event) {
                                if (event.complete) {
                                    console.log('Link authentication complete:', event.value);
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
