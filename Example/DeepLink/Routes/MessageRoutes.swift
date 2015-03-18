import Foundation
import Yukina

class MessageRoutes {
    
    class func routes() -> [YKRoute] {
        return [
            MessageRoutes.viewMessagesRoute(),
        ]
    }
    
    private class func viewMessagesRoute() -> YKRoute {
        return YKRoute(routeURLScheme: "/messages", controller: MessageController.showMessages, policies: [MessagePolicies.isAuthenticated], isPublic: true)
    }

}
