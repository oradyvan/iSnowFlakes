import UIKit
import iSnowFlakes

final class MainViewController: UIViewController {

    weak var snowflakesViewController: SnowflakesViewController?
    weak var pauseResumeButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = .all

        // embed Snowflakes View into the Main View
        let child = SnowflakesViewController()
        addChild(child)
        view.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        child.didMove(toParent: self)
        snowflakesViewController = child

        // add "Pause"/"Resume" button at the bottom of the screen
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pause", for: .normal)
        button.addTarget(self, action: #selector(onPause), for: .primaryActionTriggered)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        pauseResumeButton = button
    }

    @objc func onPause() {
        pauseResumeButton?.removeTarget(self, action: #selector(onPause), for: .primaryActionTriggered)
        pauseResumeButton?.setTitle("Resume", for: .normal)
        pauseResumeButton?.addTarget(self, action: #selector(onResume), for: .primaryActionTriggered)
        snowflakesViewController?.pause()
    }

    @objc func onResume() {
        pauseResumeButton?.removeTarget(self, action: #selector(onResume), for: .primaryActionTriggered)
        pauseResumeButton?.setTitle("Pause", for: .normal)
        pauseResumeButton?.addTarget(self, action: #selector(onPause), for: .primaryActionTriggered)
        snowflakesViewController?.resume()
    }
}
