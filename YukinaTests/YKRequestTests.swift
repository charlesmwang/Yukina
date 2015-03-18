import UIKit
import XCTest
import Nimble

class YKRequestTests: XCTestCase {
    
    func testValidRequestInitWithURLString() {
        let urlString = "/hello/world"
        let request = YKRequest(urlString: urlString)!
        
        expect(request).toNot(beNil())
        expect(request.urlComponents).toNot(beNil())
        expect(request.routePath).to(equal(urlString))
        expect(request.routePath).toNot(equal("/invalid/routePath"))
        expect(request.queries).toNot(beNil())
        expect(request.queries.count).to(equal(0))
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(0))
        expect(request.data).toNot(beNil())
        expect(request.data.count).to(equal(0))
    }
    
    func testInvalidRequestInitWithURLString() {
        let urlString = "/hello */ world"
        let request = YKRequest(urlString: urlString)
        
        expect(request).to(beNil())
    }
    
    func testValidRequestInitWithURLStringAndQueryParams() {
        let query1 = "input1=output1"
        let query2 = "input2=output2"
        let query3 = "input3=test%20with%20space"
        let urlString = "/hello/world?\(query1)&\(query2)&\(query3)"
        let request = YKRequest(urlString: urlString)!
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal("/hello/world"))
        expect(request.routePath).toNot(equal(urlString))

        expect(request.queries).toNot(beNil())
        expect(request.queries.count).to(equal(3))
        expect(request.queries["input1"]).to(equal("output1"))
        expect(request.queries["input2"]).to(equal("output2"))
        expect(request.queries["input3"]).to(equal("test with space"))
        
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(0))
        expect(request.data).toNot(beNil())
        expect(request.data.count).to(equal(0))
    }
    
    func testValidRequestInitWithURLStringAndData() {

        struct StructObject {
            let name: String
        }
        
        let urlString = "/hello/world"
        
        let randomData = NSObject()
        let request = YKRequest(urlString: urlString, data: ["data1": randomData, "data2": "sample output", "data3": StructObject(name: "charles")])!
        
        expect(request).toNot(beNil())
        expect(request.urlComponents).toNot(beNil())
        expect(request.routePath).to(equal(urlString))
        expect(request.routePath).toNot(equal("/invalid/routePath"))
        expect(request.queries).toNot(beNil())
        expect(request.queries.count).to(equal(0))
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(0))
        expect(request.data).toNot(beNil())
        expect(request.data.count).to(equal(3))
        
        let data1: NSObject! = request.data["data1"] as! NSObject
        let data2: String! = request.data["data2"] as! String
        let data3: StructObject! = request.data["data3"] as! StructObject
        
        expect(data1).toNot(beNil())
        expect(data2).toNot(beNil())
        expect(data3).toNot(beNil())
        
        expect(data1).to(equal(randomData))
        expect(data2).to(equal("sample output"))
        expect(data3.name).to(equal("charles"))
    }
    
    func testInvalidRequestInitWithURLStringAndData() {
        
        struct StructObject {
            let name: String
        }
        
        let urlString = "/hello */ world"
        
        let randomData = NSObject()
        let request = YKRequest(urlString: urlString, data: ["data1": randomData, "data2": "sample output", "data3": StructObject(name: "charles")])
        
        expect(request).to(beNil())
    }
    
    func testValidRequestInitWithURLStringAndQueryParamsAndData() {
        
        struct StructObject {
            let name: String
        }
        
        let query1 = "input1=output1"
        let query2 = "input2=output2"
        let query3 = "input3=test%20with%20space"
        let urlString = "/hello/world?\(query1)&\(query2)&\(query3)"
        
        let randomData = NSObject()
        let request = YKRequest(urlString: urlString, data: ["data1": randomData, "data2": "sample output", "data3": StructObject(name: "charles")])!
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal("/hello/world"))
        expect(request.routePath).toNot(equal(urlString))
        
        expect(request.queries).toNot(beNil())
        expect(request.queries.count).to(equal(3))
        expect(request.queries["input1"]).to(equal("output1"))
        expect(request.queries["input2"]).to(equal("output2"))
        expect(request.queries["input3"]).to(equal("test with space"))
        
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(0))
        expect(request.data).toNot(beNil())
        expect(request.data.count).to(equal(3))
        
        let data1: NSObject! = request.data["data1"] as! NSObject
        let data2: String! = request.data["data2"] as! String
        let data3: StructObject! = request.data["data3"] as! StructObject
        
        expect(data1).toNot(beNil())
        expect(data2).toNot(beNil())
        expect(data3).toNot(beNil())
        
        expect(data1).to(equal(randomData))
        expect(data2).to(equal("sample output"))
        expect(data3.name).to(equal("charles"))
    }
    
    func testValidRequestInitWithAdditionalData() {
        
        struct StructObject {
            let name: String
        }
        
        let urlString = "/hello/world"
        
        let randomData = NSObject()
        let beforeRequest1 = YKRequest(urlString: urlString, data: ["data1": randomData, "data2": "sample output", "data3": StructObject(name: "charles")])!
        let beforeRequest2 = YKRequest(request: beforeRequest1, params: ["hello":"world"])
        let randomData2 = NSNumber(bool: true)
        let request = YKRequest(request: beforeRequest2, additionalData: ["data4": randomData2, "data5": "additional output", "data6": StructObject(name: "yukina")])
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal(urlString))
        expect(request.routePath).toNot(equal("/invalid/path"))
        
        expect(request.queries).toNot(beNil())
        expect(request.queries.count).to(equal(0))
        
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(1))
        expect(request.params["hello"]!).to(equal("world"))
        
        expect(request.data).toNot(beNil())
        expect(request.data.count).to(equal(6))
        
        let data1: NSObject! = request.data["data1"] as! NSObject
        let data2: String! = request.data["data2"] as! String
        let data3: StructObject! = request.data["data3"] as! StructObject
        let data4: NSObject! = request.data["data4"] as! NSNumber
        let data5: String! = request.data["data5"] as! String
        let data6: StructObject! = request.data["data6"] as! StructObject
        
        expect(data1).toNot(beNil())
        expect(data2).toNot(beNil())
        expect(data3).toNot(beNil())
        expect(data4).toNot(beNil())
        expect(data5).toNot(beNil())
        expect(data6).toNot(beNil())
        
        expect(data1).to(equal(randomData))
        expect(data2).to(equal("sample output"))
        expect(data3.name).to(equal("charles"))
        expect(data4).to(equal(randomData2))
        expect(data5).to(equal("additional output"))
        expect(data6.name).to(equal("yukina"))
    }
    
    func testValidRequestInitWithAdditionalDataAndQueryParams() {
        
        struct StructObject {
            let name: String
        }
        
        let query1 = "input1=output1"
        let query2 = "input2=output2"
        let query3 = "input3=test%20with%20space"
        let urlString = "/hello/world?\(query1)&\(query2)&\(query3)"
        
        let randomData = NSObject()
        let beforeRequest1 = YKRequest(urlString: urlString, data: ["data1": randomData, "data2": "sample output", "data3": StructObject(name: "charles")])!
        let beforeRequest2 = YKRequest(request: beforeRequest1, params: ["hello":"world"])
        let randomData2 = NSNumber(bool: true)
        let request = YKRequest(request: beforeRequest2, additionalData: ["data4": randomData2, "data5": "additional output", "data6": StructObject(name: "yukina")])
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal("/hello/world"))
        expect(request.routePath).toNot(equal(urlString))
        
        expect(request.queries).toNot(beNil())
        expect(request.queries.count).to(equal(3))
        expect(request.queries["input1"]).to(equal("output1"))
        expect(request.queries["input2"]).to(equal("output2"))
        expect(request.queries["input3"]).to(equal("test with space"))
        
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(1))
        expect(request.params["hello"]!).to(equal("world"))
        
        expect(request.data).toNot(beNil())
        expect(request.data.count).to(equal(6))
        
        let data1: NSObject! = request.data["data1"] as! NSObject
        let data2: String! = request.data["data2"] as! String
        let data3: StructObject! = request.data["data3"] as! StructObject
        let data4: NSObject! = request.data["data4"] as! NSNumber
        let data5: String! = request.data["data5"] as! String
        let data6: StructObject! = request.data["data6"] as! StructObject
        
        expect(data1).toNot(beNil())
        expect(data2).toNot(beNil())
        expect(data3).toNot(beNil())
        expect(data4).toNot(beNil())
        expect(data5).toNot(beNil())
        expect(data6).toNot(beNil())
        
        expect(data1).to(equal(randomData))
        expect(data2).to(equal("sample output"))
        expect(data3.name).to(equal("charles"))
        expect(data4).to(equal(randomData2))
        expect(data5).to(equal("additional output"))
        expect(data6.name).to(equal("yukina"))
    }
    
    func testRequestInitWithParams() {
        let urlString = "/hello/world"
        let beforeRequest1 = YKRequest(urlString: urlString)!
        let request = YKRequest(request: beforeRequest1, params: ["hello":"world","sample":"yukina"])
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal(urlString))
        expect(request.routePath).toNot(equal("/invalid/path"))
        
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(2))
        expect(request.params["hello"]).to(equal("world"))
        expect(request.params["sample"]).to(equal("yukina"))
        
        expect(request.data).toNot(beNil())
        expect(request.data.count).to(equal(0))
    }
    
    func testRequestInitWithParamsAndQueryParams() {
        
        struct StructObject {
            let name: String
        }
        
        let query1 = "input1=output1"
        let query2 = "input2=output2"
        let query3 = "input3=test%20with%20space"
        let urlString = "/hello/world?\(query1)&\(query2)&\(query3)"
        
        let randomData = NSObject()
        let beforeRequest = YKRequest(urlString: urlString)!
        let request = YKRequest(request: beforeRequest, params: ["hello":"world","sample":"yukina"])
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal("/hello/world"))
        expect(request.routePath).toNot(equal(urlString))
        
        expect(request.queries).toNot(beNil())
        expect(request.queries.count).to(equal(3))
        expect(request.queries["input1"]).to(equal("output1"))
        expect(request.queries["input2"]).to(equal("output2"))
        expect(request.queries["input3"]).to(equal("test with space"))
        
        expect(request.params).toNot(beNil())
        expect(request.params.count).to(equal(2))
        expect(request.params["hello"]!).to(equal("world"))
        expect(request.params["sample"]).to(equal("yukina"))
    }
    
    func testRequestInitWithBadURLString() {
        
        let urlString = "/hello/world"
        let request = YKRequest(badURLString: urlString)
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal(urlString))
        expect(request.routePath).toNot(equal("/invalid/path"))
    }
    
    func testValidRequestInitWithURLComponents() {
        
        let url: NSURL? = NSURL(string: "appscheme://host/relative/path?query=params")
        expect(url).toNot(beNil())
        let request = YKRequest(URL: url!)!
        
        expect(request).toNot(beNil())
        expect(request.routePath).to(equal("/host/relative/path"))
        expect(request.routePath).toNot(equal(url?.absoluteString))
    }

}

