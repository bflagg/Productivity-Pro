//
//  PPColorPicker.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 20.07.23.
//

import SwiftUI

struct PPColorPicker: View {
    
    @Binding var color: Color
    @Binding var isPresented: Bool
    
    var hsc: UserInterfaceSizeClass?
    var size: CGSize
    
    var body: some View {
        ZStack {
            PPColorPickerRepresentable(color: $color)
            
            if hsc == .compact {
                Button(action: { isPresented = false }) {
                    ExitButtonView()
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing
                )
                .padding(.trailing)
                .padding(.top, 12)
            }
            
        }
        .frame(
            minWidth: hsc == .regular ? 400 : size.width,
            maxWidth: hsc == .regular ? 400 : size.width,
            minHeight: 630,
            maxHeight: hsc == .regular ? 630 : .infinity
        )
        .ignoresSafeArea(edges: .all)
    }
}

struct PPColorPickerRepresentable: UIViewControllerRepresentable {
    
    @Binding var color: Color
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = true
        picker.selectedColor = UIColor(color)
        
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(color: $color)
    }
    
    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        @Binding var color: Color
        
        init(color: Binding<Color>) {
            _color = color
        }
        
        func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            color = Color(viewController.selectedColor)
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            color = Color(viewController.selectedColor)
        }
    }
}