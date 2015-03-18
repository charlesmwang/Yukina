import Foundation
import Yukina

class AppLinkMiddleware {
    
    class func appLinkParser(request: YKRequest) -> YKRequest {
        let appLinkQuery: String? = request.queries["al_applink_data"]
        
        if let appLinkQuery = appLinkQuery {
            if let appLink = AppLinkMiddleware.decodeAppLinkString(appLinkQuery) {
                return YKRequest(request: request, additionalData: ["appLink": appLink])
            }
        }
        return request
    }

    private class func decodeAppLinkString(appLinkString: String) -> AppLink? {
        if let decodedURL = AppLinkMiddleware.decodeURL(appLinkString) {
            if let data = decodedURL.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                var error: NSError?
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error)
                if let dictObject = jsonObject as? [String: AnyObject] where error == nil {
                    
                    let targetURL = dictObject["target_url"] as? String
                    let userAgent = dictObject["user_agent"] as? String
                    let extras = dictObject["extras"] as? [String: String]
                    
                    return AppLink(targetURL: targetURL, userAgent: userAgent, extras: extras)
                }
            }
        }
        return nil
    }
    
    private class func decodeURL(appLinkString: String) -> String? {
        return appLinkString.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    }
    
}
