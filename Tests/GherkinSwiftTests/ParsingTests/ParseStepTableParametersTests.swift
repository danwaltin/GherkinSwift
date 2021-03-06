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
//  ParseStepTableParametersTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-05.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseStepTableParametersTests: TestSuccessfulParseBase {
	func test_tableParametersToSteps_oneColumnOneRow() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    Given x
		        | Column |
		        | value  |
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.given,
			"x",
			table(
				"Column",
				"value"))
	}
	
	func test_tableParametersToSteps_oneColumnTwoRows() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    When y
		        | col |
		        | v1  |
		        | v2  |
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.when,
			"y",
			table(
				"col",
				"v1",
				"v2"))
	}
	
	func test_tableParametersToSteps_twoColumnsOneRow() {
		when_parsingDocument(
		"""
		Feature: featur
		Scenario: scenario
		    Then z
		        | c1   | c2   |
		        | r1c1 | r1c2 |
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.then,
			"z",
			table(
				"c1", "c2",
				"r1c1", "r1c2"))
	}
	
	func test_tableParametersToSteps_twoColumnsTwoRows() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    When alfa
		        | A | B |
		        | c | d |
		        | e | f |
		
		    Then beta
		        | G | H |
		        | i | j |
		        | k | l |
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 2)
		then_shouldReturnScenarioWithStep(
			atIndex: 0,
			.when,
			"alfa",
			table(
				"A", "B",
				"c", "d",
				"e", "f"))
		then_shouldReturnScenarioWithStep(
			atIndex: 1,
			.then,
			"beta",
			table(
				"G", "H",
				"i", "j",
				"k", "l"))
	}

	func test_tableParametersToSteps_withNewLine() {
		// need to use the parse method taking an array of lines,
		// we can't use the one taking one string, because one of the lines
		// contains newlines
		when_parsing([
			"Feature: feature",
			"Scenario: scenario",
			"   When x",
			"      | foobar          |",
			"      | \nalpha\nbeta\n |",
		])
		
		then_shouldReturnScenarioWithStep(
			atIndex: 0,
			.when,
			"x",
			table(
				"foobar",
				"\nalpha\nbeta\n"))
	}

	// MARK: - Givens, whens, thens

	private func then_shouldReturnScenarioWith(numberOfSteps expected: Int,
											   file: StaticString = #file, line: UInt = #line) {
		assert.scenario(0, file, line) {
			XCTAssertEqual($0.steps.count, expected, file: file, line: line)
		}
	}

	private func then_shouldReturnScenarioWithStep(atIndex index: Int = 0,
												   _ stepType: StepType,
												   _ text: String,
												   _ table: Table,
												   file: StaticString = #file, line: UInt = #line) {
		assert.step(stepType, text, table, atIndex: index, forScenario: 0, file, line)
	}
}
