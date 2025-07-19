import UIKit

@main
final class AppDelegate: NSObject, UIApplicationDelegate {
    static func main() {
        UIApplicationMain(
            CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self)
        )
    }

    func application(_ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
