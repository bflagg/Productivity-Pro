//
//  FolderView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 24.09.23.
//

import SwiftUI
import SwiftData

struct DocumentView: View {
    @Environment(\.modelContext) var context
    
    var parent: String
    var title: String
    var contentObjects: [ContentObject]
    
    @AppStorage("ppsorttype") 
    var sortType: SortingValue = .title
    
    @AppStorage("ppisreverse")
    var isReverse: Bool = false
    
    @AppStorage("ppsortbytype")
    var typeSorting: Bool = true
    
    @AppStorage("ppgrade")
    var grade: Int = 5
    
    // MARK: Creation Values
    @State var addFolder: Bool = false
    @State var editFolder: Bool = false
    @State var selectedObject: ContentObject? = nil
    @State var moveContentObject: Bool = false
    @State var importFile: Bool = false

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea(.all)
            
            List {
                Section {
                    if typeSorting {
                        ForEach(getObjects(.file, isPinned: true)) { object in
                            ObjectLink(for: object)
                        }
                        
                        ForEach(getObjects(.folder, isPinned: true)) { object in
                            ObjectLink(for: object)
                        }
                    } else {
                        ForEach(getObjects(.none, isPinned: true)) { object in
                            ObjectLink(for: object)
                        }
                    }
                }
                Section {
                    if typeSorting {
                        ForEach(getObjects(.file, isPinned: false)) { object in
                            ObjectLink(for: object)
                        }
                        
                        ForEach(getObjects(.folder, isPinned: false)) { object in
                            ObjectLink(for: object)
                        }
                    } else {
                        ForEach(getObjects(.none, isPinned: false)) { object in
                            ObjectLink(for: object)
                        }
                    }
                }
            }
            .animation(.bouncy, value: grade)
            .scrollContentBackground(.hidden)
            .environment(\.defaultMinListRowHeight, 10)
            .navigationTitle(title)
            .navigationBarBackButtonHidden()
            .toolbarRole(.browser)
            .toolbar {
                FolderViewToolbar(
                    parent: parent,
                    addFolder: $addFolder,
                    importFile: $importFile
                )
            }
            .navigationBarTitleDisplayMode(
                parent == "root" ? .large : .inline
            )
        }
        .modifier(
            AddFolderView(
                parent: parent,
                contentObjects: contentObjects, 
                isPresented: $addFolder
            )
        )
        .modifier(
            RenameFolderView(
                contentObjects: contentObjects, 
                folder: selectedObject,
                isPresented: $editFolder
            )
        )
        .sheet(isPresented: $moveContentObject) {
            ObjectPicker(
                isPresented: $moveContentObject, 
                selectedObject: $selectedObject
            )
        }
        .fileImporter(
            isPresented: $importFile,
            allowedContentTypes: [.pro],
            allowsMultipleSelection: false
        ) { result in
            importFile(result: result)
        }
        
    }
    
    @ViewBuilder func ObjectLink(for object: ContentObject) -> some View {
        if object.type == .folder {
            FolderLink(for: object)
        } else if object.type == .file {
            FileLink(for: object)
        }
    }
    
}