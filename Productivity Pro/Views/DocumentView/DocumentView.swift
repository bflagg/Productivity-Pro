//
//  DocumentView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 24.09.23.
//

import SwiftUI
import SwiftData

struct DocumentView: View {
    
    @Query(animation: .bouncy)
    var contentObjects: [ContentObject]
    
    @State var toolManager: ToolManager = ToolManager()
    @State var subviewManager: SubviewManager = SubviewManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea(.all)
                
                FolderView(
                    parent: "root",
                    title: "Notizen",
                    contentObjects: contentObjects,
                    toolManager: toolManager,
                    subviewManager: subviewManager
                )
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    DocumentView()
}
