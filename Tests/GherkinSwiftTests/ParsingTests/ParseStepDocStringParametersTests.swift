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
//  ParseStepDocStringParametersTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-05.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseStepDocStringParametersTests: TestSuccessfulParseBase {
	// MARK: - Scenario
	func test_docStringParametersToScenarioStep_oneRow() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: regular
			Given something
			  ===
			  Ada Lovelace
			  ===
		Scenario: alternative
			Then something
			  ---
			  Alan Turing
			  ---
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			forScenario: 0,
			.given,
			"something",
			docString("Ada Lovelace", "==="))

		then_shouldReturnScenarioWithStep(
			forScenario: 1,
			.then,
			"something",
			docString("Alan Turing", "---"))
	}

	func test_docStringParametersToScenarioStep_twoRows_withIndentation() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		   Given something
		     ===
		     first line
		       second line indented two spaces
		     ===
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.given,
			"something",
			docString("first line\n  second line indented two spaces", "==="))
	}

	func test_docStringParametersToScenarioStep_threeRows_middleEmpty() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		   Given something
		     ===
		     first line

		     third line
		     ===
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.given,
			"something",
			docString("first line\n\nthird line", "==="))
	}

	func test_docStringParametersToScenarioStep_usingAlternateSeparator() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
			Given something
			  ---
			  one line
			  ---
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.given,
			"something",
			docString("one line", "---"))
	}

	func test_docStringParametersToScenarioStep_mediaType() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
			Given something
			  ===xml
			  <one>line</one>
			  ===
		""")

		then_shouldReturnDocString(withMediaType: "xml");
	}

	func test_docStringParametersToScenarioStep_withoutMediaType() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
			Given something
			  ===xml
			  <one>line</one>
			  ===
		""")

		then_shouldReturnDocString(withMediaType: "xml");
	}

	func test_docStringParametersToScenarioStep_alternateSeparatorInside() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
			Given something
		      ===
		      one
		      ---
		      two
			  ===
		""")

		then_shouldReturnDocString(withContent: "one\n---\ntwo")
	}

	// MARK: - Scenario Outline
	func test_docStringParametersToScenarioOulineStep_oneRow() {
		given_docStringSeparator("===", alternative: "---")

		when_parsingDocument(
		"""
		Feature: feature
		Scenario Outline: scenario
			Given something
			  ===
			  one line
			  ===
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.given,
			"something",
			docString("one line", "==="))
	}

	// MARK: - Tag character in doc string
	func test_docStringParameter_withTagCharacter() {
		given_docStringSeparator("===", alternative: "---")

		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario with docString
		   Given something
		      ===
		      @thisLooksLikeATag but it's not
		      ===
		
		Scenario: second scenario
		   Given another thing
		""")

		then_shouldReturnScenarioWithStep(
			forScenario: 0,
			.given,
			"something",
			docString("@thisLooksLikeATag but it's not", "==="))
	}

	func test_docStringParameter_withTagCharacter_inBackground() {
		given_docStringSeparator("===", alternative: "---")

		when_parsingDocument(
		"""
		Feature: feature
		Background:
		   Given something
		      ===
		      @thisLooksLikeATag but it's not
		      ===
		
		Scenario: second scenario
		   Given another thing
		""")

		then_shouldReturnScenarioWithStep(
			forScenario: 0,
			.given,
			"something",
			docString("@thisLooksLikeATag but it's not", "==="))
	}

	// MARK: - Table in doc string
	func test_docStringParameter_withTable() {
		given_docStringSeparator("===", alternative: "---")

		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario with docString
		   Given something
		      ===
		      | this | looks   |
		      | like | a table |
		      ===
		
		Scenario: second scenario
		   Given another thing
		""")

		then_shouldReturnScenarioWithStep(
			forScenario: 0,
			.given,
			"something",
			docString("| this | looks   |\n| like | a table |", "==="))
	}

	// MARK: - Givens, whens, thens

	private func docString(_ content: String, _ separator: String) -> DocString {
		return DocString(separator: separator, content: content, location: Location.zero(), mediaType: nil)
	}
	
	private func then_shouldReturnScenarioWith(numberOfSteps expected: Int,
											   file: StaticString = #file, line: UInt = #line) {
		assert.scenario(0, file, line) {
			XCTAssertEqual($0.steps.count, expected, file: file, line: line)
		}
	}

	private func then_shouldReturnScenarioWithStep(atIndex index: Int = 0,
												   forScenario scenarioIndex: Int = 0,
												   _ stepType: StepType,
												   _ text: String,
												   _ docString: DocString,
												   file: StaticString = #file, line: UInt = #line) {
		assert.step(stepType, text, docString, atIndex: index, forScenario: scenarioIndex, file, line)
	}
	
	private func then_shouldReturnDocString(withMediaType mediaType: String?,
											file: StaticString = #file, line: UInt = #line) {
		assert.stepDocStringParameter(stepIndex: 0, forScenario: 0, file, line) {
			XCTAssertEqual($0.mediaType, mediaType, file: file, line: line)
		}
	}

	private func then_shouldReturnDocString(withContent content: String,
											file: StaticString = #file, line: UInt = #line) {
		assert.stepDocStringParameter(stepIndex: 0, forScenario: 0, file, line) {
			XCTAssertEqual($0.content, content, file: file, line: line)
		}
	}
}
