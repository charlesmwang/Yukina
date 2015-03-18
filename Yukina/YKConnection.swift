import Foundation

public struct YKConnection {
    
    public static func send(#request: YKRequest, router: YKRouter, responseHandler: YKResponseHandler) {
        YKConnection.send(request: request, router: router, responseHandler: responseHandler, isPublic: false)
    }
    
    public static func send(#urlString: String, router: YKRouter, responseHandler: YKResponseHandler) {
        
        // Construct Request
        let request = YKRequest(urlString: urlString)
        
        // Check if the request is valid
        if let request = request {
            YKConnection.send(request: request, router: router, responseHandler: responseHandler)
        } else {
            responseHandler(YKResponse(request: YKRequest(badURLString: urlString), status: YKResponseStatus.Error(kYKResponseFailedBadRequest), data: nil))
        }
    }
    
    public static func send(fromPublicURL url: NSURL, sourceApplication: String?, router: YKRouter, responseHandler: YKResponseHandler) {
        let request: YKRequest? = YKRequest(URL: url, sourceApplication: sourceApplication)
        if let request = request {
            YKConnection.send(request: request, router: router, responseHandler: responseHandler, isPublic: true)
        } else {
            // TODO Check the url
            if let absoluteURLPath = url.absoluteString {
                responseHandler(YKResponse(request: YKRequest(badURLString: absoluteURLPath), status: YKResponseStatus.Error(kYKResponseFailedBadRequest), data: nil))
            } else {
                responseHandler(YKResponse(request: YKRequest(badURLString: "/UNKNOWN_ERROR"), status: YKResponseStatus.Error(kYKResponseFailedBadRequest), data: nil))
            }
        }
    }
    
    /* Internal Method */
    
    static func send(#request: YKRequest, router: YKRouter, responseHandler: YKResponseHandler, isPublic: Bool) {
        let route: YKRoute? = router.findRoute(request: request)
        
        if let route = route {
            
            if !route.isPublic && isPublic {
                responseHandler(YKResponse(request: request, status: YKResponseStatus.Error(kYKResponseFailedBadRequest), data: nil)) // Failed For Public Route
                return
            }
            
            let extractedParamsRequest = YKRequest(request: request, params: route.extractParams(fromRequest: request))
            let parsedRequest = router.reduceMiddleware()(extractedParamsRequest) // Apply Middlewares
            
            let policy: YKPolicy = YKConnection.applyPoliciesToRequest(parsedRequest, policies: route.policies) // Apply Policies
            
            switch policy {
            case .Verfied:
                let response: YKResponse = route.controller(parsedRequest)
                responseHandler(response)
            case .Failed(let response):
                responseHandler(response)
            default:
                responseHandler(YKResponse(request: parsedRequest, status: YKResponseStatus.Error(kYKResponseFailedBadRequest), data: nil)) // Failed For Unknown Reason
            }
        }
        else {
            responseHandler(YKResponse(request: request, status: YKResponseStatus.Error(kYKResponseFailedNotFound), data: nil))
        }
    }
    
    
    /* Private Method */
    
    // Policy Handler
    static func applyPoliciesToRequest(request: YKRequest, policies: YKPolicies?) -> YKPolicy {
        
        if let policies = policies {
            
            // Apply Individual Policy
            let appliedPolicies: [YKPolicy] = policies.map {
                policyHandler in
                return policyHandler(request)
            }
            
            // Find Failed Policy
            let policy: YKPolicy = appliedPolicies.reduce(YKPolicy.Verfied, combine: {
                (previousPolicy, newPolicy) -> YKPolicy in
                
                switch previousPolicy {
                case .Failed(_):
                    return previousPolicy
                default:
                    return newPolicy
                }
            })
            
            return policy
        }
        else {
            return YKPolicy.Verfied
        }
    }
    
}