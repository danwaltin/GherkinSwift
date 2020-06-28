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
//  ParseScenariosTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseScenariosTests: TestParseBase {
	func test_oneScenarioShouldReturnScenarioWithName() {
		when_parsing([
			"Feature: feature name  ",
			"Scenario: scenario name"])
		
		then_shouldReturnScenariosWithNames([
			"scenario name"]
		)
	}
	
	func test_twoScenariosShouldReturnScenariosWithNames() {
		when_parsing([
			"Feature: feature name",
			"Scenario: scenario one",
			"Scenario: scenario two"])
		
		then_shouldReturnScenariosWithNames([
			"scenario one",
			"scenario two"]
		)
	}
	
	func test_scenarioWithOneGivenStep() {
		when_parsing([
			"Feature: feature  ",
			"Scenario: scenario",
			"    Given there is something"])
		
		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(.Given, "there is something")
	}
	
	func test_scenarioWithOneWhenStep() {
		when_parsing([
			"Feature: feature  ",
			"Scenario: scenario",
			"    When something happens"])
		
		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(.When, "something happens")
	}
	
	func test_scenarioWithOneThenStep() {
		when_parsing([
			"Feature: feature  ",
			"Scenario: scenario",
			"    Then something is the result"])
		
		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(.Then, "something is the result")
	}
	
	// MARK: - Table parameters to steps
	
	func test_tableParametersToSteps_oneColumnOneRow() {
		when_parsing([
			"Feature: feature  ",
			"Scenario: scenario",
			"    Given x ",
			"        | Column |    ",
			"        | value  |    "])
		
		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.Given,
			"x",
			table(
				"Column",
				"value"))
	}
	
	func test_tableParametersToSteps_oneColumnTwoRows() {
		when_parsing([
			"Feature: feature  ",
			"Scenario: scenario",
			"    When y            ",
			"        | col |       ",
			"        | v1  |       ",
			"        | v2  |       "])
		
		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.When,
			"y",
			table(
				"col",
				"v1",
				"v2"))
	}
	
	func test_tableParametersToSteps_twoColumnsOneRow() {
		when_parsing([
			"Feature: feature  ",
			"Scenario: scenario",
			"    Then z            ",
			"        | c1   | c2   |",
			"        | r1c1 | r1c2 |"])
		
		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			.Then,
			"z",
			table(
				"c1", "c2",
				"r1c1", "r1c2"))
	}
	
	func test_tableParametersToSteps_twoColumnsTwoRows() {
		when_parsing([
			"Feature: feature  ",
			"Scenario: scenario",
			"    When alfa    ",
			"        | A | B |",
			"        | c | d |",
			"        | e | f |",
			"                 ",
			"    Then beta    ",
			"        | G | H |",
			"        | i | j |",
			"        | k | l |"])
		
		then_shouldReturnScenarioWith(numberOfSteps: 2)
		then_shouldReturnScenarioWithStep(
			atIndex: 0,
			.When,
			"alfa",
			table(
				"A", "B",
				"c", "d",
				"e", "f"))
		then_shouldReturnScenarioWithStep(
			atIndex: 1,
			.Then,
			"beta",
			table(
				"G", "H",
				"i", "j",
				"k", "l"))
	}
	
	// MARK: - Givens, whens, thens
	
	private func then_shouldReturnScenarioWith(numberOfSteps expected: Int,
											   file: StaticString = #file,
											   line: UInt = #line) {
		
		let s = scenario(at: 0)
		XCTAssertEqual(s.steps.count, expected, file: file, line: line)
	}
	
	private func then_shouldReturnScenarioWithStep(_ stepType: StepType,
												   _ text: String,
												   file: StaticString = #file,
												   line: UInt = #line) {
		let actual = step(at: 0)
		
		XCTAssertEqual(actual.type, stepType, file: file, line: line)
		XCTAssertEqual(actual.text, text, file: file, line: line)
	}
	
	private func then_shouldReturnScenarioWithStep(_ stepType: StepType,
												   _ text: String,
												   _ table: Table,
												   file: StaticString = #file,
												   line: UInt = #line) {
		let actual = step(at: 0)

		XCTAssertEqual(actual.type, stepType, file: file, line: line)
		XCTAssertEqual(actual.text, text, file: file, line: line)
		XCTAssertEqual(actual.tableParameter!, table, file: file, line: line)
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
	
	private func step(at index: Int) -> Step {
		return scenario(at: 0).steps[index]
	}
}

