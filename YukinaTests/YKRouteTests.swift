import UIKit
import XCTest
import Nimble

class YKRouteTests: XCTestCase {

    func testRouteInit() {
        let route = YKRoute(routeURLScheme: "/country/:country_id/place/:place_id", controller: someController, policies: nil, isPublic: true)
        expect(route.isPublic).to(equal(true))
        expect(route.policies).to(beNil())
        
        expect(route.url).toNot(beNil())
        
        let request = YKRequest(urlString: "/country/1/place/2")
        expect(route.controller(request!).request.routePath).to(equal("/country/1/place/2"))
        expect(route.controller(request!).data["data"]).toNot(beNil())
        expect(route.controller(request!).data["data"] as? String).to(equal("success"))
    }
    
    func testExtractParams() {
        let route = YKRoute(routeURLScheme: "/country/:country_id/place/:place_id", controller: someController, policies: nil, isPublic: true)
        let request = YKRequest(urlString: "/country/1/place/2")
        let params = route.extractParams(fromRequest: request!)
        expect(params).toNot(beNil())
        expect(count(params)).to(equal(2))
        expect(params["country_id"]).to(equal("1"))
        expect(params["place_id"]).to(equal("2"))
    }
    
    private func someController(request: YKRequest) -> YKResponse {
        return YKResponse(successfulRequest: request, data: ["data":"success"])
    }

}
