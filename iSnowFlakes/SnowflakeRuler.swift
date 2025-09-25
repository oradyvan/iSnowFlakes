import Foundation
import CoreGraphics

final class SnowflakeRuler {
    let numberOfSnowflakes: Int
    let size: CGSize

    private let kMinSnowflakeRatio: CGFloat = 0.05
    private let kMaxSnowflakeRatio: CGFloat = 0.1
    private let kFallSpeed: CGFloat = 2.5
    private let kMinPhases: Int
    private let kMaxPhases: Int

    private var sequenceNumber: Int = 0
    private var snowflakes: [Int: SnowflakeParticle] = [:]
    private var presetWidths: [CGFloat] = []

    init(numberOfSnowflakes: Int, size: CGSize) {
        self.numberOfSnowflakes = numberOfSnowflakes
        self.size = size

        // seed the random generator
        srandom(UInt32(Date.timeIntervalSinceReferenceDate))

        presetWidths.append(size.width * 0.03)
        presetWidths.append(size.width * 0.06)
        presetWidths.append(size.width * 0.1)
        kMinPhases = 1
        kMaxPhases = presetWidths.count
    }

    func createParticle() -> (Int, SnowflakeParticle) {
        // choosing random value of number of phases
        let phase = Int.random(in: kMinPhases...kMaxPhases)

        // choosing one of the predefined widths for the particles
        let flakeSize: CGFloat = presetWidths[phase - 1]

        let minX: CGFloat = -flakeSize
        let maxX: CGFloat = size.width - flakeSize / 2
        let flakeX: CGFloat = CGFloat.random(in: minX...maxX)
        var flakeFrame = CGRect(x: flakeX, y: -flakeSize, width: flakeSize, height: flakeSize).integral

        // choose X position until there are no overlaps with the existing snowflakes
        while snowflakes.values.contains(where: { $0.frame.intersects(flakeFrame) }) {
            flakeFrame.origin.x = CGFloat.random(in: minX...maxX)
        }

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
        let fallSpeed = kFallSpeed * CGFloat(particle.phase)
        frame.origin.y += fallSpeed

        let x: CGFloat = frame.origin.y / size.height * CGFloat(particle.phase) * .pi
        let shift = fallSpeed / 2 * (particle.rotationAngle > 0 ? -1 : 1)
        frame.origin.x += shift * sin(x / 2) * cos(5 * x / 6)

        let updatedParticle = SnowflakeParticle(
            rotationAngle: particle.rotationAngle,
            frame: frame,
            phase: particle.phase
        )
        snowflakes[id] = updatedParticle
        return updatedParticle
    }

    func shouldDestroy(particle: SnowflakeParticle) -> Bool {
        particle.frame.maxY > size.height ||
        particle.frame.maxX < 0 ||
        particle.frame.minX > size.width
    }
}
