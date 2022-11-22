extension NoiseSource {
    func lerping(to range: ClosedRange<Output>) -> some NoiseSource {
        Lerp(range: range, source: self)
    }
}

private struct Lerp<S: NoiseSource>: NoiseSource {
    let range: ClosedRange<Output>
    let source: S

    private func lerp(value: Output) -> Output {
        value * (range.upperBound - range.lowerBound) + range.lowerBound
    }

    func evaluate(_ x: Double) -> Output {
        lerp(value: source.evaluate(x))
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        lerp(value: source.evaluate(x, y))
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        lerp(value: source.evaluate(x, y, z))
    }
}
