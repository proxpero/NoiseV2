import Benchmark
import NoiseV2

let size2d = 300.0

let openSimplex2S_2D = BenchmarkSuite(
    name: "Open Simplex 2S 2D",
    settings: Iterations(1000)
) { suite in
    suite.benchmark("Classic") {
        let noise = OpenSimplex2S(seed: 1729, variant2D: .classic)
        for x in stride(from: -size2d, through: size2d, by: .pi) {
            for y in stride(from: -size2d, through: size2d, by: .pi) {
                _ = noise.evaluate(x, y)
            }
        }
    }

    suite.benchmark("ImproveX") {
        let noise = OpenSimplex2S(
            seed: 1729,
            variant2D: .improveX
        )
        for x in stride(from: -size2d, through: size2d, by: .pi) {
            for y in stride(from: -size2d, through: size2d, by: .pi) {
                _ = noise.evaluate(x, y)
            }
        }
    }
}
