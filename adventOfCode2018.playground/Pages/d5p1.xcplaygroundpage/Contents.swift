//: [Previous](@previous)

import Foundation

let data: String = try! String(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!).components(separatedBy: "\n")[0]
//let data = "dabAcCaCBAcCcaDA"
data.count

var stack: Stack<Character> = Stack<Character>()

for char in data {
    stack.push(char)
    
    // process stack
    if stack.count > 1 {
        // check top two elements and pop them if they react
        if abs(Int(stack.peek(0)!.unicodeScalars.first!.value) - Int(stack.peek(1)!.unicodeScalars.first!.value)) == 32 {
            stack.pop()
            stack.pop()
        }
    }
}

let solution: Int = stack.count

//: [Next](@next)
