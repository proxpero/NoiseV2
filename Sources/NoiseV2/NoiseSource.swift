import Foundation

protocol NoiseSource {
    associatedtype Output
    func evaluate(_ x: Double) -> Output
    func evaluate(_ x: Double, _ y: Double) -> Output
    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output
}

extension NoiseSource where Output: FloatingPoint {
    func added<S: NoiseSource>(to other: S) -> some NoiseSource where Output == S.Output {
        AddedNoiseSource(s0: self, s1: other)
    }

    func clamped(to range: ClosedRange<Output>) -> some NoiseSource {
        ClampedNoiseSource(range: range, source: self)
    }

    func inverted() -> some NoiseSource {
        InvertedNoiseSource(source: self)
    }

    func lerping(to range: ClosedRange<Output>) -> some NoiseSource {
        LerpingNoiseSource(range: range, source: self)
    }

    func mapping(current: ClosedRange<Output>, target: ClosedRange<Output>, forceClamp: Bool = false) -> some NoiseSource {
        MappedNoiseSource(
            current: current,
            target: target,
            forceClamp: forceClamp,
            source: self
        )
    }

    func multiplied<S: NoiseSource>(by other: S) -> some NoiseSource where Output == S.Output {
        MultipliedNoiseSource(s0: self, s1: other)
    }

//    func normalizing<S: NoiseSource>
}

struct AddedNoiseSource<S0: NoiseSource, S1: NoiseSource>: NoiseSource where S0.Output == S1.Output, S0.Output: FloatingPoint {
    let s0: S0
    let s1: S1

    func evaluate(_ x: Double) -> S1.Output {
        s0.evaluate(x) + s1.evaluate(x)
    }

    func evaluate(_ x: Double, _ y: Double) -> S1.Output {
        s0.evaluate(x, y) + s1.evaluate(x, y)
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> S1.Output {
        s0.evaluate(x, y, z) + s1.evaluate(x, y, z)
    }
}

struct InvertedNoiseSource<S: NoiseSource>: NoiseSource where S.Output: FloatingPoint {
    let source: S

    func evaluate(_ x: Double) -> S.Output {
        -source.evaluate(x)
    }

    func evaluate(_ x: Double, _ y: Double) -> S.Output {
        -source.evaluate(x, y)
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> S.Output {
        -source.evaluate(x, y, z)
    }
}

struct ClampedNoiseSource<S: NoiseSource>: NoiseSource where S.Output: FloatingPoint {
    let range: ClosedRange<S.Output>
    let source: S

    func evaluate(_ x: Double) -> S.Output {
        max(min(source.evaluate(x), range.upperBound), range.lowerBound)
    }

    func evaluate(_ x: Double, _ y: Double) -> S.Output {
        max(min(source.evaluate(x, y), range.upperBound), range.lowerBound)
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> S.Output {
        max(min(source.evaluate(x, y, z), range.upperBound), range.lowerBound)
    }
}

struct Constant<S: NoiseSource>: NoiseSource where S.Output: FloatingPoint {
    let value: S.Output

    func evaluate(_ x: Double) -> S.Output {
        value
    }

    func evaluate(_ x: Double, _ y: Double) -> S.Output {
        value
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> S.Output {
        value
    }
}

struct LerpingNoiseSource<S: NoiseSource>: NoiseSource where S.Output: FloatingPoint {
    let range: ClosedRange<S.Output>
    let source: S

    private func lerp(value: S.Output) -> S.Output {
        value * (range.upperBound - range.lowerBound) + range.lowerBound
    }

    func evaluate(_ x: Double) -> S.Output {
        lerp(value: source.evaluate(x))
    }

    func evaluate(_ x: Double, _ y: Double) -> S.Output {
        lerp(value: source.evaluate(x, y))
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> S.Output {
        lerp(value: source.evaluate(x, y, z))
    }
}

struct MappedNoiseSource<S: NoiseSource>: NoiseSource where S.Output: FloatingPoint {
    let current: ClosedRange<S.Output>
    let target: ClosedRange<S.Output>
    let forceClamp: Bool
    let source: S

    private func map(value: S.Output) -> S.Output {
        let result = (value - current.lowerBound) / (current.upperBound - current.lowerBound) * (target.upperBound - target.lowerBound) + target.lowerBound
        if !forceClamp {
            return result
        }
        return max(min(result, target.upperBound), target.lowerBound)
    }

    func evaluate(_ x: Double) -> S.Output {
        map(value: source.evaluate(x))
    }

    func evaluate(_ x: Double, _ y: Double) -> S.Output {
        map(value: source.evaluate(x, y))
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> S.Output {
        map(value: source.evaluate(x, y, z))
    }
}

struct MultipliedNoiseSource<S0: NoiseSource, S1: NoiseSource>: NoiseSource where S0.Output == S1.Output, S0.Output: FloatingPoint {
    let s0: S0
    let s1: S1

    func evaluate(_ x: Double) -> S0.Output {
        s0.evaluate(x) * s1.evaluate(x)
    }

    func evaluate(_ x: Double, _ y: Double) -> S0.Output {
        s0.evaluate(x, y) * s1.evaluate(x, y)
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> S0.Output {
        s0.evaluate(x, y, z) * s1.evaluate(x, y, z)
    }
}

struct Simplex: NoiseSource {
    func evaluate(_ x: Double) -> Double {
        return 1.0
    }

    func evaluate(_ x: Double, _ y: Double) -> Double {
        return 1.0
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Double {
        return 1.0
    }
}
