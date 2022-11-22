extension NoiseSource {
    func inverted() -> some NoiseSource {
        Inversion(source: self)
    }
}

private struct Inversion<S: NoiseSource>: NoiseSource {
    let source: S

    func evaluate(_ x: Double) -> Output {
        -source.evaluate(x)
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        -source.evaluate(x, y)
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        -source.evaluate(x, y, z)
    }
}
