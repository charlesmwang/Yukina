import Foundation

func mergeDictionary<K,V>(dict1: [K:V], dict2: [K:V]) -> [K:V] {
    
    var dict:[K:V] = dict1
    
    for (key, value) in dict2 {
        dict.updateValue(value, forKey: key)
    }
    
    return dict
}

func extractQueryItems(queryItems:[AnyObject]?) -> [String:String]{
    let dictQueryItems:[[String:String]]? = queryItems?.map({ (queryItem) -> [String:String] in
        if let queryItem = queryItem as? NSURLQueryItem, let value = queryItem.value {
            return [queryItem.name: value]
        }
        else {
            return [:]
        }
    })
    if let dictQueryItems = dictQueryItems {
        let dictQueryItem:[String:String] = dictQueryItems.reduce([:], combine: { (queryItem1, queryItem2) -> [String:String] in
            return mergeDictionary(queryItem1, queryItem2)
        })
        return dictQueryItem
    }
    return [String:String]()
}

