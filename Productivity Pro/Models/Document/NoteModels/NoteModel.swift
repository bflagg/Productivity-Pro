//
//  NoteModel.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 16.09.22.
//

import Foundation

struct Note: Codable, Equatable {
    var pages: [Page] = []
}
