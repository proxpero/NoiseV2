//extension NoiseSource {
//    static func constant(_ value: Double) -> some NoiseSource {
//        Constant(value: value)
//    }
//}

struct Constant: NoiseSource {
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
