//: [Previous](@previous)
import Foundation

func differByOne(a: Substring, b: Substring) -> Bool {
    if a.count != b.count {
        return false
    }
    
    var count: Int = 0
    for i in 0..<a.count {
        if a[a.index(a.startIndex, offsetBy: i)] != b[b.index(b.startIndex, offsetBy: i)] {
            count += 1
        }
    }
    
    return count == 1
}

let data: [Substring] = try! String(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!).split(separator: "\n")

for i in 0..<data.count-1 {
    for j in i+1..<data.count {
        if differByOne(a: data[i], b: data[j]) {
            print(data[i], data[j])
        }
    }
}



//: [Next](@next)
