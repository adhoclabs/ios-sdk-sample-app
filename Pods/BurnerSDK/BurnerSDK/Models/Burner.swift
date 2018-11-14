import Foundation

public struct Burner: Decodable {
    public let autoReplyActive: Int
    public let autoReplyText: String
    public let callerIdEnabled: Bool
    public let dateCreated: Int
    public let expires: Int
    public let hexColor: Int
    public let id: String
    public let name: String
    public let notifications: Bool
    public let phoneNumber: String
    public let remainingMinutes: Int
    public let remainingTexts: Int
    public let ringer: Bool
    public let sip: Bool
    public let totalMinutes: Int
    public let totalTexts: Int
}
