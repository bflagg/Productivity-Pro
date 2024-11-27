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
        Group {
            switch navigationManager.selection {
            case .gemini:
                GemniContainer
            case .finder:
                FinderContainer
            case .search:
                SearchContainer
            case .trash:
                TrashContainer
            case .tasks:
                HomeworkContainer
            case .schedule:
                ScheduleContainer
            case .subjects:
                SubjectContainer
            case .general:
                SettingsContainer
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
    
    var GemniContainer: some View {
        Text("Gemini View")
    }
    
    var FinderContainer: some View {
        FileSystemView(contentObjects: contentObjects)
    }
    
    var SearchContainer: some View {
        Text("Search View")
    }
    
    var TrashContainer: some View {
        TrashView(contentObjects: contentObjects)
    }
    
    var HomeworkContainer: some View {
        HomeworkView(tasks: tasks)
    }
    
    var ScheduleContainer: some View {
        ScheduleViewContainer()
    }
    
    var SubjectContainer: some View {
        SubjectSettings()
    }
    
    var SettingsContainer: some View {
        PPSettingsView()
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
