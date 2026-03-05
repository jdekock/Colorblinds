import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SwiftUIExampleView()
                    .tabItem {
                        Label("SwiftUI", systemImage: "swift")
                    }

                UIKitExampleWrapper()
                    .tabItem {
                        Label("UIKit", systemImage: "hammer")
                    }
            }
        }
    }
}
