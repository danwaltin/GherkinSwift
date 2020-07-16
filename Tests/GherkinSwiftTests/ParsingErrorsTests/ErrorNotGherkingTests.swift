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
//  ErrorNotGherkingTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-04.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ErrorNotGherkingTests : TestParseBase {
	func test_firstLineNotGherkin_message() {
		when_parsingDocument(
		"""
		lorem ipsum
		""")
		
		then_shouldReturnParseErrorWith(message:
			"(1:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'lorem ipsum'")
	}

	func test_firstLineNotGherkin_location() {
		when_parsingDocument(
		"""
		lorem ipsum
		""")
		
		then_shouldReturnParseErrorWith(location:
			Location(column: 1, line: 1))
	}

	// MARK: - helpers
	private func then_shouldReturnParseErrorWith(message: String, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualParseError.message, message, file: file, line: line)
	}

	private func then_shouldReturnParseErrorWith(location: Location, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualParseError.source.location, location, file: file, line: line)
	}
}
