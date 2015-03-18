import Foundation

struct AppLink {
    let targetURL: String
    let userAgent: String?
    let extras: [String: String]?
    
    init?(targetURL: String?, userAgent: String?, extras: [String: String]?) {
        if let targetURL = targetURL {
            self.targetURL = targetURL
        } else {
            return nil
        }
        self.userAgent = userAgent
        self.extras = extras
    }
}
