// swift-tools-version: 6.3.3

import Foundation
import PackageDescription

extension String {
    static let stripe: Self = "Stripe"
    static let stripeBalance: Self = "Stripe Balance"
    static let stripeBalanceTransactions: Self = "Stripe Balance Transactions"
    static let stripeCharges: Self = "Stripe Charges"
    static let stripeCustomers: Self = "Stripe Customers"
    static let stripeCustomerSession: Self = "Stripe Customer Session"
    static let stripeDisputes: Self = "Stripe Disputes"
    static let stripeEvents: Self = "Stripe Events"
    static let stripeEventDestinations: Self = "Stripe Event Destinations"
    static let stripeFiles: Self = "Stripe Files"
    static let stripeFileLinks: Self = "Stripe File Links"
    static let stripeMandates: Self = "Stripe Mandates"
    static let stripePaymentIntents: Self = "Stripe Payment Intents"
    static let stripeSetupIntents: Self = "Stripe Setup Intents"
    static let stripeSetupAttempts: Self = "Stripe Setup Attempts"
    static let stripePayouts: Self = "Stripe Payouts"
    static let stripeRefunds: Self = "Stripe Refunds"
    static let stripeConfirmationToken: Self = "Stripe Confirmation Token"
    static let stripeTokens: Self = "Stripe Tokens"
    static let stripePaymentMethods: Self = "Stripe Payment Methods"
    static let stripeProducts: Self = "Stripe Products"
    static let stripeCheckout: Self = "Stripe Checkout"
    static let stripePaymentLink: Self = "Stripe Payment Link"
    static let stripeBilling: Self = "Stripe Billing"
    static let stripeCapital: Self = "Stripe Capital"
    static let stripeConnect: Self = "Stripe Connect"
    static let stripeFraud: Self = "Stripe Fraud"
    static let stripeIssuing: Self = "Stripe Issuing"
    static let stripeTerminal: Self = "Stripe Terminal"
    static let stripeTreasury: Self = "Stripe Treasury"
    static let stripeEntitlements: Self = "Stripe Entitlements"
    static let stripeSigma: Self = "Stripe Sigma"
    static let stripeReporting: Self = "Stripe Reporting"
    static let stripeFinancialConnections: Self = "Stripe Financial Connections"
    static let stripeTax: Self = "Stripe Tax"
    static let stripeIdentity: Self = "Stripe Identity"
    static let stripeCrypto: Self = "Stripe Crypto"
    static let stripeClimate: Self = "Stripe Climate"
    static let stripeForwarding: Self = "Stripe Forwarding"
    static let stripeWebhooks: Self = "Stripe Webhooks"
    static let stripeWebElements: Self = "Stripe Web Elements"
    static let stripeShared: Self = "Stripe Shared"
}

