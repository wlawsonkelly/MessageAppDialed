//
//  MessageRecipientView.swift
//  TestMessaging
//
//  Created by William Carter on 10/14/21.
//

import SwiftUI
import Combine
//
//struct MessageRecipientView: View {
//
//    @EnvironmentObject var appStateModel: AppStateModel
//
//    @FocusState private var focusedField: Field?
//    @FocusState private var focusBool: Bool
//
//    @State var lastTextLength: Int = 0
//
//    @State var tokens: [Contact] = []
//
//    func didDelete(tokenString: String) {
//        tokens = tokens.filter({ $0.name != tokenString })
//    }
//
//    var body: some View {
//        VStack {
//            ScrollViewReader { scrollView in
//                HStack {
//                    HStack {
//                        Text("To: ")
//                        if !tokens.isEmpty {
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack {
//                                    ForEach(0..<tokens.count, id: \.self) { i in
//                                        TokenView(
//                                            text: tokens[i].name,
//                                            didDelete: {
//                                                scrollView.scrollTo(tokens[tokens.count - 1], anchor: .trailing)
//                                                self.didDelete(tokenString: tokens[i].name)
//                                            }
//                                        )
//                                            .id(tokens[i].id)
//                                    }
//                                }
//                            }
//                        }
//                        TextField("Recipient",
//                                  text: $appStateModel.recipientField,
//                                  onEditingChanged: { (isBegin) in
//                            guard !appStateModel.recipientField.trimmingCharacters(in: .whitespaces).isEmpty else {
//                                return
//                            }
//
//                        }, onCommit: {
//                            appStateModel.searchResults.removeAll()
//                        }
//                        )
//                            .focused($focusedField, equals: Field.recipient)
//                            .focused($focusBool)
//
//                        Button(action: {
//                            if appStateModel.recipientField == "" {
//                                self.tokens = []
//                            } else {
//                                appStateModel.recipientField = ""
//                            }
//                        }, label: {
//                            Image(systemName: "xmark.circle.fill")
//                                .renderingMode(.template)
//                                .tint(.gray)
//                        })
//                            .padding(.trailing, 15)
//                            .if(tokens.count < 2 && appStateModel.recipientField.isEmpty, transform: { view in
//                                view.hidden()
//                            })
//                }
//                Button(action: {
//
//                }, label: {
//                    Image(systemName: "plus.circle.fill")
//                        .renderingMode(.template)
//                })
//                    .onChange(of: appStateModel.recipientField) { text in
//                        if text.isEmpty {
//                            appStateModel.searchResults.removeAll()
//                            return
//                        }
//                        lastTextLength = text.count
//                        withAnimation {
//                            appStateModel.searchUsers(queryText: text) { names in
//
//                            }
//                        }
//                    }
//                }
//            }
//
//            if appStateModel.searchResults.isEmpty {
//                List {
//                    ForEach(appStateModel.searchResults, id: \.self) { result in
//                        Button(action: {
//                            if !self.tokens.contains(result) {
//                                self.tokens.append(result)
//                                focusedField = .compose
//                                appStateModel.recipientField = ""
//                                self.focusBool = true
//                            }
//                        }, label: {
//                            Text(result.name)
//                        })
//
//                            .buttonStyle(PlainButtonStyle())
//                            .padding(5)
//                    }
//                }
//                .listStyle(PlainListStyle())
//                .padding([.top, .leading, .trailing], 15)
//            }
//            Rectangle()
//                .foregroundColor(Color(.systemGray5))
//                .frame(maxWidth: .infinity, minHeight: 1)
//            Spacer()
//        }
//        .padding()
//        .task {
//            focusedField = .recipient
//        }
//    }
//}
//
//struct MessageRecipientView_PreviewsContainer : View {
//
//    @FocusState private var focusedField: Field?
//
//    init() {
//        focusedField = .recipient
//    }
//
//     var body: some View {
//         MessageRecipientView()
//     }
//}
//
//struct MessageRecipientView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageRecipientView_PreviewsContainer()
//    }
//}
