import SwiftUI
import Firebase

struct SplashView: View {
    @State private var isActive = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if self.isActive {
                if authViewModel.isSignedIn {
                    MainView()
                        .environmentObject(authViewModel)
                } else {
                    AuthView()
                        .environmentObject(authViewModel)
                }
            } else {
                Text("NewsLine")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(AuthViewModel())
    }
}
