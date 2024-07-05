import SwiftUI
import Firebase

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showPasswordReset = false
    @State private var resetEmail = ""
    @State private var resetErrorMessage = ""
    @Binding var showSignUp: Bool
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                signIn()
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                showPasswordReset = true
            }) {
                Text("Forgot Password?")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 20)

            Spacer()

            HStack {
                Text("Don't have an account?")
                Button(action: {
                    showSignUp = true
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showPasswordReset) {
            PasswordResetView(resetEmail: $resetEmail, resetErrorMessage: $resetErrorMessage, showPasswordReset: $showPasswordReset)
        }
    }

    func signIn() {
        authViewModel.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showSignUp: .constant(false))
            .environmentObject(AuthViewModel())
    }
}
