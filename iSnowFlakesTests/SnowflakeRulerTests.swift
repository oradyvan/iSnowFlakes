import UIKit
import Testing
@testable import iSnowFlakes

struct SnowflakeRulerTests {

    @Test("When createParticle is called few times it should create non-overlapping ones")
    func createParticle_fewTimes_nonOverlapping() {
        let environment = Environment()
        let sut = environment.makeSUT()

        var snowflakes = [SnowflakeParticle]()
        for _ in 1...3 {
            let (_, particle) = sut.createParticle()

            #expect(snowflakes.contains(where: { $0.frame.intersects(particle.frame) }) == false)

            snowflakes.append(particle)
        }
    }

    @Test("When createParticle is called many times it may create overlapping ones")
    func createParticle_manyTimes_overlapping() {
        let environment = Environment()
        let sut = environment.makeSUT()

        var snowflakes = [SnowflakeParticle]()
        var hasOverlapping: Bool = false
        for _ in 1...100 {
            let (_, particle) = sut.createParticle()

            if !hasOverlapping {
                hasOverlapping = snowflakes.contains(
                    where: { $0.frame.intersects(particle.frame) }
                )
            }

            snowflakes.append(particle)
        }

        #expect(hasOverlapping)
    }

    @Test("When created particle was destroyed, moveParticle should throw error")
    func moveParticle_destroyedParticle_throwsError() {
        let environment = Environment()
        let sut = environment.makeSUT()

        let (id, _) = sut.createParticle()
        sut.destroyParticle(id)

        let error = #expect(throws: SnowflakeRulerError.self) {
            try sut.moveParticle(id)
        }
        guard case .invalidSnowflakeID(let caughtId) = error else {
            Issue.record("Expected .invalidSnowflakeID error")
            return
        }
        #expect(caughtId == id)
    }

    @Test func moveParticle_shouldUpdateFrame() throws {
        let environment = Environment()
        let sut = environment.makeSUT()

        let (id, initialParticle) = sut.createParticle()
        let particle = try sut.moveParticle(id)

        #expect(particle.frame.minY > initialParticle.frame.minY)
        if particle.rotationAngle > 0 {
            #expect(particle.frame.minX > initialParticle.frame.minX)
        } else {
            #expect(particle.frame.minX < initialParticle.frame.minX)
        }
    }

    @Test func shouldDestroy_whenWithinBounds_shouldReturnFalse() {
        let environment = Environment()
        let sut = environment.makeSUT()
        
        let particle = SnowflakeParticle(
            rotationAngle: 0.0,
            frame: CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0),
            phase: 1
        )

        #expect(!sut.shouldDestroy(particle: particle))
    }

    @Test("shouldDestroy when outside bounds should return True", arguments: [
        CGRect(x: -20.0, y: 10.0, width: 10.0, height: 10.0),
        CGRect(x: 210.0, y: 10.0, width: 10.0, height: 10.0),
        CGRect(x: 10.0, y: 200.0, width: 10.0, height: 10.0),
    ])
    func shouldDestroy_whenOutsideBounds_shouldReturnTrue(frame: CGRect) {
        let environment = Environment()
        let sut = environment.makeSUT()

        let particle = SnowflakeParticle(
            rotationAngle: 0.0,
            frame: frame,
            phase: 1
        )

        #expect(sut.shouldDestroy(particle: particle))
    }
}

private struct Environment {
    let count = 100
    let size = CGSize(width: 200, height: 200)

    func makeSUT() -> SnowflakeRuler {
        SnowflakeRuler(numberOfSnowflakes: count, size: size)
    }
}
