import Math
import SnapshotTesting
import XCTest
@testable import NoiseV2

final class Custom2DTests: XCTestCase {
    func testHorizontalSigmoid() {
        let width = 400
        let height = 300
        let start = 0.3
        let end = 0.7

        let noise: NoiseSource = Custom2D.horizontalSigmoid(start: start, end: end, width: width)
        let matrix = noise.matrix2D(width: width, height: height)
        
        assertSnapshot(matching: matrix.image, as: .image)
    }

    func testHorizontalSigmoidDouble() {
        let width = 400
        let height = 300
        let start = -1.0
        let r1 = 0.2 ... 0.4
        let middle = 0.0
        let r2 = 0.6 ... 0.8
        let end = 1.0
        let noise: NoiseSource = Custom2D.horizontalSigmoidDouble(start: start, r1: r1, middle: middle, r2: r2, end: end, width: width)
        let matrix = noise.matrix2D(width: width, height: height)

        assertSnapshot(matching: matrix.image, as: .image)
    }

    func testHorizontalSigmoidDoubleMask() {
        let width = 400
        let height = 300

        let br: NoiseSource = OpenSimplex2S(seed: 1729, frequency: 0.01, variant2D: .classic)
            .brownian(seed: 1, gain: 0.5, lacunarity: 2.5, octaves: 4, weightedStrength: 0.0)

        let start = -1.0
        let r1 = 0.2 ... 0.4
        let middle = 0.0
        let r2 = 0.6 ... 0.8
        let end = 1.0
        let sigmoid: NoiseSource = Custom2D.horizontalSigmoidDouble(start: start, r1: r1, middle: middle, r2: r2, end: end, width: width)
            .mapping(current: -1 ... 1, target: -3 ... 3)
        let noise = br.added(to: sigmoid)
            .clamped(to: -1 ... 1)

        assertSnapshot(matching: noise.matrix2D(width: width, height: height).image, as: .image)
    }

    func testCustom2D() {
        let width = 400
        let height = 300

        let a = 0.1
        let b = 0.4
        let c = 0.6
        let d = 0.9

        func evaluate(_ x: Double, _ y: Double) -> Double {
            let position = Double(x) / Double(width)
            if position < a {
                return 0
            }

            else if position < b {
                let t = map(value: position, current: a ... b, target: 0 ... 1)
                let value = smoothestStep(t)
                return value
            }

            else if position < c {
                return 1
            }

            else if position < d {
                let t = map(value: position, current: c ... d, target: 0 ... 1)
                let value = smoothestStep(t)
                return 1 - value
            }

            else {
                return 0
            }
        }

        let noise: NoiseSource = OpenSimplex2S(seed: 3, frequency: 0.004, variant2D: .improveX)
            .custom2D(transform: evaluate(_:_:))
        assertSnapshot(matching: noise.matrix2D(width: width, height: height).image, as: .image)
    }
}
