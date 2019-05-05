//: [Previous](@previous)
import Foundation

let data: String = try! String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)

var i: Int = 0
var set: Set = [i]
var duplicateDetected: Bool = false
var arr: [Int] = [Int]()

for j in data.split(separator: "\n") {
    arr.append(Int(j)!)
}

while !duplicateDetected {
    for j in 0..<arr.count {
        i += arr[j]
        if set.contains(i) {
            print(i)
            duplicateDetected = true
            break
        } else {
            set.insert(i)
        }
    }
}


//: [Next](@next)
