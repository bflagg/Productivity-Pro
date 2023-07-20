//
//  PPDrawingBar.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 19.07.23.
//

import SwiftUI

struct PPDrawingBar: View {
    
    @StateObject var drawingModel: PPDrawingModel
    @StateObject var toolManager: ToolManager
    
    @AppStorage("colorSelection") var selectedColor: Int = 0
    @AppStorage("drawingColor1") var firstColor: Color = Color.black
    @AppStorage("drawingColor2") var secondColor: Color = Color.blue
    @AppStorage("drawingColor3") var thirdColor: Color = Color.red
    
    @AppStorage("widthSelection") var selectedWidth: Int = 0
    @AppStorage("drawingWidth1") var firstWidth: Double = 3
    @AppStorage("drawingWidth2") var secondWidth: Double = 9
    
    var hsc: UserInterfaceSizeClass?
    var size: CGSize
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            DrawingBar(0)
                .padding(10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                DrawingBar(10)
            }
            .padding(.vertical, 10)
        }
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 19))
        .padding(.horizontal, 10)
        .onAppear {
            switch selectedColor {
            case 0: drawingModel.selectedColor = firstColor
            case 1: drawingModel.selectedColor = secondColor
            case 2: drawingModel.selectedColor = thirdColor
            default:
                break
            }
            
            switch selectedWidth {
            case 0: drawingModel.selectedWidth = firstWidth
            case 1: drawingModel.selectedWidth = secondWidth
            default:
                break
            }
            
        }
    }
    
    @ViewBuilder func DrawingBar(_ outerPadding: CGFloat) -> some View {
        HStack {
            Group {
                PPToolButton(
                    icon: "pencil.line",
                    isTinted: drawingModel.selectedTool == .pen
                ) {
                    drawingModel.selectedTool = .pen
                }
                .padding(.trailing, 2.5)
                .padding(.leading, outerPadding)
                
                PPToolButton(
                    icon: "highlighter",
                    isTinted: drawingModel.selectedTool == .highlighter
                ) {
                    drawingModel.selectedTool = .highlighter
                }
                .padding(.horizontal, 2.5)
                
                PPToolButton(
                    icon: "eraser",
                    isTinted: drawingModel.selectedTool == .eraser
                ) {
                    drawingModel.selectedTool = .eraser
                }
                .padding(.horizontal, 2.5)
                
                PPToolButton(
                    icon: "lasso",
                    isTinted: drawingModel.selectedTool == .lasso
                ) {
                    drawingModel.selectedTool = .lasso
                }
                .padding(.horizontal, 2.5)
            }
            
            Divider()
                .frame(height: 35)
                .padding(.horizontal, 2.5)
            
            Group {
                PPToolButton(
                    icon: "wand.and.rays",
                    isTinted: drawingModel.objectRecognitionTool == .objectRecognition
                ) {
                    if drawingModel.objectRecognitionTool == .objectRecognition {
                        drawingModel.objectRecognitionTool = .none
                    } else {
                        drawingModel.objectRecognitionTool = .objectRecognition
                    }
                }
                .padding(.horizontal, 2.5)
                
                PPToolButton(
                    icon: "ruler",
                    isTinted: drawingModel.objectRecognitionTool == .ruler
                ) {
                    if drawingModel.objectRecognitionTool == .ruler {
                        drawingModel.objectRecognitionTool = .none
                    } else {
                        drawingModel.objectRecognitionTool = .ruler
                    }
                }
                .padding(.horizontal, 2.5)
            }
            
            Divider()
                .frame(height: 35)
                .padding(.horizontal, 2.5)
            
            Group {
                PPColorButton(
                    color: $firstColor,
                    selectedColor: $drawingModel.selectedColor,
                    selectedValue: $selectedColor,
                    value: 0,
                    hsc: hsc,
                    size: size
                )
                .padding(.horizontal, 2.5)
                
                PPColorButton(
                    color: $secondColor,
                    selectedColor: $drawingModel.selectedColor,
                    selectedValue: $selectedColor,
                    value: 1,
                    hsc: hsc,
                    size: size
                )
                .padding(.horizontal, 2.5)
                
                PPColorButton(
                    color: $thirdColor,
                    selectedColor: $drawingModel.selectedColor,
                    selectedValue: $selectedColor,
                    value: 2,
                    hsc: hsc,
                    size: size
                )
                .padding(.horizontal, 2.5)
            }
            
            Divider()
                .frame(height: 35)
                .padding(.horizontal, 2.5)
            
            Group {
                PPSizeButton(
                    width: $firstWidth,
                    selectedWidth: $drawingModel.selectedWidth,
                    selectedValue: $selectedWidth,
                    value: 0
                )
                .padding(.horizontal, 2.5)
                
                PPSizeButton(
                    width: $secondWidth,
                    selectedWidth: $drawingModel.selectedWidth,
                    selectedValue: $selectedWidth,
                    value: 1
                )
                .padding(.horizontal, 2.5)
            }
            
            Divider()
                .frame(height: 35)
                .padding(.horizontal, 5)
            
            PPMenuView(toolManager: toolManager)
                .padding(.leading, 2.5)
                .padding(.trailing, outerPadding)

        }
    }
}
