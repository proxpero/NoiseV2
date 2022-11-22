import Gypsum
import XCTest
@testable import NoiseV2

final class OpenSimplex2S_3D_Tests: XCTestCase {
    let noise = OpenSimplex2S(seed: 3301, variant3D: .classic)

    func testValues() {
        assert(value: -40.10296170490728, expectation: -0.2860904050772242)
        assert(value: 54.06423169761942, expectation: 0.0465919813487467)
        assert(value: 84.54465264447907, expectation: -0.11967957279095182)
        assert(value: -60.59420508956768, expectation: 0.07005863712208582)
        assert(value: -94.01020528870848, expectation: -0.027022796869847838)
        assert(value: 38.332092573108895, expectation: 0.20273126067245809)
        assert(value: -5.006735942532994, expectation: -0.6457371912090442)
        assert(value: 1.9261641977405697, expectation: -0.005666276596107776)
    }

    func assert(value: Double, expectation: Double, file: StaticString = #file, line: UInt = #line) {
        let result = noise.evaluate(value, -value, value * .pi)
        XCTAssertEqual(result, expectation, accuracy: 1E-10, file: file, line: line)
    }

    func testExpectedRange() {
        let expectedRange: ClosedRange<Double> = -1 ... 1
        for _ in 1 ... 1_000_000 {
            let x: Double = .random(in: -1000 ... 1000)
            let y: Double = .random(in: -1000 ... 1000)
            let z: Double = .random(in: -1000 ... 1000)
            let value = noise.evaluate(x, y, z)
            XCTAssertTrue(expectedRange.contains(value), "Out of bounds: value \(value) for x: \(x), y: \(y), z: \(z)")
        }
    }

    func _test_find_values() {
        while true {
            let candidate = Double.random(in: 0 ... 10)
            print(candidate, -candidate, candidate * .pi)
            _ = noise.evaluate(candidate, -candidate, candidate * .pi)
        }
    }

    func testMatrix3D_1() {
        let noise = OpenSimplex2S(seed: 1279, frequency: 0.007)
        let size = 256
        let matrix = noise.matrix3D(width: size, height: size, depth: size)
        matrix.animated(frameRate: 60, filepath: "/Users/proxpero/Images/Animations/test4.gif")
    }

    func testMatrix3D_2() {
        let noise = OpenSimplex2S(seed: 1279, frequency: 0.007)
        let matrix = noise.matrix3D(width: 200, height: 100, depth: 200)
        matrix.animated(frameRate: 60, filepath: "/Users/proxpero/Images/Animations/\(#function).gif")
    }
}
