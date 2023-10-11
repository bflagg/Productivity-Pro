//
//  FolderViewFileLink.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 26.09.23.
//

import SwiftUI

struct ObjectViewFileLink: View {
    var contentObjects: [ContentObject]
    var object: ContentObject
    var swipeAction: Bool = true
    
    @AppStorage("ppgrade") var grade: Int = 5
    
    let delete: () -> Void
    
    @State var isMove: Bool = false
    @State var isRename: Bool = false
    @State var selectedObject: String = ""
    
    var body: some View {
        NavigationLink(destination: {
            NoteView(contentObject: object)
        }) {
            ContentObjectLink(obj: object)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if swipeAction {
                Button(role: .destructive, action: {
                    withAnimation(.bouncy) {
                        object.isPinned.toggle()
                    }
                }) {
                    Image(systemName: !object.isPinned ? "pin.fill" : "pin.slash.fill"
                    )
                }
                .tint(Color.accentColor)
            }
        }
        .contextMenu {
            Section {
                Button("Umbenennen", systemImage: "pencil") {
                    isRename = true
                }
                
                Button("Bewegen", systemImage: "folder") {
                    isMove = true
                }
            }
            
            Section {
                Button(action: {
                    
                }) {
                    Label("Teilen", systemImage: "square.and.arrow.up")
                }
            }
            
            Button(role: .destructive, action: {
                withAnimation(.bouncy) {
                    delete()
                }
            }) {
                Label("Löschen", systemImage: "trash")
            }
        }
        .modifier(
            RenameContentObjectView(
                contentObjects: contentObjects,
                object: object,
                isPresented: $isRename, 
                parent: object.parent
            )
        )
        .sheet(isPresented: $isMove, onDismiss: move) {
            ObjectPicker(
                objects: contentObjects,
                isPresented: $isMove,
                selectedObject: $selectedObject, type: .folder
            )
        }
        
    }
    
    func move() {
        if selectedObject.isEmpty == false {
            var value: String = object.title
            var index: Int = 1
            
            let filteredObjects = contentObjects
                .filter({
                    $0.type == object.type &&
                    $0.parent == selectedObject &&
                    $0.grade == grade &&
                    $0.inTrash == false
                })
                .map({ $0.title })
            
            
            while filteredObjects.contains(value) {
                value = "\(object.title) \(index)"
                index += 1
            }
            
            withAnimation(.bouncy) {
                object.parent = selectedObject
                object.title = value
            }
            
            selectedObject = ""
        }
    }
    
}