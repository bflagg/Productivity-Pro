//
//  ContentMenu.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.11.24.
//

import SwiftUI

struct ContentMenu: View {
    @Namespace private var animation
    
    @Environment(NavigationManager.self) var navigation
    @State var showMenu = false
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(ViewPresentation.allCases, id: \.self) { view in
                Button(action: {
                    withAnimation(.spring) {
                        navigation.selection = view
                    }
                }) {
                    Image(systemName: image(view: view))
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(
                            view == navigation.selection ? Color.accentColor : Color.primary
                        )
                        .padding(11)
                        .background {
                            if view == navigation.selection {
                                Circle()
                                    .foregroundStyle(.background)
                                    .matchedGeometryEffect(
                                        id: "view", in: animation
                                    )
                            }
                        }
                }
            }
        }
        .padding(3)
        .padding(.horizontal, 2)
        .background {
            ZStack {
                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
                
                Rectangle()
                    .foregroundStyle(.quinary)
            }
        }
        .clipShape(Capsule())
        .frame(
            maxWidth: .infinity, maxHeight: .infinity,
            alignment: .bottom
        )
        .padding(.bottom, 30)
        .ignoresSafeArea(.all)
    }
    
    func image(view: ViewPresentation) -> String {
        switch view {
        case .gemini:
            return "sparkles"
        case .finder:
            return "doc"
        case .tasks:
            return "checklist"
        case .schedule:
            return "calendar"
        case .subjects:
            return "tray.2"
        case .general:
            return "gearshape"
        }
    }
    
    func title(view: ViewPresentation) -> String {
        switch view {
        case .gemini:
            return "Gemini"
        case .finder:
            return "Notizen"
        case .tasks:
            return "Aufgaben"
        case .schedule:
            return "Stundenplan"
        case .subjects:
            return "Fächer"
        case .general:
            return "Einstellungen"
        }
    }
}

#Preview {
    ContentMenu()
        .environment(NavigationManager())
}
