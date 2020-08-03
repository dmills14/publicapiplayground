import UIKit

//MARK: Goals
//GET all categories - FETCH
//GET all API's for a specific category - FETCH

let baseURL = URL(string: "https://api.publicapis.org")

struct TopLevelObject: Decodable {
    let count: Int
    let entries: [Entry]
}

struct Entry: Decodable {
    let API: String
    let Description: String
    let Auth: String
    let HTTPS: Bool
    let Cors: String
    let Link: String
    let Category: String
}

//MARK: - Model Controller

class EntryController {
    
    static let baseURL = URL(string: "https://api.publicapis.org")
    static let categoriesEndpoint = "categories"
    static let entriesEndpoint = "entries"
    
    static func fetchAllCategories(completion: @escaping ([String]) -> Void) {
        
        guard let baseURL = baseURL else { return completion([])}
        let categoriesURL = baseURL.appendingPathComponent(categoriesEndpoint)
        print(categoriesURL)
        
        URLSession.shared.dataTask(with: categoriesURL) { (data, _, error) in
            // Check if there was an error
            if let error = error {
                print(error.localizedDescription)
                return completion([])
            }
            //Chec if there is data
            guard let data = data else { return completion([]) }

        // Decode that data
            do {
                let categories = try JSONDecoder().decode([String].self, from: data)
                return completion(categories)
            } catch {
                print(error.localizedDescription)
                return completion([])
            }
        }.resume()  //start the task
    }
        
    static func fetchEntries(for category: String, completion: @escaping ([Entry]) -> Void) {
        // 1. Build the URL
        guard let baseURL = baseURL else { return completion([])}
        let entriesURL = baseURL.appendingPathComponent(entriesEndpoint)
        var components = URLComponents(url: entriesURL, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [URLQueryItem(name: "category", value: category)]
        
        guard let finalURL = components?.url else { return }
        print(finalURL)
        // 2. Fetch the Data
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //Check for error
            if let error = error {
                print(error.localizedDescription)
                return completion([])
            }
            guard let data = data else { return completion([])}
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let entries = topLevelObject.entries
                return completion(entries)
            } catch {
                print(error.localizedDescription)
                return completion([])
            }
            
        }.resume()
        
    }
    
}//end of class
/*
EntryController.fetchAllCategories { (categories) in
    for cat in categories {
        print(cat)
    }
}
*/
EntryController.fetchEntries(for: "news") { (entries) in
    for entry in entries {
        print("""
            - - - - - - - - - - - - - - -
            Name: \(entry.API)
            Desc: \(entry.Description)
            Category: \(entry.Category)
            Link: \(entry.Link)
            Auth: \(entry.Auth)
            Cors: \(entry.Cors)
            https: \(entry.HTTPS)

            """)
    }
}
