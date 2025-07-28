import UIKit

struct SnowflakeMaker {
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
        context.clear(rect)

        // going top to bottom in the middle of the image
        drawBoldLine(
            in: context,
            from: CGPoint(x: rect.midX, y: rect.maxY),
            to: CGPoint(x: rect.midX, y: rect.minY),
            shiftX: 1.0
        )

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

            // centring and rotating context so that the rect is drawn as a diamond
            context.saveGState()
            context.translateBy(x: square.midX, y: square.midY)
            context.rotate(by: .pi / 4)

            let bounds = CGRect(x: 0.0, y: 0.0, width: square.size.width, height: square.size.height)

            // draw line from bottom left to bottom right corner
            drawBoldLine(
                in: context,
                from: CGPoint(x: bounds.minX, y: bounds.minY),
                to: CGPoint(x: bounds.maxX, y: bounds.minY),
                shiftY: 1.0
            )

            // draw line from bottom left to top left corner
            drawBoldLine(
                in: context,
                from: CGPoint(x: bounds.minX, y: bounds.minY),
                to: CGPoint(x: bounds.minX, y: bounds.maxY),
                shiftX: 1.0
            )

            // rotate the graphics context back to the initial state
            context.restoreGState()
        }

        return context.makeImage()
    }

    private func drawBoldLine(
        in context: CGContext,
        from startPoint: CGPoint,
        to endPoint: CGPoint,
        shiftX: CGFloat = 0,
        shiftY: CGFloat = 0
    ) {
        let leftStartPoint = CGPoint(x: startPoint.x - shiftX, y: startPoint.y - shiftY)
        let leftEndPoint = CGPoint(x: endPoint.x - shiftX, y: endPoint.y - shiftY)
        context.move(to: leftStartPoint)
        context.addLine(to: leftEndPoint)

        let rightStartPoint = CGPoint(x: startPoint.x + shiftX, y: startPoint.y + shiftY)
        let rightEndPoint = CGPoint(x: endPoint.x + shiftX, y: endPoint.y + shiftY)
        context.move(to: rightStartPoint)
        context.addLine(to: rightEndPoint)

        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()

        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
    }
}
