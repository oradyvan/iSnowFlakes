import UIKit

struct SnowflakesMaker {
    let size: CGSize
    let screenScale: CGFloat

    private let kMinRects: Int = 10
    private let kMaxRects: Int = 20
    private let kMinRectSizeRatio: CGFloat = 0.02
    private let kMaxRectSizeRatio: CGFloat = 0.5

    func createSnowflake() -> UIImage {
        // creating image for the quarter size of the image view
        let scale: CGFloat = self.screenScale
        let size = CGSize(
            width: scale * (self.size.width / 2).rounded(),
            height: scale * (self.size.height / 2).rounded()
        )
        let rect = CGRect(
            x: 0.0,
            y: 0.0,
            width: (size.width / 2).rounded(),
            height: (size.height / 2).rounded()
        )

        guard let branch = randomizeOneSnowflakeBranch(in: rect) else {
            return UIImage()
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: Int(size.width) * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return UIImage() }
        let bounds = CGRect(x: 0.0, y: 0.0, width: rect.size.width, height: rect.size.height)

        context.translateBy(x: rect.midX, y: rect.maxY)
        context.draw(branch, in: bounds)

        let deltaAngle: CGFloat = -.pi / 3
        let dX: CGFloat = rect.midX * cos(deltaAngle)
        let dY: CGFloat = -rect.midY * sin(deltaAngle)

        for _ in 1..<6 {
            context.translateBy(x: dX, y: dY)
            context.rotate(by: deltaAngle)
            context.draw(branch, in: bounds)
        }

        let cgImage = context.makeImage()!
        return UIImage(cgImage: cgImage)
    }

    func randomizeOneSnowflakeBranch(in rect: CGRect) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: Int(rect.size.width),
            height: Int(rect.size.height),
            bitsPerComponent: 8,
            bytesPerRow: Int(rect.size.width) * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        context.setStrokeColor(UIColor.white.cgColor)
        context.clear(rect)

        // going top to bottom in the middle of the image
        context.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        context.drawPath(using: .stroke)

        let numRects: Int = Int.random(in: kMinRects...kMaxRects)
        let h = rect.height
        for _ in 0..<numRects {
            // calculating random size of the square
            let rectExtent = (h * CGFloat.random(in: kMinRectSizeRatio...kMaxRectSizeRatio)).rounded()
            var square = CGRect(x: 0.0, y: 0.0, width: rectExtent, height: rectExtent)

            // calculate random position of the rect on line, excluding edge cases
            let minY = rect.minY + rectExtent / 2
            let maxY = rect.maxY - rectExtent / 2
            let yPos = CGFloat.random(in: minY...maxY)

            // shifting square to the middle of the rect horizontally
            // and by the random amount of points vertically
            square = square.offsetBy(dx: rect.midX - rectExtent / 2, dy: yPos)

            // centering and rotating context so that the rect is drawn as a diamond
            context.saveGState()
            context.translateBy(x: square.midX, y: square.midY)
            context.rotate(by: .pi / 4)

            let bounds = CGRect(x: 0.0, y: 0.0, width: square.size.width, height: square.size.height)

            // draw line from bottom left to bottom right corner
            context.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            context.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))

            // draw line from bottom left to top left corner
            context.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            context.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))

            // stroke the lines
            context.strokePath()
            context.restoreGState()
        }

        return context.makeImage()
    }
}
