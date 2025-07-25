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
    private var snowflakes: [UIImageView] = []

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

        // draw a sample of a snowflake
        imgView.image = maker.createSnowflake()

        Timer.scheduledTimer(
            timeInterval: kTimerRate,
            target: self,
            selector: #selector(onTimer),
            userInfo: nil,
            repeats: true
        )
    }

    @IBAction func onRefresh() {
        print(#function)
    }

    @objc func onTimer() {
        var flakesToRemove: [UIImageView] = []

        // move existing snowflakes down one step
        snowflakes.forEach { snowflake in
            var frame = snowflake.frame
            frame.origin.y += kFallSpeed
            let x: CGFloat = frame.origin.y / view.frame.height * CGFloat(snowflake.tag) * .pi

            frame.origin.x += kFallSpeed * sin(x / 2) * cos(5 * x / 6)
            snowflake.frame = frame

            // if the snowflake falls off the screen, mark it for removal
            if frame.origin.y > view.frame.height {
                flakesToRemove.append(snowflake)
                snowflake.removeFromSuperview()
            }
        }

        // remove snowflakes that are out of view
        snowflakes.removeAll(where: flakesToRemove.contains)

        // add new snowflake
        if snowflakes.count < kNumberOfSnowflakes {
            let flakeSize: CGFloat = view.frame.width * CGFloat.random(in: kMinSnowflakeRatio...kMaxSnowflakeRatio)
            let minX: CGFloat = -flakeSize
            let maxX: CGFloat = view.frame.width - flakeSize / 2
            let flakeX: CGFloat = CGFloat.random(in: minX...maxX)
            let flakeFrame = CGRect(x: flakeX, y: -flakeSize, width: flakeSize, height: flakeSize).integral
            let snowflake = UIImageView(frame: flakeFrame)

            // choosing random value of number of phases
            snowflake.tag = Int.random(in: kMinPhases...kMaxPhases)

            // generating unique snowflake image
            snowflake.image = maker.createSnowflake()
            view.addSubview(snowflake)
            snowflakes.append(snowflake)
        }
    }
}
