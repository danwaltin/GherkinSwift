// ------------------------------------------------------------------------
// Copyright 2020 Dan Waltin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ------------------------------------------------------------------------
//
//  NotGherkinTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-16.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

// #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty
// #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty
// #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty
// #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty
class NotGherkinTests : TestErrorParseBase {
	func test_firstLineNotGherkin_message() {
		when_parsingDocument(
		"""
		lorem ipsum
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'lorem ipsum'")
		
	}

	func test_secondLineNotGherkin_message() {
		when_parsingDocument(
		"""
		
		rabarber
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'rabarber'")
	}

	func test_invalidBetweenFeatureTagAndFeature() {
		when_parsingDocument(
		"""
		@featureTag

		between

		Feature: blubb
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'between'")
	}

	func test_invalidBetweenScenarioTagAndFirstScenario() {
		when_parsingDocument(
		"""
		Feature: feature
		@firstTag
		
		not gherkin
		Scenario: first

		@secondTag
		
		Scenario: second
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidBetweenScenarioTagAndSecondScenario() {
		when_parsingDocument(
		"""
		Feature: feature
		@firstTag
		
		Scenario: first

		@secondTag
		
		not gherkin
		Scenario: second
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidAfterScenarioStepFirstScenario() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: first
		   Given something

		not gherkin

		Scenario: second
		   Given something else
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidAfterScenarioStepSecondScenario() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: first
		   Given something

		Scenario: second
		   Given something else
		
		not gherkin
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidAfterBackgroundStep() {
		when_parsingDocument(
		"""
		Feature: blubb
		Background:
			Given stuff

		gherkin, not so much

		Scenario: blabb
		   Given something

		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'gherkin, not so much'")
	}

	func test_invalidAfterScenarioStepTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: first
		   Given something
		      | header |
		      | row    |

		not gherkin
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidAfterScenarioStepDocString() {
		given_docStringSeparator("===", alternative: "---")

		when_parsingDocument(
		"""
		Feature: feature
		Scenario: first
		   Given something
		      ===
		      lorem ipsum
		      ===

		not gherkin
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidAfterBackgroundStepTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Background:
		   Given something
		      | header |
		      | row    |

		not gherkin
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidAfterBackgroundStepDocString() {
		given_docStringSeparator("===", alternative: "---")

		when_parsingDocument(
		"""
		Feature: feature
		Background:
		   Given something
		      ===
		      lorem ipsum
		      ===

		not gherkin
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'not gherkin'")
	}

	func test_invalidBetweenExamplesTagAndFirstExamples() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario Outline: things on the sky becomes visible
		   Given the <thing> becomes visible
		   
		   @firstTag

		   nope, not gherkin
		   Examples: first
		      | thing |
		      | sun   |

		   @secondTag

		   Examples: second
		      | thing |
		      | moon  |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'nope, not gherkin'")
	}

	func test_invalidBetweenExamplesTagAndSecondExamples() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario Outline: things on the sky becomes visible
		   Given the <thing> becomes visible
		   
		   @firstTag

		   Examples: first
		      | thing |
		      | sun   |

		   @secondTag

		   nope, not gherkin
		   Examples: second
		      | thing |
		      | moon  |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'nope, not gherkin'")
	}

	func test_invalidInScenarioStepTable() {
		when_parsingDocument(
		"""
		Feature: f
		Scenario: s
		   Given the following customers
		      | Customer     |
		      | Ada Lovelace |
		      we expected a table row here!
		      | Alan Turing  |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'we expected a table row here!'")
	}

	func test_invalidInBackgroundStepTable() {
		when_parsingDocument(
		"""
		Feature: f

		Background:
		   Given the following customers
		      | Customer     |
		      | Ada Lovelace |
		      we expected a table row here!
		      | Alan Turing  |

		Scenario: s
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'we expected a table row here!'")
	}

	func test_invalidInExamplesTable() {
		when_parsingDocument(
		"""
		Feature: f

		Scenario Outline: s
		   Given the customer <customer>
		
		Examples:
		      | customer     |
		      | Ada Lovelace |
		      we expected a table row here!
		      | Alan Turing  |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "expected: X, got 'we expected a table row here!'")
	}

	func test_severalNonGherkinLines() {
		when_parsingDocument(
		"""
		
		no gherkin one
		@featureTag
		no gherkin two
		Feature: several errors
		   @scenarioTag

		no gherkin three

		   Scenario: foo
		      Given bar

		no gherkin four

		   @scenarioTag
		no gherkin five
		   Scenario: bar
		      Given foo

		no gherkin six
		""")
		
		then_shouldReturn(numberOfParseErrors: 6)
		
		then_shouldReturnParseErrorWith(messages: [
			"expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got \'no gherkin one\'",
			"expected: #TagLine, #FeatureLine, #Comment, #Empty, got \'no gherkin two\'",
			"expected: X, got \'no gherkin three\'",
			"expected: X, got \'no gherkin four\'",
			"expected: X, got \'no gherkin five\'",
			"expected: X, got \'no gherkin six\'",
		])
		
		then_shouldReturnParseErrorWith(locations: [
			Location(column: 1, line: 2),
			Location(column: 1, line: 4),
			Location(column: 1, line: 8),
			Location(column: 1, line: 13),
			Location(column: 1, line: 16),
			Location(column: 1, line: 20)
		])
	}

	// MARK: - helpers
	private func then_shouldReturn(numberOfParseErrors expected: Int, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(file, line) {
			XCTAssertEqual($0.count, expected, file: file, line: line)
		}
	}
	
	private func then_shouldReturnParseErrorWith(message: String,
												 location: Location,
												 file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessage: message, file, line)
		assert.parseError(withLocation: location, file, line)
	}

	private func then_shouldReturnParseErrorWith(message: String,
												 file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessage: message, file, line)
	}

	private func then_shouldReturnParseErrorWith(messages: [String], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessages: messages, file, line)
	}

	private func then_shouldReturnParseErrorWith(location: Location, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocation: location, file, line)
	}

	private func then_shouldReturnParseErrorWith(locations: [Location], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocations: locations, file, line)
	}
}
