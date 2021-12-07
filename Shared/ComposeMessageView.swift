//
//  ComposeMessageView.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/3/21.
//

import SwiftUI
import SwiftUIX
import UIKit

struct ComposeMessageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appStateModel: AppStateModel

    @State var recipient: String = ""
    @State var message: String = ""
        
    @State var usernames: [String] = []
    
    @State var searchTokens: [UISearchToken] = []

    private func sendMessage() {
        guard !message.isEmpty else { return }
       // appStateModel.sendMessage(text: message)
        message = ""
    }
    
    private func highlight(text: String) {
        guard text != "" else { return }
        let filtered = searchTokens.filter({$0.representedObject as! String == text })
        if filtered.isEmpty {
            let phoneToken = UISearchToken(icon: UIImage(systemName: "phone.fill"), text: text)
            phoneToken.representedObject = text
            searchTokens.append(phoneToken)
        }
    }
    
    func onCommit() -> () {
        if !usernames.isEmpty {
            highlight(text: usernames.first ?? "")
            recipient = ""
        }
    }
    
    func getOtherUsername() -> String {
        if searchTokens.isEmpty {
            return ""
        } else {
            return searchTokens.first?.representedObject as! String
        }
    }
        
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("To:")
                        .font(.system(size: 20))
                    RecipientTextField(
                        text: $recipient,
                        searchTokens: $searchTokens,
                        onCommit: self.onCommit
                    )

                    Spacer()
                    Button {
                        //
                    } label: {
                        Image(systemName: "plus.circle")
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 16)
                Divider()
                VStack {
                    ForEach(usernames, id: \.self) { name in
                        HStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.green)
                            Text(name)
                                .font(.system(size: 24))
                                .bold()
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .onTapGesture {
                            highlight(text: name)
                            recipient = ""
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                Spacer()
                ChatInputView(
                    otherUsername: getOtherUsername(),
                    message: $message
                )
                    .environmentObject(appStateModel)
                .padding()
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
            }
            .onChange(of: recipient) { text in
                if text.isEmpty {
                    self.usernames.removeAll()
                    return
                }
                withAnimation {
                    appStateModel.searchUsers(queryText: text) { names in
                        self.usernames = names
                    }
                }
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $message)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 0.4))
                    .opacity(message.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                appStateModel.otherUsername = searchTokens.first?.representedObject as! String
                print(appStateModel.otherUsername, " other username")
                print(appStateModel.currentUsername, " current username")
                appStateModel.sendMessage(text: message)
            } label: {
                Text("Send")
                    .foregroundColor(message.isEmpty ? .black : .white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(message.isEmpty ? .gray : .blue)
            .cornerRadius(8)
        }
        .padding(.vertical, 8)
    }
}

struct ComposeMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeMessageView()
    }
}
