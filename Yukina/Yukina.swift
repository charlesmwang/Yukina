import Foundation

public let kYKResponseFailedBadRequest: (UInt, String) = (400, "Bad Request")
public let kYKResponseFailedUnauthorized: (UInt, String) = (400, "Unauthorized")
public let kYKResponseFailedNotFound: (UInt, String) = (404, "Not Found")

public let kYKResponseSuccessOK: (UInt, String) = (200, "OK")

public enum YKResponseStatus {
    case Error(UInt, String)
    case Success(UInt, String)
}

public enum YKPolicy {
    case Verfied
    case Failed(YKResponse)
}

public typealias YKPolicyHandler = (YKRequest) -> YKPolicy
public typealias YKPolicies = [YKPolicyHandler]
public typealias YKRequestHandler = (YKRequest) -> YKResponse
public typealias YKResponseHandler = (YKResponse) -> Void
public typealias YKRequestParser = (YKRequest) -> YKRequest

