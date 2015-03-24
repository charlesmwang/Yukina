# Yukina -雪菜-
Yukina is a deep-linking framework for Swift. Inspired by popular web application frameworks including Ruby on Rails, Sails.js, Python Django, and Node.js.

##Requirements

- iOS 8.3 Beta +
- Xcode 6.3 Beta +
- Swift 1.2+

##Installation

###CocoaPods
```ruby
pod 'Yukina'
```

##How to Use

###File Structure
This is an optional file structure you can adopt to organize your files and it is similar to existing web application (MVC) frameworks' project structures.

```
AppName
│   ViewController.swift
│   ...
│
└───DeepLinking
    │
    ├───Models
    │   │   AppLink.swift
    │   │   ...
    │
    ├───Controllers
    │   │   MessageController.swift
    │   │   ProfileController.swift
    │   │   ...
    │
    ├───Routes
    │   │   MessageRoutes.swift
    │   │   ProfileRoutes.swift
    │   │   ...
    │
    ├───Policies
    │   │   MessagePolicies.swift
    │   │   ...
    │
    ├───Middlewares
    │   │   AppLinkMiddleware.swift
    │   │   ...
```

###YKRoute
By prepending a ":" to a path component, Yukina will extract that parameter. However, it could only match for digits only.
For example, if the route is defined as "/messages/:message_id" and the request has a URL "/messages/1", the request parameters dictionary will have ["message_id":"1"].

```Swift
YKRoute(routeURLScheme: "/messages/:message_id", controller: MessageController.showMessages, policies: [MessagePolicies.isAuthenticated], isPublic: true)
```

The controller is an action closure where the closure function must be in a format of:
```Swift
 (YKRequest) -> YKResponse
```

You can add multiple Policy closures to the policies.

You can set the route to be public or private.
When set to public, other apps can access execute your route.
When set to private, other apps would not be able to execute your route and you would get an YKResponse error object.

See Policy for more details.


###YKRouter
```Swift
let router: YKRouter = YKRouter(middlewares: [AppLinkMiddleware.appLinkParser], routes: [YKRoute(routeURLScheme: "/messages", controller: MessageController.showMessages, policies: [MessagePolicies.isAuthenticated], isPublic: true), ...])
```
Note that the YKRouter object is not a singleton. You can make it to a singleton.
###YKRequest

Inside the controller, you can access the YKRequest object that contains these data:

```Swift
public let routePath: String
public let data: [String: Any] // Container
public let queries: [String: String]
public let params:[String: String]
public let sourceApplication: String?
```

###YKResponse

You can access the YKResponse object that contains these data:
```Swift
public let request: YKRequest
public let data: [String: Any]
public let status: YKResponseStatus
```

All controllers need to return a YKResponse object.

Inside the YKConnection methods, you can handle the response in there.

###YKConnection

Simply call: 

```Swift
YKConnection.send(urlString: "/messages", router: router, responseHandler: { (response) -> Void in
	switch response.status {
		... // Check response status
		let data:[String: Any] = response.data["someData"]
		... // Do something with the data
	}
})
```

To intercept deep links from other App, simply add this code inside the AppDelegate

```Swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {        
    YKConnection.send(fromPublicURL: url, sourceApplication: sourceApplication, router: self.router, responseHandler: { (response: YKResponse) -> Void in
		...
    })
	return true
}
```

If you don't want to keep inserting the YKRouter object inside the YKConnection methods, you can create a default connection struct:

```Swift
struct YKDefaultConnection {
    public static func send(#request: YKRequest, responseHandler: YKResponseHandler) {
        YKConnection.send(#request: request, router: SomeSingletonRouter.sharedInstance(), responseHandler: responseHandler) {
			...
    	}
	}
}
```

###Middleware

You can define middlewares in the router that can transform the request.
For example in AppLinks, the AppLinks data is in the query string of the url.
An AppLinks middleware can parse the query string and create an AppLinks object and attach it to the request.
To insert data use this method preferably:

```Swift
public init(request: YKRequest, additionalData: [String: Any])
```

Example
```Swift
func sampleMiddleware(#request: YKRequest) -> YKRequest {
	if request.sourceApplication == "someApplication" {
		...
		return YKRequest(request: request, additionalData: ["someApplicationData": SomeObject])
	} 
	return request
}
```

Note that all requests will run through the Middleware(s) defined in the router.
Middleware should be independent with other middlewares

###Policy

You can filter the reqeust by creating policies such that the policies need to be satisfied in order to execute the controller
Policy created should be independent with other policy.
(Policy A [Verified]) -> (Policy B [Failed]) = Failed
(Policy B [Failed]) -> (Policy A [Verified]) = Failed

Example
```Swift
func somePolicy(#request: request) -> YKPolicy {
	...
	// if policy failed
	return YKPolicy.Failed(YKResponse(request: request, status: YKResponseStatus.Error(...), data: nil))
	// otherwise
	return YKPolicy.Verfied
}
```

If the policy fails, insert the YKResponse object inside the YKPolicy.Failed.

##Example
Please look at the Example App for the basic use of the Yukina framework.

##Custom Middlewares
1. AppLinks [TBA]

##Objective-C Support
I have no plan for Objective-C support. It may work for it, but I don't have any gurantee of it. 

##Pre Swift 1.2
I am working on porting it to Swift 1.1 (Xcode 6.2)

## License

The MIT License (MIT)

Copyright (c) 2015 Charles Wang

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.