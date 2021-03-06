//
//  ChatInputView.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/6/21.
//

import SwiftUI
import SwiftUIX

struct ChatInputView: View {
    @EnvironmentObject var appStateModel: AppState
    
    @ObservedObject var messageViewModel: MessageViewModel
    
    @Binding var message: String
    @Binding var isSent: Bool

    var otherUsername: String
        
    init(
        otherUsername: String,
        message: Binding<String>,
        isSent: Binding<Bool>,
        messageViewModel: MessageViewModel
    ) {
        self.otherUsername = otherUsername
        _message = message
        _isSent = isSent
        self.messageViewModel = messageViewModel
    }
    
    var body: some View {
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
                messageViewModel.otherUsername = otherUsername
                messageViewModel.sendMessage(text: message)
                message = ""
                isSent = true
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

struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Enter Message")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
            Spacer()
        }
    }
}

//struct ChatInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatInputView(message: <#Binding<String>#>,
//                      otherUsername: <#Binding<String>#>)
//    }
//}
