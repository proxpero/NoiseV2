import NoiseV2

@main
enum CLI {
    static func main() async throws {
        print(2590817245141883476)
        let xsbp = 44268
        let primeX = 0x5205402B9270C86F
        let result = xsbp.multipliedReportingOverflow(by: primeX)
//        let result = primeX / 2590817245141883476
        print(result)
    }
}
