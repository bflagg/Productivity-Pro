//
//  PremiumView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 10.09.23.
//

import SwiftUI

struct PremiumView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var hsc
    
    @Environment(StoreVM.self) var storeVM
    @AppStorage("ppisunlocked") var isSubscribed: Bool = false
    
    @State var load: Bool = false
    
    var body: some View {
        NavigationStack {
            if let product = storeVM.subscriptions.first {
                VStack(spacing: 0) {
                    
                    Text("Premium")
                        .font(.largeTitle.bold())
                        .padding(.bottom)
                    
                    ViewThatFits(in: .vertical) {
                        PVAnimationView()
                        Color.clear
                            .frame(width: 0, height: 0)
                    }
                    
                    Spacer()
                    PVOfferView(product: product)
                        .padding(.vertical)
                    
                    Text("Teste Productivity Pro Premium die ersten 2 Wochen kostenlos.")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await subscribe()
                        }
                    }) {
                        Text("Abonnieren")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .padding(13)
                            .padding(.horizontal, 65)
                            .background {
                                RoundedRectangle(cornerRadius: 13)
                                    .foregroundStyle(Color.accentColor)
                            }
                            .opacity(load ? 0 : 1)
                            .overlay {
                                if load {
                                    ProgressView()
                                }
                            }
                    }
                    .padding(.bottom, 10)
                    .allowsTightening(load == false)
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: { dismiss() }) {
                            Text("Abbrechen")
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
    }
    
    let images = [
        "pencil",
        "doc.fill",
        "checklist",
        "eraser.fill",
        "calendar",
        "graduationcap.fill",
        "ruler.fill",
        "paintbrush.fill",
        "highlighter",
        "lasso",
        "tray.full.fill"
    ]
}
