//
//  RTFEditorView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 21.11.23.
//

import SwiftUI
import RichTextKit

struct RTFEditorView: View {
    @Environment(ToolManager.self) var toolManager
    
    @StateObject var context: RichTextContext = RichTextContext()
    @State var nsString: NSAttributedString = .init()
    
    var body: some View {
        NavigationStack {
            RichTextEditor(text: $nsString, context: context)
                .toolbar { RTFEditorToolbar(context: context) }
                .onChange(of: nsString) {
                    toolManager.activeItem?.textField?.nsAttributedString = nsString.data()
                }
                .onAppear {
                    if let data = toolManager.activeItem?.textField?.nsAttributedString {
                        if let string = NSAttributedString(data: data) {
                            context.setAttributedString(to: string)
                        }
                    }
                }
        }
    }
}

#Preview {
    RTFEditorView()
}
