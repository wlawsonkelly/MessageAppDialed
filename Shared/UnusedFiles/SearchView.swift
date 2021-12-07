//
//  SearchView.swift
//  MessageApp
//
//  Created by Lawson Kelly on 10/19/21.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appStateModel: AppState
    @State var text: String = ""
    @State var usernames: [String] = []
    let completion: ((String) -> Void)

    init(completion: @escaping ((String) -> Void)) {
        self.completion = completion
    }

    var body: some View {
        VStack {
            TextField("Username", text: $text)
                .modifier(CustomFieldModifier())
                .padding()
            Button {
                guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                    return
                }

                appStateModel.searchUsers(queryText: text) { usernames in
                    self.usernames = usernames
                }

            } label: {
                Text("Search")
            }

            List {
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
                        presentationMode.wrappedValue.dismiss()
                        completion(name)
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView() { _ in}
    }
}
