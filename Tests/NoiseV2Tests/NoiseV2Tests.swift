@testable import NoiseV2
import XCTest

final class NoiseTests: XCTestCase {
    let noise = OpenSimplex2S_2D(seed: 3301, variant: .classic)

    func assert(y: Double, expectation: Double, file: StaticString = #file, line: UInt = #line) {
        let result = noise.evaluate(0.5, y)
        XCTAssertEqual(result, expectation, accuracy: 1E-10, file: file, line: line)
    }

    func test_positive_values() {
        assert(y: 35.98280336997802, expectation: -0.21916985511779785)
        assert(y: 56.87238745425168, expectation: 0.6978500485420227)
        assert(y: 16.433779956417368, expectation: -0.07597653567790985)
        assert(y: 38.16934163187286, expectation: 0.16735444962978363)
    }

    func test_negative_values() {
        assert(y: -28.030079764222165, expectation: -0.799645185470581)
        assert(y: -79.06171938784037, expectation: 0.43900394439697266)
        assert(y: -94.8182595076705, expectation: 0.33484625816345215)
        assert(y: -26.325385481634157, expectation: -0.3525061011314392)
    }

    func test_integer_values() {
        assert(y: 92, expectation: 0.1900099515914917)
        assert(y: 47, expectation: -0.4192034900188446)
        assert(y: 87, expectation: 0.3660953938961029)
        assert(y: 12, expectation: 0.27647024393081665)
    }

    func _testFinder() {
        let noise = OpenSimplex2S_2D(seed: 3301, variant: .classic)
        while true {
            let value = Double.random(in: 1 ... 100)
            print(value)
            _ = noise.evaluate(0.5, value)
        }
    }
}

final class Noise3Tests: XCTestCase {
    let noise = OpenSimplex2S_3D(seed: 3301, variant: .classic)

    func assert(value: Double, expectation: Double, file: StaticString = #file, line: UInt = #line) {
        let result = noise.evaluate(value, -value, value * 0.42)
        XCTAssertEqual(result, expectation, accuracy: 1E-10, file: file, line: line)
    }

//    func test_positive_values() {
//        assert(y: 74.16017309771038, expectation: -0.21916985511779785)
//        assert(y: 45.62798690888695, expectation: -0.12388665229082108)
//        assert(y: 67.92125108871845, expectation: 0.5371147394180298)
//        assert(value: -96.03960616411842, expectation: -0.2247042953968048)
//        assert(value: -22.15408229182229, expectation: 0.20941361784934998)
//        assert(value: -49.211713822254, expectation: 0.3087639808654785)
//    }

    func testFinder() {
        let noise = OpenSimplex2S_3D(seed: 3301, variant: .classic)
        while true {
            let value = Double.random(in: -100 ... 100)
            print(value, -value, value * 0.42)
            _ = noise.evaluate(value, -value, value * 0.42)
        }
    }
}
