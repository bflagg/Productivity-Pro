//
//  MDTIntro.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 13.01.24.
//

import MarkdownUI
import SwiftUI

struct MDTIntro: View {
    var body: some View {
        Markdown(
            """
            #### Markdown
            Mit Markdown kannst du Text formatieren, ohne deinen Schreibfluss zu unterbrechen. Dazu musst du lediglich verschiedene Zeichen miteinander kombinieren. Klingt erstmal schwer, ist aber ganz leicht.
            """
        )
        .markdownTheme(.productivitypro(
            name: UIFont.systemFont(ofSize: 9).familyName,
            size: 18.6 / 2,
            color: Color.white.data()
        ))
        .padding(50)
    }
}

#Preview {
    MarkdownTutorialView()
}
