# GherkinSwift
A Gherkin parser implementation in [Swift](https://swift.org). It parses .feature files and generates an object structure where a `Feature` has e.g. a number of `Scenario`-s, which
in turn has `Step`-s etc.

For more information about Gherkin, see the [Gherkin github page](https://github.com/cucumber/cucumber/tree/master/gherkin).

Currently does not handle
* rule
* errors when parsing

## Usage
GherkinSwift exposes its functionality as a Swift library package. 

## Localization
GherkinSwift supports feature files in different languages, such as english:
```
Feature: an english feature
Scenario: an english scenario
   When something is done
   Then stuff happens
```

or swedish:
```
Egenskap: en svensk .feature-fil
Scenario: ett scenario på svenska
   Givet att världen är på ett visst sätt
   När något händer
   Så har världen ändrat på sig
```

The available languages can be found in the [`gherkin-languages.json`](https://github.com/danwaltin/GherkinSwift/blob/master/Sources/GherkinSwift/gherkin-languages.json) file.
