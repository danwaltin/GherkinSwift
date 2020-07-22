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
//  WhitespaceInTagsTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-22.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class WhitespaceInTagsTests : TestErrorParseBase {
	func test_parseFeatureWithOneTagWithWhitespace() {
		when_parsingDocument(
		"""
		@with withspace
		Feature: name
		""")

		then_shouldReturnParseErrorWith(
			message: "A tag may not contain whitespace")
	}

	func test_parseFeatureWithTwoTagsWithWhitespace() {
		when_parsingDocument(
		"""
		@with withspace
		
		@also with whitespace
		Feature: name
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(
			messages: ["A tag may not contain whitespace", "A tag may not contain whitespace"])
	}

	func test_parseScenarioWithOneTagWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		@with withspace
		Scenario: name
		""")

		then_shouldReturnParseErrorWith(
			message: "A tag may not contain whitespace")
	}

	func test_parseScenarioWithTwoTagsWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		@with withspace @also with whitespace
		Scenario: name
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(
			messages: ["A tag may not contain whitespace", "A tag may not contain whitespace"])
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

	private func then_shouldReturnParseErrorWith(messages: [String],
												 file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessages: messages, file, line)
	}
}
