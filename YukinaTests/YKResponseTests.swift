import UIKit
import XCTest
import Nimble

class YKResponseTests: XCTestCase {

    func testYKResponseInit() {
        
        let request = YKRequest(urlString: "/hello/world")
        expect(request).toNot(beNil())
        let response = YKResponse(request: request!, status: YKResponseStatus.Success(kYKResponseSuccessOK), data: ["hello":"world"])
        expect(response).toNot(beNil())
        expect(response.request.routePath).to(equal(request!.routePath))
        switch response.status {
        case .Success(let code, let message):
            let (c, m) = kYKResponseSuccessOK
            expect(code).to(equal(c))
            expect(message).to(equal(m))
        default:
            expect(true).to(equal(false))
        }
        let responseData = response.data["hello"] as! String
        expect(responseData).to(equal("world"))
        
        
        let badResponse = YKResponse(request: request!, status: YKResponseStatus.Error(kYKResponseFailedBadRequest), data: ["hello":"world"])
        expect(badResponse).toNot(beNil())
        expect(badResponse.request.routePath).to(equal(request!.routePath))
        switch badResponse.status {
        case .Error(let code, let message):
            let (c, m) = kYKResponseFailedBadRequest
            expect(code).to(equal(c))
            expect(message).to(equal(m))
        default:
            expect(true).to(equal(false))
        }
        let badResponseData = badResponse.data["hello"] as! String
        expect(badResponseData).to(equal("world"))
    }
    
    func testSuccessfulYKResponseInit() {
        
        let request = YKRequest(urlString: "/hello/world")
        expect(request).toNot(beNil())
        let response = YKResponse(successfulRequest: request!, data: ["hello":"world"])
        expect(response).toNot(beNil())
        expect(response.request.routePath).to(equal(request!.routePath))
        switch response.status {
        case .Success(let code, let message):
            let (c, m) = kYKResponseSuccessOK
            expect(code).to(equal(c))
            expect(message).to(equal(m))
        default:
            expect(true).to(equal(false))
        }
        let responseData = response.data["hello"] as! String
        expect(responseData).to(equal("world"))
    }
    
}
