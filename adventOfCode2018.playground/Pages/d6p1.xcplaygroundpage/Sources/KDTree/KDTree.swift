//
//  KDTree+Equatable.swift
//  Pods
//
//  Created by Konrad Feiler on 28/03/16.
//
//

import Foundation

private enum ReplacementDirection {
    case max
    case min
}

public enum KDTree<Element: KDTreePoint> {
    case leaf
    indirect case node(left: KDTree<Element>, value: Element, dimension: Int, right: KDTree<Element>)
}

extension KDTree {
    public init(values: [Element], depth: Int = 0) {
        guard !values.isEmpty else {
            self = .leaf
            return
        }
        
        let currentSplittingDimension = depth % Element.dimensions
        if values.count == 1, let firstValue = values.first {
            self = .node(left: .leaf, value: firstValue, dimension: currentSplittingDimension, right: .leaf)
        }
        else {
            var median = values.count / 2
            
            let selected = KDTree.quickSelect(targetIndex: median, array: values[0..<values.endIndex], kdDimension: currentSplittingDimension)
            let medianElement = selected[median]
            let medianValue = medianElement.kdDimension(currentSplittingDimension)
          
            //Ensure left subtree contains currentSplittingDimension-coordinate strictly less than its parent node
            //Needed for 'contains' and 'removing' method.
            while median >= 1 && abs(selected[median-1].kdDimension(currentSplittingDimension) - medianValue) < Double.ulpOfOne {
              median -= 1
            }
          
            let leftTree = KDTree(values: selected[0..<median], depth: depth+1)
            let rightTree = KDTree(values: selected[median+1..<selected.count], depth: depth+1)
            
            self = .node(left: leftTree, value: selected[median],
                         dimension: currentSplittingDimension, right: rightTree)
        }
    }
    
    public init(values: ArraySlice<Element>, depth: Int = 0) {
        guard !values.isEmpty else {
            self = .leaf
            return
        }
        
        let currentSplittingDimension = depth % Element.dimensions
        if values.count == 1, let firstValue = values.first {
            self = .node(left: .leaf, value: firstValue, dimension: currentSplittingDimension, right: .leaf)
        }
        else {
            let sliceStartIndex = values.startIndex
            let sliceEndIndex = values.endIndex
            var median = sliceStartIndex + (sliceEndIndex - sliceStartIndex) / 2
            
            let selected = KDTree.quickSelect(targetIndex: median, array: values, kdDimension: currentSplittingDimension)
            let medianElement = selected[median]
            let medianValue = medianElement.kdDimension(currentSplittingDimension)
            
            //Ensure left subtree contains currentSplittingDimension-coordinate strictly less than its parent node
            //Needed for 'contains' and 'removing' method.
            while median >= 1 && median > sliceStartIndex && abs(selected[median-1].kdDimension(currentSplittingDimension) - medianValue) < Double.ulpOfOne {
                median -= 1
            }
            
            let leftTree = KDTree(values: selected[sliceStartIndex..<median], depth: depth+1)
            let rightTree = KDTree(values: selected[median+1..<sliceEndIndex], depth: depth+1)
            
            self = .node(left: leftTree, value: selected[median],
                         dimension: currentSplittingDimension, right: rightTree)
        }
    }
    
    /** Quickselect function is based on https://github.com/mourner/kdbush
     */
    private static func quickSelect(targetIndex: Int, array: ArraySlice<Element>, kdDimension: Int) -> ArraySlice<Element> {
        guard array.count > 1 else { return array }
        
        var varray = array
        let partitionIndex = KDTree.partitionLomuto(&varray, kdDimension: kdDimension)
        
        if partitionIndex == targetIndex {
            return varray
        } else if partitionIndex < targetIndex {
            let s = partitionIndex+1
            return varray[...partitionIndex] + quickSelect(targetIndex: targetIndex, array: varray[s...], kdDimension: kdDimension)
        } else {
            // partitionIndex is greater than the targetIndex, quickSelect moves to indexes smaller than partitionIndex
            return quickSelect(targetIndex: targetIndex, array: varray[..<partitionIndex], kdDimension: kdDimension) + varray[partitionIndex...]
        }
    }
    
