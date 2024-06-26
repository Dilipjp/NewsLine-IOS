//
//  ResetPasswordView.swift
//  NewsApp
//
//  Created by User on 2024-06-26.
//

import SwiftUI
import FirebaseAuth

struct ResetPasswordView: View {
    @Binding var showResetPassword: Bool
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                resetPassword()
            }) {
                Text("Send Reset Link")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            Spacer()

            Button(action: {
                withAnimation {
                    showResetPassword = false
                }
            }) {
                Text("Back to Sign In")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
        }
        .padding()
    }

    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                successMessage = ""
            } else {
                successMessage = "Password reset email sent."
                errorMessage = ""
            }
        }
    }
}
