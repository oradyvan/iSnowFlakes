import UIKit

@main
final class AppDelegate: NSObject, UIApplicationDelegate {
    static func main() {
        UIApplicationMain(
            CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self)
        )
    }
}
