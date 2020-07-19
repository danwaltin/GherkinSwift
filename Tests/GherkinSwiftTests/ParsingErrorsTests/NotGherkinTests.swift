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

#warning("TODO: add test for invalid after docString")
class NotGherkinTests : TestErrorParseBase {
	func test_firstLineNotGherkin_message() {
		when_parsingDocument(
		"""
		lorem ipsum
		""")
		
		then_shouldReturnParseErrorWith(
			message: "(1:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'lorem ipsum'",
			location: Location(column: 1, line: 1))
		
	}

	func test_secondLineNotGherkin_message() {
		when_parsingDocument(
		"""
		
		rabarber
		""")
		
		then_shouldReturnParseErrorWith(
			message: "(2:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'rabarber'",
			location: Location(column: 1, line: 2))
	}

	func test_invalidBetweenFeatureTagAndFeature() {
		when_parsingDocument(
		"""
		@featureTag

		between

		Feature: blubb
		""")
		
		then_shouldReturnParseErrorWith(message:
			"(3:1): expected: #TagLine, #FeatureLine, #Comment, #Empty, got 'between'",
			location: Location(column: 1, line: 3))
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
		
		then_shouldReturnParseErrorWith(message:
			"(4:1): expected: #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'not gherkin'",
			location: Location(column: 1, line: 4))
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
		
		then_shouldReturnParseErrorWith(message:
			"(8:1): expected: #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'not gherkin'",
			location: Location(column: 1, line: 8))
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
		
		then_shouldReturnParseErrorWith(message:
			"(5:1): expected: #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'not gherkin'",
			location: Location(column: 1, line: 5))
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
		
		then_shouldReturnParseErrorWith(message:
			"(8:1): expected: #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'not gherkin'",
			location: Location(column: 1, line: 8))
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
		
		then_shouldReturnParseErrorWith(message:
			"(5:1): expected: #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'gherkin, not so much'",
			location: Location(column: 1, line: 5))
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
		
		then_shouldReturnParseErrorWith(message:
			"(7:1): expected: #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'nope, not gherkin'",
			location: Location(column: 1, line: 7))
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
		
		then_shouldReturnParseErrorWith(message:
			"(13:1): expected: #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'nope, not gherkin'",
			location: Location(column: 1, line: 13))
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
		
		then_shouldReturnParseErrorWith(message:
			"(6:1): expected: #TableRow, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'we expected a table row here!'",
			location: Location(column: 1, line: 6))
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
		
		then_shouldReturnParseErrorWith(message:
			"(7:1): expected: #TableRow, #StepLine, #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'we expected a table row here!'",
			location: Location(column: 1, line: 7))
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
		
		then_shouldReturnParseErrorWith(message:
			"(9:1): expected: #TableRow, #StepLine, #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'we expected a table row here!'",
			location: Location(column: 1, line: 9))
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
			"(2:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got \'no gherkin one\'",
			"(4:1): expected: #TagLine, #FeatureLine, #Comment, #Empty, got \'no gherkin two\'",
			"(8:1): expected: #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got \'no gherkin three\'",
			"(13:1): expected: #EOF, #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got \'no gherkin four\'",
			"(16:1): expected: #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got \'no gherkin five\'",
			"(20:1): expected: #EOF, #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got \'no gherkin six\'",
		])
		
		then_shouldReturnParseErrorWith(locations: [
			Location(column: 1, line: 2),
			Location(column: 1, line: 4),
			Location(column: 1, line: 7),
			Location(column: 1, line: 11),
			Location(column: 1, line: 14),
			Location(column: 1, line: 18)
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
