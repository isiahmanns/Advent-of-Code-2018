import Foundation

public class CounterBag<T: Hashable> {
    private var dict: Dictionary<T, Int> = [:]
    private var keyOfMaxCount: T!
    private var maxCount: Int!
    //private var maxCountHistory: [(T,Int)] = []
    
    public init() {}
    
    public func insert(_ elem: T) -> Void {
        dict[elem] = dict[elem] != nil ? dict[elem]! + 1 : 1
        
        if maxCount == nil || dict[elem]! > maxCount {
            maxCount = dict[elem]!
            keyOfMaxCount = elem
            //maxCountHistory.append((keyOfMaxCount, maxCount))
        }
    }
    
    /*
    public func remove(_ elem: T) -> Void {
        if let existingVal = dict[elem] {
            /*
            if maxCountHistory.contains(where: {$0 == (elem, existingVal)}) {
                let index: Int = maxCountHistory.firstIndex(where: {$0 == (elem,existingVal)})!
                maxCountHistory.remove(at: index)
                maxCount = maxCountHistory.last?.1
                keyOfMaxCount = maxCountHistory.last?.0
            }
            */
            
            dict[elem] = dict[elem] == 1 ? nil : existingVal - 1
        }
    }
    */
    
    public func lookup(_ elem: T) -> Int? {
        return dict[elem]
    }
    
    public func highestOccuringElement() -> T? {
        return keyOfMaxCount != nil ? keyOfMaxCount : nil
    }
    
    public func count() -> Int {
        return dict.values.reduce(0, {$0 + $1})
    }
    
    public func contents() -> Dictionary<T, Int> {
        return dict
    }
}
