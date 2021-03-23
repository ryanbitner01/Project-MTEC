/*:
 ## App Exercise - Workout Extensions

 >These exercises reinforce Swift concepts in the context of a fitness tracking app.

 Add an extension to the `Workout` struct below and make it adopt the `CustomStringConvertible` protocol.
 */
struct Workout {
    var distance: Double
    var time: Double
    var averageHR: Int
}

extension Workout: CustomStringConvertible {
    var description: String {
        return "Distance: \(distance), Time: \(time), AverageHR: \(averageHR)"
    }
    
}

extension Workout {
    var speed: Double {
        return distance/time
    }
    
    func harderWorkout() -> Workout {
        let doubleDistance = self.distance * 2
        let doubleTime = self.time * 2
        let harderHeartRate = averageHR + 40
        return Workout(distance: doubleDistance, time: doubleTime, averageHR: harderHeartRate)
    }
}
/*:
 Now create another extension for `Workout` and add a property `speed` of type `Double`. It should be a computed property that returns the average meters per second traveled during the workout.
 */


/*:
 In the second extension to `Workout`, add a `harderWorkout` method that takes no parameters and returns another `Workout` instance. This method should double the `distance` and `time` properties and add 40 to `averageHR`. Create an instance of `Workout` and print it to the console. Then call `harderWorkout` and print the new `Workout` instance to the console
 */
let workout1 = Workout(distance: 100, time: 50, averageHR: 45)
let harderWorkout = workout1.harderWorkout()

print(workout1)
print(harderWorkout)
//: [Previous](@previous)  |  page 2 of 2
