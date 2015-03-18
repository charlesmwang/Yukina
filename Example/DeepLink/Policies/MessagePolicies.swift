import Foundation
import Yukina

class MessagePolicies {
    
    class func isAuthenticated(request: YKRequest) -> YKPolicy {
        println("isAuthenticated")
        // Check if the user is authenticated
        return YKPolicy.Verfied
    }
    
}
