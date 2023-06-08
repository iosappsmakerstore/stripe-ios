//
//  CustomerSheetTestPlayground.swift
//  PaymentSheet Example
//
//  ⚠️🏗 This is a playground for internal Stripe engineers to help us test things, and isn't
//  an example of what you should do in a real app!
//  Note: Do not import Stripe using `@_spi(STP)` or @_spi(PrivateBetaCustomerSheet) in production.
//  This exposes internal functionality which may cause unexpected behavior if used directly.

import Contacts
import Foundation
import PassKit
@_spi(PrivateBetaCustomerSheet) import StripePaymentSheet
import SwiftUI
import UIKit

@available(iOS 15.0, *)
struct CustomerSheetTestPlayground: View {
    @StateObject var playgroundController: CustomerSheetTestPlaygroundController

    init(settings: CustomerSheetTestPlaygroundSettings) {
        _playgroundController = StateObject(wrappedValue: CustomerSheetTestPlaygroundController(settings: settings))
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Group {
                        HStack {
                            Text("Backend").font(.headline)
                            Spacer()
                            Button {
                                playgroundController.didTapResetConfig()
                            } label: {
                                Text("Reset")
                                    .font(.callout.smallCaps())
                            }.buttonStyle(.bordered)
                        }
                        SettingView(setting: $playgroundController.settings.customerMode)
                        TextField("CustomerId", text: customerIdBinding)
                    }
                }
            }
        }
    }

    var customerIdBinding: Binding<String> {
        Binding<String> {
            return playgroundController.settings.customerId ?? ""
        } set: { newString in
            playgroundController.settings.customerId = (newString != "") ? newString : nil
        }

    }
}


