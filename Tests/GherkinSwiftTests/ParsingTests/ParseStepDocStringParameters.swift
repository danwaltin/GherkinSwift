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
	func test_docStringParametersToScenarioStep_oneRow() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
			Given something
			  ===
			  one line
			  ===
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.Given,
			"something",
			docString([
				"one line"]))
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
			docString([
				"one line"]))
	}

	
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
			docString([
				"one line"]))
	}

	// MARK: - Givens, whens, thens

	private func docString(_ lines: [String]) -> DocString {
		return DocString()
	}
	
	private func then_shouldReturnScenarioWith(numberOfSteps expected: Int,
											   file: StaticString = #file, line: UInt = #line) {
		assert.scenario(0, file, line) {
			XCTAssertEqual($0.steps.count, expected, file: file, line: line)
		}
	}

	private func then_shouldReturnScenarioWithStep(atIndex index: Int = 0,
												   _ stepType: StepType,
												   _ text: String,
												   _ docString: DocString,
												   file: StaticString = #file, line: UInt = #line) {
		assert.step(stepType, text, docString, atIndex: index, forScenario: 0, file, line)
	}
}
