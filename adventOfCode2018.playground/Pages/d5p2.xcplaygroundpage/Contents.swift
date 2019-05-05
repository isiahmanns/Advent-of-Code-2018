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
let solutionContents: [Character] = stack.contents()


// solution 2 using solution 1
var minCount: Int = data.count

for i in 0..<26 {
    // keep track of minimum count by excluding each upper/lowercase letter of alphabet
    let upperCase: Character = Character(UnicodeScalar(65 + i)!)
    let lowerCase: Character = Character(UnicodeScalar(65 + i + 32)!)
    
    // build a stack like before, using this new data
    stack.clear()
    
    for char in solutionContents {
        if !(char == upperCase || char == lowerCase) {
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
    }
    
    if stack.count < minCount {
        minCount = stack.count
    }
}

minCount


//: [Next](@next)
