import Foundation

public protocol DataAPIPortalRecord: Decodable {
    var recordId: String { get }
    var modId: String { get }
}

public protocol LayoutKey {
    var rawValue: String { get }
    var layoutName: String { get }
}

public protocol QueryParameter {
    var queryParameters: [URLQueryItem] { get }
}

