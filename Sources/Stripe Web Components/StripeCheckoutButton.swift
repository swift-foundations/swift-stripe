// MARK: - Stripe Checkout Button
// Reusable HTML component for creating Stripe checkout sessions.
// Works with both one-time payments and subscriptions.

import CSS
import Dependencies
import Foundation
import HTML

/// A reusable Stripe checkout button that handles both one-time and subscription payments
public struct StripeCheckoutButton: HTML {
    let productId: String
    let buttonText: String
    let className: String?
    let createSessionEndpoint: URL
    let successUrl: URL?
    let cancelUrl: URL?

    public init(
        productId: String,
        buttonText: String = "Checkout",
        className: String? = "btn btn-primary",
        createSessionEndpoint: URL,
        successUrl: URL? = nil,
        cancelUrl: URL? = nil
    ) {
        self.productId = productId
        self.buttonText = buttonText
        self.className = className
        self.createSessionEndpoint = createSessionEndpoint
        self.successUrl = successUrl
        self.cancelUrl = cancelUrl
    }

    public var body: some HTML {
        div {
            button {
                buttonText
            }
            .id("checkout-button-\(productId)")
            .class(className ?? "")
            .data("product-id", productId)

            script {
                """
                document.getElementById('checkout-button-\(productId)').addEventListener('click', async (e) => {
                    const button = e.target;
                    button.disabled = true;
                    button.textContent = 'Loading...';
                    
                    try {
                        const response = await fetch('\(createSessionEndpoint.absoluteString)', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({
                                productId: '\(productId)',
                                \(successUrl.map { "successUrl: '\($0.absoluteString)'," } ?? "")
                                \(cancelUrl.map { "cancelUrl: '\($0.absoluteString)'" } ?? "")
                            }),
                        });
                        
                        const data = await response.json();
                        
                        if (data.success && data.data.sessionUrl) {
                            window.location.href = data.data.sessionUrl;
                        } else {
                            alert('Failed to create checkout session: ' + (data.message || 'Unknown error'));
                            button.disabled = false;
                            button.textContent = '\(buttonText)';
                        }
                    } catch (error) {
                        console.error('Error:', error);
                        alert('An error occurred. Please try again.');
                        button.disabled = false;
                        button.textContent = '\(buttonText)';
                    }
                });
                """
            }
        }
    }
}

/// A subscription selector with interval choice
public struct StripeSubscriptionSelector: HTML {
    let products: [(id: String, name: String, monthlyPrice: Int, yearlyPrice: Int?)]
    let createSessionEndpoint: URL
    let buttonText: String
    let className: String?

    public init(
        products: [(id: String, name: String, monthlyPrice: Int, yearlyPrice: Int?)],
        createSessionEndpoint: URL,
        buttonText: String = "Subscribe",
        className: String? = "btn btn-primary"
    ) {
        self.products = products
        self.createSessionEndpoint = createSessionEndpoint
        self.buttonText = buttonText
        self.className = className
    }

    public var body: some HTML {
        div {
            // Product selector
            select {
                HTMLForEach(products) { product in
                    option(value: product.id) {
                        "\(product.name) - \((Double(product.monthlyPrice) / 100.0).formatted(.currency(code: "USD")))/month"
                    }
                }
            }
            .id("subscription-selector")
            .style(.width(.percent(100)))
            .style(.padding(.rem(0.5)))
            .style(.marginBottom(.rem(1)))

            // Interval selector
            div {
                label {
                    input(name: "interval", type: .radio)
                        .attribute("value", "month")
                        .attribute("checked", "checked")
                    " Monthly billing"
                }
                .style(.display(.block))
                .style(.marginBottom(.rem(0.5)))

                label {
                    input(name: "interval", type: .radio)
                        .attribute("value", "year")
                    " Annual billing (save up to 20%)"
                }
                .style(.display(.block))
            }
            .style(.marginBottom(.rem(2)))

            // Checkout button
            button {
                buttonText
            }
            .id("subscription-checkout-button")
            .class(className ?? "")
            .style(.width(.percent(100)))

            script {
                """
                document.getElementById('subscription-checkout-button').addEventListener('click', async () => {
                    const button = document.getElementById('subscription-checkout-button');
                    const selector = document.getElementById('subscription-selector');
                    const intervalRadios = document.getElementsByName('interval');
                    
                    let interval = 'month';
                    for (const radio of intervalRadios) {
                        if (radio.checked) {
                            interval = radio.value;
                            break;
                        }
                    }
                    
                    button.disabled = true;
                    button.textContent = 'Loading...';
                    
                    try {
                        const response = await fetch('\(createSessionEndpoint.absoluteString)', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({
                                productId: selector.value,
                                interval: interval
                            }),
                        });
                        
                        const data = await response.json();
                        
                        if (data.success && data.data.sessionUrl) {
                            window.location.href = data.data.sessionUrl;
                        } else {
                            alert('Failed to create checkout session: ' + (data.message || 'Unknown error'));
                            button.disabled = false;
                            button.textContent = '\(buttonText)';
                        }
                    } catch (error) {
                        console.error('Error:', error);
                        alert('An error occurred. Please try again.');
                        button.disabled = false;
                        button.textContent = '\(buttonText)';
                    }
                });
                """
            }
        }
    }
}
