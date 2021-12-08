//
//  ContentView.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/7/21.
//

import Foundation
import SwiftUI

struct ContentView: View {
    let appStateModel = AppState()
    
    var body: some View {
        TabView {
            InboxView(inboxViewModel: InboxViewModel(currentUsername: appStateModel.currentUsername))
                .environmentObject(appStateModel)
                .tabItem {
                    Label("Inbox", systemImage: "envelope")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
