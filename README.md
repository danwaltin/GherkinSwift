# GherkinSwift
A Gherkin parser implementation in [Swift](https://swift.org). It parses .feature files and generates an object structure where a `Feature` has e.g. a number of `Scenario`-s, which
in turn has `Step`-s etc.

For more information about Gherkin, see the [Gherkin github page](https://github.com/cucumber/cucumber/tree/master/gherkin).

Currently does not handle the keyword `Rule`.

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

## Differences to the cucumber project
The json serialization of parsing errors is different from the cucumber project.

### Unexpected EOF
The expected tags error message in json testfile for unexpected eof (`unexpected_eof.feature.errors.ndjson`) is changed.
An `#ExamplesLine` is added.

**GherkinSwift**
`#TagLine, #ExamplesLine, #ScenarioLine, #Comment, #Empty`

**Cucumber json**
`#TagLine, #ScenarioLine, #Comment, #Empty`

### Arrays of parse error objects
The errors are serialized to an array of parse error objects. The parse error "bad" test files 
have been changed.

**GherkinSwift**
```
[
  {
    "parseError": {
    }
  },
  {
    "parseError": {
    }
  }
]
```
**Cucumber json**
```
{
  "parseError": {
  }
}
{
  "parseError": {
  }
}
```

**GherkinSwift, multiple_parser_error**
```
[
  {
    "parseError": {
      "message": "(2:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'invalid line here'",
      "source": {
        "location": {
          "column": 1,
          "line": 2
        },
        "uri": "testdata/bad/multiple_parser_errors.feature"
      }
    }
  },
  {
    "parseError": {
      "message": "(9:1): expected: #EOF, #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'another invalid line here'",
      "source": {
        "location": {
          "column": 1,
          "line": 9
        },
        "uri": "testdata/bad/multiple_parser_errors.feature"
      }
    }
  }
]
```
**Cucumber json, multiple_parser_error**
```
{
  "parseError": {
    "message": "(2:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'invalid line here'",
	"source": {
	  "location": {
		"column": 1,
		"line": 2
	  },
	  "uri": "testdata/bad/multiple_parser_errors.feature"
	}
  }
}
{
  "parseError": {
	"message": "(9:1): expected: #EOF, #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'another invalid line here'",
	"source": {
	  "location": {
		"column": 1,
		"line": 9
	  },
	  "uri": "testdata/bad/multiple_parser_errors.feature"
	}
  }
}
```
