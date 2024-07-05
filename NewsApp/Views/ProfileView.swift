import SwiftUI
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if let userEmail = authViewModel.currentUserEmail() {
                Text("Welcome, \(userEmail)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            } else {
                Text("Not signed in")
                    .font(.title)
                    .foregroundColor(.red)
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
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
