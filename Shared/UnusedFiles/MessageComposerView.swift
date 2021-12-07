//
//  MessageComposeView.swift
//  TestMessaging
//
//  Created by William Carter on 10/14/21.
//

import SwiftUI

struct MessageComposerView: View {
    
    @EnvironmentObject var appStateModel: AppStateModel
    @State var message: String = ""

    var focusedField: FocusState<Field?>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
//
//            if viewModel.previewMedia.count > 0 {
//                HStack(spacing: 10) {
//                    ForEach(viewModel.previewMedia, id: \.self) { urlString in
//                        AsyncImage(url: URL(string: urlString)) { image in
//                            image
//                                .resizable()
//                                .frame(width: 75, height: 75, alignment: .center)
//                                .border(Color(.systemGray3))
//                                .cornerRadius(15)
//                        } placeholder: {
//                            ProgressView()
//                        }
//                    }
//                    Spacer()
//                }
//                .padding([.leading, .trailing], 10)
//                .frame(width: UIScreen.main.bounds.width, height: 85)
//                .background(.thinMaterial)
//            }
//
            HStack(alignment: .bottom) {
                
                Button(action: {
                    
                }) {
                    Label("", systemImage: "camera.fill")
                }
                .padding([.bottom], 22)
                VStack() {
                    TextEditor(text: $appStateModel.composeText)
                        .focused(focusedField, equals: Field.compose)
                        .onChange(of: appStateModel.composeText, perform: { value in
                            print("Value of text modified to = \(value)")
                        })
                        .onSubmit {
                            print("Submit")
                            focusedField.wrappedValue = nil
                        }
                        .onChange(of: focusedField.wrappedValue) { isFocused in
                            if let f = isFocused, f == .compose {
                                if appStateModel.composeText == "Write something!" {
                                    appStateModel.composeText = ""
                                }
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    if focusedField.wrappedValue == Field.compose {
                                        Button(action: {
                                            appStateModel.refreshReplies()
                                        }) {
                                            Image(systemName: "arrow.clockwise")
                                        }
                                        Button(action: {
                                            appStateModel.composeText = appStateModel.quickReplySuggestion
                                            appStateModel.sendMessage(text: appStateModel.quickReplySuggestion)
                                        }) {
                                            Text(appStateModel.quickReplySuggestion)
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        focusedField.wrappedValue = nil
                                    }) {
                                        Image(systemName: "keyboard.chevron.compact.down")
                                    }
                                }
                            }
                        }
                    //.disableAutocorrection(true)
                        .interactiveDismissDisabled(false)
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                        .padding(.top, -10)
                }
                SendButton(text: $message)
                    .padding(.leading, 15)
            }
        }
        .background(Color(.systemBackground))
        .frame(height: 50)
    }
}
