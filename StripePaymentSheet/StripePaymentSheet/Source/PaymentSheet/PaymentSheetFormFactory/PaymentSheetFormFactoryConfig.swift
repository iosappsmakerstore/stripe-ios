//
//  PaymentSheetFormFactoryConfig.swift
//  StripePaymentSheet
//

import Foundation

@_spi(STP) import StripePayments

enum PaymentSheetFormFactoryConfig {
    case paymentSheet(PaymentSheet.Configuration)
    case customerSheet(CustomerSheet.Configuration)

    var customer: PaymentSheet.CustomerConfiguration? {
        switch self {
        case .paymentSheet(let config):
            return config.customer
        case .customerSheet:
            return nil // TODO: Pass in adapter.
        }
    }
    var merchantDisplayName: String {
        switch self {
        case .paymentSheet(let config):
            return config.merchantDisplayName
        case .customerSheet:
            assertionFailure("Using merchantDisplayName w/ Customer Sheet. Please file a bug at https://github.com/stripe/stripe-ios")
            return ""
        }
    }
    var linkPaymentMethodsOnly: Bool {
        switch self {
        case .paymentSheet(let config):
            return config.linkPaymentMethodsOnly
        case .customerSheet:
            return false
        }
    }
    var billingDetailsCollectionConfiguration: PaymentSheet.BillingDetailsCollectionConfiguration {
        switch self {
        case .paymentSheet(let config):
            return config.billingDetailsCollectionConfiguration
        case .customerSheet:
            return PaymentSheet.BillingDetailsCollectionConfiguration()
        }
    }
    var appearance: PaymentSheet.Appearance {
        switch self {
        case .paymentSheet(let config):
            return config.appearance
        case .customerSheet(let config):
            return config.appearance
        }
    }
    var defaultBillingDetails: PaymentSheet.BillingDetails {
        switch self {
        case .paymentSheet(let config):
            return config.defaultBillingDetails
        case .customerSheet:
            return PaymentSheet.BillingDetails()
        }
    }
    var shippingDetails: () -> AddressViewController.AddressDetails? {
        switch self {
        case .paymentSheet(let config):
            return config.shippingDetails
        case .customerSheet:
            return { return nil }
        }
    }
    var savePaymentMethodOptInBehavior: PaymentSheet.SavePaymentMethodOptInBehavior {
        switch self {
        case .paymentSheet(let config):
            return config.savePaymentMethodOptInBehavior
        case .customerSheet:
            return .automatic
        }
    }
}
