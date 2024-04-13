//
//  PremiumBadge.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 24.09.23.
//

import SwiftUI

struct PremiumBadge: ViewModifier {
    @AppStorage("ppisunlocked") var isUnlocked: Bool = false
    
    func body(content: Content) -> some View {
        if isUnlocked {
            content
        } else {
            content
                .badge(Text("Premium"))
        }
    }
}
