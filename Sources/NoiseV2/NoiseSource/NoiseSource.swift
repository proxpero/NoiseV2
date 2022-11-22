import Foundation
import Math

typealias Seed = Int
typealias Output = Double

protocol NoiseSource {
    func evaluate(_ x: Double) -> Output
    func evaluate(_ x: Double, _ y: Double) -> Output
    func evaluate(_ x: Double, _ y: Double, _ z: Double) -> Output
}
