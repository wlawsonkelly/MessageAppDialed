//
//  ChatView.swift
//  MessageApp
//
//  Created by Lawson Kelly on 10/19/21.
//

import SwiftUI

struct CustomFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
    }
}

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var appStateModel: AppStateModel

    @State var message: String = ""
    let otherUsername: String

    init(otherUsername: String) {
        self.otherUsername = otherUsername
    }

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button() {
                    dismiss()
                } label: {
                    Text("Back")
                }
                Spacer()
                Text(otherUsername)
                    .font(.system(size: 24))
                    .bold()
            }
            .padding(.horizontal, 16)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(appStateModel.messages, id: \.self) { message in
                    ChatRowView(text: message.text, type: message.type)
                        .padding(3)
                }
            }
            ChatInputView(
                otherUsername: otherUsername,
                message: $message
            )
            .padding()
        }
//        .navigationTitle(otherUsername)
//        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            appStateModel.otherUsername = otherUsername
            appStateModel.observeChat()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(otherUsername: "James")
    }
}
