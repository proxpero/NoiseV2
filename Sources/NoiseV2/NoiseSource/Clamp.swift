extension NoiseSource {
    func clamping(to range: ClosedRange<Output>) -> some NoiseSource {
        Clamp(range: range, source: self)
    }
}

private struct Clamp<S: NoiseSource>: NoiseSource {
    let range: ClosedRange<Output>
    let source: S

    func evaluate(_ x: Double) -> Output {
        max(min(source.evaluate(x), range.upperBound), range.lowerBound)
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        max(min(source.evaluate(x, y), range.upperBound), range.lowerBound)
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        max(min(source.evaluate(x, y, z), range.upperBound), range.lowerBound)
    }
}
