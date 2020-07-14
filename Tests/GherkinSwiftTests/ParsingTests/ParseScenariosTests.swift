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
		when_parsingDocument(
		"""
		Feature: feature name
		Scenario: scenario name
		""")
		
		then_shouldReturnScenariosWithNames([
			"scenario name"]
		)
	}
	
	func test_twoScenariosShouldReturnScenariosWithNames() {
		when_parsingDocument(
		"""
		Feature: feature name
		Scenario: scenario one
		Scenario: scenario two
		""")

		then_shouldReturnScenariosWithNames([
			"scenario one",
			"scenario two"]
		)
	}
	
	func test_scenarioWithOneGivenStep() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    Given there is something
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(.given, "there is something")
	}
	
	func test_scenarioWithOneWhenStep() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    When something happens
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(.when, "something happens")
	}
	
	func test_scenarioWithOneThenStep() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    Then something is the result
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(.then, "something is the result")
	}

	func test_scenarioWithOneAsteriskStep() {
		given_languageWithAsterisk()
		
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    * something is the result
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(.asterisk, "something is the result")
	}

	func test_scenarioWithGivenAndAndStep() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    Given there is something
		    And there is something else
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 2)
		then_shouldReturnScenarioWithStep(.given, "there is something", atIndex: 0)
		then_shouldReturnScenarioWithStep(.and, "there is something else", atIndex: 1)
	}

	func test_scenarioWithThenAndButStep() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		    Then something
		    But not something else
		""")

		then_shouldReturnScenarioWith(numberOfSteps: 2)
		then_shouldReturnScenarioWithStep(.then, "something", atIndex: 0)
		then_shouldReturnScenarioWithStep(.but, "not something else", atIndex: 1)
	}

	// MARK: - Givens, whens, thens
	
	func then_shouldReturnScenariosWithNames(_ names: [String],
											 file: StaticString = #file, line: UInt = #line) {
		assert.scenarios(withNames: names, file, line)
	}

	private func then_shouldReturnScenarioWith(numberOfSteps expected: Int,
											   file: StaticString = #file, line: UInt = #line) {
		assert.scenario(0, file, line) {
			XCTAssertEqual($0.steps.count, expected, file: file, line: line)
		}
	}
	
	private func then_shouldReturnScenarioWithStep(_ stepType: StepType,
												   _ text: String,
												   atIndex index: Int = 0,
												   file: StaticString = #file, line: UInt = #line) {		
		assert.step(stepType, text, atIndex: index, forScenario: 0, file, line)
	}
}