    /// # Lomuto's partitioning algorithm.
    /// This is conceptually simpler than Hoare's original scheme but less efficient.
    /// The return value is the index of the pivot element in the new array. The left
    /// partition is [low...p-1]; the right partition is [p+1...high], where p is the
    /// return value.
    /// - - -
    /// The left partition includes all values smaller than the pivot, so
    /// if the pivot value occurs more than once, its duplicates will be found in the
    /// right partition.
    ///
    /// - Parameters:
    ///   - array: the inout array slice
    ///   - kdDimension: the dimension sorted over
    /// - Returns: the index of the pivot element in the new array
    private static func partitionLomuto(_ array: inout ArraySlice<Element>, kdDimension: Int) -> Int {
        let lo = array.startIndex
        let hi = array.endIndex-1
        guard lo < hi else { return lo }
        
        let randomIndex = Int.random(in: lo...hi)
        array.swapAt(hi, randomIndex)
        let pivot = array[hi]
        
        // This loop partitions the array into four (possibly empty) regions:
        //   [lo   ...    i] contains all values < pivot,
        //   [i+1  ...  j-1] contains all values >= pivot,
        //   [j    ..< hi-1] are values we haven't looked at yet,
        //   [hi           ] is the pivot value.
        var i = array.startIndex
        
        for j in array.startIndex..<hi {
            if array[j].kdDimension(kdDimension) < pivot.kdDimension(kdDimension) {
                array.swapAt(i, j)
                i += 1
            }
        }
        
        // Swap the pivot element with the first element that is greater than
        // the pivot. Now the pivot sits between the < and >= regions and the
        // array is properly partitioned.
        array.swapAt(i, hi)
        return i
    }
    
    /// Returns `true` iff `self` is empty.
    ///
    /// - Complexity: O(1)
    public var isEmpty: Bool {
        switch self {
        case .leaf: return true
        default: return false
        }
    }
    
    /// The number of elements the KDTree stores.
    public var count: Int {
        switch self {
        case .leaf:
            return 0
        case let .node(left, _, _, right):
            return 1 + left.count + right.count
        }
    }
    
    /// The elements the KDTree stores as an Array.
    public var elements: [Element] {
        switch self {
        case .leaf:
            return []
        case let .node(left, value, _, right):
            var mappedTs = left.elements
            mappedTs.append(value)
            mappedTs.append(contentsOf: right.elements)
            return mappedTs
        }
    }
    
    /// Returns `true` iff `element` is in `self`.
    public func contains(_ value: Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case let .node(left, nodeValue, dim, right):
            if value == nodeValue { return true }
            else {
                let valueDist = value.kdDimension(dim)
                let nodeDist = nodeValue.kdDimension(dim)
                if valueDist < nodeDist {
                    return left.contains(value)
                } else {
                    return right.contains(value)
                }
            }
        }
    }
    
    /// Return a KDTree with the element inserted. Tree might not be balanced anymore after this
    ///
    /// - Complexity: O(n log n )..
    public func inserting(_ newValue: Element, dim: Int = 0) -> KDTree {
        switch self {
        case .leaf:
            return .node(left: .leaf, value: newValue, dimension: dim, right: .leaf)
        case let .node(left, value, dim, right):
            if value == newValue { return self }
            else {
                let nextDim = (dim + 1) % Element.dimensions
                if newValue.kdDimension(dim) < value.kdDimension(dim) {
                    return KDTree.node(left: left.inserting(newValue, dim: nextDim), value: value,
                                       dimension: dim, right: right)
                }
                else {
                    return KDTree.node(left: left, value: value, dimension: dim,
                                       right: right.inserting(newValue, dim: nextDim))
                }
            }
        }    
    }
    
    /// Return a KDTree with the element removed.
    ///
    /// If element is not contained the new KDTree will be equal to the old one
    public func removing(_ valueToBeRemoved: Element, dim: Int = 0) -> KDTree {
        switch self {
        case .leaf:
            return self
        case let .node(left, value, dim, right):
            if value == valueToBeRemoved {
                let (newLeftSubTree, leftReplacementValue) = left.findBestReplacement(dim, direction: ReplacementDirection.max)
                if let replacement = leftReplacementValue {
                    return KDTree.node(left: newLeftSubTree, value: replacement, dimension: dim, right: right)
                }

                let (newRightSubTree, rightReplacementValue) = right.findBestReplacement(dim, direction: ReplacementDirection.min)
                if let replacement = rightReplacementValue {
                    return KDTree.node(left: left, value: replacement, dimension: dim, right: newRightSubTree)
                }
                
                //if neither left nor right has a replacement we can safely return an empty leaf
                return KDTree.leaf
            }
            else {
                let nextDim = (dim + 1) % Element.dimensions
                if valueToBeRemoved.kdDimension(dim) < value.kdDimension(dim) {
                    return KDTree.node(left: left.removing(valueToBeRemoved, dim: nextDim), value: value,
                                       dimension: dim, right: right)
                }
                else {
                    return KDTree.node(left: left, value: value, dimension: dim,
                                       right: right.removing(valueToBeRemoved, dim: nextDim))
                }
            }
        }
    }
    
    private func findBestReplacement(_ dimOfCut: Int, direction: ReplacementDirection) -> (KDTree, Element?) {
        switch self {
        case .leaf:
            return (self, nil)
        case .node(let left, let value, let dim, let right):
            if dim == dimOfCut {
                //look at the best side of the split for the best replacement
                let subTree = (direction == .min) ? left : right
                let (newSubTree, replacement) = subTree.findBestReplacement(dim, direction: direction)
                if let replacement = replacement {
                    if direction == .min { return (.node(left: newSubTree, value: value, dimension: dim, right: right), replacement) }
                    else { return (.node(left: left, value: value, dimension: dim, right: newSubTree), replacement) }
                }
                //the own point is the optimum!
                return (self.removing(value), value)
            }
            else {
                //look at both side and the value and find the min/max regarding f() along the dimOfCut
                let nilDropIn = (direction == .min) ? Double.infinity : -Double.infinity

                let (newLeftSubTree, leftReplacementValue) = left.findBestReplacement(dimOfCut, direction: direction)
                let (newRightSubTree, rightReplacementValue) = right.findBestReplacement(dimOfCut, direction: direction)
                let dimensionValues: [Double] = [leftReplacementValue, rightReplacementValue, value].map({ element -> Double in
                    return element.flatMap({ $0.kdDimension(dimOfCut) }) ?? nilDropIn
                })
                let optimumValue = (direction == .min) ? dimensionValues.min() : dimensionValues.max()
                if let bestValue = leftReplacementValue , dimensionValues[0] == optimumValue {
                    return (.node(left: newLeftSubTree, value: value, dimension: dim, right: right), bestValue)
                }
                else if let bestValue = rightReplacementValue , dimensionValues[1] == optimumValue {
                    return (.node(left: left, value: value, dimension: dim, right: newRightSubTree), bestValue)
                }
                else { //the own point is the optimum!
                    return (self.removing(value), value)
                }
            }
        }
    }
    
    /// Return the maximum distance of this KDTrees farthest leaf
    public var depth: Int {
        switch self {
        case .leaf:
            return 0
        case let .node(left, _, _, right):
            let leftDepth = left.depth
            let rightDepth = right.depth
            let maxSubTreeDepth = leftDepth > rightDepth ? leftDepth : rightDepth
            return 1 + maxSubTreeDepth
        }
    }
}

