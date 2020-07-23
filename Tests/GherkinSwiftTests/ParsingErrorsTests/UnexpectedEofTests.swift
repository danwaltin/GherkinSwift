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
//  UnexpectedEofTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-23.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class UnexpectedEofTests : TestErrorParseBase {
	func test_eofAfterTagBeforeFeature() {
		when_parsingDocument(
		"""
		@tag
		""")

		then_shouldReturnParseErrorWith(
			message: "unexpected end of file, expected: #TagLine, #FeatureLine, #Comment, #Empty")
		then_shouldReturnParseErrorWith(location:
			Location(column: 0, line: 1))
	}

	func test_eofAfterTagBeforeScenario() {
		when_parsingDocument(
		"""
		Feature: Unexpected end of file

		@tag
		""")

		then_shouldReturnParseErrorWith(
			message: "unexpected end of file, expected: #TagLine, #ScenarioLine, #Comment, #Empty")
		then_shouldReturnParseErrorWith(location:
			Location(column: 0, line: 3))
	}

	func test_eofAfterTagAfterScenarioAndAfterFeature() {
		when_parsingDocument(
		"""
		Feature: Unexpected end of file

		Scenario Outline: minimalistic
		  Given the minimalism

		  @tag
		""")

		then_shouldReturnParseErrorWith(
			message: "unexpected end of file, expected: #TagLine, #ExamplesLine, #ScenarioLine, #Comment, #Empty")
		then_shouldReturnParseErrorWith(location:
			Location(column: 0, line: 6))
	}

	func test_eofAfterTagAfterTwoNewLinesBeforeFeature() {
		when_parsingDocument(
		"""
		@tag


		""")

		then_shouldReturnParseErrorWith(
			message: "unexpected end of file, expected: #TagLine, #FeatureLine, #Comment, #Empty")
		then_shouldReturnParseErrorWith(location:
			Location(column: 0, line: 3))
	}

	// MARK: - Helpers
	private func then_shouldReturnParseErrorWith(message: String,
												 file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessage: message, file, line)
	}

	private func then_shouldReturnParseErrorWith(location: Location, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocation: location, file, line)
	}
}
