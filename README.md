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

## License