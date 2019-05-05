//: [Previous](@previous)
import Foundation

let data: [String] = try! String(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!).components(separatedBy: "\n")

var fabric: Dictionary<Int, Int> = [:]
var inTact: Set<Int> = Set()

/*
 for _ in 0..<1000 {
 fabric.append(Array(repeating: ".", count: 1000))
 }
 */

let regex: NSRegularExpression = try! NSRegularExpression(pattern: "#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+)",
                                                          options: [])

for expr in data {
    let match: NSTextCheckingResult! = regex.firstMatch(in: expr,
                                                        options: [],
                                                        range: NSRange(location: 0, length: expr.count))
    
    guard match != nil else {continue}
    
    let idRange: NSRange = match.range(at: 1)
    let id: Int = Int(expr[Range(idRange, in: expr)!])!
    
    let lRange: NSRange = match.range(at: 2)
    let l: Int = Int(expr[Range(lRange, in: expr)!])!
    
    let tRange: NSRange = match.range(at: 3)
    let t: Int = Int(expr[Range(tRange, in: expr)!])!
    
    let wRange: NSRange = match.range(at: 4)
    let w: Int = Int(expr[Range(wRange, in: expr)!])!
    
    let hRange: NSRange = match.range(at: 5)
    let h: Int = Int(expr[Range(hRange, in: expr)!])!
    
    var rectVisted: Bool = false
    
    // process claim
    for i in 0..<h {
        for j in 0..<w {
            let index: Int = (t + i) * 1000 + (l + j)
            
            if let prevId = fabric[index] {
                rectVisted = true
                inTact.remove(prevId)
            }
            
            fabric[index] = id
        }
    }
    
    // every cell has been processed
    if !rectVisted {
        inTact.insert(id)
    }
}

print(inTact)

//: [Next](@next)
