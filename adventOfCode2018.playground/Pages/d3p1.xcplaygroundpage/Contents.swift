//: [Previous](@previous)
import Foundation

let data: [String] = try! String(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!).components(separatedBy: "\n")

var fabric: Dictionary<Int, Int> = [:]
//var usedTiles: Set<Int> = Set()

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
    
    // process claim
    for i in 0..<h {
        for j in 0..<w {
            let index: Int = (t + i) * 1000 + (l + j)
            
            if let _ = fabric[index] {
                // in use at least once before
                fabric[index] = 2
            } else {
                fabric[index] = 1
            }
        }
    }
}

print(fabric.values.reduce(0, {$1 == 2 ? $0 + 1 : $0}))
//: [Next](@next)
