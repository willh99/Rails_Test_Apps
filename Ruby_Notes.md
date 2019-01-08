# Ruby Notes
### Getting Started with the Basics
#### Printing to the Command Line

* `puts` method - Prints a string to the cli with a break at the end
  * Ex: `puts "Hello World" --> Hello World\n`
* `print` method - Prints a string to the cli
  * Ex: `puts "Hello World" --> Hello World`
* `p` method - Prints a string literal to the cli
  * Equilvalent to `mystring.inspect`
 * Some useful string related methods:
   * `.upcase`, `.downcase`, `.capitalize`, and `.swapcase`
   * `.include?`
   * `.length` or `.size`
   * `.reverse`
   * `.empty?` or `.nil?`
   * `mystring[3]` or `mystring.slice(3)`
   * `mystring[3, 6]` or `mystring.slice(3, 6)`
   * * `.to_i` or `.to_f` - Converts to an integer or float
   * `mystring.gsub(/s/, "th")`
   * `mystring.split(" ")`
 
#### Comments

  

The `#` character is used for single line comments.

Multi-line comments are written as follows.
```ruby
puts "Hello World"
=begin
Stuff in here is a multi-line comment.
At least it is as of this line.
=end
```

#### Parallel Variable Assignment
Variables can be assigned as used in parallel (written in one line) as follows:
```ruby
a, b, c = 10, 20, 30
p a, b, c

=begin
Output:
10
20
30
=end
# Variable Swaping
a, b = b, a
```

#### String Interpolation
Example:
```ruby
p "Hello #{name}!"
```

#### `gets` and `chomp` methods
* `gets` retrieves a command line inputs from the user
* `chomp` - removes an extra line from the end of a string (from `gets` for example)

### Getting Under the Hood with Ruby

#### Numbers
Numbers in Ruby are either integers or floating point numbers. All numbers are objects and can therefore have methods called upon them. For example:
```ruby
1.next # = 2
p 1.to_s # "1"
1.class # Fixnum
1.01.class # Float
999999999999999999999999999999999999.class # Bignum
1.odd? # true
1.even? # false
3.between?(1, 5) # true
1.5.floor # = 1
1.5.ceil # = 2
3.1415.round # = 3
3.1415.round(3) # = 3.142
-381.abs # = 381
```

#### Equality/Comparison
Basically the same as other common programming languages. Just look it up if it behaves in an unexpected manner.
