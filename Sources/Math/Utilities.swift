import Darwin

@inlinable
public func lerp<T: FloatingPoint>(_ a: T, _ b: T, _ t: T) -> T {
    a + t * (b - a)
}

@inlinable
public func map<T: FloatingPoint>(value: T, current: ClosedRange<T>, target: ClosedRange<T>, forceClamp: Bool = false) -> T {
    let result = (value - current.lowerBound) / current.magnitude * target.magnitude + target.lowerBound
    if !forceClamp {
        return result
    }

    return max(min(result, target.upperBound), target.lowerBound)
}

extension FloatingPoint {
    @inlinable
    public func norm(range: ClosedRange<Self>) -> Self {
        max(min((self / range.upperBound), range.upperBound), range.lowerBound)
    }

    @inlinable
    public func lerp(range: ClosedRange<Self>) -> Self {
        self * (range.upperBound - range.lowerBound) + range.lowerBound
    }

    @inlinable
    public func map(current: ClosedRange<Self>, target: ClosedRange<Self>) -> Self {
        (self - current.lowerBound) / current.magnitude * target.magnitude + target.lowerBound
    }
}

extension ClosedRange where Bound: SignedNumeric {
    @inlinable
    public var magnitude: Bound {
        upperBound - lowerBound
    }
}

public func smoothStep(_ t: Double) -> Double {
    t * t * (3 - 2 * t)
}

public func smootherStep(_ t: Double) -> Double {
    t * t * t * (t * (t * 6 - 15) + 10)
}

public func smoothestStep(_ t: Double) -> Double {
    var x = -20 * pow(t, 7)
    x += 70 * pow(t, 6)
    x -= 84 * pow(t, 5)
    x += 35 * pow(t, 4)
    return x
}

public func safeMultiply<T: BinaryFloatingPoint>(_ value: T, _ factor: Int) -> Int {
    Int(value).multipliedReportingOverflow(by: factor).partialValue
}

public func safeMultiply<T: BinaryInteger>(_ value: T, _ factor: Int) -> Int {
    Int(value).multipliedReportingOverflow(by: factor).partialValue
}
