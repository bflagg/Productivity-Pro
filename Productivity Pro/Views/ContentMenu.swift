//
//  ContentMenu.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.11.24.
//

import SwiftUI

struct ContentMenu: View {
    @Environment(NavigationManager.self) var navigation
    @State var showMenu = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            let views = ViewPresentation.allCases.count - 1
            
            ForEach(0...views, id: \.self) { index in
                ZStack {
                    let view = ViewPresentation.allCases[index]
                    Circle()
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 50, height: 50)
                    
                    Button(action: {
                        navigation.selection = view
                        showMenu.toggle()
                    }) {
                        Label(
                            title(view: view),
                            systemImage: image(view: view)
                        )
                        .labelStyle(.iconOnly)
                        .font(.title3)
                        .foregroundStyle(
                            navigation.selection == view ? Color.accentColor : Color.primary
                        )
                        .padding()
                        .frame(width: 50, height: 50)
                        .background(.background)
                        .clipShape(Circle())
                        .compositingGroup()
                        .shadow(color: Color.primary.opacity(0.5), radius: 0.5)
                    }
                    .offset(
                        y: showMenu ? CGFloat(8 - index) * -65 : 0
                    )
                }
                .opacity(showMenu ? 1 : 0)
                .zIndex(0)
            }
            
            Button(action: {
                showMenu.toggle()
            }) {
                Label("Tab", systemImage: "ellipsis")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(Color.white)
                    .font(.title3)
                    .padding()
                    .frame(width: 50, height: 50)
                    .background(.accent)
                    .clipShape(Circle())
            }
            .zIndex(1)
        }
        .padding(25)
        .animation(.bouncy, value: navigation.selection)
        .animation(.bouncy, value: showMenu)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottomLeading
        )
        .ignoresSafeArea(.all)
    }
    
    func image(view: ViewPresentation) -> String {
        switch view {
        case .gemini:
            return "sparkles"
        case .finder:
            return "doc"
        case .search:
            return "magnifyingglass"
        case .trash:
            return "trash"
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
        case .search:
            return "Suchen"
        case .trash:
            return "Papierkorb"
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
