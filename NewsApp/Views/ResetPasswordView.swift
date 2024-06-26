//
//  ResetPasswordView.swift
//  NewsApp
//
//  Created by Dilip on 2024-06-26.
//



import SwiftUI
import FirebaseAuth

struct ResetPasswordView: View {
    @Binding var showResetPassword: Bool
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow]), startPoint: .topLeading, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("app_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                    .clipShape(Circle())
                
                Text("NewsLine")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Enter your email to receive a password reset link.")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    resetPassword()
                }) {
                    Text("Reset Password")
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: {
                    withAnimation {
                        self.showResetPassword = false
                    }
                }) {
                    Text("Back to Sign In")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
            }
            .alert(isPresented: Binding<Bool>(get: { errorMessage != "" || successMessage != "" }, set: { _ in })) {
                Alert(
                    title: Text(errorMessage.isEmpty ? "Success" : "Error"),
                    message: Text(errorMessage.isEmpty ? successMessage : errorMessage),
                    dismissButton: .default(Text("OK"), action: {
                        errorMessage = ""
                        successMessage = ""
                    })
                )
            }
        }
    }

    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                successMessage = ""
            } else {
                successMessage = "A password reset link has been sent to your email."
                errorMessage = ""
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(showResetPassword: .constant(true))
    }
}



