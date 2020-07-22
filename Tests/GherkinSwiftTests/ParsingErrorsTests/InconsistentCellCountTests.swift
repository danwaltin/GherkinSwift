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
//  InconsistentCellCountTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-22.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class InconsistentCellCountTests : TestErrorParseBase {
	func test_inconsistentCellCount_atRowTwo_inScenarioStepTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		   Given inconsistent table
		      | h1   |
		      | r1c1 | r1c2 |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "inconsistent cell count within the table")
	}

	func test_inconsistentCellCount_atRowThree_inScenarioStepTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		   Given inconsistent table
		      | h1   | h2   |
		      | r1c1 | r1c2 |
		      | r2c1 |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "inconsistent cell count within the table")
	}

	func test_inconsistentCellCount_atRowTwo_inBackgroundStepTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Background:
		   Given inconsistent table
		      | h1   |
		      | r1c1 | r1c2 |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "inconsistent cell count within the table")
	}

	func test_inconsistentCellCount_atRowThree_inBackgroundStepTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Background:
		   Given inconsistent table
		      | h1   | h2   |
		      | r1c1 | r1c2 |
		      | r2c1 |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "inconsistent cell count within the table")
	}

	func test_inconsistentCellCount_atRowTwo_inExamplesTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario Outline: scenario
		   Given <h1>
		
		   Examples:
		      | h1   |
		      | r1c1 | r1c2 |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "inconsistent cell count within the table")

	}

	func test_inconsistentCellCount_atRowThree_inExamplesStepTable() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario Outline: scenario
		   Given <h1>
		   And <h2>
		
		   Examples:
		      | h1   | h2   |
		      | r1c1 | r1c2 |
		      | r2c1 |
		""")
		
		then_shouldReturnParseErrorWith(
			message: "inconsistent cell count within the table")
	}
	
	func test_twoSteps_withInconsistentCellCounts_locations() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		   Given inconsistent table
		      | h1   |
		      | r1c1 | r1c2 |

		   Given inconsistent table
		      | h1   | h2   |
		      | r1c1 | r1c2 |
		         | r2c1 |
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(locations: [
			Location(column: 7, line: 5),
			Location(column: 10, line: 10)
		])
	}

	func test_twoInconsistentCellCounts_inSameTable_locations() {
		when_parsingDocument(
		"""
		Feature: feature
		Scenario: scenario
		   Given inconsistent table
		      | h1   | h2   |
		      | r1c1 | r1c2 |
		         | r2c1 |
		      | r3c1 | r3c2 |
		   | r4c1 | r4c2 | r4c3 |
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(locations: [
			Location(column: 10, line: 6),
			Location(column: 4, line: 8)
		])
	}

	// MARK: - helpers
	private func then_shouldReturn(numberOfParseErrors expected: Int, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(file, line) {
			XCTAssertEqual($0.count, expected, file: file, line: line)
		}
	}
	
	private func then_shouldReturnParseErrorWith(message: String,
												 file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessage: message, file, line)
	}

	private func then_shouldReturnParseErrorWith(locations: [Location], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocations: locations, file, line)
	}
}
