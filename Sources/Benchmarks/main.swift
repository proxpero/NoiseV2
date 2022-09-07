import Benchmark
import NoiseV2

benchmark("Open Simplex2S 3d classic") {
    let noise = OpenSimplex2S_3D(
        seed: 1729,
        variant: .classic
    )

    for x in stride(from: 0, to: 100, by: .pi / 3) {
        for y in stride(from: 0, to: 100, by: .pi / 3) {
            for z in stride(from: 0, to: 100, by: .pi / 3) {
                _ = noise.evaluate(x, y, z)
            }
        }
    }
}

benchmark("Open Simplex2S 3d improve xy") {
    let noise = OpenSimplex2S_3D(
        seed: 1729,
        variant: .improveXY
    )

    for x in stride(from: 0, to: 100, by: .pi / 3) {
        for y in stride(from: 0, to: 100, by: .pi / 3) {
            for z in stride(from: 0, to: 100, by: .pi / 3) {
                _ = noise.evaluate(x, y, z)
            }
        }
    }
}

let suites = [
    openSimplex2SBenchmarks
]

Benchmark.main(suites)
