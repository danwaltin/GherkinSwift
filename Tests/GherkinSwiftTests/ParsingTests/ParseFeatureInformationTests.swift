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
//  ParseFeatureInformationTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ParseFeatureInformationTests: TestSuccessfulParseBase {

	func test_parseFeature_shouldReturnFeatureWithName() {
		when_parsing([
			"Feature: feature name"])
		
		then_featureNameShouldBe("feature name")
	}

	func test_parseFeature_whitespaceIsTrimmedFromName() {
		when_parsing([
			"Feature: name with white space at end   "])
		
		then_featureNameShouldBe("name with white space at end")
	}

	func test_parseFeature_withEmptyLine_shouldReturnFeatureWithName() {
		when_parsing([
			"Feature: feature name",
			""])
		
		then_featureNameShouldBe("feature name")
	}

	func test_parsingTwoFeaturesWithTheSameParserInstance() {
		let instance = parser()
		
		when_parsingDocument("Feature: one", instance)
		then_featureNameShouldBe("one")

		when_parsingDocument("Feature: two", instance)
		then_featureNameShouldBe("two")
	}
	
	// MARK: - Givens, whens, thens
	private func then_featureNameShouldBe(_ name: String,
										  file: StaticString = #file, line: UInt = #line) {
		assert.feature(file, line) {
			XCTAssertEqual($0.name, name, file: file, line: line)
		}
	}
}
