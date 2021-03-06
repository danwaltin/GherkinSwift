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

class ParseScenarioOutlinesTests: TestSuccessfulParseBase {
	func test_oneScenarioOutlineWithOneExampleShouldReturnScenarioWithName() {
		when_parsingDocument(
			"""
			Feature: feature name
			Scenario Outline: scenario name
			    Given given <alpha>
			    When when <beta>
			    Then then <gamma>
			
			    Examples:
			        | alpha | beta | gamma |
			        | one   | two  | three |
			""")
		
		then_shouldReturnScenariosWithNames([
			"scenario name"]
		)
		then_shouldReturnScenarioWith(numberOfSteps: 3)
		
		then_shouldReturnScenarioWithStep(atIndex: 0, .given, "given <alpha>")
		then_shouldReturnScenarioWithStep(atIndex: 1, .when, "when <beta>")
		then_shouldReturnScenarioWithStep(atIndex: 2, .then, "then <gamma>")
	}
	
	func test_oneScenarioOutlineWithoutStepsOrExamples() {
		when_parsingDocument(
			"""
			Feature: feature name
			Scenario Outline: scenario name
			""")
		
		then_shouldReturnScenariosWithNames([
			"scenario name"]
		)
		then_shouldReturnScenarioWith(numberOfSteps: 0)
		then_shouldReturnScenarioWith(numberOfExamples: 0)
	}
	
	// MARK: - Table parameters to steps
	
	func test_tableParametersToSteps() {
		when_parsingDocument(
			"""
			Feature: feature
			Scenario Outline: scenario
			    Given x
			        | Column |
			        | <key>  |
			
			    Examples:
			        | key   |
			        | value |
			""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 1)
		then_shouldReturnScenarioWithStep(
			atIndex: 0,
			.given,
			"x",
			table(
				"Column",
				"<key>"))
	}
	
	// MARK: - Examples
	func test_outlineExamples() {
		when_parsingDocument(
			"""
			Feature: feature
			Scenario Outline: scenario
			    When the <foo>
			    Then should <bar>
			
			    Examples:
			        | foo | bar   |
			        | one | two   |
			
			    Examples: Lorem ipsum
			        | foo   |
			        | alpha |
			        | beta  |
			""")
		
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
	
	func test_outlineOneExampleWithoutTable() {
		when_parsingDocument(
			"""
			Feature: feature
			Scenario Outline: scenario
			    When something happens
			
			    Examples:
			""")
		
		then_shouldReturnScenarioWith(numberOfExamples: 1)
		then_shouldReturnScenarioWithExamplesWithoutTable(atIndex: 0)
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
	
	private func then_shouldReturnScenarioWith(numberOfExamples expected: Int,
											   file: StaticString = #file, line: UInt = #line) {
		
		assert.scenario(0, file, line) {
			XCTAssertEqual($0.examples.count, expected, file: file, line: line)
		}
	}
	
	private func then_shouldReturnScenarioWithExamples(atIndex index: Int,
													   name: String,
													   _ table: Table,
													   file: StaticString = #file, line: UInt = #line) {
		assert.examples(index, forScenario: 0, file, line) {
			XCTAssertEqual($0.name, name, file: file, line: line)
			XCTAssertEqual($0.table!.withoutLocation(), table, file: file, line: line)
		}
	}
	
	private func then_shouldReturnScenarioWithExamplesWithoutTable(atIndex index: Int,
																   file: StaticString = #file, line: UInt = #line) {
		assert.examples(index, forScenario: 0, file, line) {
			XCTAssertEqual($0.table, nil, file: file, line: line)
		}
	}
	
	private func then_shouldReturnScenarioWithStep(atIndex index: Int,
												   _ stepType: StepType,
												   _ text: String,
												   file: StaticString = #file, line: UInt = #line) {
		assert.step(stepType, text, atIndex: index, forScenario: 0, file, line)
	}
	
	private func then_shouldReturnScenarioWithStep(atIndex index: Int,
												   _ stepType: StepType,
												   _ text: String,
												   _ table: Table,
												   file: StaticString = #file, line: UInt = #line) {
		assert.step(stepType, text, table, atIndex: index, forScenario: 0, file, line)
	}
}

