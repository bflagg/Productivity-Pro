//
//  DocumentModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 15.09.22.
//

import Foundation
import SwiftData

struct Document: Codable {
    var documentType: DocumentType = .none
    
    var note: Note!
    var realityNote: RealityNote?
}

enum DocumentType: Codable {
    case none
    
    case note
    case realityNote
}
