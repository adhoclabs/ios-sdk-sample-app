import Foundation

public struct OAuth: Decodable {
    public let access_token: String
    public let connected_burners: [ConnectedBurners]
    public let expires_in: Int
    public let scope: String
    public let token_type: String
}
