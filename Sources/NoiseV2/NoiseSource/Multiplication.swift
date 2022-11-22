extension NoiseSource {
    func multiplying<S: NoiseSource>(by other: S) -> some NoiseSource {
        Multiplication(s0: self, s1: other)
    }
}

private struct Multiplication<S0: NoiseSource, S1: NoiseSource>: NoiseSource {
    let s0: S0
    let s1: S1

    func evaluate(_ x: Double) -> Output {
        s0.evaluate(x) * s1.evaluate(x)
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        s0.evaluate(x, y) * s1.evaluate(x, y)
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        s0.evaluate(x, y, z) * s1.evaluate(x, y, z)
    }
}
