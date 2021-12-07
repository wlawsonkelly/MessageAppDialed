//
//  SignupView.swift
//  TestMessaging
//
//  Created by Lawson Kelly  on 12/1/21.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var appStateModel: AppStateModel

    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""

    var body: some View {
        VStack {
            // Heading
            Image("logo")
                .resizable()
                .frame(width: 120, height: 120)
                .aspectRatio(contentMode: .fit)
            Text("Messenger")
                .bold()
                .font(.system(size: 34))

            VStack {
                TextField("Email", text: $email)
                    .modifier(CustomFieldModifier())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                TextField("Username", text: $username)
                    .modifier(CustomFieldModifier())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                SecureField("Password", text: $password)
                    .modifier(CustomFieldModifier())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button {
                    signUp()
                } label: {
                    Text("Sign Up")
                        .frame(width: 180, height: 50)
                        .font(.system(size: 24))
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(16.0)
                }
                .padding()
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
    }

    func signUp() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            return
        }
        appStateModel.signUp(email: email, username: username, password: password)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
