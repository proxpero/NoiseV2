import Benchmark
import NoiseV2

let size2d = 300.0

let openSimplex2SBenchmarks = BenchmarkSuite(name: "Open Simplex 2S", settings: Iterations(1000)) { suite in
    suite.benchmark("Classic") {
        let noise = OpenSimplex2S_2D(seed: 1729, variant: .classic)
        for x in stride(from: -size2d, through: size2d, by: .pi) {
            for y in stride(from: -size2d, through: size2d, by: .pi) {
                _ = noise.evaluate(x, y)
            }
        }
    }

    suite.benchmark("ImproveX") {
        let noise = OpenSimplex2S_2D(seed: 1729, variant: .improveX)
        for x in stride(from: -size2d, through: size2d, by: .pi) {
            for y in stride(from: -size2d, through: size2d, by: .pi) {
                _ = noise.evaluate(x, y)
            }
        }
    }
}
