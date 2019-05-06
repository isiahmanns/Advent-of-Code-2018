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

// create kdtree
var kdtree: KDTree<CGPoint> = KDTree<CGPoint>(values: coords)

// lookup for # of coords who nearest neighbor is <key> [CGPoint]
var areaCount: CounterBag<String> = CounterBag()

// set of islands who shouldn't be counted because they are infinite
var infiniteIslands: Set<String> = Set<String>()

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
        let twoNearestIslands: [CGPoint] = kdtree.nearestK(2, to: currPoint)
        
        // we want to credit the closer point if there isn't a tiebreaker
        if currPoint.squaredDistance(to: twoNearestIslands.first!) !=
            currPoint.squaredDistance(to: twoNearestIslands.last!) {
                let closestIsland: CGPoint = currPoint.squaredDistance(to: twoNearestIslands.first!) <
                                            currPoint.squaredDistance(to: twoNearestIslands.last!) ?
                                            twoNearestIslands.first! : twoNearestIslands.last!
            
                if x == leftMostX || x == rightMostX || y == topMostY || y == bottomMostY {
                    infiniteIslands.insert(closestIsland.debugDescription)
                }
            
                if !infiniteIslands.contains(closestIsland.debugDescription) {
                    areaCount.insert(closestIsland.debugDescription)
                }
        }
        
        y += 1
    }
    x += 1
    y = topMostY
}

print(areaCount.highestOccuringElement()!)
print(areaCount.lookup(areaCount.highestOccuringElement()!)!)


//: [Next](@next)
