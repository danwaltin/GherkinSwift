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
//  NotGherkinTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-16.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class NotGherkinTests : TestErrorParseBase {
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

	func test_secondLineNotGherkin_message() {
		when_parsingDocument(
		"""
		
		rabarber
		""")
		
		then_shouldReturnParseErrorWith(message:
			"(2:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got 'rabarber'")
	}

	func test_secondLineNotGherkin_location() {
		when_parsingDocument(
		"""
		
		tomater
		""")
		
		then_shouldReturnParseErrorWith(location:
			Location(column: 1, line: 2))
	}

	func test_twoNonGherkinLines_messages() {
		when_parsingDocument(
		"""
		
		lorem
		Feature: several errors
		Scenario: foo
		   Given bar

		ipsum
		
		Scenario: bar
		   Given foo

		forty two
		""")
		
		then_shouldReturnParseErrorWith(messages: [
			"(2:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got \'lorem\'",
			"(7:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got \'ipsum\'",
			"(12:1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got \'forty two\'"
		])
	}

	func test_twoNonGherkinLines_locations() {
		when_parsingDocument(
		"""
		
		lorem
		Feature: several errors
		Scenario: foo
		   Given bar

		ipsum

		Scenario: bar
		   Given foo

		forty two
		""")
		
		then_shouldReturnParseErrorWith(locations: [
			Location(column: 1, line: 2),
			Location(column: 1, line: 7),
			Location(column: 1, line: 12)
		])
	}

	// MARK: - helpers
	private func then_shouldReturnParseErrorWith(message: String, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessage: message, file, line)
	}

	private func then_shouldReturnParseErrorWith(messages: [String], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessages: messages, file, line)
	}

	private func then_shouldReturnParseErrorWith(location: Location, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocation: location, file, line)
	}

	private func then_shouldReturnParseErrorWith(locations: [Location], file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocations: locations, file, line)
	}
}
