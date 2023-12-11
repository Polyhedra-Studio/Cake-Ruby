# Cake
The tiniest unit tester, ported to Ruby

# How to write unit tests
- Cake will search for anything that has .cake.rb for the file name in the directory that it's run in
- Example of how to write unit tests:
```ruby
require_relative 'cake'

TestRunner.new('Test Runner - Basic', [
  Group.new('Group Basic', [
    Test.new(
      'True should be true',
      action: ->(test) {
              value = 'foo'
              test.actual = value
              test.expected = value
            },
      assertions: ->(test) { [Expect::Equals.new(actual: test.actual, expected: test.expected)] }
    )
  ])
])
```

You can also pass variables from parents and test stages.

```ruby
  Group.new('Groups can assign context', [
    Test.new(
      'Group can pass context to children',
      assertions: ->(test) { [Expect::Equals.new(actual: test.foo, expected: 'bar')] }
    ),
    Test.new(
      'Children can override parent context',
      action: ->(test) { test.foo = 'baz' },
      assertions: ->(test) { [Expect::Equals.new(actual: test.foo, expected: 'baz')] }
    )
  ], setup: ->(test) {
    test.foo = 'bar'
  }),
```


# Expect Matches
- Equals
- IsNotEqual
- IsNil
- IsNotNil
- IsTrue
- IsFalse
- RespondTo
- Undefined
- DoesNotRespondTo (synonym for Undefined)

# How to run the test runner
- The package will need to run globally. Install via this command:
`gem install cake-tester`
- After it's installed, you can run it by using `cake-tester` in the directory that you want to run your tests in. It will search any files in the directory or any sub-folders ending with `cake.rb`.
- You can also add flags to run specific tests or view output from specific tests.

## Flags

### File name filter
- `-f [fileName]`
  - Filters tests based off of file name
  - EX: `cake-tester -f foo` will test 'test-foo.cake.rb'

### Verbose mode
- `-v` or `--verbose`
  - Displays full output of summary and tests run

### Test Filter
- `-t [testFilter]`, `--tt [testFilter]`, `--tte [testName]`,  `--tg [groupFilter]`, `--tge [groupName]`, `--tr [testRunnerFilter]`, `--tre [testRunnerName]`
  - All of these do similar things, which filters based off of title of the item. You can also use certain tags to run only a group, test runner, or a specific test.
  - Note - search is case-sensitive.
  - Examples: 
    - `-t` **General search:** `ruby cake-tester -t foo` - Run all tests, groups, and runners with "foo" in the title
    - `--tt` **Test search** `ruby cake-tester --tt "cool test"` - Run all tests with the phrase "cool test" in the title
    - `--tte` **Test search, exact:** `ruby cake-tester --tte "should only run when this one specific thing happens"` - Runs only the test that matches the phrase exactly.
    - `--tg` **Group search** `ruby cake-tester --tg bar` - Run all groups matching "bar" in the title
    - `--tge` **Group search, exact:** `ruby cake-tester --tge "API Endpoints" - Runs all groups _exactly_ matching the phrase "API Endpoints"
    - `--tr` **Test Runner search:** `ruby cake-tester --tr "Models" - Runs all test runners with "Models" in the title
    - `--tre` **Test Runner search, exact:** `ruby cake-tester --tre "Models - User"` - Runs test runners that _exactly_ match the phrase "Models - User" 

### Interactive mode
- `-i`
  - Allows for repeatedly running tests. You can also use the test filters similar to non-interactive mode's syntax.
  * Note this is not yet implemented with this version.