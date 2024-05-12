//
//  UITFRepresentable.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 15.04.24.
//

import RichTextKit
import SwiftUI

struct UITFRepresentable: UIViewRepresentable {
    var scale: CGFloat
    var textField: PPTextFieldModel

    @Bindable var toolManager: ToolManager

    func makeUIView(context: Context) -> RichTextView {
        let view = RichTextView()
        view.delegate = context.coordinator
        view.backgroundColor = .clear

        Task { @MainActor in
            if let data = textField.attributedString {
                view.attributedString = NSAttributedString(data: data)

                // MARK: set default text attributes

            } else {
                view.attributedString = MDConverter.attributedString(
                    field: textField
                )
            }
        }

//        adopt(view: view, to: scale * 2.5)
        return view
    }
}
