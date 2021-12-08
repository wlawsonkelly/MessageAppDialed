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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appStateModel: AppState

    @ObservedObject var inboxViewModel: InboxViewModel
    
    @State var recipient: String = ""
    @State var message: String = ""
    
    @State var usernames: [String] = []
    
    @State var searchTokens: [UISearchToken] = []
    
    @State var isSent: Bool = false
        
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
        VStack {
            ZStack {
                HStack {
                    Button("Back") {
                        dismiss()
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                .zIndex(1)
                HStack {
                    Text("New Message")
                        .font(.system(size: 22))
                        .bold()
                }
                .zIndex(0)
            }
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
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 4))
            .padding(.horizontal, 16)
            Divider()
                .padding(.top, -32)
            VStack {
                ForEach(usernames, id: \.self) { name in
                    HStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.red)
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
            .padding(.top, -24)
            Spacer()
            ChatInputView(
                otherUsername: getOtherUsername(),
                message: $message,
                isSent: $isSent,
                messageViewModel: MessageViewModel(
                    currentUsername: inboxViewModel.currentUsername,
                    otherUsername: getOtherUsername()
                )
            )
                .padding()
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
        .onChange(of: isSent) { _ in
            dismiss()
        }
    }
}

//struct ComposeMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComposeMessageView()
//    }
//}
