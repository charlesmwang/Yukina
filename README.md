# Yukina -雪菜-
Yukina is a deep-linking framework for Swift. Inspired by popular web application frameworks including Ruby on Rails, and Sails.js.

##Requirements

- iOS 8.3 or greater
- Xcode 6.3
- Swift 1.2+

##Installation

###CocoaPods (Coming Soon)

##How to Use

###File Structure
This is an optional file structure you can adopt to organize your files and it is similar to existing web application (MVC) frameworks' project structures.

```
AppName
│   ViewController.swift
│   ...
│
└───AppRouting
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

####Defining a Route

```Swift
YKRoute(routeURLScheme: String, controller: (YKRequest) -> YKResponse, policies: [(YKRequest) -> YKPolicy], isPublic: Bool)
// Example
YKRoute(routeURLScheme: "/messages/:message_id", controller: MessageController.showMessages, policies: [MessagePolicies.isAuthenticated], isPublic: true)
```

By prepending a ":" to a path component, Yukina extracts that path component and uses as a parameter name.

```
/messages/:message_id (message_id is the parameter name)
/people/:person_id/messages/:message_id (person_id and message_id are the parameter names)
```

Yukina expects parameter values to be integers.
For example, if the route is defined as "/messages/:message_id" and the request has a URL "/messages/1", the request parameters dictionary will have ["message_id":"1"].

The controller is an action closure where the closure function must have a YKRequest as an argument and a YKResponse as a return value:

```Swift
 (YKRequest) -> YKResponse
```

You can add multiple Policy closures to the policies.
Please see Policy section for more details.

You can set a route to be public or private.
When set to public, other apps can execute your route.
When set to private, other apps cannot execute your route and a YKResponse error is returned.

###YKRouter
```Swift
let router: YKRouter = YKRouter(middlewares: [AppLinkMiddleware.appLinkParser], routes: [YKRoute(routeURLScheme: "/messages", controller: MessageController.showMessages, policies: [MessagePolicies.isAuthenticated], isPublic: true), ...])
```
Note that the YKRouter object is not a singleton. You can make it to a singleton.

###YKRequest

```Swift
public let routePath: String
public let data: [String: Any] // Container
public let queries: [String: String]
public let params:[String: String]
public let sourceApplication: String?
```

###YKResponse

```Swift
public let request: YKRequest
public let data: [String: Any]
public let status: YKResponseStatus
```

All controllers need to return a YKResponse.

YKResponse is handled inside the YKConnection functions.

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

To intercept deep links from other Apps, simply add this code inside the AppDelegate

```Swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    YKConnection.send(fromPublicURL: url, sourceApplication: sourceApplication, router: self.router, responseHandler: { (response: YKResponse) -> Void in
		...
    })
	return true
}
```

###Middleware

You can define custom middlewares in the router that can transform all incoming requests.

A middleware function has a YKRequest as an argument and a YKResponse as a return value.

```Swift
(YKRequest) -> YKRequest
```

For example for AppLinks, the AppLinks data is in the query string of the url.
The AppLinks middleware can parse the query string and create an AppLinks object and attach it to the request.

To insert data recreate another YKRequest:

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

Note that all requests run through the Middleware(s) defined in the router.
Middleware should be independent with other middlewares.

###Policy

You can filter the request by creating policies such that the policies need to be satisfied in order to execute the controller.

A policy function has a YKRequest as an argument and a YKPolicy as a return value.

```Swift
(YKResponse) -> YKPolicy

// public enum YKPolicy {
//    case Verfied
//    case Failed(YKResponse)
// }
```

Policy defined should be independent with other policy.

```
(Policy A [Verified]) -> (Policy B [Failed]) = Failed
(Policy B [Failed]) -> (Policy A [Verified]) = Failed
```

Example
```Swift
func somePolicy(#request: request) -> YKPolicy {
	...
	// For failure policy
	return YKPolicy.Failed(YKResponse(request: request, status: YKResponseStatus.Error(...), data: nil))
	// otherwise
	return YKPolicy.Verfied
}
```

If a policy fails, insert a YKResponse inside the YKPolicy.Failed.

##Example
Please look at the Example App for the basic use of the framework.

##Custom Middlewares
1. AppLinks [TBA]

##Objective-C Support
I have no plan for Objective-C support. It may work for it, but I don't have any gurantee of it.

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
