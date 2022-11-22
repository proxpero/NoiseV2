extension NoiseSource {
    func masked<S: NoiseSource>(by other: S) -> some NoiseSource {
        Mask(s0: self, s1: other)
    }
}

private struct Mask<S0: NoiseSource, S1: NoiseSource>: NoiseSource {
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
