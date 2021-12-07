//
//  ConversationListView.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import SwiftUI
import SwiftUIX

struct InboxView: View {
    @EnvironmentObject var appStateModel: AppStateModel

    @State var otherUsername: String = ""
    @State var showChat: Bool = false
    
    @State var searchText: String = ""
    
    @State var showSheet: Bool = false
    
    @State var showCompose: Bool = false
    
    var conversations: [String] {
        if searchText.isEmpty {
            return appStateModel.conversations
        } else {
            return appStateModel.conversations.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
        }
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(conversations, id: \.self) {
                    name in
                    
                    Button {
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
                    .fullScreenCover(isPresented: $showSheet) {
                        ChatView(otherUsername: name)
                            .environmentObject(appStateModel)
                    }

                    
//                    NavigationLink {
//                        ChatView(otherUsername: name)
//                            .environmentObject(appStateModel)
//                    } label: {
//                        HStack {
//                            Circle()
//                                .frame(width: 65, height: 65)
//                                .foregroundColor(Color.pink)
//                            Text(name)
//                                .bold()
//                                .font(.system(size: 32))
//                                .foregroundColor(Color(.label))
//                            Spacer()
//                        }
//                        .padding()
//                    }

                }
                .searchable(text: $searchText)
                if !otherUsername.isEmpty {
                    NavigationLink("",
                                   destination: ChatView(otherUsername: otherUsername),
                                   isActive: $showChat
                    )
                }
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
            ComposeMessageView()
                .environmentObject(appStateModel)
        })
        .onAppear {
            guard appStateModel.auth.currentUser != nil else { return
            }
            appStateModel.getConversations()
        }

    }

    func signOut() {

    }
}

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
