//
//  ChatRowView.swift
//  MessageApp
//
//  Created by Lawson Kelly on 10/19/21.
//

import SwiftUI

struct ChatRowView: View {
    let type: MessageType
    let text: String

    var isSender: Bool {
        type == .sent
    }

    init(text: String, type: MessageType) {
        self.type = type
        self.text = text
    }

    var body: some View {
        HStack {
            if isSender {
                Spacer()
            }
            if !isSender {
                VStack {
                    Spacer()
                    Circle()
                        .frame(width: 45, height: 45)
                        .foregroundColor(Color.pink)
                }
            }
            HStack {
                Text(text)
                    .foregroundColor(isSender ? Color.white : Color(.label))
                    .padding()
            }
            .background(isSender ? Color.blue : Color(.systemGray4))
            .padding(isSender ? .leading : .trailing, isSender ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width/5)
            if !isSender {
                Spacer()
            }
        }
    }
}

struct ChatRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRowView(text: "Sup", type: .sent)
                .preferredColorScheme(.dark)
            ChatRowView(text: "Not much", type: .received)
                .preferredColorScheme(.dark)
        }
    }
}
