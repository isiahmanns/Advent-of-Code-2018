//: [Previous](@previous)
import Foundation

let data: [Substring] = try! String(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!).split(separator: "\n")

var a: Int = 0
var b: Int = 0

for str in data {
    var letterCount: [Character:Int] = [:]
    
    for char in str {
        letterCount[char] = (letterCount[char] ?? 0) + 1
    }
    
    if letterCount.values.contains(3) {
        a += 1
    }
    
    if letterCount.values.contains(2) {
        b += 1
    }
}

print(a * b)

//: [Next](@next)
