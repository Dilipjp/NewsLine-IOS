//
//  PasswordResetView.swift
//  NewsApp
//
//  Created by Dilip on 2024-07-05.
//

import SwiftUI
import Firebase

struct PasswordResetView: View {
    @Binding var resetEmail: String
    @Binding var resetErrorMessage: String
    @Binding var showPasswordReset: Bool

    var body: some View {
        
        
        VStack {
            Text("Reset Password")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $resetEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !resetErrorMessage.isEmpty {
                Text(resetErrorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                sendPasswordReset()
            }) {
                Text("Send Reset Link")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()

            Button(action: {
                showPasswordReset = false
            }) {
                Text("Back to Sign In")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }

    func sendPasswordReset() {
        Auth.auth().sendPasswordReset(withEmail: resetEmail) { error in
            if let error = error {
                resetErrorMessage = error.localizedDescription
            } else {
                resetErrorMessage = "A password reset link has been sent to your email."
            }
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(resetEmail: .constant(""), resetErrorMessage: .constant(""), showPasswordReset: .constant(false))
    }
}