extension Target.Dependency {
    static var stripe: Self { .target(name: .stripe) }
    static var stripeBalance: Self { .target(name: .stripeBalance) }
    static var stripeBalanceTransactions: Self { .target(name: .stripeBalanceTransactions) }
    static var stripeCharges: Self { .target(name: .stripeCharges) }
    static var stripeCustomers: Self { .target(name: .stripeCustomers) }
    static var stripeCustomerSession: Self { .target(name: .stripeCustomerSession) }
    static var stripeDisputes: Self { .target(name: .stripeDisputes) }
    static var stripeEvents: Self { .target(name: .stripeEvents) }
    static var stripeEventDestinations: Self { .target(name: .stripeEventDestinations) }
    static var stripeFiles: Self { .target(name: .stripeFiles) }
    static var stripeFileLinks: Self { .target(name: .stripeFileLinks) }
    static var stripeMandates: Self { .target(name: .stripeMandates) }
    static var stripePaymentIntents: Self { .target(name: .stripePaymentIntents) }
    static var stripeSetupIntents: Self { .target(name: .stripeSetupIntents) }
    static var stripeSetupAttempts: Self { .target(name: .stripeSetupAttempts) }
    static var stripePayouts: Self { .target(name: .stripePayouts) }
    static var stripeRefunds: Self { .target(name: .stripeRefunds) }
    static var stripeConfirmationToken: Self { .target(name: .stripeConfirmationToken) }
    static var stripeTokens: Self { .target(name: .stripeTokens) }
    static var stripePaymentMethods: Self { .target(name: .stripePaymentMethods) }
    static var stripeProducts: Self { .target(name: .stripeProducts) }
    static var stripeCheckout: Self { .target(name: .stripeCheckout) }
    static var stripePaymentLink: Self { .target(name: .stripePaymentLink) }
    static var stripeBilling: Self { .target(name: .stripeBilling) }
    static var stripeCapital: Self { .target(name: .stripeCapital) }
    static var stripeConnect: Self { .target(name: .stripeConnect) }
    static var stripeFraud: Self { .target(name: .stripeFraud) }
    static var stripeIssuing: Self { .target(name: .stripeIssuing) }
    static var stripeTerminal: Self { .target(name: .stripeTerminal) }
    static var stripeTreasury: Self { .target(name: .stripeTreasury) }
    static var stripeEntitlements: Self { .target(name: .stripeEntitlements) }
    static var stripeSigma: Self { .target(name: .stripeSigma) }
    static var stripeReporting: Self { .target(name: .stripeReporting) }
    static var stripeFinancialConnections: Self { .target(name: .stripeFinancialConnections) }
    static var stripeTax: Self { .target(name: .stripeTax) }
    static var stripeIdentity: Self { .target(name: .stripeIdentity) }
    static var stripeCrypto: Self { .target(name: .stripeCrypto) }
    static var stripeClimate: Self { .target(name: .stripeClimate) }
    static var stripeForwarding: Self { .target(name: .stripeForwarding) }
    static var stripeWebhooks: Self { .target(name: .stripeWebhooks) }
    static var stripeWebElements: Self { .target(name: .stripeWebElements) }
    static var stripeShared: Self { .target(name: .stripeShared) }
}

