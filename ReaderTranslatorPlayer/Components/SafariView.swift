//
//  SafariView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 1/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariRepresentable: UIViewControllerRepresentable {
    @Binding var url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: Context) {

    }

}

struct SafariView: View {
    @Binding var url: URL?
    static private var view: SafariRepresentable?

    var body: some View {
        Group {
            if url != nil {
                SafariRepresentable(url: Binding($url)!)
            } else {
                EmptyView()
            }
        }
    }
}
