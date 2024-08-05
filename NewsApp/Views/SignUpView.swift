import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var errorMessage = ""
    @Binding var showSignUp: Bool
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow, Color.orange]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding()

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    signUp()
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()

                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white)
                    Button(action: {
                        showSignUp = false
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
        }
    }

    func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty"
            return
        }

        authViewModel.signUp(email: email, password: password) { result in
            switch result {
            case .success:
                if let currentUser = Auth.auth().currentUser {
                    let changeRequest = currentUser.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                        } else {
                            // Save user data to Realtime Database
                            let userRef = Database.database().reference(withPath: "users").child(currentUser.uid)
                            let userData: [String: Any] = [
                                "username": username,
                                "email": email
                            ]
                            userRef.setValue(userData) { error, _ in
                                if let error = error {
                                    self.errorMessage = error.localizedDescription
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showSignUp: .constant(true))
            .environmentObject(AuthViewModel())
    }
}
