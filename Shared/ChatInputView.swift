//
//  ChatInputView.swift
//  MessageApp
//
//  Created by Lawson Kelly  on 12/6/21.
//

import SwiftUI
import SwiftUIX

struct ChatInputView: View {
    @EnvironmentObject var appStateModel: AppStateModel
    @Binding var message: String
    
    var otherUsername: String
    
    init(otherUsername: String, message: Binding<String>) {
        self.otherUsername = otherUsername
        _message = message
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
                appStateModel.otherUsername = otherUsername
                appStateModel.sendMessage(text: message)
                message = ""
                print("sending")
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
