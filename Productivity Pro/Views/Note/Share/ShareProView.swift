//
//  ShareProView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 06.12.23.
//

import SwiftUI

struct ShareProView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ToolManager.self) var toolManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()
                
                ZStack {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 10,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 50,
                        style: .continuous
                    )
                    .frame(width: 120, height: 165)
                    .foregroundStyle(Color.primary)
                    .colorInvert()
                    .shadow(radius: 5)
                    
                    Text("pronote")
                        .font(.title3.bold())
                        .foregroundStyle(
                            Color.accentColor.gradient
                        )
                        .frame(width: 120, height: 165)
                        .clipShape(.rect)
                        .draggable(Image(systemName: "house"))
                }
                
                Text("Buch S. 163/12")
                    .font(.headline.bold())
                
                Spacer()
                
                
                
                Button(action: {
                }) {
                    Text("Teilen")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .padding(13)
                        .padding(.horizontal, 93)
                        .background {
                            RoundedRectangle(cornerRadius: 13)
                                .foregroundStyle(
                                    Color.accentColor
                                )
                        }
                }
                .padding(.bottom, 40)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
            
        }
        .onAppear {
            ExportManager().export(
                contentObject: toolManager.selectedContentObject,
                to: .downloadsDirectory
            )
        }
        .onDisappear {
            
        }
    }
}
