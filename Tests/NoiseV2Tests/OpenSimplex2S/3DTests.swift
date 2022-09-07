@testable import NoiseV2
import XCTest

final class OpenSimplex2S_3D_Tests: XCTestCase {
    let noise = OpenSimplex2S_3D(seed: 3301, variant: .classic)

    func testValues() {
        assert(value: -40.10296170490728, expectation: -0.28609031438827515)
        assert(value: 54.06423169761942, expectation: 0.04659201577305794)
        assert(value: 84.54465264447907, expectation: -0.1196795254945755)
        assert(value: -60.59420508956768, expectation: 0.07005861401557922)
        assert(value: -94.01020528870848, expectation: -0.02702281065285206)
        assert(value: 38.332092573108895, expectation: 0.20273122191429138)
        assert(value: -5.006735942532994, expectation: -0.6457372307777405)
        assert(value: 1.9261641977405697, expectation: -0.005666222423315048)
    }

    func assert(value: Double, expectation: Double, file: StaticString = #file, line: UInt = #line) {
        let result = noise.evaluate(value, -value, value * .pi)
        XCTAssertEqual(result, expectation, accuracy: 1E-10, file: file, line: line)
    }

    func test_find_values() {
        while true {
            let candidate = Double.random(in: 0 ... 10)
            print(candidate, -candidate, candidate * .pi)
            _ = noise.evaluate(candidate, -candidate, candidate * .pi)
        }
    }
}
