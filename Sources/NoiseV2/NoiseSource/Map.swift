extension NoiseSource {
    func map(
        current: ClosedRange<Output>,
        target: ClosedRange<Output>,
        forceClamp: Bool = false
    ) -> some NoiseSource {
        Map(
            current: current,
            target: target,
            forceClamp: forceClamp,
            source: self
        )
    }
}

private struct Map<S: NoiseSource>: NoiseSource {
    let current: ClosedRange<Output>
    let target: ClosedRange<Output>
    let forceClamp: Bool
    let source: S

    private func map(value: Output) -> Output {
        let result = (value - current.lowerBound) / (current.upperBound - current.lowerBound) * (target.upperBound - target.lowerBound) + target.lowerBound
        if !forceClamp {
            return result
        }
        return max(min(result, target.upperBound), target.lowerBound)
    }

    func evaluate(_ x: Double) -> Output {
        map(value: source.evaluate(x))
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        map(value: source.evaluate(x, y))
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        map(value: source.evaluate(x, y, z))
    }
}
