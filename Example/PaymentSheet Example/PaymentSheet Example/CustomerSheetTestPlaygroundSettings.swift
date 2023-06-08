//
//  CustomerSheetTestPlaygroundSettings.swift
//  PaymentSheet Example
//

import Foundation

struct CustomerSheetTestPlaygroundSettings: Codable, Equatable {
    enum CustomerMode: String, PickerEnum {
        static var enumName: String { "CustomerMode" }
        case new
        case returning
        case id
    }
    var customerMode: CustomerMode
    var customerId: String?


    static func defaultValues() -> CustomerSheetTestPlaygroundSettings {
        return CustomerSheetTestPlaygroundSettings(customerMode: .new)
    }

    static let nsUserDefaultsKey = "CustomerSheetPlaygroundSettings"

}
