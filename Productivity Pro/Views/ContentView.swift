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
    
    var body: some View {
        TabView() {
            Tab {
                FileSystemView(contentObjects: contentObjects)
            } label: {
                Image(systemName: "doc.fill")
            }
            
            Tab {
                HomeworkView(tasks: tasks)
            } label: {
                Image(systemName: "checklist")
            }

            Tab {
                ScheduleViewContainer()
            } label: {
                Image(systemName: "calendar")
            }
            
            Tab {
                PPSettingsView()
            } label: {
                Image(systemName: "gearshape")
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
