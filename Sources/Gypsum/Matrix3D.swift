import AppKit
import Math

public struct Matrix3D {
    let store: [[[Pixel]]]
}

public extension Matrix3D {
    init<T: FloatingPoint>(
        width: Int,
        height: Int,
        depth: Int,
        evaluate: (T, T, T) -> Pixel
    ) {
        var result: [[[Pixel]]] = []
        for z in 0 ..< depth {
            var plane: [[Pixel]] = []
            for y in 0 ..< height {
                var line: [Pixel] = []
                for x in 0 ..< width {
                    let value = evaluate(T(x), T(y), T(z))
                    line.append(value)
                }
                plane.append(line)
            }
            result.append(plane)
        }

        self.store = result
    }

    init(
        width: Int,
        height: Int,
        depth: Int,
        evaluate: (Double, Double, Double) -> Double
    ) {
        self = .init(width: width, height: height, depth: depth) {
            Pixel(monochrome: evaluate($0, $1, $2))
        }
    }

    static func monochrome(
        width: Int,
        height: Int,
        depth: Int,
        evaluate: (Double, Double, Double) -> Double
    ) -> Self {
        .init(width: width, height: height, depth: depth) {
            Pixel(monochrome: evaluate($0, $1, $2))
        }
    }

    func images() -> [CGImage] {
        store.map(CGImage.image)
    }

    func animated(frameRate: Double = 60, loop: Bool = true, filepath: String) {
        guard let imageDestination = CGImageDestinationCreateWithURL(
            URL(fileURLWithPath: filepath) as CFURL,
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

        self.store.map(CGImage.image).forEach {
            CGImageDestinationAddImage(imageDestination, $0, frameProperties)
        }

        guard CGImageDestinationFinalize(imageDestination) else {
            fatalError()
        }
    }
}

//public func animate(matrix: Matrix3D, frameRate: Double, loop: Bool, filepath: String) {
//    guard let imageDestination = CGImageDestinationCreateWithURL(
//        URL(fileURLWithPath: filepath) as CFURL,
//        kUTTypeGIF, 0, nil
//    ) else {
//        fatalError()
//    }
//
//    let gifProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFLoopCount as String: loop ? 0 : 1
//        ]
//    ]
//
//    CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)
//    let frameProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFDelayTime as String: 1 / frameRate
//        ]
//    ] as CFDictionary
//
//    matrix.images().forEach {
//        CGImageDestinationAddImage(imageDestination, $0, frameProperties)
//    }
//
//    guard CGImageDestinationFinalize(imageDestination) else {
//        fatalError()
//    }
//}

//public func animate(matrix: [[[Double]]], frameRate: Double, loop: Bool, path: String) {
//    guard let imageDestination = CGImageDestinationCreateWithURL(
//        URL(fileURLWithPath: path) as CFURL,
//        kUTTypeGIF, 0, nil
//    ) else {
//        fatalError()
//    }
//
//    let gifProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFLoopCount as String: loop ? 0 : 1
//        ]
//    ]
//    CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)
//    let frameProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFDelayTime as String: 1 / frameRate
//        ]
//    ] as CFDictionary
//
//    for plane in matrix {
////        let pixels = pl
//        CGImageDestinationAddImage(imageDestination, .image(from: plane), frameProperties)
//    }
//
//    guard CGImageDestinationFinalize(imageDestination) else {
//        fatalError()
//    }
//}

//func animate(images: [CGImage], frameRate: Double, isLoop: Bool, path: String) {
//    guard let imageDestination = CGImageDestinationCreateWithURL(
//        URL(fileURLWithPath: path) as CFURL,
//        kUTTypeGIF, 0, nil
//    ) else {
//        fatalError()
//    }
//
//    let loopCount = isLoop ? 0 : 1
//    let gifProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFLoopCount as String: loopCount
//        ]
//    ]
//
//    CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)
//
//    let frameProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFDelayTime as String: 1 / frameRate
//        ]
//    ]
//
//    for image in images {
//        CGImageDestinationAddImage(imageDestination, image, frameProperties as CFDictionary)
//    }
//
//    guard CGImageDestinationFinalize(imageDestination) else {
//        fatalError()
//    }
//}

//public func animate(images: [NSImage], frameRate: Double, isLoop: Bool, path: String) throws {
//    guard let imageDestination = CGImageDestinationCreateWithURL(
//        URL(fileURLWithPath: path) as CFURL,
//        kUTTypeGIF, 0, nil
//    ) else {
//        fatalError()
//    }
//
//    let loopCount = isLoop ? 0 : 1
//    let gifProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFLoopCount as String:loopCount
//        ]
//    ]
//
//    CGImageDestinationSetProperties(imageDestination, gifProperties as CFDictionary)
//
//    let frameProperties = [
//        kCGImagePropertyGIFDictionary as String: [
//            kCGImagePropertyGIFDelayTime as String: 1 / frameRate
//        ]
//    ]
//
//    for image in images {
//        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
//            fatalError()
//        }
//
//        CGImageDestinationAddImage(imageDestination, cgImage, frameProperties as CFDictionary)
//    }
//
//    guard CGImageDestinationFinalize(imageDestination) else {
//        fatalError()
//    }
//}
