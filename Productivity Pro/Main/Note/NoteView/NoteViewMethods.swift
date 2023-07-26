//
//  NoteViewMethods.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 23.03.23.
//

import SwiftUI
import PencilKit
import PDFKit

extension NoteView {
    
    func loadFirst() {
        guard let page = document.document.note.pages.first else { return }
        if page.type == .pdf {
            
            guard let data = page.backgroundMedia else {
                toolManager.preloadedMedia.append(nil)
                return
            }
            
            guard let pdf = PDFDocument(data: data) else {
                toolManager.preloadedMedia.append(nil)
                return
            }
            
            toolManager.preloadedMedia.append(pdf)
            
        } else {
            toolManager.preloadedMedia.append(nil)
        }
    }
    
    func loadMedia() {
        for page in Array(document.document.note.pages.dropFirst()) {
            if page.type == .pdf {
                
                guard let data = page.backgroundMedia else {
                    toolManager.preloadedMedia.append(nil)
                    continue
                }
                
                guard let pdf = PDFDocument(data: data) else {
                    toolManager.preloadedMedia.append(nil)
                    continue
                }
                
                toolManager.preloadedMedia.append(pdf)
                
            } else {
                toolManager.preloadedMedia.append(nil)
            }
        }
    }
    
    func isViewVisible(page: Page) -> Bool {
        var isVisible: Bool = false
        
        let index = document.document.note.pages.firstIndex(of: page)!
        
        if toolManager.selectedPage == index {
            isVisible = true
        } else if toolManager.selectedPage - 1 == index {
            isVisible = true
        } else if toolManager.selectedPage + 1 == index {
            isVisible = true
        }
        
        return isVisible
    }
    
    func pickedImageDidChange() {
        if let image = toolManager.pickedImage { addImage(image) }
        toolManager.pickedImage = nil
    }
    
    func noteDidAppear() {
        UITabBar.appearance().isHidden = true
        loadFirst()
        
        toolManager.selectedTab = document.document.note.pages.first!.id
        toolManager.selectedPage = document.document.note.pages.firstIndex(
            where: { $0.id == toolManager.selectedTab }
        )!
        
        fixScrollViewBug()
    }
    
    func selectedPageDidChange(index page: Int) {
        toolManager.selectedTab = document.document.note.pages[
            page
        ].id
    }
    
    func selectedTabDidChange(_ tab: UUID, size: CGSize) {
        toolManager.selectedPage = document.document.note.pages.firstIndex(where: {
            $0.id == tab
        }) ?? 0
        
        toolManager.selectedItem = nil
        toolManager.scrollOffset = .zero
        toolManager.zoomScale = getScale(
            toolManager.selectedPage, size: size
        )
        
        pageIndicator()
    }
    
    func fixScrollViewBug() {
        Task {
            document.document.note.pages.append(
                Page(
                    backgroundColor: "pagewhite",
                    backgroundTemplate: "blank",
                    isPortrait: true
                )
            )
            
            try? await Task.sleep(nanoseconds: 50000)
            document.document.note.pages.removeLast()
            try? await Task.sleep(nanoseconds: 50000)
            undoManager?.removeAllActions()
        }
    }
    
    func addImage(_ img: UIImage) {
        let image = resize(img, to: CGSize(width: 1024, height: 1024))
        
        let ratio = 400/image.size.width
        
        var newItem = ItemModel(
            width: image.size.width * ratio,
            height: image.size.height * ratio,
            type: .media
        )
        
        newItem.x = toolManager.scrollOffset.size.width * (1/toolManager.zoomScale) + newItem.width/2 + 40
        
        newItem.y = toolManager.scrollOffset.size.height * (1/toolManager.zoomScale) + newItem.height/2 + 40
        
        let media = MediaModel(media: image.pngData() ?? Data())
        newItem.media = media
        
        document.document.note.pages[
            toolManager.selectedPage
        ].items.append(newItem)
        
        toolManager.selectedItem = newItem
        toolManager.showProgress = false
    }
    
    func deletePage() {
        withAnimation {
            
            document.document.note.pages[
                toolManager.selectedPage
            ].items.removeAll()
            
            document.document.note.pages[
                toolManager.selectedPage
            ].type = .template
            
            toolManager.preloadedMedia.remove(at: toolManager.selectedPage)
            
            let seconds = 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                
                if toolManager.selectedTab == document.document.note.pages.last?.id {
                    
                    let newSelection = document.document.note.pages[toolManager.selectedPage - 1].id
                    document.document.note.pages.remove(at: toolManager.selectedPage)
                    
                    toolManager.selectedTab = newSelection
                    
                } else {
                    
                    let newSelection = document.document.note.pages[toolManager.selectedPage + 1].id
                    document.document.note.pages.remove(at: toolManager.selectedPage)
                    
                    toolManager.selectedTab = newSelection
                    
                }
                
                undoManager?.removeAllActions()
                toolManager.selectedItem = nil
                
            }
        }
    }
    
    func pageIndicator() {
        if subviewManager.overviewSheet == false {
            toolManager.isPageNumberVisible = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    toolManager.isPageNumberVisible = false
                }
            }
        }
    }
    
    func colorScheme(page: Page) -> ColorScheme {
        var cs: ColorScheme = .dark
        
        if  page.backgroundColor == "pagewhite" ||  page.backgroundColor == "white" ||  page.backgroundColor == "pageyellow" ||  page.backgroundColor == "yellow"{
            cs = .light
        }
        
        return cs
    }
    
    func getFrame(for page: Page) -> CGSize {
        var frame: CGSize = .zero
        
        if page.isPortrait {
            frame = CGSize(
                width: shortSide,
                height: longSide
            )
        } else {
            frame = CGSize(width: longSide, height: shortSide)
        }
        
        return frame
    }
    
    func getScale(_ index: Int, size: CGSize) -> CGFloat {
        var scale: CGFloat = 0
        
        let page = document.document.note.pages[index]
        
        if page.isPortrait {
            scale = size.width / shortSide
        } else {
            scale = size.width / longSide
        }
        
        return scale
    }
    
}