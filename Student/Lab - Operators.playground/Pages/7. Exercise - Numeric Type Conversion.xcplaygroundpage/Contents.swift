/*:
 ## Exercise - Numeric Type Conversion

 Create an integer constant `x` with a value of 10, and a double constant `y` with a value of 3.2. Create a constant `multipliedAsIntegers` equal to `x` times `y`. Does this compile? If not, fix it by converting your `Double` to an `Int` in the mathematical expression. Print the result.
 */
let x = 10
let y = 3.2
//let multpiedAsIntegers = x * y
// Does not run
let multipliedAsIntegers = x * Int(y)
print(multipliedAsIntegers)

/*:
 Create a constant `multipliedAsDoubles` equal to `x` times `y`, but this time convert the `Int` to a `Double` in the expression. Print the result.
 */
let multipliedAsDoubles = Double(x) * y
print(multipliedAsDoubles)
/*:
 Are the values of `multipliedAsIntegers` and `multipliedAsDoubles` different? Print a statement to the console explaining why.
 */
print("They are different because as ints it cuts the 3.2 short making it 10 * 3 = 30 but as a double it makes it 10 * 3.2 which is 32")

//: [Previous](@previous)  |  page 7 of 8  |  [Next: App Exercise - Converting Types](@next)
