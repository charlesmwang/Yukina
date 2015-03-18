import UIKit
import Yukina

class MessageController {

    class func showMessages(request: YKRequest) -> YKResponse {
        if let appLink = request.data["appLink"] as? AppLink {
            println(appLink.targetURL)
            println(appLink.userAgent!)
            println(appLink.extras!)
        }
        var alertView = UIAlertView()
        return YKResponse(successfulRequest: request, data:["alertView":alertView])
    }

}
