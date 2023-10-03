//
//  ExportablePageModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 04.10.23.
//

import Foundation

struct ExportablePageModel: Codable {
    var id: UUID
    
    var type: PPPageType = .none
    var canvas: PPCanvasType = .pkCanvas
    
    var title: String = ""
    var created: Date
    
    var template: String = ""
    var color: String = ""
    var isPortrait: Bool = false
    var media: Data? = nil
    
//    var ppCanvas: PPCanvasModel? // MARK: Coming soon
    var pkCanvas: Data?
    
    var items: [ExportableItemModel] = []
}
