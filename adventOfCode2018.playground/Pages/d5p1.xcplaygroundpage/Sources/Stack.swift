import Foundation

public class Stack<T> {
    private class Node<T> {
        var value: T
        var next: Node<T>?
        weak var prev: Node<T>?
        
        init(_ value: T) {
            self.value = value
            self.next = nil
            self.prev = nil
        }
    }
    
    private var root: Node<T>!
    private var last: Node<T>!
    private(set) public var count: Int = 0
    
    public init() {}
    
    public func push(_ elem: T) -> Void {
        let newNode: Node<T> = Node(elem)

        if root == nil {
            root = newNode
            last = root
        } else {
            let tmp: Node<T> = last
            last.next = newNode
            last = last.next
            last.prev = tmp
        }
        
        count += 1
    }
    
    public func pop() -> Void {
        if root === last {
            root = nil
            last = nil
            count = 0
        } else {
            last = last.prev
            last.next = nil
            count -= 1
        }
    }
    
    public func peek(_ offset: Int) -> T? {
        var i: Int = 0
        var node: Node<T>? = last
        
        while i < offset && node != nil {
            node = node!.prev
            i += 1
        }
        
        return node != nil ? node!.value : nil
    }
    
    public func contents() -> [T] {
        var node: Node<T>! = root
        
        guard node != nil else {return []}
        
        var contents: [T] = []
        while node != nil {
            contents.append(node.value)
            node = node.next
        }
        
        return contents
    }
}
