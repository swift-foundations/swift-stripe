import Dependencies
import Environment_Dependencies
import Foundation
import HTML
import Stripe_Live_Shared
import Stripe_Web_Elements_Types

extension Stripe.WebElements.TaxID {
    public struct View: HTML.View {
        let element: Stripe.WebElements.TaxID
        let elementId: String
        let styledElement: HTML.AnyView
        @Dependency(\.uuid) var uuid
        @Dependency(\.envVars.stripe.publishableKey) var publishableKey

        public init(
            element: Stripe.WebElements.TaxID
        ) {
            @Dependency(\.uuid) var uuid

            let elementId = "tax-id-\(uuid().uuidString)"

            let styledElement = HTML.AnyView(
                div {}
                    .id(elementId)
                    .css
                    .padding(.rem(1))
                    .borderRadius(.px(4))
                    .border(.init(width: .px(1), style: .solid, color: .hex("#ccc")))
                    .backgroundColor(.white)
            )

            self.elementId = elementId
            self.styledElement = styledElement
            self.element = element
        }

        public var body: some HTML.View {

            div {
                styledElement

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
                            
                            const taxIdOptions = \(generateOptionsJSON());
                            const taxIdElement = elements.create('taxId', taxIdOptions);
                            taxIdElement.mount('#\(elementId)');
                            
                            taxIdElement.on('change', function(event) {
                                if (event.complete) {
                                    console.log('Tax ID complete:', event.value);
                                }
                            });
                        });


                    })();
                    """
                }

                HTML_Standard.Style {
                    HTML.Raw(
                        """
                        .tax-id-element {
                            padding: 12px;
                            border: 1px solid #e0e0e0;
                            border-radius: 4px;
                            background-color: white;
                        }
                        """
                    )
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
