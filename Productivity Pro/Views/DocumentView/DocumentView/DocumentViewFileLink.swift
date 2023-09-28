//
//  FolderViewFileLink.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 26.09.23.
//

import SwiftUI

extension DocumentView {
    
    @ViewBuilder
    func FileLink(for object: ContentObject) -> some View {
        NavigationLink(destination: {
            
            Text("\(object.document.documentType.hashValue)")
            
        }) {
            HStack {
                Label(object.title, systemImage: "doc.fill")
                Spacer()
                
                if object.isPinned {
                    Image(systemName: "pin")
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        .frame(height: 30)
    }
    
}
