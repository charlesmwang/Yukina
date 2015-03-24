import UIKit
import XCTest
import Nimble

class YKConnectionTests: XCTestCase {

    func testApplyPoliciesToRequest() {
        
        struct PolicyAction {
            static func method1(request: YKRequest) -> YKPolicy {
                return YKPolicy.Verfied
            }
            static func method2(request: YKRequest) -> YKPolicy {
                return YKPolicy.Verfied
            }
            static func method3(request: YKRequest) -> YKPolicy {
                return YKPolicy.Verfied
            }
            static func method4(request: YKRequest) -> YKPolicy {
                return YKPolicy.Failed(YKResponse(request: request, status: YKResponseStatus.Error(4, "Method4 Error"), data: nil))
            }
            static func method5(request: YKRequest) -> YKPolicy {
                return YKPolicy.Failed(YKResponse(request: request, status: YKResponseStatus.Error(5, "Method5 Error"), data: nil))
            }
        }
        
        let request = YKRequest(urlString: "/someRequest")
        
        let policies1: YKPolicies = [PolicyAction.method1, PolicyAction.method2, PolicyAction.method3] // Ok
        let policies2: YKPolicies = [PolicyAction.method1, PolicyAction.method3, PolicyAction.method4] // Fail
        let policies3: YKPolicies = [PolicyAction.method5, PolicyAction.method4, PolicyAction.method1] // Fail
        
        let policy1 = YKConnection.applyPoliciesToRequest(request!, policies: policies1)
        switch policy1 {
            case .Verfied:
                expect(true).to(equal(true))
            default:
                expect(false).to(equal(true)) // Let it fail
        }
        
        
        let policy2 = YKConnection.applyPoliciesToRequest(request!, policies: policies2)
        switch policy2 {
        case .Failed(let response):
            expect(true).to(equal(true))
            switch response.status {
                case .Error(let code, let reason):
                    expect(code).to(equal(4))
                    expect(reason).to(equal("Method4 Error"))
                default:
                    expect(false).to(equal(true)) // Let it fail
            }
        default:
            expect(false).to(equal(true)) // Let it fail
        }
        
        let policy3 = YKConnection.applyPoliciesToRequest(request!, policies: policies3)
        switch policy3 {
        case .Failed(let response):
            expect(true).to(equal(true))
            switch response.status {
            case .Error(let code, let reason):
                expect(code).to(equal(5))
                expect(reason).to(equal("Method5 Error"))
            default:
                expect(false).to(equal(true)) // Let it fail
            }
        default:
            expect(false).to(equal(true)) // Let it fail
        }
        
        
        
    }

}
