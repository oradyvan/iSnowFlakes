import Foundation

public struct SnowflakesConfiguration {
    public var snowflakeCount: Int
    public var timerUpdateInterval: TimeInterval

    public init(
        snowflakeCount: Int = 100,
        timerUpdateInterval: TimeInterval = 0.04
    ) {
        self.snowflakeCount = snowflakeCount
        self.timerUpdateInterval = timerUpdateInterval
    }
}
