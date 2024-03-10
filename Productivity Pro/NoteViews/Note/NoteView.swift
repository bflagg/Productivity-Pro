//
//  NoteView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 25.09.22.
//

import SwiftData
import SwiftUI

struct NoteView: View {
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    var contentObjects: [ContentObject]
    @Bindable var contentObject: ContentObject
    
    var pages: [PPPageModel] {
        contentObject.note!.pages!
            .sorted(by: { $0.index < $1.index })
    }
    
    var body: some View {
        if contentObject.note?.pages != nil && !contentObject.inTrash {
            @Bindable var subviewValue = subviewManager
            @Bindable var toolValue = toolManager
            
            GeometryReader { proxy in
                PagerView(pages, currentPage: $toolValue.index) { page in
                    ScrollViewContainer(
                        note: contentObject.note!,
                        page: page, size: proxy.size
                    )
                }
                .noteViewModifier(with: contentObject)
                .onChange(of: toolValue.index) {
                    toolManager.activeItem = nil
                        
                    toolManager.activePage = pages[toolValue.index]
                    contentObject.note?.index = toolValue.index
                }
                .onAppear {
                    if let index = contentObject.note?.index {
                        toolValue.index = index
                    } else {
                        toolValue.index = 0
                    }
                    
                    toolManager.activePage = pages[toolManager.index]
                }
            }
            .background {
                Button("Widerrufen") {
                    toolManager.activePage?.undo(
                        toolManager: toolManager
                    )
                    toolManager.update += 1
                }
                .keyboardShortcut(KeyEquivalent("z"), modifiers: .command)
                
                Button("Wiederherstellen") {
                    toolManager.activePage?.redo(toolManager: toolManager)
                    toolManager.update += 1
                }
                .keyboardShortcut(KeyEquivalent("z"), modifiers: [
                    .command, .shift
                ])
                
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea(.all, edges: [.top, .horizontal])
            }
            .modifier(
                RenameContentObjectView(
                    contentObjects: contentObjects,
                    object: contentObject,
                    isPresented: $subviewValue.renameView
                )
            )
            .onChange(of: toolValue.activePage, initial: true) {
                toolManager.pencilKit = false
            }
            .overlay {
                ClipboardControl()
                    .padding(10)
                
                IndicatorText(contentObject: contentObject)
                PrinterViewContainer(contentObject: contentObject)
            }
            
        } else {
            ZStack {
                Color(UIColor.secondarySystemBackground)
                    .ignoresSafeArea(.all, edges: [.top, .horizontal])
                
                ContentUnavailableView(
                    "Ein Fehler ist aufgetreten.",
                    systemImage: "exclamationmark.triangle.fill"
                )
            }
        }
    }
}
