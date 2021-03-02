/*:
 ## App Exercise - Similar Workouts

 >These exercises reinforce Swift concepts in the context of a fitness tracking app.

 In previous app exercises, you used inheritance to enforce similar behavior between different kinds of workouts. You can also enforce shared behavior between different workouts using protocols.

 Create a protocol called `Workout` with two requirements: a settable property called `distance` and a settable property called `time`, both of type `Double`.
 */
protocol Workout {
    var distance: Double {get set}
    var time: Double {get set}
}

/*:
 Create two structs, `RunningWorkout` and `SwimmingWorkout`. Both should adopt the `Workout` protocol. Uncomment the function `simpleWorkoutDescription(workout:)` below, create an instance of each of your structs, and call `simpleWorkoutDescription(workout:)` twice, passing in a `RunningWorkout` object and then a `SwimmingWorkout` object.
 */
func simpleWorkoutDescription(workout: Workout) {
    print("You went \(workout.distance) meters in \(workout.time) seconds.")
}

struct RunningWorkout: Workout {
    var distance: Double
    var time: Double
}

struct SwimmingWorkout: Workout {
    var distance: Double
    var time: Double
}

let workout1 = RunningWorkout(distance: 10, time: 34)
let workout2 = SwimmingWorkout(distance: 14, time: 45)

simpleWorkoutDescription(workout: workout1)
simpleWorkoutDescription(workout: workout2)



//: [Previous](@previous)  |  page 4 of 5  |  [Next: App Exercise - Heart Rate Delegate](@next)
