import Foundation

public class YKRouter {
    
    public let routes: [YKRoute]
    public let middlewares: [YKRequestParser]
    
    /* Public Method */
    public init(middlewares: [YKRequestParser]?, routes: [YKRoute]...) {
        
        if let middlewares = middlewares {
            self.middlewares = middlewares
        }
        else {
            self.middlewares = [YKRequestParser]()
        }
        
        self.routes = [YKRoute]().join(routes)
    }
    
    public func printRoutes() {
        var publicRoutesString: String = ""
        var privateRoutesString: String = ""
        for route in self.routes {
            if route.isPublic {
                publicRoutesString += "\(route.url.registeredRoute)\n"
            } else {
                privateRoutesString += "\(route.url.registeredRoute)\n"
            }
        }
        println("========Public  Routes========")
        print(publicRoutesString)
        println("==============================")
        println()
        println("========Private Routes========")
        print(privateRoutesString)
        println("==============================")
    }
    
    /* Internal Methods */
    func reduceMiddleware() -> YKRequestParser {
        return self.middlewares.reduce({ request in
            return request
            }, combine: { (requestParser1, requestParser2) -> YKRequestParser in
                return { request in
                    requestParser2(requestParser1(request))
                }
        })
    }
    
    func findRoute(routeURLString: String) -> YKRoute? {
        let routeUrl: NSURL? = NSURL(string: routeURLString)
        if let routeURLPath = routeUrl?.path {
            // Using iteration as it need the first occurrance once
            for route in routes {
                let matches = route.url.regexRouteURL.matchesInString(routeURLPath, options: NSMatchingOptions.Anchored, range:NSMakeRange(0, count(routeURLPath)))
                if count(matches) == 1 {
                    return route
                }
            }
        }
        return nil
    }
    
    func findRoute(#request: YKRequest) -> YKRoute? {
        return findRoute(request.routePath)
    }
}