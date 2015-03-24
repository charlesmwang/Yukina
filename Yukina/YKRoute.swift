import Foundation

public struct YKRoute {
    
    let url: YKURL
    public let controller: YKRequestHandler
    public let policies: [YKPolicyHandler]?
    public let isPublic: Bool
    
    public init(routeURLScheme: String, controller: YKRequestHandler, policies: [YKPolicyHandler]?, isPublic: Bool) {
        self.url = YKURL(routeURLScheme: routeURLScheme) // If invalid route, it would crash
        self.controller = controller
        self.policies = policies
        self.isPublic = isPublic
    }
    
    func extractParams(fromRequest request: YKRequest) -> [String: String] {
        
        var dict = [String: String]()
        
        // At this point URL has been matched !!!
        let matches: [NSTextCheckingResult]? = self.url.regexRouteURL.matchesInString(request.urlComponents.URL!.path!, options: NSMatchingOptions.Anchored, range:NSMakeRange(0, count(request.urlComponents.URL!.path!))) as? [NSTextCheckingResult]
        
        if let matches = matches where count(matches) == 1{
            
            // (match.numberOfRanges - 1) because it includes the whole string
            if let match = matches.first where (match.numberOfRanges - 1) == count(self.url.parameterNames) {
                for (index, paramName) in enumerate(self.url.parameterNames) {
                    let nsURLString = request.urlComponents.URL!.path! as NSString
                    let paramValue = nsURLString.substringWithRange(match.rangeAtIndex(index + 1)) as String
                    dict[paramName] = paramValue
                }
            }
        }
        
        return dict
        
    }
}
