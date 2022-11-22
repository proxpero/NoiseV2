extension Double {
    static let root3over3 = 0.577350269189626
    static let root2over2 = 0.7071067811865476
    static let skew2D = 0.366025403784439
    static let unskew2D = -0.21132486540518713
    static let rotate3Orthagonalizer = -0.21132486540518713
    static let fallbackRotate3 = 2.0 / 3.0
    static let rSquared2D = 2.0 / 3.0
    static let rSquared3D = 3.0 / 4.0
    static let rSquared4D = 4.0 / 5.0
    static let skew4D = 0.309016994374947
    static let unskew4D = -0.138196601125011
    static let normalizer2D = 0.05481866495625118
    static let normalizer3D = 0.2781926117527186
    static let normalizer4D = 0.11127401889945551
}

extension Int {
    static let primeX = 0x5205402B9270C86F
    static let primeY = 0x598CD327003817B5
    static let primeZ = 0x5BCC226E9FA0BACB
    static let primeW = 0x56CC5227E58F554B
    static let hashMultiplier = 0x53A3F72DEEC546F5
    static let seedFlip3D = 0x52D547B2E96ED629
    static let nGrads2DExponent = 7
    static let nGrads3DExponent = 8
    static let nGrads4DExponent = 9
    static let nGrads2D = 1 << nGrads2DExponent
    static let nGrads3D = 1 << nGrads3DExponent
    static let nGrads4D = 1 << nGrads4DExponent
}

