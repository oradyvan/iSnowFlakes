import Foundation
import CoreGraphics

final class SnowflakeRuler {
    let numberOfSnowflakes: Int
    let size: CGSize

    private let kMinSnowflakeRatio: CGFloat = 0.05
    private let kMaxSnowflakeRatio: CGFloat = 0.1
    private let kFallSpeed: CGFloat = 5.0
    private let kMinPhases: Int = 1
    private let kMaxPhases: Int = 3

    private var sequenceNumber: Int = 0
    private var snowflakes: [Int: SnowflakeParticle] = [:]

    init(numberOfSnowflakes: Int, size: CGSize) {
        self.numberOfSnowflakes = numberOfSnowflakes
        self.size = size

        // seed the random generator
        srandom(UInt32(Date.timeIntervalSinceReferenceDate))
    }

    func createParticle() -> (Int, SnowflakeParticle) {
        let flakeSize: CGFloat = size.width * CGFloat.random(in: kMinSnowflakeRatio...kMaxSnowflakeRatio)
        let minX: CGFloat = -flakeSize
        let maxX: CGFloat = size.width - flakeSize / 2
        let flakeX: CGFloat = CGFloat.random(in: minX...maxX)
        let flakeFrame = CGRect(x: flakeX, y: -flakeSize, width: flakeSize, height: flakeSize).integral

        // choosing random value of number of phases
        let phase = Int.random(in: kMinPhases...kMaxPhases)

        // choosing random angle of rotation
        let angle = CGFloat.random(in: kMinSnowflakeRatio...kMaxSnowflakeRatio)

        // choosing random direction of rotation
        let sign: CGFloat = Bool.random() ? 1 : -1

        let particle = SnowflakeParticle(
            rotationAngle: sign * angle,
            frame: flakeFrame,
            phase: phase
        )
        sequenceNumber += 1
        snowflakes[sequenceNumber] = particle
        return (sequenceNumber, particle)
    }

    func destroyParticle(_ id: Int) {
        snowflakes[id] = nil
    }

    func moveParticle(_ id: Int) -> SnowflakeParticle {
        let particle = snowflakes[id]!

        var frame = particle.frame
        frame.origin.y += kFallSpeed

        let x: CGFloat = frame.origin.y / size.height * CGFloat(particle.phase) * .pi
        frame.origin.x += kFallSpeed * sin(x / 2) * cos(5 * x / 6)

        let updatedParticle = SnowflakeParticle(
            rotationAngle: particle.rotationAngle,
            frame: frame,
            phase: particle.phase
        )
        snowflakes[id] = updatedParticle
        return updatedParticle
    }

    func shouldDestroy(particle: SnowflakeParticle) -> Bool {
        particle.frame.maxY > size.height
    }
}
