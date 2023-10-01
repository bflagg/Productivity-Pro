//
//  ContentObjectLink.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 30.09.23.
//

import SwiftUI

struct ContentObjectLink: View {
    
    var obj: ContentObject
    
    var body: some View {
        HStack {
            Image(
                systemName: obj.type == .file ? "doc.fill" : "folder.fill"
            )
            .font(.title)
            .foregroundStyle(Color.accentColor)
            .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(obj.title)
                
                Group {
                    Text(obj.created, style: .date) +
                    Text(", ") +
                    Text(obj.created, style: .time)
                }
                .environment(\.locale, Locale(identifier: "de"))
                .foregroundStyle(Color.secondary)
                .font(.caption)
            }
            .padding(.leading, 5)
            
            Spacer()
            
            if obj.isPinned {
                Image(systemName: "pin")
                    .foregroundStyle(Color.accentColor)
            }
        }
        .frame(height: 40)
    }
}