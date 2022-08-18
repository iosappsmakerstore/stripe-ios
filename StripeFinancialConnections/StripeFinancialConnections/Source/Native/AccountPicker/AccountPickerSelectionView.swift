//
//  AccountPickerSelectionView.swift
//  StripeFinancialConnections
//
//  Created by Krisjanis Gaidis on 8/10/22.
//

import Foundation
import UIKit
@_spi(STP) import StripeUICore

protocol AccountPickerSelectionViewDelegate: AnyObject {
    func accountPickerSelectionView(
        _ view: AccountPickerSelectionView,
        didSelectAccounts selectedAccounts: [FinancialConnectionsPartnerAccount]
    )
}

final class AccountPickerSelectionView: UIView {
    
    private let type: AccountPickerType
    private let allAccounts: [FinancialConnectionsPartnerAccount]
    private weak var delegate: AccountPickerSelectionViewDelegate?
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.spacing = 12
        verticalStackView.axis = .vertical
        return verticalStackView
    }()
    
    init(
        type: AccountPickerType,
        accounts: [FinancialConnectionsPartnerAccount],
        delegate: AccountPickerSelectionViewDelegate
    ) {
        self.type = type
        self.allAccounts = accounts
        self.delegate = delegate
        super.init(frame: .zero)
        addAndPinSubviewToSafeArea(verticalStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectAccounts(_ selectedAccounts: [FinancialConnectionsPartnerAccount]) {
        // clear all previous state
        verticalStackView.arrangedSubviews.forEach { arrangedSubview in
            arrangedSubview.removeFromSuperview()
        }
        
        // list accounts
        switch type {
        case .checkbox:
            fallthrough // `checkbox` and `radioButton` are similar
        case .radioButton:
            if type == .checkbox {
                // show a "all accounts" cell
                let allAccountsCellView = AccountPickerSelectionRowView(
                    type: .checkmark,
                    didSelect: { [weak self] in
                        guard let self = self else { return }
                        let isAllAccountsSelected = (self.allAccounts.count == selectedAccounts.count)
                        var selectedAccounts = selectedAccounts
                        if isAllAccountsSelected {
                            selectedAccounts.removeAll()
                        } else {
                            selectedAccounts = self.allAccounts
                        }
                        self.delegate?.accountPickerSelectionView(self, didSelectAccounts: selectedAccounts)
                    }
                )
                allAccountsCellView.setTitle(
                    STPLocalizedString("All accounts", "A button that allows users to select all their bank accounts. This button appears in a screen that allows users to select which bank accounts they want to use to pay for something."),
                    subtitle: nil,
                    isSelected: (allAccounts.count == selectedAccounts.count)
                )
                verticalStackView.addArrangedSubview(allAccountsCellView)
            }
            
            // list each of the available accounts
            allAccounts.forEach { account in
                let accountCellView = AccountPickerSelectionRowView(
                    type: type == .checkbox ? .checkmark : .radiobutton,
                    didSelect: { [weak self] in
                        guard let self = self else { return }
                        var selectedAccounts = selectedAccounts
                        if let index = selectedAccounts.firstIndex(where: { $0.id == account.id }) {
                            selectedAccounts.remove(at: index)
                        } else {
                            if self.type == .checkbox {
                                selectedAccounts.append(account)
                            } else { // radiobutton
                                selectedAccounts = [account] // select only one account
                            }
                        }
                        self.delegate?.accountPickerSelectionView(self, didSelectAccounts: selectedAccounts)
                    }
                )
                accountCellView.setTitle(
                    account.name,
                    subtitle: {
                        if let displayableAccountNumbers = account.displayableAccountNumbers {
                            return "••••••••\(displayableAccountNumbers)"
                        } else {
                            return nil
                        }
                    }(),
                    isSelected: selectedAccounts.contains(where: { $0.id == account.id })
                )
                verticalStackView.addArrangedSubview(accountCellView)
            }
            
            // TODO(kgaidis): also handle disabled accounts
        case .dropdown:
            fatalError("not implemented") // TODO(kgaidis): implement
        }
    }
}
