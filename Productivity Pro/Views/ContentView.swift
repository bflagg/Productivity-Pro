//
//  ContentView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 10.09.23.
//

import SwiftData
import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var hsc
    @Environment(\.requestReview) var requestReview
    
    @Query var contentObjects: [ContentObject]
    
    @State var toolManager: ToolManager = .init()
    @State var subviewManager: SubviewManager = .init()
    @State var navigationManager: NavigationManager = .init()
    
    var body: some View {
        NavigationSplitView(sidebar: {
            SidebarView(contentObjects: contentObjects)
        }) {
            switch navigationManager.selection {
            case .gemini:
                Text("Gemini View")
            case .finder:
                FileSystemView(contentObjects: contentObjects)
            case .search:
                Text("Search View")
            case .trash:
                TrashView(contentObjects: contentObjects)
            case .library:
                Text("Library View")
            case .tasks:
                HomeworkView()
            case .schedule:
                ScheduleViewContainer()
            case .exams:
                Text("Tests View")
            case .subjects:
                SubjectSettings()
            case .general:
                PPSettingsView()
            case .none:
                Text("Productivity Pro")
            }
        }
        .disabled(toolManager.showProgress)
        .modifier(
            OpenURL(
                objects: contentObjects,
                contentObjects: contentObjects
            ) { }
        )
        .scrollDisabled(toolManager.showProgress)
        .environment(toolManager)
        .environment(subviewManager)
        .environment(navigationManager)
        .scrollIndicators(.hidden)
        .overlay {
            if toolManager.showProgress {
                LoadingView()
                    .transition(.push(from: .bottom))
            }
        }
        .animation(.smooth(duration: 0.2), value: toolManager.showProgress)
        .sheet(isPresented: $subviewManager.sharePDFView) {
            SharePDFView()
        }
        .sheet(isPresented: $subviewManager.shareProView) {
            ShareProView()
        }
        .sheet(isPresented: $subviewManager.shareQRPDFView) {
            ShareQRPDFView()
        }
        .onAppear {
            review()
        }
    }
    
    @MainActor func review() {
        #if DEBUG
        #else
        if contentObjects.count > 3 {
            requestReview()
        }
        #endif
    }
}
