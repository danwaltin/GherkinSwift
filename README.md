# GherkinSwift
A Gherkin parser implementation in [Swift](https://swift.org). It parses .feature files and generates an object structure where a `Feature` has e.g. a number of `Scenario`-s, which
in turn has `Step`-s etc.


For more information about Gherkin, see the [Gherkin github page](https://github.com/cucumber/cucumber/tree/master/gherkin).

Currently does not handle
* rule
* errors when parsing

## Usage
GherkinSwift exposes its functionality as a Swift library package. 

