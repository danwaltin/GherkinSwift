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
	// MARK: - No background
	func test_featureWithoutBackground() {
		when_parsingDocument(
		"""
		Feature: feature name
		""")
		
		then_shouldReturnFeatureWithoutBackground()
	}

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
	
	private func assertBackground(_ file: StaticString, _ line: UInt, assertBackground: (Background) -> Void ) {
		guard let actualBackground = actualFeature.background else {
			XCTFail("No background found", file: file, line: line)
			return
		}
		
		assertBackground(actualBackground)
	}

	private func assertBackgroundStep(atIndex index: Int, _ file: StaticString, _ line: UInt, assertStep: (Step) -> Void ) {
		assertBackground(file, line) {
			if $0.steps.count <= index {
				XCTFail("No step at index \(index)", file: file, line: line)
				return
			}
			
			let actualStep = $0.steps[index]
			
			assertStep(actualStep)
		}
	}

	private func then_shouldReturnFeatureWithoutBackground(file: StaticString = #file, line: UInt = #line) {
		XCTAssertNil(actualFeature.background, file: file, line: line)
	}

	private func then_shouldReturnBackgroundWithName(_ name: String,
													 file: StaticString = #file, line: UInt = #line) {
		assertBackground(file, line) {
			XCTAssertEqual($0.name, name, file: file, line: line)
		}
	}

	private func then_shouldReturnBackgroundWithoutName(file: StaticString = #file, line: UInt = #line) {
		assertBackground(file, line) {
			XCTAssertEqual($0.name, "", file: file, line: line)
		}
	}

	private func then_shouldReturnBackgroundWith(numberOfSteps expected: Int,
												 file: StaticString = #file, line: UInt = #line) {
		assertBackground(file, line) {
			XCTAssertEqual($0.steps.count, expected, file: file, line: line)
		}
	}
	
	private func then_shouldReturnBackgroundWithStep(_ stepType: StepType,
													 _ text: String,
													 atIndex index: Int = 0,
													 file: StaticString = #file, line: UInt = #line) {
		assertBackgroundStep(atIndex: index, file, line) {
			XCTAssertEqual($0.type, stepType, file: file, line: line)
			XCTAssertEqual($0.text, text, file: file, line: line)
		}
	}

	private func then_shouldReturnBackgroundWithStep(atIndex index: Int = 0,
													 _ stepType: StepType,
													 _ text: String,
													 _ table: Table,
													 file: StaticString = #file, line: UInt = #line) {
		assertBackgroundStep(atIndex: index, file, line) {
			XCTAssertEqual($0.type, stepType, file: file, line: line)
			XCTAssertEqual($0.text, text, file: file, line: line)

			let actualTable = $0.tableParameter!.withoutLocation()
			XCTAssertEqual(actualTable, table, file: file, line: line)
		}
	}
}
