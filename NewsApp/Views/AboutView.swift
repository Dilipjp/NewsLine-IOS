import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About NewsLine")
                .font(.largeTitle)
                .padding()

            Text("Welcome to NewsLine! Stay updated with the latest news from around the world.")
                .font(.body)
                .padding()

            Spacer()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
