import SnapshotTesting
import XCTest
@testable import NoiseV2

final class OpenSimplex2STests: XCTestCase {
    var noise: OpenSimplex2S!
    let width = 256
    let height = 256

    override func setUp() {
        super.setUp()
        self.noise = .init(seed: 1729, variant2D: .improveX)
    }

    override func tearDown() {
        super.tearDown()
        self.noise = nil
    }

    func testMatrix() {
        noise.frequency = 0.007
        let matrix = noise.matrix2D(width: width, height: height)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image)
    }

    func testAdding() {
        noise.frequency = 0.005
        let other: NoiseSource = OpenSimplex2S(seed: 123)
            .brownian(seed: 1337, gain: 0.5, lacunarity: 2.0, octaves: 6, weightedStrength: 0.2)
        let added = noise.added(to: other)
        let product = added.multiplied(by: noise.ridged(seed: 1337, gain: 0.1, lacunarity: 6.0, octaves: 3, weightedStrength: 1.0))
        let matrix = product.matrix2D(width: width, height: height)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image, record: true)
    }
}

extension NSImage {
    public static func image(from values: [[Double]]) -> NSImage {
        .init(
            cgImage: .image(from: values),
            size: .init(
                width: values[0].count,
                height: values.count
            )
        )
    }
}

extension CGImage {
    public static func image(from values: [[Double]]) -> CGImage {
        let values = values.map(current: values.minMax(), target: 0 ... 255)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let width = values.count
        let height = values[0].count
        let bitsPerComponent: Int = 8
        let componentCount = 4
        let byteCount = height * width * componentCount
        let pixelData: [UInt8] = values.flatMap { row in
            row.flatMap { value in
                (1 ... componentCount).map { _ in UInt8(value) }
            }
        }
        assert(byteCount == pixelData.count)

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

public func animate(matrix: [[[Double]]], frameRate: Double, loop: Bool, path: String) {
    guard let imageDestination = CGImageDestinationCreateWithURL(
        URL(fileURLWithPath: path) as CFURL,
        kUTTypeGIF, 0, nil
    ) else {
        fatalError()
    }

    let gifProperties = [
        kCGImagePropertyGIFDictionary as String: [
            kCGImagePropertyGIFLoopCount as String: loop ? 0 : 1
        ]
    ]
    CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)
    let frameProperties = [
        kCGImagePropertyGIFDictionary as String: [
            kCGImagePropertyGIFDelayTime as String: 1 / frameRate
        ]
    ] as CFDictionary

    for plane in matrix {
        CGImageDestinationAddImage(imageDestination, .image(from: plane), frameProperties)
    }

    guard CGImageDestinationFinalize(imageDestination) else {
        fatalError()
    }
}

func animate(images: [CGImage], frameRate: Double, isLoop: Bool, path: String) {
    guard let imageDestination = CGImageDestinationCreateWithURL(
        URL(fileURLWithPath: path) as CFURL,
        kUTTypeGIF, 0, nil
    ) else {
        fatalError()
    }

    let loopCount = isLoop ? 0 : 1
    let gifProperties = [
        kCGImagePropertyGIFDictionary as String: [
            kCGImagePropertyGIFLoopCount as String: loopCount
        ]
    ]

    CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)

    let frameProperties = [
        kCGImagePropertyGIFDictionary as String: [
            kCGImagePropertyGIFDelayTime as String: 1 / frameRate
        ]
    ]

    for image in images {
        CGImageDestinationAddImage(imageDestination, image, frameProperties as CFDictionary)
    }

    guard CGImageDestinationFinalize(imageDestination) else {
        fatalError()
    }
}

public func animate(images: [NSImage], frameRate: Double, isLoop: Bool, path: String) throws {
    guard let imageDestination = CGImageDestinationCreateWithURL(
        URL(fileURLWithPath: path) as CFURL,
        kUTTypeGIF, 0, nil
    ) else {
        fatalError()
    }

    let loopCount = isLoop ? 0 : 1
    let gifProperties = [
        kCGImagePropertyGIFDictionary as String: [
            kCGImagePropertyGIFLoopCount as String:loopCount
        ]
    ]

    CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)

    let frameProperties = [
        kCGImagePropertyGIFDictionary as String: [
            kCGImagePropertyGIFDelayTime as String: 1 / frameRate
        ]
    ]

    for image in images {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            fatalError()
        }

        CGImageDestinationAddImage(imageDestination, cgImage, frameProperties as CFDictionary)
    }

    guard CGImageDestinationFinalize(imageDestination) else {
        fatalError()
    }
}

extension Array where Element == [Double] {
    func minMax() -> ClosedRange<Double> {
        var min = Double.infinity
        var max = -Double.infinity
        for line in self {
            min = Swift.min(line.min()!, min)
            max = Swift.max(line.max()!, max)
        }

        return min ... max
    }

    func map(current: ClosedRange<Double>, target: ClosedRange<Double>) -> [[Double]] {
        var result = self
        for j in result.indices {
            for i in self[j].indices {
                result[i][j] = result[i][j].map(current: current, target: target)
            }
        }

        return result
    }

    func normalized() -> [[Double]] {
        let range = minMax()
        return map(current: range, target: 0 ... 1)
    }
}
