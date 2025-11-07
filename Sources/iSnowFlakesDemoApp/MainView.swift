import SwiftUI
import UIKit

struct MainView: UIViewControllerRepresentable {

    typealias UIViewControllerType = MainViewController

    func makeUIViewController(context: Context) -> MainViewController {
        MainViewController()
    }

    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
        // no-op
    }
}
