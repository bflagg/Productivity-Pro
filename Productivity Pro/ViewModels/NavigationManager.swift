//
//  NavigationManager.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 13.11.24.
//

import Foundation

@Observable class NavigationManager {
    var selection: ViewPresentation? = .finder
}

enum ViewPresentation {
    case gemini
    case finder
    case search
    case library
    case tasks
    case schedule
    case exams
    case grades
    case subjects
    case general
}
