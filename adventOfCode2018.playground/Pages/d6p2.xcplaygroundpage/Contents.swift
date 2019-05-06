//: [Previous](@previous)

import Foundation
import CoreGraphics

var data: [String] = try! String(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!).components(separatedBy: "\n")
data.removeLast() // get rid of extra "\n"
// data.last!

var coords: [CGPoint] = []

for entry in data {
    let coord: [String] = entry.components(separatedBy: ", ")
    coords.append(CGPoint(x: Int(coord[0])!, y: Int(coord[1])!))
}

var count: Int = 0

// determine rectangle of curiosity (starts from top-left-most to bottom-right-most point)
var leftMostX: CGFloat = CGFloat(Int.max)
var topMostY: CGFloat = CGFloat(Int.max)
var rightMostX: CGFloat = 0.0
var bottomMostY: CGFloat = 0.0

for coord in coords {
    if coord.x < leftMostX {
        leftMostX = coord.x
    }
    
    if coord.x > rightMostX {
        rightMostX = coord.x
    }
    
    if coord.y < topMostY {
        topMostY = coord.y
    }
    
    if coord.y > bottomMostY {
        bottomMostY = coord.y
    }
}

leftMostX
topMostY
rightMostX
bottomMostY

var x: CGFloat = leftMostX
var y: CGFloat = topMostY

// iterate from <leftMostX, topMostY> to <rightMostX, bottomMostY>
while x <= rightMostX {
    while y <= bottomMostY {
        let currPoint: CGPoint = CGPoint(x: x, y: y)
        let totalDistance: CGFloat = coords.reduce(0.0, {$0 + abs(currPoint.x - $1.x) + abs(currPoint.y - $1.y)})
        if totalDistance < 10000 {
            count += 1
        }
        
        y += 1
    }
    x += 1
    y = topMostY
}

print(count)


//: [Next](@next)
