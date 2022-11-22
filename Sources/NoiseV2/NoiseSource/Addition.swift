extension NoiseSource {
    func adding<S: NoiseSource>(to other: S, weight: Double = 0.5) -> some NoiseSource {
        Addition(s0: self, s1: other, weight: weight)
    }
}

private struct Addition<S0: NoiseSource, S1: NoiseSource>: NoiseSource {
    let s0: S0
    let s1: S1
    let weight: Double

    func evaluate(_ x: Double) -> Output {
        (s0.evaluate(x) * (1.0 - weight)) + (s1.evaluate(x) * weight)
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        s0.evaluate(x, y) * (1.0 - weight) + s1.evaluate(x, y) * weight
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        s0.evaluate(x, y, z) + s1.evaluate(x, y, z)
    }
}
