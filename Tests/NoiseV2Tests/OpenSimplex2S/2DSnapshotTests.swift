import Gypsum
import SnapshotTesting
import XCTest
@testable import NoiseV2

final class OpenSimplex2STests: XCTestCase {
    var noise: OpenSimplex2S!
    let width = 256
    let height = 512

    override func setUp() {
        super.setUp()
        self.noise = .init(seed: 1729, variant2D: .improveX)
    }

    override func tearDown() {
        super.tearDown()
        self.noise = nil
    }

    func testMatrix2() {
        noise.frequency = 0.007
        let matrix = noise.matrix2D(width: width, height: height)
        assertSnapshot(matching: matrix.image, as: .image, record: true)
    }

    func testAdding() {
        noise.frequency = 0.005
        let other: NoiseSource = OpenSimplex2S(seed: 123)
            .brownian(seed: 1337, gain: 0.0, lacunarity: 2.0, octaves: 6, weightedStrength: 0.0)
        let sum = noise
            .added(to: other)
            .mapping(current: -2 ... 2, target: -1 ... 1)
        let matrix = sum.matrix2D(width: width, height: height)
        assertSnapshot(matching: matrix.image, as: .image, record: true)
    }
}
