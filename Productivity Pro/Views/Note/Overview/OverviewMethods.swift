//
//  OverviewMethods.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 04.06.23.
//

import SwiftUI

extension OverviewView {
    
    func delete(_ page: Page) {
        withAnimation {
            toolManager.selectedItem = nil
            document.document.note.pages[
                toolManager.selectedPage
            ].items = []
            
            if page == document.document.note.pages.last! {
                
                if toolManager.selectedTab == page.id {
                    toolManager.selectedPage = document.document.note.pages.firstIndex(
                        of: document.document.note.pages.last!
                    )! - 1
                }
                
                document.document.note.pages.removeAll(where: {
                    $0.id == document.document.note.pages.last!.id
                })
                
            } else {
                let pageIndex: Int = document.document.note.pages.firstIndex(of: page)!
                
                if pageIndex < toolManager.selectedPage {
                    
                    
                    
                } else if pageIndex == toolManager.selectedPage {
                    toolManager.selectedTab = document.document.note.pages[
                        toolManager.selectedPage + 1
                    ].id
                    
                    document.document.note.pages.removeAll(where: { $0 == page })
                } else if pageIndex > toolManager.selectedPage {
                    document.document.note.pages.removeAll(where: { $0 == page })
                }
                
            }
        }
    }
    
    func goToPage(page: Page) {
        withAnimation {
            toolManager.selectedTab = page.id
            subviewManager.overviewSheet.toggle()
        }
    }
    
    func toggleBookmark(page: Page) {
        document.document.note.pages[
            document.document.note.pages.firstIndex(of: page)!
        ].isBookmarked.toggle()
    }
    
}