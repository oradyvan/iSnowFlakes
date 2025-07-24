import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!

    //let maker = SnowflakesMaker(size: .init(width: 1000, height: 1000))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    @IBAction func onRefresh() {
        print(#function)
    }
}
