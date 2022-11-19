import SnapshotTesting
import XCTest
@testable import NoiseV2

class BrownianMotionTests: XCTestCase {
    func testBrownianMotion1() {
        let noise: NoiseSource = OpenSimplex2S(seed: 3, frequency: 0.004, variant2D: .improveX)
            .brownian(seed: 1, gain: 0.1, lacunarity: 2.0, octaves: 6, weightedStrength: 0.0)
        let matrix = noise.matrix2D(width: 256, height: 256)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image)
    }

    func testBrownianMotion2() {
        let noise: NoiseSource = OpenSimplex2S(seed: 3, frequency: 0.004, variant2D: .improveX)
            .brownian(seed: 1, gain: 0.5, lacunarity: 6.0, octaves: 6, weightedStrength: 0.0)
        let matrix = noise.matrix2D(width: 256, height: 256)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image)
    }

    func testGeneration() {
        let noise: NoiseSource = OpenSimplex2S(seed: 1, frequency: 0.009, variant2D: .improveX)
            .brownian(seed: 1, gain: 0.0, lacunarity: 2.0, octaves: 6, weightedStrength: 0.0)
        let matrix = noise.matrix2D(width: 500, height: 1000)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image, record: true)
    }
}
