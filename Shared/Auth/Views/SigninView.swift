//
//  SigninView.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import SwiftUI

struct SigninView: View {
    @EnvironmentObject var appStateModel: AppState

    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "message.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .aspectRatio(contentMode: .fit)
                Text("Messenger")
                    .bold()
                    .font(.system(size: 34))

                VStack {
                    TextField("Username", text: $username)
                        .modifier(CustomFieldModifier())
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)

                    SecureField("Password", text: $password)
                        .modifier(CustomFieldModifier())
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)

                    Button {
                        appStateModel.signIn(username: username, password: password)
                    } label: {
                        Text("Sign In")
                            .frame(width: 180, height: 50)
                            .font(.system(size: 24))
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(16.0)
                    }
                    .padding()

                }
                .padding()

                HStack {
                    Text("Don't have an account?")
                    NavigationLink("Create Account") {
                        SignupView()
                    }
                }
                .padding()
                Spacer()
            }
        }
    }

    func signIn() {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            return
        }
        appStateModel.signIn(username: username, password: password)
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
