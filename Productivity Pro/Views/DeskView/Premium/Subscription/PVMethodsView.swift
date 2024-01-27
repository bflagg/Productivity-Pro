//
//  PVMethodsView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 05.12.23.
//

import Foundation
import StoreKit

extension PremiumView {
    
    func subscribe() async {
        DispatchQueue.main.async {
            load = true
        }
        
        do {
            
            guard let subscription = storeVM.subscriptions.first else { return }
            
            if try await storeVM.purchase(subscription) != nil {
                isSubscribed = true
                dismiss()
            }
            
        } catch {
            print("purchase failed")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            load = false
        }
    }
    
    func restore() {
        
    }
    
}
