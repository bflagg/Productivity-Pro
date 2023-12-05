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
    
    @AppStorage("ppisunlocked") var isSubscribed: Bool = false
    
    var body: some View {
        NavigationStack {
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
                PVOfferView()
                    .padding(.vertical)
                Spacer()
                
                Button(action: { subscribe() }) {
                    Text("Abonnieren")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .padding(15)
                        .padding(.horizontal, 60)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color.accentColor.gradient)
                        }
                }
                .padding(.bottom, 10)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3.bold())
                            .foregroundStyle(Color.secondary)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { restore() }) {
                        Image(systemName: "purchased")
                    }
                }
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

#Preview {
    NavigationStack {
        PremiumView()
    }
}
