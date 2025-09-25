import UIKit

public final class SnowflakesViewController: UIViewController {

    private let kNumberOfSnowflakes: Int = 200
    private let kMinSnowflakeRatio: CGFloat = 0.05
    private let kMaxSnowflakeRatio: CGFloat = 0.1
    private let kTimerRate: TimeInterval = 0.03
    private let kSampleSnowflakeSize: CGFloat = 150

    private var maker: SnowflakeMaker!
    private var ruler: SnowflakeRuler!

    private var snowflakes: [UIImageView] = []

    public override func willMove(toParent parent: UIViewController?) {
        if let parent  {
            let screenScale = parent.traitCollection.displayScale
            initializeEngines(frame: parent.view.frame, screenScale: screenScale)
        }
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        ruler.size = size
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = .all
    }

    func initializeEngines(frame: CGRect, screenScale: CGFloat) {
        // initialise the main engine of making the snowflakes
        self.maker = SnowflakeMaker(
            size: CGSize(width: kSampleSnowflakeSize, height: kSampleSnowflakeSize),
            screenScale: screenScale
        )

        // initialise the engine controlling the life cycle of
        // the snowflakes as particles
        self.ruler = SnowflakeRuler(
            numberOfSnowflakes: kNumberOfSnowflakes,
            size: frame.size
        )

        Timer.scheduledTimer(
            timeInterval: kTimerRate,
            target: self,
            selector: #selector(onTimer),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func onTimer() {
        var flakesToRemove: [UIImageView] = []

        // move existing snowflakes down one step
        snowflakes.forEach { snowflake in
            let particle = ruler.moveParticle(snowflake.tag)

            // update the centre of the snowflake by the updated particle frame
            snowflake.center = CGPoint(x: particle.frame.midX, y: particle.frame.midY)

            // rotate the snowflake a bit
            snowflake.transform = snowflake.transform.rotated(by: particle.rotationAngle)

            // if the snowflake falls off the screen, mark it for removal
            if ruler.shouldDestroy(particle: particle) {
                flakesToRemove.append(snowflake)
                ruler.destroyParticle(snowflake.tag)
                snowflake.removeFromSuperview()
            }
        }

        // remove snowflakes that are out of view
        snowflakes.removeAll(where: flakesToRemove.contains)

        // add new snowflake
        if snowflakes.count < kNumberOfSnowflakes {
            // generate new particle
            let (tag, particle) = ruler.createParticle()
            let snowflake = UIImageView(frame: particle.frame)

            // store the reference to the particle
            snowflake.tag = tag

            // generating unique snowflake image
            snowflake.image = maker.createSnowflake()
            view.addSubview(snowflake)
            snowflakes.append(snowflake)
        }
    }
}
