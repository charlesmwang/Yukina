import Foundation

struct YKURL {
    
    let parameterNames:[String]
    let registeredRoute: String
    let regexRouteURL: NSRegularExpression! // Let it crash for invalid route : This should be caught in debugging stage
    
    init(routeURLScheme: String) {
        let url: NSURL? = NSURL(string: routeURLScheme)
        YKURL.verifyValidRouteURL(url, routeString: routeURLScheme)
        self.registeredRoute = routeURLScheme
        // verifyValidRouteURL should catch any url problem
        let regexString: String
        (self.parameterNames, regexString) = YKURL.yukinaURLProcessor(url!)
        var error: NSError? = nil
        println(regexString)
        println(self.parameterNames)
        self.regexRouteURL = NSRegularExpression(pattern: regexString, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)!
        
        if error != nil || self.regexRouteURL == nil {
            NSException(name: "Invalid Route Regex", reason: "Invalid URL String \(routeURLScheme)", userInfo: nil).raise()
        }
        
    }
    
    // Throws Exception
    static func verifyValidRouteURL(url: NSURL?, routeString: String) {
        if let url = url {
            if let urlPathComponents = url.pathComponents as? [String] where urlPathComponents.count > 0 {
                if let firstPathComponents = urlPathComponents.first where firstPathComponents != "/" {
                    NSException(name: "Invalid Route", reason: "Invalid URL String \(routeString). Missing '/' in the beginning.", userInfo: nil).raise()
                }
            }
            else {
                NSException(name: "Invalid Route", reason: "Invalid URL String \(routeString)", userInfo: nil).raise()
            }
        }
        else {
            NSException(name: "Invalid Route", reason: "Invalid URL String \(routeString)", userInfo: nil).raise()
        }
    }
    
    typealias Params = [String]
    typealias RegexURLString = String
    static func yukinaURLProcessor(url: NSURL) -> (Params, RegexURLString) {
        
        if let pathComponents = url.pathComponents as? [String] {
            var params = [String]()
            var regexPathComponents = pathComponents
            
            for (index, pathComponent) in enumerate(pathComponents) {
                if count(pathComponents) > 0 && pathComponent[pathComponent.startIndex] == ":" {
                    let param = pathComponent.substringFromIndex(advance(pathComponent.startIndex, 1)) // Remove :
                    params.append(param)
                    regexPathComponents[index] = "([\\d]+)"
                }
            }
            
            // Accessing first index is safe
            regexPathComponents[0] = "^"
            let regexURL = "\\/".join(regexPathComponents) + "[\\/]*$"
            
            return (params, regexURL)
            
        }
        // Failed Case
        NSException(name: "Could not process URL", reason: "Unknown Reason: \(url.absoluteString)", userInfo: nil).raise()
        return ([String]() , "")
    }
}