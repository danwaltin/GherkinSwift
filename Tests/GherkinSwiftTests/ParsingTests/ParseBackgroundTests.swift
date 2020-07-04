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
//  ParseBackgroundTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-04.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ParseBackgroundTests: TestParseBase {
	// MARK: - Name
	func test_backgroundWithName() {
		when_parsingDocument(
		"""
		Feature: feature name
		Background: background name
		""")
		
		then_shouldReturnBackgroundWithName("background name")
	}

	func test_backgroundWithoutName() {
		when_parsingDocument(
		"""
		Feature: feature name
		Background:
		""")
		
		then_shouldReturnBackgroundWithoutName()
	}
	
	// MARK: - Steps
	func test_backgroundWithOneGivenStep() {
		when_parsingDocument(
		"""
		Feature: feature
		Background:
		    Given there is something
		""")

		then_shouldReturnBackgroundWith(numberOfSteps: 1)
		then_shouldReturnBackgroundWithStep(.Given, "there is something")
	}

	func test_backgroundWithGivenAndButStep() {
		when_parsingDocument(
		"""
		Feature: feature
		Background:
		    Given there is something
		    But not something else
		""")

		then_shouldReturnBackgroundWith(numberOfSteps: 2)
		then_shouldReturnBackgroundWithStep(.Given, "there is something", atIndex: 0)
		then_shouldReturnBackgroundWithStep(.But, "not something else", atIndex: 1)
	}
	
	// MARK: - Table parameters to steps
	
	func test_tableParameterToSteps() {
		when_parsingDocument(
		"""
		Feature: feature
		Background:
		    Given x
		        | Column |
		        | value  |
		""")

		then_shouldReturnBackgroundWith(numberOfSteps: 1)
		then_shouldReturnBackgroundWithStep(
			.Given,
			"x",
			table(
				"Column",
				"value"))
	}

	// MARK: - Givens, whens and thens
	private func then_shouldReturnBackgroundWithName(_ name: String,
													 file: StaticString = #file, line: UInt = #line) {
		XCTFail("not implemented yet")
	}

	private func then_shouldReturnBackgroundWithoutName(file: StaticString = #file, line: UInt = #line) {
		XCTFail("not implemented yet")
	}

	private func then_shouldReturnBackgroundWith(numberOfSteps expected: Int,
												 file: StaticString = #file, line: UInt = #line) {
		
		XCTFail("not implemented yet")
//		let s = scenario(at: 0)
//		XCTAssertEqual(s.steps.count, expected, file: file, line: line)
	}
	
	private func then_shouldReturnBackgroundWithStep(_ stepType: StepType,
													 _ text: String,
													 atIndex index: Int = 0,
													 file: StaticString = #file, line: UInt = #line) {
		XCTFail("not implemented yet")
//		let actual = step(at: index)
//
//		XCTAssertEqual(actual.type, stepType, file: file, line: line)
//		XCTAssertEqual(actual.text, text, file: file, line: line)
	}

	private func then_shouldReturnBackgroundWithStep(atIndex index: Int = 0,
													 _ stepType: StepType,
													 _ text: String,
													 _ table: Table,
													 file: StaticString = #file, line: UInt = #line) {
		XCTFail("not implemented yet")
//		let actual = step(at: 0)
//
//		XCTAssertEqual(actual.type, stepType, file: file, line: line)
//		XCTAssertEqual(actual.text, text, file: file, line: line)
//
//		let actualTable = actual.tableParameter!.withoutLocation()
//		XCTAssertEqual(actualTable, table, file: file, line: line)
	}
	
	private func step(at index: Int) -> Step {
		XCTFail("not implemented yet")
		return scenario(at: 0).steps[index]
	}


}
