//
//  MessagesView.swift
//  TestMessaging
//
//  Created by William Carter on 10/12/21.
//

//import SwiftUI
//
//struct MessagesView: View {
//
//    /*enum Field: Hashable {
//     case compose
//     case recipient
//     }*/
//    
//    @EnvironmentObject var appStateModel: AppStateModel
//
//    @State var scrollViewProxy: ScrollViewProxy?
//    @FocusState var focusedField: Field?
//    @StateObject var viewModel = MessagesViewModel()
//
//    @State var recipientField: String = ""
//
//    var body: some View {
//
//        NavigationView {
//            VStack(alignment: .leading) {
//                if viewModel.contact == nil {
//                    MessageRecipientView()
//                        .environmentObject(appStateModel)
//                    MessageComposerView(focusedField: $focusedField)
//                        .environmentObject(appStateModel)
//                }
//                ScrollViewReader { proxy in
//                    if viewModel.contact != nil {
//                        ConversationListView()
//                            .environmentObject(appStateModel)
//                    }
//                }
//                .background(Color(UIColor.systemBackground))
//            }
//            .navigationBarTitle("Message")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarColor(UIColor.systemBackground, textColor: .label)
//            .toolbar {
//                ToolbarItem {
//                    Button(action: {
//
//                    }) {
//                        Image(systemName: "person.fill")
//                    }
//                }
//            }
//            .onTapGesture(count: 1) {
//                focusedField = nil
//            }
//        }
//        .onAppear {
//            //            viewModel.messages.append(Message(name: "New Message"))
//            viewModel.messages.append(Message())
//            viewModel.refreshReplies()
//
//            //viewModel.contact = Contact()
//
//            // uncomment this to test adding media
//            /*DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//             withAnimation {
//             viewModel.previewMedia.append("https://media.glamour.com/photos/609e9531953014aaf7ae9f19/1:1/w_354%2Cc_limit/swift%252520rodrigo.png")
//             }
//             }
//
//             DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
//             withAnimation {
//             viewModel.previewMedia.append("https://media.glamour.com/photos/609e9531953014aaf7ae9f19/1:1/w_354%2Cc_limit/swift%252520rodrigo.png")
//             }
//             }*/
//
//        }
//
//    }
//}
//
//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView()
//    }
//}

