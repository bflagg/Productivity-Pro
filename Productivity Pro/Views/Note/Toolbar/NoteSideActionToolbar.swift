//
//  TopToolbar.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 29.09.22.
//

import SwiftUI

struct NoteSideActionToolbar: ToolbarContent {
    
    @AppStorage("startDate") var startDate: String = ""
    @AppStorage("fullAppUnlocked") var isFullAppUnlocked: Bool = false
    
    @Environment(\.undoManager) var undoManager
    @Environment(\.horizontalSizeClass) var hsc
    
    @Binding var document: ProductivityProDocument
    
    @StateObject var toolManager: ToolManager
    @StateObject var subviewManager: SubviewManager
    
    var body: some ToolbarContent {
        
        ToolbarItemGroup(placement: .primaryAction) {
            
            if toolManager.isCanvasEnabled && !subviewManager.isPresentationMode {
                Button(action: { toolManager.isLocked.toggle() }) {
                    Label(
                        "Lock Scroll",
                        systemImage: toolManager.isLocked ? "lock.fill" : "lock"
                    )
                }
            } else {
                DrawingModeDisabled()
            }
            
            if subviewManager.isPresentationMode {
                Button(action: {
                    document.document.note.pages[toolManager.selectedPage].isBookmarked.toggle()
                }) {
                    Image(systemName: document.document.note.pages[toolManager.selectedPage].isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color("red"))
                }
            }
            
            if subviewManager.isPresentationMode == false {
                Menu(content: {
                    Section {
                        let isBookmarked = document.document.note.pages[
                            toolManager.selectedPage
                        ].isBookmarked
                        
                        Button(action: {
                            document.document.note.pages[toolManager.selectedPage].isBookmarked.toggle()
                        }) {
                            Label(
                                isBookmarked ? "Remove Bookmark" : "Add Bookmark",
                                systemImage:
                                    isBookmarked ? "bookmark.fill" : "bookmark"
                            )
                        }
                    }
                    
                    Section {
                        Button(action: {
                            toolManager.isCanvasEnabled = false
                            subviewManager.addPageSettingsSheet = true
                        }) {
                            Label("Add Page", systemImage: "doc.badge.plus")
                        }
                        
                        Button(action: {
                            toolManager.isCanvasEnabled = false
                            subviewManager.changeTemplate.toggle()
                        }) {
                            Label("Change Page Template", systemImage: "doc.badge.gearshape")
                        }
                        .disabled(document.document.note.pages[toolManager.selectedPage].type != .template)
                        
                    }
                    
                    Section {
                        Button(action: {
                            toolManager.isCanvasEnabled = false
                            subviewManager.showScanDoc.toggle()
                        }) {
                            Label("Scan Document", systemImage: "doc.text.fill.viewfinder")
                        }
                        
                        Button(action: {
                            toolManager.isCanvasEnabled = false
                            subviewManager.showImportFile.toggle()
                        }) {
                            Label("Import PDF", systemImage: "folder")
                        }
                    }
                    
                    if document.document.note.pages.count != 1 {
                        Button(role: .destructive, action: {
                            toolManager.isCanvasEnabled = false
                            subviewManager.isDeletePageAlert.toggle()
                        }) {
                            Label("Delete Page", systemImage: "trash")
                        }
                    }
                    
                }) {
                    Label("Page Actions", systemImage: "doc.badge.ellipsis")
                }
                .modifier(
                    AddPDFPageHelper(
                        document: $document,
                        toolManager: toolManager,
                        subviewManager: subviewManager
                    )
                )
            }
        }
        
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button(action: {
                
                toolManager.selectedItem = nil
                toolManager.isLocked = false
                toolManager.isCanvasEnabled = false
                
                tapPresentationButton()
                
            }) {
                ZStack {
                    Text(subviewManager.isPresentationMode ? "Edit Mode" : "Presentation Mode")
                        .frame(width: 0, height: 0)
                    
                    Image(
                        systemName: subviewManager.isPresentationMode ? "pencil.and.outline" : "pencil.slash"
                    )
                    .frame(width: 30)
                }
            }
            .keyboardShortcut("p", modifiers: [.command, .option])
            
            if hsc == .regular {
                Button(action: {
                    toolManager.isCanvasEnabled = false
                    UITabBar.appearance().isHidden = false
                    subviewManager.overviewSheet.toggle()
                }) {
                    ZStack {
                        Text("Overview")
                            .frame(width: 0, height: 0)
                        
                        Image(systemName: "square.grid.2x2")
                    }
                }
                .keyboardShortcut("o", modifiers: [.command])
            }
        }
        
    }
    
    @ViewBuilder func DrawingModeDisabled() -> some View {
        if subviewManager.isPresentationMode == false {
            
            if hsc == .regular {
                
                Button(action: { undo() }) {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                }
                .disabled(!(undoManager?.canUndo ?? false))
                
                Button(action: { redo() }) {
                    Label("Redo", systemImage: "arrow.uturn.forward")
                }
                .disabled(!(undoManager?.canRedo ?? false))
                
            } else {
                Menu(content: {
                    
                    Button(action: { undo() }) {
                        Label("Undo", systemImage: "arrow.uturn.backward")
                    }
                    .disabled(!(undoManager?.canUndo ?? false))
                    
                    Button(action: { redo() }) {
                        Label("Redo", systemImage: "arrow.uturn.forward")
                    }
                    .disabled(!(undoManager?.canRedo ?? false))
                    
                }) {
                    Label("Undo/Redo", systemImage: "arrow.uturn.backward")
                }
                .disabled(
                    !(undoManager?.canUndo ?? false) && !(undoManager?.canRedo ?? false)
                )
            }
            
            Button(action: {
                toolManager.selectedItem = document.document.note.pages[
                    toolManager.selectedPage
                ].items.first(where: { $0.id == toolManager.selectedItem?.id })
                subviewManager.showStylePopover.toggle()
            }) {
                ZStack {
                    Text("Show Editor")
                        .frame(width: 0, height: 0)
                    
                    Image(systemName: "paintbrush")
                }
            }
            .keyboardShortcut("e", modifiers: [.command])
            .disabled(toolManager.selectedItem == nil)
            .popover(isPresented: $subviewManager.showStylePopover) {
                EditPageItemView(
                    hsc: hsc,
                    document: $document,
                    toolManager: toolManager,
                    subviewManager: subviewManager
                )
                .presentationCompactAdaptation(.popover)
                .presentationBackgroundInteraction(.enabled)
            }
            
        }
    }
    
    func tapPresentationButton() {
        let dateTrialEnd = Calendar.current.date(
            byAdding: .day,
            value: freeTrialDays,
            to: Date(rawValue: startDate)!
        )
        
        if !isFullAppUnlocked && dateTrialEnd! < Date() {
            subviewManager.showUnlockView = true
        } else {
            subviewManager.isPresentationMode.toggle()
            
            if subviewManager.isPresentationMode == false {
                Task {
                    try? await Task.sleep(nanoseconds: 50000)
                    undoManager?.removeAllActions()
                }
            }
        }
    }
    
    func undo() {
        undoManager?.undo()
    }
    
    func redo() {
        undoManager?.redo()
    }
    
}

