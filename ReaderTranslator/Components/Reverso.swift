//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct Reverso : ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let host = "https://context.reverso.net/translation/"

    static var pageView: WKPageView?

    class Coordinator: WKCoordinator {
        var selectedText = ""
        
        override init(_ parent: WKScriptsSetup) {
            super.init(parent)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        print("Reverso_makeCoordinator")
        return Coordinator(self)
    }
    
    func makeView(context: Context) -> WKPageView  {
        print("Reverso_makeView")
        let view = WKPageView(defaultUrl: host)
        Self.pageView = view
        
        setupScriptCoordinator(view: view, coordinator: context.coordinator)
        setupScript(view: view, file: "reverso-reverso-speaker")

        return view
    }
      
    func updateView(_ view: WKPageView, context: Context) {
        print("Reverso_updateView")
        guard case let .reverso(text) = selectedText else { return }
        selectedText.setNone()

        print("Reverso_updateView_update", text)
        
        let search = text.replacingOccurrences(of: " ", with: "+")
        let language = view.url?.absoluteString.groups(for: #"\/translation\/(\w+-\w+)\/"#)[safe: 0]?[safe: 1] ?? "english-russian"
        let urlString = "\(host)\(language)/\(search)"
        
        if view.url?.absoluteString == urlString { return }
        
        if let url = URL(string: urlString.encodeUrl) {
            print("Reverso_updateView_reload", urlString)
            view.load(URLRequest(url: url))
        }
    }
}

extension Reverso.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            self.selectedText = text
        case "keydown":
            if event.extra?.keyCode == 17 { //Ctrl
                store.translateAction = .translator(text: text, noReverso: true)
            }
            if event.extra?.keyCode == 18 { //Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}



