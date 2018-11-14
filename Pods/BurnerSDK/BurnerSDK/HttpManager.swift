import Foundation

public class HttpManager: NSObject {

    static let shared = HttpManager()

    let session = URLSession.shared

    func getAuthToken(code: String, completion: @escaping BurnerCompletionHandler) {
        let url = URL(string: "\(Creds.shared.api)/oauth/access")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setBodyContent([
            "grant_type":    "authorization_code",
            "client_id":     BurnerSDK.shared.clientId!,
            "client_secret": BurnerSDK.shared.clientSecret!,
            "redirect_uri":  "burner://burnertoken",
            "code":          code
            ])
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(request.httpBody?.count ?? 0)", forHTTPHeaderField: "Content-Length")

        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                let json: OAuth = try JSONDecoder.init().decode(OAuth.self, from: data!)
                self.getBurnerNumberFor(json, completion: completion)
                print("HTTP DEBUG: Getting Burner for: \(json)")
            } catch let error {
                print("HTTP ERROR: Can't get OAuth Access Token: \(error)")
                completion(nil, nil, error)
            }
        }
        task.resume()
    }

    func getBurnerNumberFor(_ response: OAuth, completion: @escaping BurnerCompletionHandler) {
        let url = URL(string: "\(Creds.shared.api)/v1/burners")!
        var request = URLRequest(url: url)
        let oauth = response
        request.addValue("Bearer \(response.access_token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                let json = try JSONDecoder().decode([Burner].self, from: data!)
                print("Received JSON response from /burners: \(json)")

                completion(json.first, oauth, error)
            } catch let error {
                print("HTTP ERROR: Can't get Burner list: \(error)")
                completion(nil, oauth, error)
            }
        }
        task.resume()
    }
    
    func getBurnerNumbersFor(_ oauth: OAuth, completion: @escaping BurnersCompletionHandler) {
        let url = URL(string: "\(Creds.shared.api)/v1/burners")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(oauth.access_token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                let json = try JSONDecoder().decode([Burner].self, from: data!)
                print("Received JSON response from /burners: \(json)")
                completion(json, error)
            } catch let error {
                print("HTTP ERROR: Can't get Burner list: \(error)")
                completion(nil, error)
            }
        }
        task.resume()
    }


}


