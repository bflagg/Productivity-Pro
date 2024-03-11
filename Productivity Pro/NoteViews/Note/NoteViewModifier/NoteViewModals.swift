//
//  NoteSheetHelper.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 17.11.22.
//

import SwiftUI

struct NoteViewSheet: ViewModifier {
    @Environment(\.undoManager) var undoManager
    
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    var contentObject: ContentObject
    
    func body(content: Content) -> some View {
        @Bindable var manager = subviewManager
        
        content
            .sheet(isPresented: $manager.overview, content: {
                OverviewContainerView(contentObject: contentObject)
            })
            .sheet(isPresented: $manager.addPage, content: {
                if let page = toolManager.activePage {
                    TemplateView(
                        isPresented: $manager.addPage,
                        buttonTitle: "Hinzufügen",
                        preselectedOrientation: page.isPortrait,
                        preselectedColor: page.color,
                        preselectedTemplate: page.template
                    ) { isPortrait, template, color in
                        addPage(isPortrait, template, color)
                    }
                } else {
                    ProgressView()
                }
            })
            .sheet(isPresented: $manager.changePage, content: {
                if let page = toolManager.activePage {
                    TemplateView(
                        isPresented: $manager.changePage,
                        buttonTitle: "Ändern",
                        preselectedOrientation: page.isPortrait,
                        preselectedColor: page.color,
                        preselectedTemplate: page.template
                    ) { isPortrait, template, color in
                        changePage(isPortrait, template, color)
                    }
                } else {
                    ProgressView()
                }
            })
            .modifier(MDViewContainer(isPresented: $manager.rtfEditor))
            .fullScreenCover(isPresented: $manager.scanDocument) {
                ScannerView(
                    cancelAction: { subviewManager.scanDocument = false }
                ) { result in
                    scanDocument(with: result)
                }
                .edgesIgnoringSafeArea(.all)
            }
            .fileImporter(
                isPresented: $manager.importFile,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                importPDF(with: result)
            }
            .alert(
                "Möchtest du diese Seite wirklich löschen?",
                isPresented: $manager.deletePage
            ) {
                Button("Löschen", role: .destructive) {
                    deletePage()
                    subviewManager.deletePage = false
                }
                
                Button("Abbrechen", role: .cancel) {
                    subviewManager.deletePage = false
                }
            }
    }
}
