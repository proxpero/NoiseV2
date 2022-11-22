@testable import NoiseV2
import XCTest

final class OpenSimplex2S_2D_Tests: XCTestCase {
    let noise = OpenSimplex2S(seed: 3301, variant2D: .classic)

    func assert(value: Double, expectation: Double, file: StaticString = #file, line: UInt = #line) {
        let result = noise.evaluate(0.5, value)
        XCTAssertEqual(result, expectation, accuracy: 1E-10, file: file, line: line)
    }

    func test_positive_values() {
        assert(value: 35.98280336997802, expectation: -0.21916977831988227)
        assert(value: 56.87238745425168, expectation: 0.6978495993136121)
        assert(value: 16.433779956417368, expectation: -0.07597649695327024)
        assert(value: 38.16934163187286, expectation: 0.16735417486094356)
    }

    func test_negative_values() {
        assert(value: -28.030079764222165, expectation: -0.7996448523437348)
        assert(value: -79.06171938784037, expectation: 0.43900391622471724)
        assert(value: -94.8182595076705, expectation: 0.33484571807050795)
        assert(value: -26.325385481634157, expectation: -0.3525059942412214)
    }

    func test_integer_values() {
        assert(value: 92, expectation: 0.19000977073906888)
        assert(value: 47, expectation: -0.4192033726481913)
        assert(value: 87, expectation: 0.3660954426062507)
        assert(value: 12, expectation: 0.27647023414264094)
    }

    func testExpectedRange() {
        let expectedRange: ClosedRange<Double> = -1 ... 1
        for _ in 1 ... 1_000_000 {
            let x: Double = .random(in: -1000 ... 1000)
            let y: Double = .random(in: -1000 ... 1000)
            let value = noise.evaluate(x, y)
            XCTAssertTrue(expectedRange.contains(value), "Out of bounds: value \(value) for x: \(x), y: \(y)")
        }
    }

    func _test_find_values() {
        let noise = OpenSimplex2S(seed: 3301, variant2D: .classic)
        while true {
            let value = Double.random(in: 1 ... 100)
            print(value)
            _ = noise.evaluate(0.5, value)
        }
    }
}
