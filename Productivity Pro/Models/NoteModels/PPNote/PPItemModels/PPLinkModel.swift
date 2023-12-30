//
//  PPLinkModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 01.10.23.
//

import Foundation
import SwiftData

@Model final class PPLinkModel {
    init(linkedObject: UUID) {
        self.linkedObject = linkedObject
        self.type = PPLinkType.medium.rawValue
    }
    
    var type: PPLinkType.RawValue = ""
    var linkedObject: UUID = UUID()
}
