import Foundation

enum SnowflakeRulerError: LocalizedError {
    case invalidSnowflakeID(Int)

    var errorDescription: String? {
        switch self {
        case .invalidSnowflakeID(let id):
            return "Cannot find snowflake with ID: \(id)"
        }
    }
}
