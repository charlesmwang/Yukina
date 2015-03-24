import UIKit
import XCTest
import Nimble

class YKURLTests: XCTestCase {
    
    func testValidYKURLInit() {
        let routeURLScheme = "/country/place"
        let ykURL = YKURL(routeURLScheme: routeURLScheme)
        expect(ykURL.registeredRoute).to(equal(routeURLScheme))
        expect(ykURL.parameterNames.count).to(equal(0))
    }
    
    // Add more regex test TODO
    func testValidYKURLInitWithParams() {
        let routeURLScheme = "/country/:country_id/place/:place_id"
        let ykURL = YKURL(routeURLScheme: routeURLScheme)
        expect(ykURL.registeredRoute).to(equal(routeURLScheme))
        expect(ykURL.parameterNames.count).to(equal(2))
        expect(ykURL.parameterNames[0]).to(equal("country_id"))
        expect(ykURL.parameterNames[1]).to(equal("place_id"))
    }
    
    func testInvalidYKURLInit() {
        let routeURLScheme = "/country/ :country_id/ place/ :place_id"
        expect(YKURL(routeURLScheme: routeURLScheme)).to(raiseException(named: "Invalid Route"))
    }
    
}
