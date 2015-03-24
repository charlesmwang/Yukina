import UIKit
import XCTest
import Nimble

class YKRouterTests: XCTestCase {
    
    let router = YKRouter(middlewares: [Middleware.method1, Middleware.method2, Middleware.method3], routes: Routes.route1(), Routes.route2(), Routes.route3())
    
    func testRouteInit() {
        expect(count(self.router.routes)).to(equal(8))
        expect(count(self.router.middlewares)).to(equal(3))
    }
    
    func testReduceMiddleware() {
        let combinedMiddleware = router.reduceMiddleware()
        let request = YKRequest(urlString: "/some_url")
        let transformedRequest = combinedMiddleware(request!)
        expect(transformedRequest.data["method1"] as? String).to(equal("data1"))
        expect(transformedRequest.data["method2"] as? String).to(equal("data2"))
        expect(transformedRequest.data["method3"] as? String).to(equal("data3"))
        
        expect(transformedRequest.routePath).to(equal(request!.routePath))
        expect(count(transformedRequest.data)).toNot(equal(count(request!.data)))
    }
    
    func testFindRoute() {
        let route = router.findRoute("/place0/:place_id")
        
    }

    struct Middleware {
        
        static func method1(request: YKRequest) -> YKRequest {
            return YKRequest(request: request, additionalData: ["method1":"data1"])
        }
        
        static func method2(request: YKRequest) -> YKRequest {
            return YKRequest(request: request, additionalData: ["method2":"data2"])
        }
        
        static func method3(request: YKRequest) -> YKRequest {
            return YKRequest(request: request, additionalData: ["method3":"data3"])
        }
    }
    
    struct Routes {
        
        static func route1() -> [YKRoute] {
            return [YKRoute(routeURLScheme: "/place0/:place_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true)]
        }
        
        static func route2() -> [YKRoute] {
            return [YKRoute(routeURLScheme: "/country0/:country_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true),
            YKRoute(routeURLScheme: "/country1/:country_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true)]
        }
        
        static func route3() -> [YKRoute] {
            return [YKRoute(routeURLScheme: "/city0/:city_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true),
            YKRoute(routeURLScheme: "/city1/:city_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true),
            YKRoute(routeURLScheme: "/city2/:city_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true),
            YKRoute(routeURLScheme: "/city3/:city_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true),
            YKRoute(routeURLScheme: "/city4/:city_id", controller: Controller.method1, policies: [PolicyAction.method1], isPublic: true)]
        }
    }
    
    struct Controller {
        static func method1(request: YKRequest) -> YKResponse {
            return YKResponse(request: request, status: YKResponseStatus.Success(kYKResponseSuccessOK), data: nil)
        }
    }
    
    struct PolicyAction {
        static func method1(request: YKRequest) -> YKPolicy {
            return YKPolicy.Verfied
        }
    }
}
