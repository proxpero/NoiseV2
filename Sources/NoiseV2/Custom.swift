import Math

extension NoiseSource {
    func custom2D(
        transform: @escaping (Double, Double) -> Output
    ) -> some NoiseSource {
        Custom2D(transform: transform)
    }
}

struct Custom2D: NoiseSource {
    let transform: (Double, Double) -> Output

    func evaluate(_ x: Double, _ y: Double) -> Output {
        transform(x, y)
    }

    func evaluate(_ x: Double) -> Output {
        fatalError()
    }

    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output {
        fatalError()
    }
}

extension Custom2D {
    static func horizontalSigmoid(
        start: Double,
        end: Double,
        width: Int
    ) -> Self {
        func evaluate(_ x: Double, _ y: Double) -> Double {
            let position = Double(x) / Double(width)
            if position < start {
                return -1
            }

            else if position >= end {
                return 1
            }

            else {
                let t = map(value: position, current: start ... end, target: 0 ... 1)
                let value = smoothestStep(t).map(current: 0 ... 1, target: -1 ... 1)
                return value
            }
        }

        return Custom2D(transform: evaluate(_:_:))
    }

    static func horizontalSigmoidDouble(
        start: Double,
        r1: ClosedRange<Double>,
        middle: Double,
        r2: ClosedRange<Double>,
        end: Double,
        width: Int
    ) -> Self {
        func evaluate(_ x: Double, _ y: Double) -> Double {
            let position = Double(x) / Double(width)
            if position < r1.lowerBound {
                return start
            } else if r1.contains(position) {
                let t = map(value: position, current: r1, target: 0 ... 1)
                let value = smoothestStep(t).map(current: 0 ... 1, target: start ... middle)
                return value
            } else if r2.contains(position) {
                let t = map(value: position, current: r2, target: 0 ... 1)
                let value = smoothestStep(t).map(current: 0 ... 1, target: middle ... end)
                return value
            } else if position > r1.upperBound, position < r2.lowerBound {
                return middle
            } else {
                return end
            }
        }

        return Custom2D(transform: evaluate(_:_:))
    }
}
