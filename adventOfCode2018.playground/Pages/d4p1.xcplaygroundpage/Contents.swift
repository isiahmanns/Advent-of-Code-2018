//: [Previous](@previous)

import Foundation

let data: [String] = try! String(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!).components(separatedBy: "\n").sorted()

var sleepData: Dictionary<Int, CounterBag<Int>> = [:]

let pattern: String = "\\[\\d{4}-\\d{2}-\\d{2} \\d{2}:(\\d{2})] (wakes up|falls asleep|Guard #(\\d+) begins shift)"
let regex: NSRegularExpression = try! NSRegularExpression(pattern: pattern,
                                                          options: [])

/*
//let expr: String = "[1518-09-20 00:43] falls asleep"
let expr: String = "[1518-05-14 23:58] Guard #1559 begins shift"
let match: NSTextCheckingResult! = regex.firstMatch(in: expr,
                                                    options: [],
                                                    range: NSRange(location: 0, length: expr.count))
match.numberOfRanges
match.range(at: 0) // whole match
match.range(at: 1) // time
match.range(at: 2) // a matched phrase
match.range(at: 3) // guard number (may or may not exist)
*/

var guardId: Int = -1
var sleepBegin: Int = -1
var sleepEnd: Int = -1

for expr in data {
    let match: NSTextCheckingResult! = regex.firstMatch(in: expr,
                                                        options: [],
                                                        range: NSRange(location: 0, length: expr.count))
    
    guard match != nil else {continue}
    
    let timeRange: NSRange = match.range(at: 1)
    let time: Int = Int(expr[Range(timeRange, in: expr)!])!
    
    let actionRange: NSRange = match.range(at: 2)
    let action: String = String(expr[Range(actionRange, in: expr)!])
    
    if action == "wakes up" {
        sleepEnd = time
        
        // save the minutes guard was asleep
        if sleepData[guardId] == nil {
            sleepData[guardId] = CounterBag<Int>()
        }
        
        for i in sleepBegin..<sleepEnd {
            sleepData[guardId]?.insert(i)
        }
    } else if action == "falls asleep" {
        sleepBegin = time
    } else {
        // guard is starting shift
        let guardIdRange: NSRange = match.range(at: 3)
        guardId = Int(expr[Range(guardIdRange, in: expr)!])!
    }
}

// who had the most sleep?
var maxMinutesSleep: Int = 0
let sleepiestGuard: Int = sleepData.reduce(-1, {
    if $1.value.count() > maxMinutesSleep {
        maxMinutesSleep = $1.value.count()
        return $1.key
    }
    
    return $0
})


let sleepiestMinute: Int = sleepData[sleepiestGuard]!.highestOccuringElement()!

let solution: Int = sleepiestGuard * sleepiestMinute

//: [Next](@next)
