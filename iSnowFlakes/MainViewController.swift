import SwiftUI
import UIKit

final class MainViewController: UIViewController {

    private let kNumberOfSnowflakes: Int = 200
    private let kMinSnowflakeRatio: CGFloat = 0.05
    private let kMaxSnowflakeRatio: CGFloat = 0.1
    private let kTimerRate: TimeInterval = 0.05

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var rotateButton: UIButton!

    private var maker: SnowflakeMaker!
    private var ruler: SnowflakeRuler!

    private var snowflakes: [UIImageView] = []
    private var rotationTimer: Timer?
    private var snowflakeParticle: SnowflakeParticle?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        edgesForExtendedLayout = .all

        // initialise the main engine of making the snowflakes
        self.maker = SnowflakeMaker(
            size: imgView.frame.size,
            screenScale: UIScreen.main.scale
        )

        // initialise the engine controlling the life cycle of
        // the snowflakes as particles
        self.ruler = SnowflakeRuler(
            numberOfSnowflakes: kNumberOfSnowflakes,
            size: view.frame.size
        )

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
        imgView.image = maker.createSnowflake()
    }

    @IBAction func onRotate() {
        if rotationTimer == nil {
            startRotating()
        } else {
            stopRotating()
        }
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

    private func startRotating() {
        rotateButton.setTitle("Stop", for: .normal)
        rotationTimer = Timer.scheduledTimer(
            timeInterval: kTimerRate,
            target: self,
            selector: #selector(onNextRotation),
            userInfo: nil,
            repeats: true
        )

        let angle: CGFloat
        if let oldParticle = snowflakeParticle {
            angle = -oldParticle.rotationAngle
        } else {
            angle = CGFloat.random(in: kMinSnowflakeRatio...kMaxSnowflakeRatio)
        }
        snowflakeParticle = SnowflakeParticle(
            rotationAngle: angle,
            frame: .zero,
            phase: 0
        )
    }

    private func stopRotating() {
        rotationTimer?.invalidate()
        rotationTimer = nil
        rotateButton.setTitle("Rotate", for: .normal)
    }

    @objc private func onNextRotation() {
        guard let snowflakeParticle else { return }
        imgView.transform = imgView.transform.rotated(by: snowflakeParticle.rotationAngle)
    }
}

struct MainView: UIViewControllerRepresentable {

    typealias UIViewControllerType = MainViewController

    func makeUIViewController(context: Context) -> MainViewController {
        MainViewController(
            nibName: "ViewController_iPhone",
            bundle: nil
        )
    }

    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
        // no-op
    }
}
