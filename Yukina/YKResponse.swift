import Foundation

public struct YKResponse {
    
    public let request: YKRequest
    public let data: [String: Any]
    public let status: YKResponseStatus

    public init(request: YKRequest, status: YKResponseStatus, data:[String: Any]?) {
        self.request = request
        if let data = data {
            self.data = data
        }
        else {
            self.data = [String: Any]()
        }
        self.status = status
    }

    public init(successfulRequest request: YKRequest, data:[String: Any]?) {
        self.init(request: request, status: YKResponseStatus.Success(kYKResponseSuccessOK), data: data)
    }
}