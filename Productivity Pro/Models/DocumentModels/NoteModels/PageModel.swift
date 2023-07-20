//
//  PageModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 25.09.22.
//

import Foundation
import PDFKit

struct Page: Codable, Identifiable, Hashable {
    
    var id: UUID = UUID()
    var type: PageType = .template
    
    var canvasType: CanvasType?
    
    var date: Date? = Date()
    
    var backgroundMedia: Data?
    var header: String?
    
    var backgroundColor: String
    var backgroundTemplate: String
    var isPortrait: Bool
    
    var canvas: Data = Data()
    
    var lines: [PPLine]? = [PPLine]()
    var items: [ItemModel] = []
    
}

enum PageType: Codable {
    case template
    case pdf
    case image
}

enum CanvasType: Codable {
    case pencilKit
    case ppDrawingKit
}
