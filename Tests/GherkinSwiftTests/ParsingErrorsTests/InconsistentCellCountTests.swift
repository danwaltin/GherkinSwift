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
		
	}

	func test_inconsistentCellCount_atRowThree_inScenarioStepTable() {
		
	}

	func test_inconsistentCellCount_atRowTwo_inBackgroundStepTable() {
		
	}

	func test_inconsistentCellCount_atRowThree_inBackgroundStepTable() {
		
	}

	func test_inconsistentCellCount_atRowTwo_inExamplesTable() {
		
	}

	func test_inconsistentCellCount_atRowThree_inExamplesStepTable() {
		
	}
	
	func test_several_inconsistentCellCount() {
		
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

	private func then_shouldReturnParseErrorWith(messages: [String], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessages: messages, file, line)
	}

	private func then_shouldReturnParseErrorWith(locations: [Location], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocations: locations, file, line)
	}
}
