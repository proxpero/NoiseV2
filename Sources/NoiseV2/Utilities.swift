@inlinable
func lerp<T: FloatingPoint>(_ a: T, _ b: T, _ t: T) -> T {
    a + t * (b - a)
}

@inlinable
func map<T: FloatingPoint>(value: T, current: ClosedRange<T>, target: ClosedRange<T>, forceClamp: Bool = false) -> T {
    let result = (value - current.lowerBound) / current.magnitude * target.magnitude + target.lowerBound
    if !forceClamp {
        return result
    }

    return max(min(result, target.upperBound), target.lowerBound)
}

extension FloatingPoint {
    @inlinable
    func norm(range: ClosedRange<Self>) -> Self {
        max(min((self / range.upperBound), range.upperBound), range.lowerBound)
    }

    @inlinable
    func lerp(range: ClosedRange<Self>) -> Self {
        self * (range.upperBound - range.lowerBound) + range.lowerBound
    }

    @inlinable
    func map(current: ClosedRange<Self>, target: ClosedRange<Self>) -> Self {
        (self - current.lowerBound) / current.magnitude * target.magnitude + target.lowerBound
    }
}

extension ClosedRange where Bound: SignedNumeric {
    @inlinable
    var magnitude: Bound {
        upperBound - lowerBound
    }
}
