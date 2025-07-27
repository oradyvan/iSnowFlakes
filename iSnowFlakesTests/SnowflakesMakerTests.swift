import UIKit
import Testing
@testable import iSnowFlakes

@Suite
struct SnowflakesMakerTests {

    @Test func createSnowflake_shouldGenerateImage() {
        let sut = Environment().makeSUT()

        let image = sut.createSnowflake()

        #expect(image.size.width == 200)
        #expect(image.size.height == 200)
    }
}

private struct Environment {
    func makeSUT() -> SnowflakeMaker {
        SnowflakeMaker(
            size: CGSize(width: 200, height: 200),
            screenScale: 2.0
        )
    }
}
