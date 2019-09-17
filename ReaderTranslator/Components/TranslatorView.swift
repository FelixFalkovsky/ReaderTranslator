//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit
  
struct TranslatorView : UIViewRepresentable {
    @Binding var text: URLQueryItem
      
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let lastUrl = uiView.url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? "https://translate.google.com?sl=auto&tl=ru"
        
        guard var urlComponent = URLComponents(string: url) else { return }
        guard let queryItems = urlComponent.queryItems else { return }

        let text = queryItems.first(where: { $0.name == "text" })?.value
        
        if text == self.text.value { return }

        let sl = queryItems.first(where: { $0.name == "sl" })?.value
        let tl = queryItems.first(where: { $0.name == "tl" })?.value

        urlComponent.queryItems = [
            .init(name: "sl", value: sl),
            .init(name: "tl", value: tl),
            self.text
        ]
        
        uiView.load(URLRequest(url: urlComponent.url!))
    }
      
}
