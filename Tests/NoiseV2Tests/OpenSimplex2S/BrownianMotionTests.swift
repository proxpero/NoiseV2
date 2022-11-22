import Gypsum
import SnapshotTesting
import XCTest
@testable import NoiseV2

class BrownianMotionTests: XCTestCase {
    func testBrownianMotion1() {
        let noise: NoiseSource = OpenSimplex2S(seed: 1729, frequency: 0.01, variant2D: .classic)
            .brownian(seed: 1, gain: 0.5, lacunarity: 2.5, octaves: 4, weightedStrength: 0.0)
        let matrix: Matrix2D = .monochrome(width: 256, height: 256, evaluate: noise.evaluate(_:_:))
        assertSnapshot(matching: matrix.image, as: .image)
    }

    func testBrownianMotion2() {
        let noise: NoiseSource = OpenSimplex2S(seed: 1729, frequency: 0.01, variant2D: .classic)
            .brownian(seed: 1, gain: 0.5, lacunarity: 2.0, octaves: 4, weightedStrength: 0.0)
        let matrix: Matrix2D = .monochrome(width: 256, height: 256, evaluate: noise.evaluate(_:_:))
        assertSnapshot(matching: matrix.image, as: .image)
    }

    func testGeneration() {
        let noise: NoiseSource = OpenSimplex2S(seed: 1, frequency: 0.009, variant2D: .improveX)
            .brownian(seed: 1, gain: 0.0, lacunarity: 2.0, octaves: 6, weightedStrength: 0.0)
        let matrix: Matrix2D = .monochrome(width: 500, height: 1000, evaluate: noise.evaluate(_:_:))
        assertSnapshot(matching: matrix.image, as: .image)
    }
}
