import Math

extension NoiseSource {
    func ridged(
        seed: Seed,
        gain: Output,
        lacunarity: Double,
        octaves: Int,
        weightedStrength: Output
    ) -> some NoiseSource {
        Ridged(
            seed: seed,
            gain: gain,
            lacunarity: lacunarity,
            octaves: octaves,
            weightedStrength: weightedStrength,
            source: self
        )
    }
}

struct Ridged<S: NoiseSource>: FractalType {
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
        var sum: Output = 0.0
        var amp = bounding
        var x = x
        for _ in 1 ... octaves {
            seed += 1
            let value = abs(source.evaluate(x))
            sum += (value * -2 + 1) * amp
            amp *= lerp(1, 1 - value, weightedStrength)
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
            let value = abs(source.evaluate(x, y))
            sum += (value * -2 + 1) * amp
            amp *= lerp(1, 1 - value, weightedStrength)
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
            let value = abs(source.evaluate(x, y, z))
            sum += (value * -2 + 1) * amp
            amp *= lerp(1, 1 - value, weightedStrength)
            x *= lacunarity
            y *= lacunarity
            z *= lacunarity
            amp *= gain
        }

        return sum
    }
}
