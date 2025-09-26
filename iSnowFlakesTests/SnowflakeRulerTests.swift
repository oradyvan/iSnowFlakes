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
}

private struct Environment {
    let count = 100
    let size = CGSize(width: 200, height: 200)

    func makeSUT() -> SnowflakeRuler {
        SnowflakeRuler(numberOfSnowflakes: count, size: size)
    }
}
