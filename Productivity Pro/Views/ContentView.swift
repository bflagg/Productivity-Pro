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
    @Query(FetchDescriptor(sortBy: [
        SortDescriptor(\Homework.title, order: .forward)
    ])) var tasks: [Homework]
    
    @State var toolManager: ToolManager = .init()
    @State var subviewManager: SubviewManager = .init()
    @State var navigationManager: NavigationManager = .init()
    
    var body: some View {
        ZStack {
            // Gemini View
            Text("Gemini View")
                .opacity(navigationManager.selection == .gemini ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .gemini)
            
            // Finder View
            FileSystemView(contentObjects: contentObjects)
                .opacity(navigationManager.selection == .finder ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .finder)
            
            // Search View
            Text("Search View")
                .opacity(navigationManager.selection == .search ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .search)
            
            // Trash View
            TrashView(contentObjects: contentObjects)
                .opacity(navigationManager.selection == .trash ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .trash)
            
            // Homework View
            HomeworkView(tasks: tasks)
                .opacity(navigationManager.selection == .tasks ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .tasks)
            
            // Schedule View
            ScheduleViewContainer()
                .opacity(navigationManager.selection == .schedule ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .schedule)
            
            // Subject View
            SubjectSettings()
                .opacity(navigationManager.selection == .subjects ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .subjects)
            
            // Settings View
            PPSettingsView()
                .opacity(navigationManager.selection == .general ? 1 : 0)
                .allowsHitTesting(navigationManager.selection == .general)
        }
        .animation(.bouncy, value: navigationManager.selection)
        .disabled(toolManager.showProgress)
        .modifier(
            OpenURL(
                objects: contentObjects,
                contentObjects: contentObjects
            ) { }
        )
        .scrollDisabled(toolManager.showProgress)
        .scrollIndicators(.hidden)
        .overlay {
            if toolManager.showProgress {
                LoadingView()
                    .transition(.push(from: .bottom))
            }
        }
        .overlay {
            ContentMenu()
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
        .environment(toolManager)
        .environment(subviewManager)
        .environment(navigationManager)
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
