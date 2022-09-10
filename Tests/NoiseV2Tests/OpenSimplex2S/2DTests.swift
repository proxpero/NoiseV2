@testable import NoiseV2
import XCTest

final class OpenSimplex2S_2D_Tests: XCTestCase {
    let noise = OpenSimplex2S(seed: 3301, variant2D: .classic)

    func assert(value: Double, expectation: Double, file: StaticString = #file, line: UInt = #line) {
        let result = noise.evaluate(0.5, value)
        XCTAssertEqual(result, expectation, accuracy: 1E-10, file: file, line: line)
    }

    func test_positive_values() {
        assert(value: 35.98280336997802, expectation: -0.21916985511779785)
        assert(value: 56.87238745425168, expectation: 0.6978500485420227)
        assert(value: 16.433779956417368, expectation: -0.07597653567790985)
        assert(value: 38.16934163187286, expectation: 0.16735444962978363)
    }

    func test_negative_values() {
        assert(value: -28.030079764222165, expectation: -0.799645185470581)
        assert(value: -79.06171938784037, expectation: 0.43900394439697266)
        assert(value: -94.8182595076705, expectation: 0.33484625816345215)
        assert(value: -26.325385481634157, expectation: -0.3525061011314392)
    }

    func test_integer_values() {
        assert(value: 92, expectation: 0.1900099515914917)
        assert(value: 47, expectation: -0.4192034900188446)
        assert(value: 87, expectation: 0.3660953938961029)
        assert(value: 12, expectation: 0.27647024393081665)
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
