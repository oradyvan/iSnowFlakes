import UIKit

final class MainViewController: UIViewController {

    private let kNumberOfSnowflakes: Int = 128
    private let kMinSnowflakeRatio: CGFloat = 0.05
    private let kMaxSnowflakeRatio: CGFloat = 0.1
    private let kTimerRate: TimeInterval = 0.05
    private let kFallSpeed: CGFloat = 5.0
    private let kMinPhases: Int = 1
    private let kMaxPhases: Int = 3

    @IBOutlet weak var imgView: UIImageView!

    private var maker: SnowflakesMaker!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // initializer the main engine of making the sowflakes
        self.maker = SnowflakesMaker(
            size: imgView.frame.size,
            screenScale: UIScreen.main.scale
        )

        // seed the random generator
        srandom(UInt32(Date.timeIntervalSinceReferenceDate))

        imgView.image = maker.createSnowflake()
    }

    @IBAction func onRefresh() {
        print(#function)
    }
}
