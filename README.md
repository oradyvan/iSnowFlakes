iSnowFlakes
===========

Snow flakes generator for iOS with a Demo App. Every snow flake is unique!

How to Use
==========

1. Add the reference to this Swift package from your product, either via Xcode or by adding this line to your Package.swift file:

1. This package provides the functionality via the UIKit's View Controller. This is how to embed it using UIKit:

```swift
import iSnowFlakes
import UIKit

final class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // embed Snowflakes View into My View
        let child = SnowflakesViewController(
            configuration: SnowflakesConfiguration()
        )
        addChild(child)
        view.addSubview(child.view)

        // use auto-layout to fill the entire My View frame
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }
}
```
