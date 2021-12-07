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
    
    @State var shouldScroll: Bool = false
    
    init(otherUsername: String) {
        self.otherUsername = otherUsername
    }
    
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
                    Text(otherUsername)
                        .font(.system(size: 24))
                        .bold()
                }
                .padding(.horizontal, 16)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(appStateModel.messages, id: \.self) { message in
                        ChatRowView(text: message.text, type: message.type)
                            .id(message.id)
                            .padding(3)
                    }
                }
                ChatInputView(
                    otherUsername: otherUsername,
                    message: $message,
                    isSent: $shouldScroll
                )
                .padding()
            }
            .onAppear {
                appStateModel.otherUsername = otherUsername
                appStateModel.observeChat()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        reader.scrollTo(appStateModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            .onChange(of: shouldScroll) { newValue in
                print("Changed")
                if shouldScroll {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            reader.scrollTo(appStateModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(otherUsername: "James")
    }
}
