//
//  NoteView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 25.09.22.
//

import SwiftUI
import SwiftUIIntrospect

struct NoteView: View {
    @Environment(ToolManager.self) var toolManager
    @State var activePage: PPPageModel?
    
    var contentObject: ContentObject
    
    var body: some View {
        if contentObject.note?.pages != nil {
            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(contentObject.note!.pages!) { page in
                            ScrollViewContainer(
                                note: contentObject.note!,
                                page: page,
                                size: proxy.size
                            )
                            .containerRelativeFrame(
                                [.horizontal, .vertical]
                            )
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $activePage)
                .onChange(of: activePage, initial: true) { last, active in
                    if let page = active {
                        toolManager.activePage = page
                    } else {
                        toolManager.activePage = contentObject.note!.pages!.first!
                    }
                }
            }
            .noteViewModifier(with: contentObject)
            .background {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea(.all)
            }
            
        } else {
            ContentUnavailableView(
                "Ein Fehler ist aufgetreten.",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }
    
//    func pageIndicator() {
//            if subviewManager.overviewSheet == false {
//                toolManager.isPageNumberVisible = true
//    
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    withAnimation {
//                        toolManager.isPageNumberVisible = false
//                    }
//                }
//            }
//        }
}
