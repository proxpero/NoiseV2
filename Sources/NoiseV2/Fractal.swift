protocol FractalType: NoiseSource {
    var seed: Seed { get }
    var bounding: Output { get }
    var gain: Output { get }
    var lacunarity: Double { get }
    var octaves: Int { get }
    var weightedStrength: Output { get }
}

extension FractalType {
    static func bounding(gain: Output, octaves: Int) -> Output {
        let gain = abs(gain)
        var amp = gain
        var ampf = Output(1.0)
        for _ in 1 ..< octaves {
            ampf += amp
            amp *= gain
        }

        return 1 / ampf
    }
}
