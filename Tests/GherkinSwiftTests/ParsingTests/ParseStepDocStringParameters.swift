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
//  ParseStepDocStringParameters.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-05.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseStepDocStringParameters: TestParseBase {
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
			.Given,
			"something",
			docString("Ada Lovelace"))

		then_shouldReturnScenarioWithStep(
			forScenario: 1,
			.Then,
			"something",
			docString("Alan Turing"))
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
			.Given,
			"something",
			docString("first line\n  second line indented two spaces"))
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
			.Given,
			"something",
			docString("first line\n\nthird line"))
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
			.Given,
			"something",
			docString("one line"))
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
			.Given,
			"something",
			docString("one line"))
	}

	// MARK: - Givens, whens, thens

	private func docString(_ content: String) -> DocString {
		return DocString(content: content, location: Location.zero())
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
}
