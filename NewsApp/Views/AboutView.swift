import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow]), startPoint: .topLeading, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("About NewsLine")
                    .font(.largeTitle)
                    .padding()
                
                Text("Welcome to NewsLine, your go-to source for all the latest updates from around the globe! We’re dedicated to bringing you the most current and comprehensive news coverage, covering a wide range of topics from breaking headlines to in-depth analysis. Stay informed and engaged with real-time updates, insightful reports, and expert opinions on the stories that matter most. Whether you’re interested in global events, local news, or specialized content, NewsLine is here to keep you connected to the world.")
                    .font(.body)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
