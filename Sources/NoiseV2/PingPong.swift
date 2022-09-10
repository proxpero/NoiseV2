extension NoiseSource {
    func pingPong(
        seed: Seed,
        gain: Output,
        lacunarity: Double,
        octaves: Int,
        strength: Output,
        weightedStrength: Output
    ) -> some NoiseSource {
        PingPong(
            seed: seed,
            gain: gain,
            lacunarity: lacunarity,
            octaves: octaves,
            strength: strength,
            weightedStrength: weightedStrength,
            source: self
        )
    }
}

struct PingPong<S: NoiseSource>: FractalType {
    let seed: Seed
    let bounding: Output
    let gain: Output
    let lacunarity: Double
    let octaves: Int
    let strength: Output
    let weightedStrength: Output
    let source: S

    init(
        seed: Seed,
        gain: Output,
        lacunarity: Double,
        octaves: Int,
        strength: Output,
        weightedStrength: Output,
        source: S
    ) {
        self.seed = seed
        self.gain = gain
        self.lacunarity = lacunarity
        self.octaves = octaves
        self.weightedStrength = weightedStrength
        self.strength = strength
        self.bounding = Self.bounding(gain: gain, octaves: octaves)
        self.source = source
    }

    func evaluate(_ x: Double) -> Output {
        var seed = seed
        var sum: Output = 0.0
        var amp = bounding
        var x = x
        for _ in 1 ... octaves {
            seed += 1
            var value = source.evaluate(x) + 1
            value = pingPong(value * strength)
            sum += (value - 0.5) * 2 * amp
            amp *= lerp(1, value, weightedStrength)
            x *= lacunarity
            amp *= gain
        }

        return sum
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        var seed = seed
        var sum: Output = 0.0
        var amp = bounding
        var x = x
        var y = y
        for _ in 1 ... octaves {
            seed += 1
            var value = source.evaluate(x, y) + 1
            value = pingPong(value * strength)
            sum += (value - 0.5) * 2 * amp
            amp *= lerp(1, value, weightedStrength)
            x *= lacunarity
            y *= lacunarity
            amp *= gain
        }

        return sum
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        var seed = seed
        var sum: Output = 0.0
        var amp = bounding
        var x = x
        var y = y
        var z = z
        for _ in 1 ... octaves {
            seed += 1
            var value = source.evaluate(x, y) + 1
            value = pingPong(value * strength)
            sum += (value - 0.5) * 2 * amp
            amp *= lerp(1, value, weightedStrength)
            x *= lacunarity
            y *= lacunarity
            z *= lacunarity
            amp *= gain
        }

        return sum
    }

    @inlinable
    func pingPong(_ t: Double) -> Double {
        let t = t - Double(Int(t * 0.5) * 2)
        return t < 1 ? t : 2 - t
    }
}
