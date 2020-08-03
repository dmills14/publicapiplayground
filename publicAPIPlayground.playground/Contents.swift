import UIKit

//Mark: Goals
//GET all categories - FETCH
//GET all API's for a specific category - FETCH

let baseURL = URL(string: "https://api.publicapis.org")

struct TopLevelObject {
    let count: Int
    let entries: [Entry]
}

struct Entry {
    let API: String
    let Description: String
    let Auth: String
    let HTTPS: Bool
    let Cors: String
    let Link: String
    let Category: String
}
