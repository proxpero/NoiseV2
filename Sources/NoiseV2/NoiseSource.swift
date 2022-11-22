import Foundation
import Gypsum
import Math

typealias Seed = Int
typealias Output = Double

protocol NoiseSource {
    func evaluate(_ x: Double) -> Output
    func evaluate(_ x: Double, _ y: Double) -> Output
    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output
}

extension NoiseSource {
    func added<S: NoiseSource>(to other: S, weight: Double = 0.5) -> some NoiseSource {
        AddedNoiseSource(s0: self, s1: other, weight: weight)
    }

    func masked<S: NoiseSource>(by other: S) -> some NoiseSource {
        MaskedNoiseSource(s0: self, s1: other)
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

    func mapping(
        current: ClosedRange<Output>,
        target: ClosedRange<Output>,
        forceClamp: Bool = false
    ) -> some NoiseSource {
        MappedNoiseSource(
            current: current,
            target: target,
            forceClamp: forceClamp,
            source: self
        )
    }

    func multiplied<S: NoiseSource>(by other: S) -> some NoiseSource {
        MultipliedNoiseSource(s0: self, s1: other)
    }
}

struct AddedNoiseSource<S0: NoiseSource, S1: NoiseSource>: NoiseSource {
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

struct MaskedNoiseSource<S0: NoiseSource, S1: NoiseSource>: NoiseSource {
    let s0: S0
    let s1: S1

    func evaluate(_ x: Double) -> Output {
        let v2 = s1.evaluate(x)
        if v2 == -1 {
            return -1
        } else if v2 == 1 {
            return 1
        }

        let v1 = s0.evaluate(x)
        return (v1 + v2).map(current: -2 ... 2, target: -1 ... 1)
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        let v2 = s1.evaluate(x, y)
        if v2 == -1 {
            return -1
        } else if v2 == 1 {
            return 1
        }

        let v1 = s0.evaluate(x, y)
        return v1 + v2
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        let v2 = s1.evaluate(x, y, z)
        if v2 == -1 {
            return -1
        } else if v2 == 1 {
            return 1
        }

        let v1 = s0.evaluate(x, y, z)
        return v1 + v2
    }
}

struct InvertedNoiseSource<S: NoiseSource>: NoiseSource {
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

struct ClampedNoiseSource<S: NoiseSource>: NoiseSource {
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

struct ConstantNoiseSource: NoiseSource {
    let value: Output

    func evaluate(_ x: Double) -> Output {
        value
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        value
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        value
    }
}

struct LerpingNoiseSource<S: NoiseSource>: NoiseSource {
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

struct MappedNoiseSource<S: NoiseSource>: NoiseSource {
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

struct MultipliedNoiseSource<S0: NoiseSource, S1: NoiseSource>: NoiseSource {
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
