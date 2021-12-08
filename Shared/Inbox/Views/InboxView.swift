//
//  ConversationListView.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import SwiftUI
import SwiftUIX

struct InboxView: View {
    @EnvironmentObject var appStateModel: AppState
    
    @ObservedObject var inboxViewModel: InboxViewModel

    @State var otherUsername: String = ""
    @State var showChat: Bool = false
    
    @State var searchText: String = ""
    
    @State var showSheet: Bool = false
    
    @State var showCompose: Bool = false
    
    @State var chatViewUsername: String = ""
    
    var conversations: [String] {
        if searchText.isEmpty {
            return inboxViewModel.usernames
        } else {
            return inboxViewModel.usernames.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
        }
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(conversations, id: \.self) {
                    name in
                    Button {
                        otherUsername = name
                        print(otherUsername, "this is it")
                        showSheet.toggle()
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 65, height: 65)
                                .foregroundColor(Color.pink)
                            Text(name)
                                .bold()
                                .font(.system(size: 32))
                                .foregroundColor(Color(.label))
                            Spacer()
                        }
                        .padding()
                    }
                }
                .searchable(text: $searchText)
            }
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCompose.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        appStateModel.signOut()
                    } label: {
                        Image(systemName: "peacesign")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $appStateModel.showSignIn, content: {
            SigninView()
        })
        .fullScreenCover(isPresented: $showCompose, content: {
            ComposeMessageView(
                inboxViewModel: inboxViewModel
            )
                .environmentObject(appStateModel)
        })
        .fullScreenCover(isPresented: $showSheet) {
            if let currentUsername = inboxViewModel.currentUsername,
                let otherUsername = otherUsername {
                let messageViewModel = MessageViewModel(
                    currentUsername: currentUsername,
                    otherUsername: otherUsername
                )
                ChatView(messageViewModel: messageViewModel)
            }
        }
        .onAppear {
            guard appStateModel.auth.currentUser != nil else { return
            }
        }
        .onChange(of: otherUsername) { name in
            self.otherUsername = name
        }
    }

    func signOut() {

    }
}

//struct ConversationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        InboxView()
//    }
//}
