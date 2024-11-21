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
            Tab(value: ViewPresentation.gemini, content: {
                Text("Gemini View")
            }) {
                Label("Gemini", systemImage: "sparkles")
            }
            
            TabSection("Notizen") {
                Tab(value: ViewPresentation.finder, content: {
                    FileSystemView(contentObjects: contentObjects)
                }) {
                    Label("Finder", systemImage: "doc.fill")
                }
                
                Tab(value: ViewPresentation.search, content: {
                    Text("Search View")
                }) {
                    Label("Suchen", systemImage: "magnifyingglass")
                }
                .defaultVisibility(.hidden, for: .tabBar)
                
                Tab(value: ViewPresentation.trash, content: {
                    TrashView(contentObjects: contentObjects)
                }) {
                   Label("Papierkorb", systemImage: "trash")
                }
                .defaultVisibility(.hidden, for: .tabBar)
            }
             
            TabSection("Organisation") {
                Tab(value: ViewPresentation.tasks, content: {
                    HomeworkView(tasks: tasks)
                }) {
                    Label("Aufgaben", systemImage: "checklist")
                }
                .badge(Text("\(tasks.count) "))
                
                Tab(value: ViewPresentation.schedule, content: {
                    ScheduleViewContainer()
                }) {
                    Label("Stundenplan", systemImage: "calendar")
                }
                .defaultVisibility(.hidden, for: .tabBar)
            }
            
            TabSection("Einstellungen") {
                Tab(value: ViewPresentation.subjects, content: {
                    SubjectSettings()
                }) {
                    Label("Fächer", systemImage: "tray.2.fill")
                }
                .defaultVisibility(.hidden, for: .tabBar)
                
                Tab(value: ViewPresentation.general, content: {
                    PPSettingsView()
                }) {
                    Label("Allgemein", systemImage: "gearshape.fill")
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewSidebarBottomBar {
            Footer()
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
    
    @ViewBuilder func Footer() -> some View {
        Group {
            Text("Entwickelt mit ") +
            Text("\(Image(systemName: "heart.fill"))")
                .foregroundStyle(Color.red) +
            Text(" für Schüler")
        }
        .font(.caption)
        .foregroundStyle(Color.secondary)
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
