//
//  MediaItemViewContainer.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.02.24.
//

import SwiftUI

struct MediaItemVContainer: View {
    @State var vuModel: VUModel = .init()
    
    @Bindable var page: PPPageModel
    @Bindable var item: PPItemModel
    @Binding var scale: CGFloat
    
    var realrenderText: Bool
    var preloadModels: Bool
    
    var body: some View {
        if preloadModels {
            vuModel.setModel(from: item)
        }
        
        return ZStack {
            ShapeItemView(
                item: item,
                editItem: vuModel,
                scale: $scale
            )
            .modifier(VUModifier(vuModel: vuModel, item: item))
            .position(
                x: (vuModel.position.x) * scale,
                y: (vuModel.position.y) * scale
            )
            .modifier(
                DragItemModifier(
                    item: item, page: page,
                    editItemModel: vuModel,
                    scale: $scale
                )
            )
            
            ToolView(
                page: page,
                item: item,
                vuModel: vuModel,
                scale: $scale
            )
            .zIndex(index)
        }
    }
    
    var index: Double {
        if let items = page.items {
            return Double(items.count + 20)
        } else {
            return 20
        }
    }
}
