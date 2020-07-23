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
//  InvalidLanguageTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-16.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class InvalidLanguageTests : TestErrorParseBase {
	override func setUp() {
		super.setUp()
		
		given_defaultLanguage("one")
		given_languages(
			["one" : L(feature: ["Feature"],
					   scenario: ["Scenario"]),
			 "two" : L(feature: ["Egenskap"],
					   scenario: ["Scenario"])])
	}
	
	func test_invalidLanguage_message() {
		
		when_parsingDocument(
			"""
			#language:three
			Feature: third wheel
			Scenario: lost in translation
			""")
		
		then_shouldReturnParseErrorWith(message:
			"Language not supported: three")
	}
	
	func test_invalidLanguage_location() {
		
		when_parsingDocument(
			"""
			#language:three
			Feature: third wheel
			Scenario: lost in translation
			""")
		
		then_shouldReturnParseErrorWith(location:
			Location(column: 1, line: 1))
	}
	
	// MARK: - helpers
	private func then_shouldReturnParseErrorWith(message: String, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withMessage: message, file, line)
	}
	
	private func then_shouldReturnParseErrorWith(location: Location, file: StaticString = #file, line: UInt = #line) {
		assert.parseError(withLocation: location, file, line)
	}
}
