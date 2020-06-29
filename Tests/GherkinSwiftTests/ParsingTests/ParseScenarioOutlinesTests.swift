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
		then_shouldReturnScenarioWithStep(atIndex: 1, .When, "when <gamma>")
		then_shouldReturnScenarioWithStep(atIndex: 2, .Then, "then <then>")
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
				"<>"))
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
			"        | foo   | bar   | ",
			"        | alpha | beta  | ",
			"        | beta  | delta | "])

		then_shouldReturnScenarioWith(numberOfExamples: 2)
		then_shouldReturnScenarioWithExamples(
			atIndex: 0,
			name: "",
			table(
				"foo",
				"one",
				"two"))
		then_shouldReturnScenarioWithExamples(
			atIndex: 1,
			name: "lorem ipsum",
			table(
				"foo",
				"one",
				"two"))
	}


	// MARK: - Replacing keys with examples in steps
	
	func IGNORE_test_oneKeyOneExample() {
		when_parsing([
			"Feature: feature name          ",
			"Scenario Outline: scenario name",
			"    Given the key <key>        ",
			"                               ",
			"    Examples:                  ",
			"        | key   |              ",
			"        | value |              "])
		
		then_shouldReturnScenarioWithSteps([
			Step.given("the key value")]
		)
	}

	func IGNORE_test_oneKeyInTwoInstancesInOneStepsOneExample() {
		when_parsing([
			"Feature: feature name          ",
			"Scenario Outline: scenario name",
			"    Then foo <key> bar '<key>' ",
			"                               ",
			"    Examples:                  ",
			"        | key   |              ",
			"        | value |              "])
		
		then_shouldReturnScenarioWithSteps([
			Step.then("foo value bar 'value'")]
		)
	}

	func IGNORE_IGNORE_test_twoKeyInInOneStepsOneExample() {
		when_parsing([
			"Feature: feature name                 ",
			"Scenario Outline: scenario name       ",
			"    Then foo <key one> bar '<key two>'",
			"                                      ",
			"    Examples:                         ",
			"        | key one | key two |         ",
			"        | one     | two     |         "])
		
		then_shouldReturnScenarioWithSteps([
			Step.then("foo one bar 'two'")]
		)
	}

	func IGNORE_test_oneKeyInTwoStepsOneExample() {
		when_parsing([
			"Feature: feature name          ",
			"Scenario Outline: scenario name",
			"    Given foo <key>            ",
			"    When <key> bar             ",
			"                               ",
			"    Examples:                  ",
			"        | key   |              ",
			"        | value |              "])
		
		then_shouldReturnScenarioWithSteps([
			Step.given("foo value"),
			Step.when("value bar")]
		)
	}

	func IGNORE_test_threeKeysInThreeStepsOneExample() {
		when_parsing([
			"Feature: feature name                     ",
			"Scenario Outline: scenario name           ",
			"    Given foo <key one>                   ",
			"    When <key two> bar                    ",
			"    Then <key three>                      ",
			"                                          ",
			"    Examples:                             ",
			"        | key one  | key two | key three |",
			"        | v1       | v2      | v3        |"])
		
		then_shouldReturnScenarioWithSteps([
			Step.given("foo v1"),
			Step.when("v2 bar"),
			Step.then("v3")]
		)
	}

	func IGNORE_test_threeKeysInThreeStepsTwoExamples() {
		when_parsing([
			"Feature: feature name          ",
			"Scenario Outline: scenario name",
			"    Given alpha <k1>           ",
			"    When beta <k2>             ",
			"    Then gamma <k3>            ",
			"                               ",
			"    Examples:                  ",
			"        | k1   | k2   | k3   | ",
			"        | v1_1 | v1_2 | v1_3 | ",
			"        | v2_1 | v2_2 | v2_3 | "])
		
		then_shouldReturnTwoScenariosWithSteps(
			[
				Step.given("alpha v1_1"),
				Step.when("beta v1_2"),
				Step.then("gamma v1_3")
			],
			[
				Step.given("alpha v2_1"),
				Step.when("beta v2_2"),
				Step.then("gamma v2_3")
			]
		)
	}
	
	// MARK: - Replacing keys with value in table parameters
	
	func IGNORE_test_oneColumnOneRow_oneKeyOneExample_replaceCell() {
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
		
		then_shouldReturnScenarioWithSteps([
			Step.given("x", table(
				"Column",
				"value"))]
		)
	}

	func IGNORE_test_oneColumnOneRow_twoKeysOneExample_replaceCell() {
		when_parsing([
			"Feature: feature          ",
			"Scenario Outline: scenario",
			"    Given x               ",
			"        | Column      |   ",
			"        | <one> <two> |   ",
			"                          ",
			"    Examples:             ",
			"        | one | two |     ",
			"        | v1  | v2  |     "])
		
		then_shouldReturnScenarioWithSteps([
			Step.given("x", table(
				"Column",
				"v1 v2"))]
		)
	}

	func IGNORE_test_oneColumnOneRow_oneKeyOneExample_replaceColumn() {
		when_parsing([
			"Feature: feature          ",
			"Scenario Outline: scenario",
			"    When x                ",
			"        | <key>      |    ",
			"        | cell value |    ",
			"                          ",
			"    Examples:             ",
			"        | key         |   ",
			"        | Column Name |   "])
		
		then_shouldReturnScenarioWithSteps([
			Step.when("x", table(
				"Column Name",
				"cell value"))]
		)
	}

	func IGNORE_test_oneColumnOneRow_twoKeysOneExample_replaceColumn() {
		when_parsing([
			"Feature: feature             ",
			"Scenario Outline: scenario   ",
			"    When x                   ",
			"        | <keyOne> <keyTwo> |",
			"        | cell value        |",
			"                             ",
			"    Examples:                ",
			"        | keyOne | keyTwo |  ",
			"        | c1     |c2      |  "])
		
		then_shouldReturnScenarioWithSteps([
			Step.when("x", table(
				"c1 c2",
				"cell value"))]
		)
	}

	func IGNORE_test_twoColumnsTwoRows_fourKeysTwoSameTwoExamples_replaceColumnAndCells() {
		when_parsing([
			"Feature: feature                            ",
			"Scenario Outline: scenario                  ",
			"    Then x                                  ",
			"        | Constant Column | <key alfa>     |",
			"        | <same key>      | constant value |",
			"        | <key beta>      | <same key>     |",
			"                                            ",
			"    Examples:                               ",
			"        | key alfa | key beta | same key |  ",
			"        | XX       | YY       | ZZ       |  ",
			"        | AA       | BB       | CC       |  "])
		
		then_shouldReturnTwoScenariosWithSteps(
			[
				Step.then("x", table(
					"Constant Column", "XX",
					"ZZ", "constant value",
					"YY", "ZZ"))
			],
			[
				Step.then("x", table(
					"Constant Column", "AA",
					"CC", "constant value",
					"BB", "CC"))
			]
		)
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
		XCTAssertEqual(actual.table, table, file: file, line: line)
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
		XCTAssertEqual(actual.tableParameter!, table, file: file, line: line)
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