extension KDTree { //SequenceType like, but keeping the KDTree datastructure
    
    /// Returns a `KDTree` containing the results of mapping `transform`
    /// over `self`. 
    /// **IMPORTANT NOTE:** In general the resulting Tree won't be balanced at all. There are however specific cases 
    /// where a map would keep the balance intact.
    ///
    /// - Complexity: O(N).
    public func map<T: KDTreePoint>(_ transform: (Element) throws -> T) rethrows -> KDTree<T> {
        switch self {
        case .leaf:
            return .leaf
        case let .node(left, value, dim, right):
            let transformedValue = try transform(value)
            let leftTree = try left.map(transform)
            let rightTree = try right.map(transform)
            return KDTree<T>.node(left: leftTree, value: transformedValue, dimension: dim, right: rightTree)
        }
    }

    /// Returns a `KDTree` containing the elements of `self`,
    /// in order, that satisfy the predicate `includeElement`.
    ///
    /// - Complexity: O(N).
    public func filter(_ includeElement: (Element) throws -> Bool) rethrows -> KDTree {
        switch self {
        case .leaf:
            return self
        case let .node(left, value, dim, right):
            if try !includeElement(value) {
                let filteredElements = try (left.elements + right.elements).filter(includeElement)
                return KDTree(values: filteredElements)
            }
            else {
                return try KDTree.node(left: left.filter(includeElement), value: value,
                                       dimension: dim, right: right.filter(includeElement))
            }
        }
    }
    
    /// Call `body` on each element in `self` in the same order as a
    /// *for-in loop.*
    ///
    ///     kdTree.forEach {
    ///       // body code
    ///     }
    ///
    /// is similar to:
    ///
    ///     for element in sequence {
    ///       // body code
    ///     }
    ///
    /// - Note: You cannot use the `break` or `continue` statement to exit the
    ///   current call of the `body` closure or skip subsequent calls.
    /// - Note: Using the `return` statement in the `body` closure will only
    ///   exit from the current call to `body`, not any outer scope, and won't
    ///   skip subsequent calls.
    ///
    /// - Complexity: O(`self.count`)
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        switch self {
        case .leaf:
            return
        case let .node(left, value, _, right):
            try left.forEach(body)
            try body(value)
            try right.forEach(body)
        }
    }
    
    /// Call `body` on each node in `self` in the same order as a
    /// *for-in loop.*
    public func investigateTree(_ parents: [KDTree] = [], depth: Int = 0, body: (_ node: KDTree, _ parents: [KDTree], _ depth: Int) -> Void) {
        switch self {
        case .leaf:
            return
        case let .node(left, _, _, right):
            body(self, parents, depth)
            let nextParents = [self] + parents
            left.investigateTree(nextParents, depth: depth+1, body: body)
            right.investigateTree(nextParents, depth: depth+1, body: body)
        }
    }
}
