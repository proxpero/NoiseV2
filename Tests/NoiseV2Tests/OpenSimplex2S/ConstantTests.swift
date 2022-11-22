import Gypsum
import Math
import SnapshotTesting
import XCTest
@testable import NoiseV2

final class ConstantTests: XCTestCase {
    func testConstantBlack() {
        let noise: NoiseSource = ConstantNoiseSource(value: -1)
        let matrix = noise.matrix2D(width: 200, height: 200)
        XCTAssertEqual(matrix, Matrix2D(width: 200, height: 200, fill: .black))
        assertSnapshot(matching: matrix.image, as: .image, record: true)
    }
}
