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
        TabView(selection: $navigationManager.selection) {
            Tab.init(value: ViewPresentation.gemini) {
                Text("Gemini View")
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: ViewPresentation.finder) {
                FileSystemView(contentObjects: contentObjects)
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: ViewPresentation.tasks) {
                HomeworkView(tasks: tasks)
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: ViewPresentation.schedule) {
                ScheduleViewContainer()
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: ViewPresentation.subjects) {
                SubjectSettings()
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: ViewPresentation.general) {
                PPSettingsView()
                    .toolbarVisibility(.hidden, for: .tabBar)
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
