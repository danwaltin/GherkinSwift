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

	func test_invalidBetweenScenarioTagAndScenario() {
		when_parsingDocument(
		"""
		Feature: blubb
		@scenarioTag
		
		not gherkin
		Scenario: blabb
		""")
		
		then_shouldReturnParseErrorWith(message:
			"(4:1): expected: #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'not gherkin'",
			location: Location(column: 1, line: 4))
	}

	func test_invalidAfterScenarioStep() {
		when_parsingDocument(
		"""
		Feature: blubb
		Scenario: blabb
		   Given something

		not gherkin
		""")
		
		then_shouldReturnParseErrorWith(message:
			"(5:1): expected: #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'not gherkin'",
			location: Location(column: 1, line: 5))
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

	func test_invalidBetweenExamplesTagAndExamples() {
		when_parsingDocument(
		"""
		Feature: f
		Scenario Outline: s
		   Given the <thing> becomes visible
		   
		   @examplesTag
		   nope, not gherkin
		   Examples:
		      | thing |
		      | sun   |
		""")
		
		then_shouldReturnParseErrorWith(message:
			"(6:1): expected: #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty, got 'nope, not gherkin'",
			location: Location(column: 1, line: 6))
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