extension Target.Dependency {
    static var stripeLive: Self { .product(name: "Stripe Live", package: "swift-stripe-live") }
    static var stripeBalanceLive: Self { .product(name: "Stripe Balance Live", package: "swift-stripe-live") }
    static var stripeBalanceTransactionsLive: Self { .product(name: "Stripe Balance Transactions Live", package: "swift-stripe-live") }
    static var stripeChargesLive: Self { .product(name: "Stripe Charges Live", package: "swift-stripe-live") }
    static var stripeCustomersLive: Self { .product(name: "Stripe Customers Live", package: "swift-stripe-live") }
    static var stripeCustomerSessionLive: Self { .product(name: "Stripe Customer Session Live", package: "swift-stripe-live") }
    static var stripeDisputesLive: Self { .product(name: "Stripe Disputes Live", package: "swift-stripe-live") }
    static var stripeEventsLive: Self { .product(name: "Stripe Events Live", package: "swift-stripe-live") }
    static var stripeEventDestinationsLive: Self { .product(name: "Stripe Event Destinations Live", package: "swift-stripe-live") }
    static var stripeFilesLive: Self { .product(name: "Stripe Files Live", package: "swift-stripe-live") }
    static var stripeFileLinksLive: Self { .product(name: "Stripe File Links Live", package: "swift-stripe-live") }
    static var stripeMandatesLive: Self { .product(name: "Stripe Mandates Live", package: "swift-stripe-live") }
    static var stripePaymentIntentsLive: Self { .product(name: "Stripe Payment Intents Live", package: "swift-stripe-live") }
    static var stripeSetupIntentsLive: Self { .product(name: "Stripe Setup Intents Live", package: "swift-stripe-live") }
    static var stripeSetupAttemptsLive: Self { .product(name: "Stripe Setup Attempts Live", package: "swift-stripe-live") }
    static var stripePayoutsLive: Self { .product(name: "Stripe Payouts Live", package: "swift-stripe-live") }
    static var stripeRefundsLive: Self { .product(name: "Stripe Refunds Live", package: "swift-stripe-live") }
    static var stripeConfirmationTokenLive: Self { .product(name: "Stripe Confirmation Token Live", package: "swift-stripe-live") }
    static var stripeTokensLive: Self { .product(name: "Stripe Tokens Live", package: "swift-stripe-live") }
    static var stripePaymentMethodsLive: Self { .product(name: "Stripe Payment Methods Live", package: "swift-stripe-live") }
    static var stripeProductsLive: Self { .product(name: "Stripe Products Live", package: "swift-stripe-live") }
    static var stripeCheckoutLive: Self { .product(name: "Stripe Checkout Live", package: "swift-stripe-live") }
    static var stripePaymentLinkLive: Self { .product(name: "Stripe Payment Link Live", package: "swift-stripe-live") }
    static var stripeBillingLive: Self { .product(name: "Stripe Billing Live", package: "swift-stripe-live") }
    static var stripeCapitalLive: Self { .product(name: "Stripe Capital Live", package: "swift-stripe-live") }
    static var stripeConnectLive: Self { .product(name: "Stripe Connect Live", package: "swift-stripe-live") }
    static var stripeFraudLive: Self { .product(name: "Stripe Fraud Live", package: "swift-stripe-live") }
    static var stripeIssuingLive: Self { .product(name: "Stripe Issuing Live", package: "swift-stripe-live") }
    static var stripeTerminalLive: Self { .product(name: "Stripe Terminal Live", package: "swift-stripe-live") }
    static var stripeTreasuryLive: Self { .product(name: "Stripe Treasury Live", package: "swift-stripe-live") }
    static var stripeEntitlementsLive: Self { .product(name: "Stripe Entitlements Live", package: "swift-stripe-live") }
    static var stripeSigmaLive: Self { .product(name: "Stripe Sigma Live", package: "swift-stripe-live") }
    static var stripeReportingLive: Self { .product(name: "Stripe Reporting Live", package: "swift-stripe-live") }
    static var stripeFinancialConnectionsLive: Self { .product(name: "Stripe Financial Connections Live", package: "swift-stripe-live") }
    static var stripeTaxLive: Self { .product(name: "Stripe Tax Live", package: "swift-stripe-live") }
    static var stripeIdentityLive: Self { .product(name: "Stripe Identity Live", package: "swift-stripe-live") }
    static var stripeCryptoLive: Self { .product(name: "Stripe Crypto Live", package: "swift-stripe-live") }
    static var stripeClimateLive: Self { .product(name: "Stripe Climate Live", package: "swift-stripe-live") }
    static var stripeForwardingLive: Self { .product(name: "Stripe Forwarding Live", package: "swift-stripe-live") }
    static var stripeWebhooksLive: Self { .product(name: "Stripe Webhooks Live", package: "swift-stripe-live") }
}

extension Target.Dependency {
    static var stripeLiveShared: Self { .product(name: "Stripe Live Shared", package: "swift-stripe-live") }
    static var stripeWebElementsTypes: Self { .product(name: "Stripe Web Elements Types", package: "swift-stripe-types") }
    static var stripeEventsTypes: Self { .product(name: "Stripe Events Types", package: "swift-stripe-types") }
}

extension Target.Dependency {
    static var environmentDependencies: Self { .product(name: "Environment Dependencies", package: "swift-environment-dependencies") }
    static var authenticating: Self { .product(name: "Authentication Foundation Integration", package: "swift-url-routing-authentication") }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing") }
    static var dependenciesTestSupport: Self { .product(name: "Dependencies Test Support", package: "swift-dependencies") }
    static var html: Self { .product(name: "HTML", package: "swift-html") }
}

