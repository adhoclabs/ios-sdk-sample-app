import Foundation

extension URLRequest {

    mutating func setBodyContent(_ parameters: [String : String]) {
        httpBody = parameters.map { (key, value) -> String in
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&").data(using: .utf8)
    }
}
