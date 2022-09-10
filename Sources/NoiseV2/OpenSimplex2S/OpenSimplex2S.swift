public struct OpenSimplex2S: NoiseSource {
    let seed: Int
    var frequency: Double
    let variant2D: Variant2D
    let variant3D: Variant3D
    let variant4D: Variant4D

    public init(
        seed: Int,
        frequency: Double = 1.0,
        variant2D: Variant2D = .improveX,
        variant3D: Variant3D = .improveXY,
        variant4D: Variant4D = .improveXYZ_XY
    ) {
        self.seed = seed
        self.frequency = frequency
        self.variant2D = variant2D
        self.variant3D = variant3D
        self.variant4D = variant4D
    }
}

extension OpenSimplex2S {
    func evaluate(_ x: Double) -> Output {
        return 0
    }
}
