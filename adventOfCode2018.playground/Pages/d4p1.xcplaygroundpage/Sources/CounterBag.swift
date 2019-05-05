import Foundation

public class CounterBag<T: Hashable> {
    private var dict: Dictionary<T, Int> = [:]
    private var keyOfMaxCount: T!
    private var maxCount: Int!
    
    public init() {}
    
    public func insert(_ elem: T) -> Void {
        dict[elem] = dict[elem] != nil ? dict[elem]! + 1 : 1
        
        if maxCount == nil || dict[elem]! > maxCount {
            maxCount = dict[elem]!
            keyOfMaxCount = elem
        }
    }
    
    /*
    public func remove(_ elem: T) -> Void {
        if let existingVal = dict[elem] {
            dict[elem] = dict[elem] == 1 ? nil : existingVal - 1
        }
    }
     */
    
    public func highestOccuringElement() -> T? {
        return keyOfMaxCount != nil ? keyOfMaxCount : nil
    }
    
    public func count() -> Int {
        return dict.values.reduce(0, {$0 + $1})
    }
}
