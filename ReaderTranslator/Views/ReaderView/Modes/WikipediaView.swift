//
//  GTranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct WikipediaView: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        WebViewContainer {
            Wikipedia(selectedText: self.$store.translateAction)
        }
    }
}

struct WikipediaView_Previews: PreviewProvider {
    static var previews: some View {
        WikipediaView()
    }
}
