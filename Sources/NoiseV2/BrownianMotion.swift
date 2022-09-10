extension NoiseSource {
    func brownian(
        seed: Seed,
        gain: Output,
        lacunarity: Double,
        octaves: Int,
        weightedStrength: Output
    ) -> some NoiseSource {
        BrownianMotion(
            seed: seed,
            gain: gain,
            lacunarity: lacunarity,
            octaves: octaves,
            weightedStrength: weightedStrength,
            source: self
        )
    }
}

struct BrownianMotion<S: NoiseSource>: FractalType {
    let seed: Seed
    let bounding: Output
    let gain: Output
    let lacunarity: Double
    let octaves: Int
    let weightedStrength: Output
    let source: S

    init(
        seed: Seed,
        gain: Output,
        lacunarity: Double,
        octaves: Int,
        weightedStrength: Output,
        source: S
    ) {
        self.seed = seed
        self.gain = gain
        self.lacunarity = lacunarity
        self.octaves = octaves
        self.weightedStrength = weightedStrength
        self.bounding = Self.bounding(gain: gain, octaves: octaves)
        self.source = source
    }

    func evaluate(_ x: Double) -> Output {
        var seed = seed
        var sum: Output = 1
        var amp = bounding
        var x = x
        for _ in 1 ... octaves {
            seed += 1
            let value = source.evaluate(x)
            sum += value * amp
            amp *= lerp(1, min(value + 1, 2) * 0.5, weightedStrength)
            x *= lacunarity
            amp *= gain
        }

        return sum
    }

    func evaluate(_ x: Double, _ y: Double) -> Output {
        var seed = seed
        var sum: Output = 1
        var amp = bounding
        var x = x
        var y = y
        for _ in 1 ... octaves {
            seed += 1
            let value = source.evaluate(x, y)
            sum += value * amp
            amp *= lerp(1, min(value + 1, 2) * 0.5, weightedStrength)
            x *= lacunarity
            y *= lacunarity
            amp *= gain
        }

        return sum
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        var seed = seed
        var sum: Output = 1
        var amp = bounding
        var x = x
        var y = y
        var z = z
        for _ in 1 ... octaves {
            seed += 1
            let value = source.evaluate(x, y, z)
            sum += value * amp
            amp *= lerp(1, min(value + 1, 2) * 0.5, weightedStrength)
            x *= lacunarity
            y *= lacunarity
            z *= lacunarity
            amp *= gain
        }

        return sum
    }
}

