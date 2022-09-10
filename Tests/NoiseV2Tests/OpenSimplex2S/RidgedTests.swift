import SnapshotTesting
import XCTest
@testable import NoiseV2

class RidgedTests: XCTestCase {
    func testRidged() {
        let noise: NoiseSource = OpenSimplex2S(seed: 3, frequency: 0.004, variant2D: .improveX)
            .ridged(seed: 1, gain: 0.1, lacunarity: 2.0, octaves: 6, weightedStrength: 0.0)
        let matrix = noise.matrix2D(width: 256, height: 256)
        let image: NSImage = .image(from: matrix)
        assertSnapshot(matching: image, as: .image)
    }
}
