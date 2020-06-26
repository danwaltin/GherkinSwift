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
//  ParseDescriptionTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-26.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ParseDescriptionTests: TestParseBase {
	func testFeatureWithDescription() {
		when_parsingFeature([
			"Feature: feature",
			"This is a description"
		])
		
		then_feature(shouldHaveDescription: "This is a description")
	}

	func testFeatureWithIndentedDescription() {
		when_parsingFeature([
			"Feature: feature",
			"   Indented description"
		])
		
		then_feature(shouldHaveDescription: "   Indented description")
	}

	func testFeatureWithTwoIndentedLinesDescription() {
		when_parsingFeature([
			"Feature: feature",
			"   First",
			"   Second",
		])
		
		then_feature(shouldHaveDescription: "   First\n   Second")
	}

	private func then_feature(shouldHaveDescription description: String, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualFeature.description, description, file: file, line: line)
	}

}
