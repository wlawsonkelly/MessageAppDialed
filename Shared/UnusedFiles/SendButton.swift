//
//  SendButton.swift
//  MessageApp
//
//  Created by Lawson Kelly on 10/19/21.
//

import SwiftUI

struct SendButton: View {
    @EnvironmentObject var appStateModel: AppState

    @Binding var text: String

    var body: some View {
        Button {
            self.sendMessage()
        } label: {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 32))
                .frame(width: 50, height: 50)
                .aspectRatio( contentMode: .fit)
                .foregroundColor(Color.white)
                .background(Color.pink)
                .clipShape(Circle())
        }
    }

    func sendMessage() {
        guard !text.isEmpty else { return }
        appStateModel.sendMessage(text: text)
        text = ""
    }
}

//struct SendButton_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
