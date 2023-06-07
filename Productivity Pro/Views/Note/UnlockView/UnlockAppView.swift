//
//  UnlockAppView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 28.02.23.
//

import SwiftUI
import StoreKit

struct UnlockAppView: View {
    
    @Environment(\.horizontalSizeClass) var hsc
    @EnvironmentObject private var model: UnlockModel
    
    @StateObject var subviewManager: SubviewManager
    @AppStorage("fullAppUnlocked")
    var isFullAppUnlocked: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            
            ZStack {
                Group {
                    Color.clear
                        .edgesIgnoringSafeArea(.all)
                    
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height
                        )
                }
                .blur(radius: 10)
                
                VStack {
                    Text("Unlock **Productivity Pro**")
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                        .padding(.bottom, 3)
                        .padding(.horizontal, 7)
                    
                    Text("Upgrade to the full version of **Productivity Pro** for unlimited note taking.")
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 13)
                    
                    Spacer()
                    
                    Button(action: {
                        if let item = model.items.first {
                            Task {
                                await model.purchase(item)
                            }
                        }
                    }) {
                        UnlockButton(size: proxy.size)
                    }
                    .padding(.bottom, 40)
                }
                .multilineTextAlignment(.center)
                
            }
            .edgesIgnoringSafeArea(.all)
            .position(
                x: proxy.size.width / 2,
                y: proxy.size.height / 2
            )
        }
        .onChange(of: model.action) { action in
            if action == .successful {
                isFullAppUnlocked = true
                
                subviewManager.isPresentationMode = false
                subviewManager.showUnlockView = false
            }
        }
        .alert(
            isPresented: $model.hasError,
            error: model.error
        ) {}
    }
    
    @ViewBuilder func UnlockButton(size: CGSize) -> some View {
        Text("Unlock for \(model.items.first?.displayPrice ?? "")")
            .font(.title2.bold())
            .foregroundColor(.white)
            .frame(
                width: buttonSize(size: size),
                height: 60
            )
            .background(Color.accentColor)
            .cornerRadius(16)
    }
    
    func buttonSize(size: CGSize) -> CGFloat {
        var width: CGFloat = .zero
        
        if hsc == .compact {
            width = size.width / 1.5
        } else {
            width = size.width / 1.8
        }
        
        return width
    }
}
