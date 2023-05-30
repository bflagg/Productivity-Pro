//
//  BackgroundView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 19.11.22.
//

import SwiftUI

struct BackgroundView: View {
    
    var page: Page
    var scale: CGFloat
    
    var body: some View {
        Group {
            
            if page.backgroundTemplate == "blank" {
                
            } else if page.backgroundTemplate == "dotted" {
                if page.isPortrait {
                    DottedViewPortrait()
                } else {
                    DottedViewLandscape()
                }
            } else if page.backgroundTemplate == "squared" {
                if page.isPortrait {
                    SquaredViewPortrait()
                } else {
                    SquaredViewLandscape()
                }
            } else if page.backgroundTemplate == "ruled" {
                if page.isPortrait {
                    RuledViewPortrait()
                } else {
                    RuledViewLandscape()
                }
            } else if page.backgroundTemplate == "ruled.large" {
                if page.isPortrait {
                    RuledLargeViewPortrait()
                } else {
                    RuledLargeViewLandscape()
                }
            } else if page.backgroundTemplate == "music" {
                if page.isPortrait {
                    MusicViewPortrait()
                } else {
                    MusicViewLandscape()
                }
            }
            
        }
        .colorScheme(colorScheme())
    }
    
    func colorScheme() -> ColorScheme {
        var cs: ColorScheme = .dark
        
        if page.backgroundColor == "yellow" || page.backgroundColor == "white" {
            cs = .light
        }
        
        return cs
    }
    
}


