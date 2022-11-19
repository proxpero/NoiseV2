public struct Pixel: Equatable {
    public let red: UInt8
    public let green: UInt8
    public let blue: UInt8
    public let alpha: UInt8 = UInt8.max

    public var values: [UInt8] {
        [red, green, blue, alpha]
    }

    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
