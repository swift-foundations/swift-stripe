import Dependencies
import Foundation
import HTML
import Stripe_Web_Elements_Types

extension Stripe.WebElements.Payment {
    public struct View: HTML {
        let element: Stripe.WebElements.Payment
        let paymentCompletionURL: URL
        let createPaymentIntentEndpoint: URL

        @Dependency(\.uuid) var uuid
        @Dependency(\.envVars.stripe.publishableKey) var publishableKey

        public init(
            element: Stripe.WebElements.Payment,
            paymentCompletionURL: URL,
            createPaymentIntentEndpoint: URL
        ) {
            self.element = element
            self.paymentCompletionURL = paymentCompletionURL
            self.createPaymentIntentEndpoint = createPaymentIntentEndpoint
        }

        public var body: some HTML {
            let paymentElementId = "payment-element-\(uuid().uuidString)"
            let paymentMessageId = "payment-message-\(uuid().uuidString)"
            let paymentFormId = "payment-form-\(uuid().uuidString)"
            let spinnerId = "spinner-\(uuid().uuidString)"
            let buttonTextId = "button-text-\(uuid().uuidString)"
            let submitId = "submit-\(uuid().uuidString)"

            div {
                // Main payment form container
                div {
                    form {
                        // Payment element container
                        div {}
                            .id(paymentElementId)

                        // Submit button with spinner
                        button(type: .submit) {
                            div {}
                                .class("spinner hidden")
                                .id(spinnerId)

                            span {
                                "Pay now"
                            }
                            .id(buttonTextId)
                        }
                        .id(submitId)
                        .class("btn btn-lg btn-primary w-100 mt-3 mb-4")

                        // Payment message container for errors/status
                        div {}
                            .id(paymentMessageId)
                            .class("hidden alert alert-info mt-3")
                    }
                    .id(paymentFormId)
                }
                .class("payment-form-container")

                // Stripe initialization script
                script {
                    """
                    (function() {
                        // Wait for Stripe to load
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
                            let elements;
                            
                            initialize();
                            checkStatus();
                            
                            async function initialize() {
                                try {
                                    const response = await fetch('\(createPaymentIntentEndpoint.absoluteURL)', {
                                        method: "POST",
                                        headers: { "Content-Type": "application/json" },
                                        body: JSON.stringify({ items: [] }),
                                    });
                                    const responseData = await response.json();
                                    
                                    if (!responseData.success || !responseData.data?.clientSecret) {
                                        showMessage(responseData.message || "Failed to create payment intent", "danger");
                                        return;
                                    }
                                    
                                    const clientSecret = responseData.data.clientSecret;
                                
                                const appearance = {
                                    theme: 'stripe',
                                    variables: {
                                        colorPrimary: '#0570de',
                                        colorBackground: '#ffffff',
                                        colorSurface: '#ffffff',
                                        colorText: '#30313d',
                                        colorDanger: '#df1b41',
                                        fontFamily: 'system-ui, sans-serif',
                                        spacingUnit: '2px',
                                        borderRadius: '4px'
                                    }
                                };
                                
                                elements = stripe.elements({ 
                                    appearance, 
                                    clientSecret 
                                });
                                
                                    const paymentElementOptions = \(generatePaymentElementOptionsJSON());
                                    
                                    const paymentElement = elements.create("payment", paymentElementOptions);
                                    paymentElement.mount("#\(paymentElementId)");
                                    
                                    // Only add submit handler after elements are successfully created
                                    document
                                        .querySelector("#\(paymentFormId)")
                                        .addEventListener("submit", handleSubmit);
                                } catch (error) {
                                    console.error('Error initializing payment:', error);
                                    showMessage("Failed to initialize payment form: " + error.message, "danger");
                                }
                            }
                            
                            async function handleSubmit(e) {
                                e.preventDefault();
                                
                                if (!elements) {
                                    showMessage("Payment form not initialized. Please refresh the page.", "danger");
                                    return;
                                }
                                
                                setLoading(true);
                                
                                const { error } = await stripe.confirmPayment({
                                    elements,
                                    confirmParams: {
                                        return_url: "\(paymentCompletionURL.absoluteString)",
                                    },
                                });
                                
                                if (error) {
                                    if (error.type === "card_error" || error.type === "validation_error") {
                                        showMessage(error.message);
                                    } else {
                                        showMessage("An unexpected error occurred.");
                                    }
                                    setLoading(false);
                                }
                            }
                            
                            async function checkStatus() {
                                const clientSecret = new URLSearchParams(window.location.search).get(
                                    "payment_intent_client_secret"
                                );
                                
                                if (!clientSecret) {
                                    return;
                                }
                                
                                const { paymentIntent } = await stripe.retrievePaymentIntent(clientSecret);
                                
                                switch (paymentIntent.status) {
                                    case "succeeded":
                                        showMessage("Payment succeeded!", "success");
                                        break;
                                    case "processing":
                                        showMessage("Your payment is processing.", "info");
                                        break;
                                    case "requires_payment_method":
                                        showMessage("Your payment was not successful, please try again.", "warning");
                                        break;
                                    default:
                                        showMessage("Something went wrong.", "danger");
                                        break;
                                }
                            }
                            
                            function showMessage(messageText, type = "info") {
                                const messageContainer = document.querySelector("#\(paymentMessageId)");
                                
                                messageContainer.className = `alert alert-${type} mt-3`;
                                messageContainer.textContent = messageText;
                                
                                setTimeout(function () {
                                    messageContainer.className = "hidden alert alert-info mt-3";
                                    messageContainer.textContent = "";
                                }, 4000);
                            }
                            
                            function setLoading(isLoading) {
                                if (isLoading) {
                                    document.querySelector("#\(submitId)").disabled = true;
                                    document.querySelector("#\(spinnerId)").classList.remove("hidden");
                                    document.querySelector("#\(buttonTextId)").classList.add("hidden");
                                } else {
                                    document.querySelector("#\(submitId)").disabled = false;
                                    document.querySelector("#\(spinnerId)").classList.add("hidden");
                                    document.querySelector("#\(buttonTextId)").classList.remove("hidden");
                                }
                            }
                        });
                    })();
                    """
                }

                Style {
                    """
                    #\(paymentElementId) {
                        min-height: 300px;
                        padding: 20px;
                        background: white;
                        border: 1px solid #e0e0e0;
                        border-radius: 8px;
                        margin-bottom: 20px;
                    }

                    .spinner {
                        display: inline-block;
                        width: 20px;
                        height: 20px;
                        border: 3px solid rgba(255, 255, 255, 0.3);
                        border-radius: 50%;
                        border-top-color: white;
                        animation: spin 1s ease-in-out infinite;
                    }

                    @keyframes spin {
                        to { transform: rotate(360deg); }
                    }

                    .hidden {
                        display: none !important;
                    }

                    .payment-form-container {
                        max-width: 600px;
                        margin: 0 auto;
                        padding: 20px;
                    }

                    /* Stripe Elements specific styling */
                    .StripeElement {
                        padding: 15px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        background-color: white;
                        transition: all 0.3s;
                    }

                    .StripeElement--focus {
                        border-color: #0570de;
                        box-shadow: 0 0 0 2px rgba(5, 112, 222, 0.1);
                    }

                    .StripeElement--invalid {
                        border-color: #df1b41;
                    }

                    .StripeElement--complete {
                        border-color: #28a745;
                    }
                    """
                }
            }
        }

        // Helper function to generate PaymentElement options JSON
        private func generatePaymentElementOptionsJSON() -> String {
            guard let options = element.options else { return "{}" }

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]

            return (try? encoder.encode(options))
                .flatMap { String(data: $0, encoding: .utf8) }
                ?? "{}"
        }
    }
}
