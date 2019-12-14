//
//  BookmarksView_List_Chunk.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 7/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine

struct BookmarksView_List_Detail: View {
    @ObservedObject var store = Store.shared

    @Binding var selectSentence: String

    var changedTime: String {
        guard let bookmark = self.store.bookmarks.first(text: self.store.longmanSelectedBookmark) else { return "" }
        let formatter = RelativeDateTimeFormatter()

        return formatter.localizedString(for: Date(), relativeTo: bookmark.changed)
    }

    var createTime: String {
        guard let bookmark = self.store.bookmarks.first(text: self.store.longmanSelectedBookmark) else { return "" }
        let formatter = RelativeDateTimeFormatter()

        return formatter.localizedString(for: Date(), relativeTo: bookmark.created)
    }

    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                HStack {
                    Text("counter changed: \(changedTime)").foregroundColor(Color.purple)
                    Text("create: \(createTime)")
                }
                Text(store.longmanSelectedBookmark).font(.title)
                sentencesView
            }
            .padding(.leading, 5)
            .padding(.bottom, 15)
        }
    }

    var sentencesView: some View {
        ForEach(store.longmanSentences, id: \.self) { sentence in
            Text("\(sentence.text)")
            .foregroundColor(self.selectSentence == sentence.text ? Color.yellow : Color.primary)
            .font(.subheadline)
            .onTapGesture {
                self.selectSentence = sentence.text
                LongmanStore.share.addAudio(url: sentence.url )
                LongmanStore.share.next()
                self.store.translateAction.add(.gTranslator(text: sentence.text), isSpeaking: false)
            }
        }
    }
}