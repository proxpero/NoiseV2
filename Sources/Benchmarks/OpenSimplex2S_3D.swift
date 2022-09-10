import Benchmark
import NoiseV2

let size3d = 100.0

let openSimplex2S_3D = BenchmarkSuite(
    name: "Open Simplex 2S 3D",
    settings: Iterations(100)
) { suite in
    suite.benchmark("Classic") {
        let noise = OpenSimplex2S(
            seed: 1729,
            variant3D: .classic
        )

        for x in stride(from: 0, to: 100, by: .pi / 3) {
            for y in stride(from: 0, to: 100, by: .pi / 3) {
                for z in stride(from: 0, to: 100, by: .pi / 3) {
                    _ = noise.evaluate(x, y, z)
                }
            }
        }
    }

    suite.benchmark("ImproveXY") {
        let noise = OpenSimplex2S(
            seed: 1729,
            variant3D: .improveXY
        )

        for x in stride(from: 0, to: 100, by: .pi / 3) {
            for y in stride(from: 0, to: 100, by: .pi / 3) {
                for z in stride(from: 0, to: 100, by: .pi / 3) {
                    _ = noise.evaluate(x, y, z)
                }
            }
        }
    }
}
