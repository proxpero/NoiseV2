import SnapshotTesting
import XCTest
@testable import NoiseV2

class PingPongTests: XCTestCase {
    func testPingPong() {
        let noise: NoiseSource = OpenSimplex2S(seed: 3, frequency: 0.04, variant2D: .improveX)
            .pingPong(
                seed: 1,
                gain: 0.1,
                lacunarity: 2.0,
                octaves: 6,
                strength: 4.0,
                weightedStrength: 0.0
            )
        let matrix = noise.matrix2D(width: 256, height: 256)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image)
    }

    func testPingPong2() {
        let noise: NoiseSource = OpenSimplex2S(seed: 3, frequency: 0.01, variant2D: .improveX)
            .pingPong(
                seed: 1,
                gain: 0.1,
                lacunarity: 5.0,
                octaves: 6,
                strength: 2.0,
                weightedStrength: 0.0
            )
        let matrix = noise.matrix2D(width: 256, height: 256)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image)
    }
}
