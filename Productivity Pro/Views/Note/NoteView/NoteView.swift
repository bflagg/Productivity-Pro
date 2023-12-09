//
//  NoteView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 25.09.22.
//

import SwiftUI
import SwiftData

struct NoteView: View {
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    var contentObjects: [ContentObject]
    var contentObject: ContentObject
    
    var pages: [PPPageModel] {
        contentObject.note!.pages!
            .sorted(by: { $0.index < $1.index })
    }
    
    var body: some View {
        if contentObject.note?.pages != nil {
            @Bindable var subviewValue = subviewManager
            @Bindable var toolValue = toolManager
            
            GeometryReader { proxy in
                ScrollViewReader { reader in
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            ForEach(pages) { page in
                                ScrollViewContainer(
                                    note: contentObject.note!,
                                    page: page,
                                    size: proxy.size
                                )
                                .id(page)
                                .containerRelativeFrame(
                                    [.horizontal, .vertical]
                                )
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $toolValue.activePage)
                    .onAppear {
                        if toolManager.activePage == nil {
                            toolManager.activePage = pages.last
                            reader.scrollTo(pages.last)
                        }
                    }
                    .onChange(of: toolValue.activePage) {
                        toolManager.pencilKit = false
                    }
                    
                }
            }
            .noteViewModifier(with: contentObject)
            .background {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea(.all)
            }
            .modifier(
                RenameContentObjectView(
                    contentObjects: contentObjects,
                    object: contentObject,
                    isPresented: $subviewValue.renameView
                )
            )
            
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
