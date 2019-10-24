//
//  StatusBarView_Tabs.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Tabs: View {
    @Binding var viewMode: ViewMode
    @Binding var currentTab: Int
    
    var body: some View {
        Group {
            if viewMode == .web {
                Divider().fixedSize()
                Button(action: { self.currentTab = 0 }) {
                    Image(systemName: "1.circle\(iconStatus(0))")
                }
                Button(action: { self.currentTab = 1 }) {
                    Image(systemName: "2.circle\(iconStatus(1))")
                }
                Button(action: { self.currentTab = 2 }) {
                    Image(systemName: "3.circle\(iconStatus(2))")
                }
            }
        }
    }
    
    private func iconStatus(_ tab: Int) -> String {
        self.currentTab == tab ? ".fill" : ""
    }
}

struct StatusBarView_Tabs_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Tabs(viewMode: .constant(.web), currentTab: .constant(0))
    }
}
