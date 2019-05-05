//: [Previous](@previous)
import Foundation

let input: String = try! String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!)
//print(input)

var i: Int = 0

for line in input.split(separator: "\n") {
    i += Int(line)!
}

print(i)

//: [Next](@next)
