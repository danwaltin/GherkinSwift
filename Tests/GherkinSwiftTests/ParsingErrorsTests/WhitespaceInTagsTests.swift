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
	// MARK: - Feature
	func test_parseFeatureWithOneTagWithWhitespace() {
		when_parsingDocument(
		"""
		@with whitespace
		Feature: name
		""")

		then_shouldReturnParseErrorWith(
			message: "A tag may not contain whitespace")
	}

	func test_parseFeatureWithTwoTagsWithWhitespace() {
		when_parsingDocument(
		"""
		@with whitespace
		
		@also with whitespace
		Feature: name
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(
			messages: ["A tag may not contain whitespace", "A tag may not contain whitespace"])
	}

	func test_parseFeatureWithTwoTags_secondWithWhitespace() {
		when_parsingDocument(
		"""
		@first @second has whitespace
		Feature: name
		""")

		then_shouldReturn(numberOfParseErrors: 1)
		then_shouldReturnParseErrorWith(
			message: "A tag may not contain whitespace")
	}

	// MARK: - Scenario
	func test_parseScenarioWithOneTagWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		@with whitespace
		Scenario: name
		""")

		then_shouldReturnParseErrorWith(
			message: "A tag may not contain whitespace")
	}

	func test_parseScenarioWithTwoTagsWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		@with whitespace @also with whitespace
		Scenario: name
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(
			messages: ["A tag may not contain whitespace", "A tag may not contain whitespace"])
	}

	func test_parseScenarioWithTwoTags_secondWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		@first @second has whitespace
		Scenario: name
		""")

		then_shouldReturn(numberOfParseErrors: 1)
		then_shouldReturnParseErrorWith(
			message: "A tag may not contain whitespace")
	}

	func test_parseTwoScenariosWithTagsWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		@first has whitespace
		Scenario: one
		@second has whitespace
		Scenario: two
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(
			messages: ["A tag may not contain whitespace", "A tag may not contain whitespace"])
	}

	// MARK: - Scenario Outline examples
	func test_parseScenarioOutlineExamplesWithOneTagWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		Scenario Outline: name
			Given <something>

			@with whitespace
			Examples:
				| something |
		        | anything  |
		""")

		then_shouldReturnParseErrorWith(
			message: "A tag may not contain whitespace")
	}

	func test_parseScenarioOutlineExamplesWithTwoTagsWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		Scenario Outline: name
			Given <something>

			@with whitespace
			Examples: one
				| something |
		        | anything  |

		   @also with whitespace
		   Examples: two
		      | something |
		      | anything  |
		""")

		then_shouldReturn(numberOfParseErrors: 2)
		then_shouldReturnParseErrorWith(
			messages: ["A tag may not contain whitespace", "A tag may not contain whitespace"])
	}

	func test_parseScenarioOutlineExamplesWithTwoTags_secondWithWhitespace() {
		when_parsingDocument(
		"""
		Feature: name
		Scenario Outline: name
			Given <something>

			@first
			Examples: one
				| something |
		        | anything  |

		   @second with whitespace
		   Examples: two
		      | something |
		      | anything  |
		""")

		then_shouldReturn(numberOfParseErrors: 1)
		then_shouldReturnParseErrorWith(
			messages: ["A tag may not contain whitespace"])
	}

	// MARK: - Locations
	func test_tagsWithWhitespace_locations() {
		when_parsingDocument(
		"""
		@feature whitespace
		Feature: feature

		   @scenario whitespace
		   Scenario: scenario
			   Given something

		   Scenario Outline: outline
		      Given <something>

		      @examples whitespace
		      Examples:
		         | something |
		         | anything  |
		""")

		then_shouldReturn(numberOfParseErrors: 3)
		then_shouldReturnParseErrorWith(
			locations: [
				Location(column: 1, line: 1),
				Location(column: 4, line: 4),
				Location(column: 7, line: 11)])
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

	private func then_shouldReturnParseErrorWith(locations: [Location], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocations: locations, file, line)
	}
}
