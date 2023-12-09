//
//  MediaArrangeView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 21.11.23.
//

import SwiftUI
import PPDoubleKeyboard
import PPAnglePicker

struct MediaArrangeView: View {
    @Environment(ToolManager.self) var toolManager
    var items: [PPItemModel]
    
    @State var anglePicker: Bool = false
    
    @State var xPos: Bool = false
    @State var yPos: Bool = false
    @State var width: Bool = false
    @State var heigth: Bool = false
    
    var body: some View {
        @Bindable var media = toolManager.activeItem!.media!
        @Bindable var item = toolManager.activeItem!
        
        Form {
            Section("Position") {
                HStack {
                    Text("X")
                    Spacer()
                    Button(String(item.x.rounded(toPlaces: 1))) {
                        xPos.toggle()
                    }
                    .ppDoubleKeyboard(isPresented: $xPos, value: $item.x)
                }
                .frame(height: 30)
                
                HStack {
                    Text("Y")
                    Spacer()
                    Button(String(item.y.rounded(toPlaces: 1))) {
                        yPos.toggle()
                    }
                    .ppDoubleKeyboard(isPresented: $yPos, value: $item.y)
                }
                .frame(height: 30)
            }
            
            Section {
                HStack {
                    Button(action: {
                        StackingModel(items: items)
                            .moveUp(item: item)
                    }) {
                        Image(systemName: "square.2.stack.3d.top.filled")
                    }
                    .buttonStyle(.bordered)
                    .hoverEffect(.lift)
                    
                    Button(action: {
                        StackingModel(items: items)
                            .moveDown(item: item)
                    }) {
                        Image(systemName: "square.2.stack.3d.bottom.filled")
                    }
                    .buttonStyle(.bordered)
                    .hoverEffect(.lift)
                    
                    Spacer()
                    Divider().frame(height: 20)
                    Spacer()
                    
                    Button(action: {
                        StackingModel(items: items)
                            .bringFront(item: item)
                    }) {
                        Image(systemName: "square.3.stack.3d.top.filled")
                    }
                    .buttonStyle(.bordered)
                    .hoverEffect(.lift)
                    
                    Button(action: {
                        StackingModel(items: items)
                            .bringBack(item: item)
                    }) {
                        Image(systemName: "square.3.stack.3d.bottom.filled")
                    }
                    .buttonStyle(.bordered)
                    .hoverEffect(.lift)
                }
                .frame(height: 30)
            }
            .listSectionSpacing(10)
            
            Section("Dimensionen") {
                HStack {
                    Text("Breite")
                    Spacer()
                    Button(String(item.width.rounded(toPlaces: 1))) {
                        width.toggle()
                    }
                    .ppDoubleKeyboard(
                        isPresented: $width, value: $item.width
                    )
                }
                .frame(height: 30)
                
                HStack {
                    Text("Höhe")
                    Spacer()
                    Button(String(item.height.rounded(toPlaces: 1))) {
                        heigth.toggle()
                    }
                    .ppDoubleKeyboard(
                        isPresented: $heigth, value: $item.height
                    )
                }
                .frame(height: 30)
            }
            
            Section {
                HStack {
                    Text("Drehung")
                    Spacer()
                    Button(action: { anglePicker.toggle() }) {
                        Text("\(String(media.rotation))°")
                    }
                    .popover(isPresented: $anglePicker) {
                        PPAnglePickerView(
                            degrees: $media.rotation
                        )
                        .presentationCompactAdaptation(.popover)
                        .frame(width: 270, height: 270)
                        .background {
                            Color(
                                UIColor.secondarySystemBackground
                            )
                            .ignoresSafeArea(.all)
                        }
                    }
                }
                .frame(height: 30)
            }
            .listSectionSpacing(10)
        }
        .environment(\.defaultMinListRowHeight, 10)
    }
}
