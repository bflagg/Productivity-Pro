//
//  DeskView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 10.09.23.
//

import SwiftUI

struct DeskView: View {
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            Form {
                
                NavigationLink(destination: {
                    PremiumView()
                }) {
                    Label("Premium", systemImage: "crown.fill")
                }
                .padding(.vertical, 8)
                
                NavigationLink(destination: {
                    
                }) {
                    Label("Was ist neu?", systemImage: "plus.app.fill")
                }
                .padding(.vertical, 8)
                
                Settings()
                LinkView()
                
                Button(action: { requestReview() }) {
                    HStack {
                        Text("Bewerte Productivity Pro")
                        Spacer()
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow.opacity(1.0))
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow.opacity(0.8))
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow.opacity(0.6))
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow.opacity(0.4))
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow.opacity(0.2))
                        }
                    }
                }
                .foregroundStyle(.primary)
                .padding(.vertical, 8)
                
            }
            .navigationTitle("Schreibtisch")
        }
    }
}

struct DeskView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 0)
    }
}