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
//  ParseCommentsTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-26.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ParseCommentsTests: TestParseBase {
	func testScenarioWithComment() {
		when_parsingGherkinDocument([
			"Feature: feature",
			"Scenario: scenario one",
			"# This is a comment!",
			"Scenario: scenario two",
			"   # Another comment!"
		])
		
		then_document(shouldHaveComments: ["# This is a comment!", "   # Another comment!"])
	}


	private func then_document(shouldHaveComments expected: [String], file: StaticString = #file, line: UInt = #line) {
		let actual = actualGherkinDocument.comments.map{c in c.text}
		XCTAssertEqual(actual, expected, file: file, line: line)
	}

}
