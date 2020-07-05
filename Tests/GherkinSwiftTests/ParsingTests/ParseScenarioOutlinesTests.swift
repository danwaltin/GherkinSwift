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
//  ParseScenarioOutlinesTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseScenarioOutlinesTests: TestParseBase {
	func test_oneScenarioOutlineWithOneExampleShouldReturnScenarioWithName() {
		when_parsing([
			"Feature: feature name            ",
			"Scenario Outline: scenario name  ",
			"    Given given <alpha>          ",
			"    When when <beta>             ",
			"    Then then <gamma>            ",
			"                                 ",
			"    Examples:                    ",
			"        | alpha | beta | gamma | ",
			"        | one   | two  | three | "])

		then_shouldReturnScenariosWithNames([
			"scenario name"]
		)
		then_shouldReturnScenarioWith(numberOfSteps: 3)
		
		then_shouldReturnScenarioWithStep(atIndex: 0, .Given, "given <alpha>")
		then_shouldReturnScenarioWithStep(atIndex: 1, .When, "when <beta>")
		then_shouldReturnScenarioWithStep(atIndex: 2, .Then, "then <gamma>")
	}
	
	// MARK: - Table parameters to steps
	
	func test_tableParametersToSteps() {
		when_parsing([
			"Feature: feature          ",
			"Scenario Outline: scenario",
			"    Given x               ",
			"        | Column |        ",
			"        | <key>  |        ",
			"                          ",
			"    Examples:             ",
			"        | key   |         ",
			"        | value |         "])

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			atIndex: 0,
			.Given,
			"x",
			table(
				"Column",
				"<key>"))
	}

	// MARK: - Examples
	func test_outlineExamples() {
		when_parsing([
			"Feature: feature          ",
			"Scenario Outline: scenario",
			"    When the <foo>        ",
			"    Then should <bar>     ",
			"                          ",
			"    Examples:             ",
			"        | foo | bar   |   ",
			"        | one | two   |   ",
			"                          ",
			"    Examples: Lorem ipsum ",
			"        | foo   |         ",
			"        | alpha |         ",
			"        | beta  |         "])

		then_shouldReturnScenarioWith(numberOfExamples: 2)
		then_shouldReturnScenarioWithExamples(
			atIndex: 0,
			name: "",
			table(
				"foo", "bar",
				"one", "two"))
		then_shouldReturnScenarioWithExamples(
			atIndex: 1,
			name: "Lorem ipsum",
			table(
				"foo",
				"alpha",
				"beta"))
	}

	// MARK: - Givens, whens, thens
	
	private func then_shouldReturnScenarioWith(numberOfSteps expected: Int,
											   file: StaticString = #file,
											   line: UInt = #line) {
		
		let s = scenario(at: 0)
		XCTAssertEqual(s.steps.count, expected, file: file, line: line)
	}

	private func then_shouldReturnScenarioWith(numberOfExamples expected: Int,
											   file: StaticString = #file,
											   line: UInt = #line) {
		
		let s = scenario(at: 0)
		XCTAssertEqual(s.examples.count, expected, file: file, line: line)
	}

	private func then_shouldReturnScenarioWithExamples(atIndex index: Int,
												   name: String,
												   _ table: Table,
												   file: StaticString = #file,
												   line: UInt = #line) {
		let actual = examples(at: index)
		
		XCTAssertEqual(actual.name, name, file: file, line: line)
		XCTAssertEqual(actual.table.withoutLocation(), table, file: file, line: line)
	}

	private func then_shouldReturnScenarioWithStep(atIndex index: Int,
												   _ stepType: StepType,
												   _ text: String,
												   file: StaticString = #file,
												   line: UInt = #line) {
		let actual = step(at: index)
		
		XCTAssertEqual(actual.type, stepType, file: file, line: line)
		XCTAssertEqual(actual.text, text, file: file, line: line)
	}

	private func then_shouldReturnScenarioWithStep(atIndex index: Int,
												   _ stepType: StepType,
												   _ text: String,
												   _ table: Table,
												   file: StaticString = #file,
												   line: UInt = #line) {
		let actual = step(at: index)
		
		XCTAssertEqual(actual.type, stepType, file: file, line: line)
		XCTAssertEqual(actual.text, text, file: file, line: line)
		XCTAssertEqual(actual.tableParameter!.withoutLocation(), table, file: file, line: line)
	}

	func then_shouldReturnScenarioWithSteps(_ steps: [Step], file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(scenario(at: 0).steps, steps, file: file, line: line)
	}

	func then_shouldReturnTwoScenariosWithSteps(_ stepsScenarioOne: [Step], _ stepsScenarioTwo: [Step], file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(scenario(at: 0).steps, stepsScenarioOne, file: file, line: line)
		XCTAssertEqual(scenario(at: 1).steps, stepsScenarioTwo, file: file, line: line)
	}

	private func step(at index: Int) -> Step {
		return scenario(at: 0).steps[index]
	}

	private func examples(at index: Int) -> ScenarioOutlineExamples {
		return scenario(at: 0).examples[index]
	}
}

