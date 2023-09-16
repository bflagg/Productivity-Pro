//
//  ChooseTypeView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 16.09.22.
//

import SwiftUI

struct NewDocumentView: View {
    @Binding var isPresented: Bool
    @Binding var document: Document
    
    @AppStorage("savedBackgroundColor")
    var savedBackgroundColor: String = ""
    
    @AppStorage("savedIsPortrait")
    var savedIsPortrait: Bool = true
    
    @AppStorage("savedBackgroundTemplate")
    var savedBackgroundTemplate: String = ""
    
    @StateObject var subviewManager: SubviewManager
    @StateObject var toolManager: ToolManager
    
    @State var isPortrait: Bool = true
    @State var selectedColor: String = "pagewhite"
    @State var selectedTemplate: String = "blank"
    
    @State var url: URL?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea(.all)
                
                ViewThatFits(in: .horizontal) {
                    HStack {
                        Grid(showIcon: true)
                    }
                    
                    ViewThatFits(in: .vertical) {
                        VStack {
                            Grid(showIcon: true)
                        }
                        
                        VStack {
                            Grid(showIcon: false)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .padding(5)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        isPresented.toggle()
                    }
                }
            }
            
        }
    }
}
