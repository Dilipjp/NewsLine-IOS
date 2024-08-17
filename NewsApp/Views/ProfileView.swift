import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var userName: String = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow]), startPoint: .topLeading, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if let userEmail = authViewModel.currentUserEmail() {
                    if !userName.isEmpty {
                        Text("Welcome \(userName)")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        Text("Email: \(userEmail)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding()
                    } else {
                        Text("User name")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding()
                    }
                } else {
                    Text("Your are not signed in, plesase sign in")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding()
                }
                
                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                fetchUserName()
            }
        }
    }

    func fetchUserName() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = Database.database().reference(withPath: "users").child(userId)
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let name = userData["username"] as? String {
                self.userName = name
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
