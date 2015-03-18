import Foundation

public struct YKRequest {
    
    public let routePath: String
    public let urlComponents: NSURLComponents
    public let data: [String: Any] // Container
    public let queries: [String: String]
    public let params:[String: String]
    public let sourceApplication: String?

    public init?(urlString: String) {
        self.init(URL: NSURL(string: urlString))
    }
    
    public init?(urlString: String, data: [String: Any]) {
        self.init(URL: NSURL(string: urlString), params: nil, data: data)
    }
    
    // Used in Middleware
    public init(request: YKRequest, additionalData: [String: Any]) {
        self.init(request: request, params: nil, additionalData: additionalData)
    }

    /* Internal Methods */
    init(request: YKRequest, params: [String: String]) {
        self.init(request: request, params: params, additionalData: nil)
    }
    
    // Used in Bad Request
    init(badURLString: String, sourceApplication: String? = nil) {
        self.routePath = badURLString
        self.urlComponents = NSURLComponents(string: badURLString) ?? NSURLComponents()
        self.data = [String: Any]()
        self.queries = extractQueryItems(self.urlComponents.queryItems)
        self.params = [String: String]()
        self.sourceApplication = sourceApplication
    }
    
    init?(URL url: NSURL?, sourceApplication: String? = nil) {
        self.init(URL: url, params: nil, data: nil, sourceApplication: sourceApplication)
    }
    
    init?(URL url: NSURL?, params: [String: String]?, data: [String: Any]?, sourceApplication: String? = nil) {
        
        // Handle Scheme *TODO Improve This*
        if let host = url?.host where url?.scheme != nil, let path = url?.path {
            self.routePath = "/\(host)\(path)"
        } else if let path = url?.path {
            self.routePath = path
        } else {
            return nil
        }
        
        if let url = url, let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) {
            self.urlComponents = urlComponents
            self.data = data ?? [String: Any]()
            self.queries = extractQueryItems(urlComponents.queryItems)
            self.params = params ?? [String: String]()
            self.sourceApplication = sourceApplication
        } else {
            return nil
        }
    }
    
    init(request: YKRequest, params: [String: String]?, additionalData: [String: Any]?) {
        self.routePath = request.routePath
        self.urlComponents = request.urlComponents
        self.params = params ?? request.params
        self.queries = request.queries
        if let additionalData = additionalData {
            self.data = mergeDictionary(request.data, additionalData)
        } else {
            self.data = request.data
        }
        self.sourceApplication = request.sourceApplication
    }
}

