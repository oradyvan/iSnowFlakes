import SwiftUI

@main
struct iSnowFlakesApp: App {
    @State var selection: Int = 0

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                VStack {
                    Picker("Theme", selection: $selection) {
                        Text("Light").tag(0)
                        Text("Dark").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    Spacer()
                }
            }
            .preferredColorScheme(selection == 1 ? ColorScheme.dark : nil)
        }
    }
}
