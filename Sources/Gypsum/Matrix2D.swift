import AppKit
import Math

public struct Matrix2D: Equatable {
    let store: [[Pixel]]
}

public extension Matrix2D {
    init(
        width: Int,
        height: Int,
        evaluate: (Double, Double) -> Pixel
    ) {
        var result: [[Pixel]] = []
        for y in 0 ..< height {
            var line: [Pixel] = []
            for x in 0 ..< width {
                let value = evaluate(Double(x), Double(y))
                line.append(value)
            }

            result.append(line)
        }

        self.store = result
    }

    static func monochrome(
        width: Int,
        height: Int,
        evaluate: (Double, Double) -> Double
    ) -> Self {
        return .init(width: width, height: height) {
            Pixel(monochrome: evaluate($0, $1))
        }
    }

    var image: NSImage {
        return .init(
            cgImage: .image(from: store),
            size: .init(
                width: store[0].count,
                height: store.count
            )
        )
    }

    init(
        width: Int,
        height: Int,
        fill: Pixel = .black
    ) {
        self = .init(store: Array(repeating: Array(repeating: fill, count: width), count: height))
    }
}

extension CGImage {
    static func image(from pixels: [[Pixel]]) -> CGImage {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let width = pixels[0].count
        let height = pixels.count
        let componentCount = 4
        let byteCount = height * width * componentCount
        let pixelData: [UInt8] = pixels.flatMap { row in
            row.flatMap { $0.values }
        }
        assert(byteCount == pixelData.count)

        let bitsPerComponent: Int = 8
        let rgbData = CFDataCreate(nil, pixelData, byteCount)!
        let provider = CGDataProvider(data: rgbData)!
        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerComponent * componentCount,
            bytesPerRow: width * componentCount,
            space: rgbColorSpace,
            bitmapInfo: .init(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )!
    }
}
