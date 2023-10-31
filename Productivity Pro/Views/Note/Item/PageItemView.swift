//
//  PageItemView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 08.02.23.
//

import SwiftUI

struct PageItemView: View {
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    var note: PPNoteModel
    @Bindable var page: PPPageModel
    
    @Binding var scale: CGFloat
    
    var highResolution: Bool
    var pdfRendering: Bool
    
    var body: some View {
        ForEach(page.items!) { ppItem in
            @Bindable var item = ppItem
            
            ItemView(
                note: note, page: page, item: ppItem,
                scale: $scale,
                highResolution: highResolution,
                pdfRendering: pdfRendering
            )
            .onTapGesture {
                tap(item: item)
            }
            .zIndex(Double(item.index))
            
        }
        .frame(
            width: scale * getFrame().width,
            height: scale * getFrame().height
        )
        .clipShape(Rectangle())
        .scaleEffect(1 / scale)
    }
    
    func tap(item: PPItemModel) {
        if subviewManager.showInspector == false {
            toolManager.activeItem = item
        }
    }
    
    func getFrame() -> CGSize {
        var frame: CGSize = .zero
        
        if page.isPortrait {
            frame = CGSize(width: shortSide, height: longSide)
        } else {
            frame = CGSize(width: longSide, height: shortSide)
        }
        
        return frame
    }
}