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
    
    @ObservedObject var messageViewModel: MessageViewModel
    
    @State var message: String = ""
    @State var shouldScroll: Bool = false
    
    var body: some View {
        ScrollViewReader { reader in
            VStack {
                HStack(spacing: 0) {
                    Button() {
                        dismiss()
                    } label: {
                        Text("Back")
                    }
                    Spacer()
                    Text(messageViewModel.otherUsername)
                        .font(.system(size: 24))
                        .bold()
                }
                .padding(.horizontal, 16)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messageViewModel.messages, id: \.self) { message in
                        ChatRowView(text: message.text, type: message.type)
                            .id(message.id)
                            .padding(3)
                    }
                }
                ChatInputView(
                    otherUsername: messageViewModel.otherUsername,
                    message: $message,
                    isSent: $shouldScroll,
                    messageViewModel: messageViewModel
                )
                .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        reader.scrollTo(messageViewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            .onChange(of: shouldScroll) { _ in
                if shouldScroll {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            reader.scrollTo(messageViewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