let package = Package(
    name: "swift-stripe",
    platforms: [
        .macOS(.v26),
        .iOS(.v26)
    ],
    products: [
        .library(name: .stripe, targets: [.stripe]),
        .library(name: .stripeBalance, targets: [.stripeBalance]),
        .library(name: .stripeBalanceTransactions, targets: [.stripeBalanceTransactions]),
        .library(name: .stripeCharges, targets: [.stripeCharges]),
        .library(name: .stripeCustomers, targets: [.stripeCustomers]),
        .library(name: .stripeCustomerSession, targets: [.stripeCustomerSession]),
        .library(name: .stripeDisputes, targets: [.stripeDisputes]),
        .library(name: .stripeEvents, targets: [.stripeEvents]),
        .library(name: .stripeEventDestinations, targets: [.stripeEventDestinations]),
        .library(name: .stripeFiles, targets: [.stripeFiles]),
        .library(name: .stripeFileLinks, targets: [.stripeFileLinks]),
        .library(name: .stripeMandates, targets: [.stripeMandates]),
        .library(name: .stripePaymentIntents, targets: [.stripePaymentIntents]),
        .library(name: .stripeSetupIntents, targets: [.stripeSetupIntents]),
        .library(name: .stripeSetupAttempts, targets: [.stripeSetupAttempts]),
        .library(name: .stripePayouts, targets: [.stripePayouts]),
        .library(name: .stripeRefunds, targets: [.stripeRefunds]),
        .library(name: .stripeConfirmationToken, targets: [.stripeConfirmationToken]),
        .library(name: .stripeTokens, targets: [.stripeTokens]),
        .library(name: .stripePaymentMethods, targets: [.stripePaymentMethods]),
        .library(name: .stripeProducts, targets: [.stripeProducts]),
        .library(name: .stripeCheckout, targets: [.stripeCheckout]),
        .library(name: .stripePaymentLink, targets: [.stripePaymentLink]),
        .library(name: .stripeBilling, targets: [.stripeBilling]),
        .library(name: .stripeCapital, targets: [.stripeCapital]),
        .library(name: .stripeConnect, targets: [.stripeConnect]),
        .library(name: .stripeFraud, targets: [.stripeFraud]),
        .library(name: .stripeIssuing, targets: [.stripeIssuing]),
        .library(name: .stripeTerminal, targets: [.stripeTerminal]),
        .library(name: .stripeTreasury, targets: [.stripeTreasury]),
        .library(name: .stripeEntitlements, targets: [.stripeEntitlements]),
        .library(name: .stripeSigma, targets: [.stripeSigma]),
        .library(name: .stripeReporting, targets: [.stripeReporting]),
        .library(name: .stripeFinancialConnections, targets: [.stripeFinancialConnections]),
        .library(name: .stripeTax, targets: [.stripeTax]),
        .library(name: .stripeIdentity, targets: [.stripeIdentity]),
        .library(name: .stripeCrypto, targets: [.stripeCrypto]),
        .library(name: .stripeClimate, targets: [.stripeClimate]),
        .library(name: .stripeForwarding, targets: [.stripeForwarding]),
        .library(name: .stripeWebhooks, targets: [.stripeWebhooks]),
        .library(name: .stripeWebElements, targets: [.stripeWebElements])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-url-routing.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-url-routing-authentication.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-environment-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-stripe-types.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-stripe-live.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-html.git", branch: "main")
    ],
    targets: [
        .target(
            name: .stripeShared,
            dependencies: [
                .environmentDependencies,
                .authenticating,
                .urlRouting,
                .stripeLiveShared,
                .stripeEventsTypes
            ]
        ),
        .target(
            name: .stripe,
            dependencies: [
                .stripeLive,
                .stripeShared,
                .environmentDependencies,
                .stripeBalance,
                .stripeBalanceTransactions,
                .stripeCharges,
                .stripeCustomers,
                .stripeCustomerSession,
                .stripeDisputes,
                .stripeEvents,
                .stripeEventDestinations,
                .stripeFiles,
                .stripeFileLinks,
                .stripeMandates,
                .stripePaymentIntents,
                .stripeSetupIntents,
                .stripeSetupAttempts,
                .stripePayouts,
                .stripeRefunds,
                .stripeConfirmationToken,
                .stripeTokens,
                .stripePaymentMethods,
                .stripeProducts,
                .stripeCheckout,
                .stripePaymentLink,
                .stripeBilling,
                .stripeCapital,
                .stripeConnect,
                .stripeFraud,
                .stripeIssuing,
                .stripeTerminal,
                .stripeTreasury,
                .stripeEntitlements,
                .stripeSigma,
                .stripeReporting,
                .stripeFinancialConnections,
                .stripeTax,
                .stripeIdentity,
                .stripeCrypto,
                .stripeClimate,
                .stripeForwarding,
                .stripeWebhooks
                // HTML-STORY GATE (E-1 R-1, supervisor 2026-07-13 13:27:53): "Stripe Web
                // Elements" is DETACHED from the aggregate — its 8 files are pf-HTML-era
                // DSL (265 errors against institute swift-html) and rewriting them would
                // decide the open HTML-email/HTML-presentation ruling by construction.
                // Same gate as swift-email's parked surface and the app's HTMLWebsite
                // stopgap. The standalone "Stripe Web Elements" product stays vended;
                // re-attach when the HTML-story ruling lands.
            ]
        ),
        .testTarget(
            name: "Stripe Shared Tests",
            dependencies: [
                .stripeShared,
                .dependenciesTestSupport
            ]
        ),
        .testTarget(
            name: "Stripe Tests",
            dependencies: [
                .stripe,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeBalance,
            dependencies: [
                .stripeBalanceLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Balance Tests",
            dependencies: [
                .stripeBalance,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeBalanceTransactions,
            dependencies: [
                .stripeBalanceTransactionsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Balance Transactions Tests",
            dependencies: [
                .stripeBalanceTransactions,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCharges,
            dependencies: [
                .stripeChargesLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Charges Tests",
            dependencies: [
                .stripeCharges,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCustomers,
            dependencies: [
                .stripeCustomersLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Customers Tests",
            dependencies: [
                .stripeCustomers,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCustomerSession,
            dependencies: [
                .stripeCustomerSessionLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Customer Session Tests",
            dependencies: [
                .stripeCustomerSession,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeDisputes,
            dependencies: [
                .stripeDisputesLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Disputes Tests",
            dependencies: [
                .stripeDisputes,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeEvents,
            dependencies: [
                .stripeEventsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Events Tests",
            dependencies: [
                .stripeEvents,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeEventDestinations,
            dependencies: [
                .stripeEventDestinationsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Event Destinations Tests",
            dependencies: [
                .stripeEventDestinations,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFiles,
            dependencies: [
                .stripeFilesLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Files Tests",
            dependencies: [
                .stripeFiles,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFileLinks,
            dependencies: [
                .stripeFileLinksLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe File Links Tests",
            dependencies: [
                .stripeFileLinks,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeMandates,
            dependencies: [
                .stripeMandatesLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Mandates Tests",
            dependencies: [
                .stripeMandates,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePaymentIntents,
            dependencies: [
                .stripePaymentIntentsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Payment Intents Tests",
            dependencies: [
                .stripePaymentIntents,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeSetupIntents,
            dependencies: [
                .stripeSetupIntentsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Setup Intents Tests",
            dependencies: [
                .stripeSetupIntents,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeSetupAttempts,
            dependencies: [
                .stripeSetupAttemptsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Setup Attempts Tests",
            dependencies: [
                .stripeSetupAttempts,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePayouts,
            dependencies: [
                .stripePayoutsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Payouts Tests",
            dependencies: [
                .stripePayouts,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeRefunds,
            dependencies: [
                .stripeRefundsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Refunds Tests",
            dependencies: [
                .stripeRefunds,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeConfirmationToken,
            dependencies: [
                .stripeConfirmationTokenLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Confirmation Token Tests",
            dependencies: [
                .stripeConfirmationToken,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTokens,
            dependencies: [
                .stripeTokensLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Tokens Tests",
            dependencies: [
                .stripeTokens,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePaymentMethods,
            dependencies: [
                .stripePaymentMethodsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Payment Methods Tests",
            dependencies: [
                .stripePaymentMethods,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeProducts,
            dependencies: [
                .stripeProductsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Products Tests",
            dependencies: [
                .stripeProducts,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCheckout,
            dependencies: [
                .stripeCheckoutLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Checkout Tests",
            dependencies: [
                .stripeCheckout,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePaymentLink,
            dependencies: [
                .stripePaymentLinkLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Payment Link Tests",
            dependencies: [
                .stripePaymentLink,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeBilling,
            dependencies: [
                .stripeBillingLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Billing Tests",
            dependencies: [
                .stripeBilling,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCapital,
            dependencies: [
                .stripeCapitalLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Capital Tests",
            dependencies: [
                .stripeCapital,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeConnect,
            dependencies: [
                .stripeConnectLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Connect Tests",
            dependencies: [
                .stripeConnect,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFraud,
            dependencies: [
                .stripeFraudLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Fraud Tests",
            dependencies: [
                .stripeFraud,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeIssuing,
            dependencies: [
                .stripeIssuingLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Issuing Tests",
            dependencies: [
                .stripeIssuing,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTerminal,
            dependencies: [
                .stripeTerminalLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Terminal Tests",
            dependencies: [
                .stripeTerminal,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTreasury,
            dependencies: [
                .stripeTreasuryLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Treasury Tests",
            dependencies: [
                .stripeTreasury,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeEntitlements,
            dependencies: [
                .stripeEntitlementsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Entitlements Tests",
            dependencies: [
                .stripeEntitlements,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeSigma,
            dependencies: [
                .stripeSigmaLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Sigma Tests",
            dependencies: [
                .stripeSigma,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeReporting,
            dependencies: [
                .stripeReportingLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Reporting Tests",
            dependencies: [
                .stripeReporting,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFinancialConnections,
            dependencies: [
                .stripeFinancialConnectionsLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Financial Connections Tests",
            dependencies: [
                .stripeFinancialConnections,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTax,
            dependencies: [
                .stripeTaxLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Tax Tests",
            dependencies: [
                .stripeTax,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeIdentity,
            dependencies: [
                .stripeIdentityLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Identity Tests",
            dependencies: [
                .stripeIdentity,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCrypto,
            dependencies: [
                .stripeCryptoLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Crypto Tests",
            dependencies: [
                .stripeCrypto,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeClimate,
            dependencies: [
                .stripeClimateLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Climate Tests",
            dependencies: [
                .stripeClimate,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeForwarding,
            dependencies: [
                .stripeForwardingLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Forwarding Tests",
            dependencies: [
                .stripeForwarding,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeWebhooks,
            dependencies: [
                .stripeWebhooksLive,
                .stripeShared,
                .environmentDependencies
            ]
        ),
        .testTarget(
            name: "Stripe Webhooks Tests",
            dependencies: [
                .stripeWebhooks,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeWebElements,
            dependencies: [
                .stripeWebElementsTypes,
                .stripeShared,
                .environmentDependencies,
                .html
            ]
        ),
        .testTarget(
            name: "Stripe Web Elements Tests",
            dependencies: [
                .stripeWebElements,
                .dependenciesTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("StrictUnsafe"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
//    .unsafeFlags(["-warnings-as-errors"]),
    // .unsafeFlags([
    //   "-Xfrontend",
    //   "-warn-long-function-bodies=50",
    //   "-Xfrontend",
    //   "-warn-long-expression-type-checking=50",
    // ])
]

for index in package.targets.indices {
    package.targets[index].swiftSettings = (package.targets[index].swiftSettings ?? []) + swiftSettings
}
