/*:
 ## Exercise - Type Casting and Inspection
 
 Create a collection of type [Any], including a few doubles, integers, strings, and booleans within the collection. Print the contents of the collection.
 */
let myCollection: [Any] = [0.2, 2, "Hello", "Good Morning", true]
print(myCollection)
/*:
 Loop through the collection. For each integer, print "The integer has a value of ", followed by the integer value. Repeat the steps for doubles, strings and booleans.
 */
for i in myCollection {
    if let num = i as? Int {
        print("The integer has a value of \(num)")
    } else if let num = i as? Double {
        print("The double has a value of \(num)")
    } else if let myString = i as? String {
        print("The string has a value of \(myString)")
    } else if let myBool = i as? Bool {
        print("The boolean value is \(myBool)")
    }
}

/*:
 Create a [String : Any] dictionary, where the values are a mixture of doubles, integers, strings, and booleans. Print the key/value pairs within the collection
 */
let myStringDictionary: [String: Any] = ["Dog": 42, "Tack Sa Mycket": "Swedish", "Percentage": 0.42, "Statement": true, "Random Value": "34.0"]

for i in myStringDictionary {
    print(i.key, i.value)
}
/*:
 Create a variable `total` of type `Double` set to 0. Then loop through the dictionary, and add the value of each integer and double to your variable's value. For each string value, add 1 to the total. For each boolean, add 2 to the total if the boolean is `true`, or subtract 3 if it's `false`. Print the value of `total`.
 */
var total: Double = 0

for i in myStringDictionary.values {
    if let myInt = i as? Int {
        total += Double(myInt)
    } else if let myDouble = i as? Double {
        total += myDouble
    } else if i is String {
        total += 1
    } else if let myBool = i as? Bool {
        if myBool == true {
            total += 2
        } else {
            total -= 3
        }
    }
}

print(total)
/*:
 Create a variable `total2` of type `Double` set to 0. Loop through the collection again, adding up all the integers and doubles. For each string that you come across during the loop, attempt to convert the string into a number, and add that value to the total. Ignore booleans. Print the total.
 */
var total2: Double = 0

for i in myStringDictionary.values {
    if let myInt = i as? Int {
        total2 += Double(myInt)
    } else if let myDouble = i as? Double {
        total2 += myDouble
    } else if let myString = i as? String {
        if let unwrappedString = Double(myString) {
            total2 += unwrappedString
        }
    }
}

print(total2)
//: page 1 of 2  |  [Next: App Exercise - Workout Types](@next)
