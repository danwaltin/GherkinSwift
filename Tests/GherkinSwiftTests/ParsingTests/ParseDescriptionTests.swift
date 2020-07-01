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
	
	// MARK: feature
	func testFeatureWithDescription() {
		when_parsing([
			"Feature: feature",
			"This is a description"
		])
		
		then_feature(shouldHaveDescription: "This is a description")
	}

	func testFeatureWithDescriptionWithOneEmptyLineAfter() {
		when_parsing([
			"Feature: feature",
			"This is a description",
			"",
		])
		
		then_feature(shouldHaveDescription: "This is a description")
	}

	func testFeatureWithDescriptionWithTwoEmptyLinesAfter() {
		when_parsing([
			"Feature: feature",
			"This is a description",
			"",
			"",
		])
		
		then_feature(shouldHaveDescription: "This is a description")
	}

	func testFeatureWithIndentedDescription() {
		when_parsing([
			"Feature: feature",
			"   Indented description"
		])
		
		then_feature(shouldHaveDescription: "   Indented description")
	}

	func testFeatureWithDescriptionWithTwoIndentedLines() {
		when_parsing([
			"Feature: feature",
			"   First",
			"   Second",
		])
		
		then_feature(shouldHaveDescription: "   First\n   Second")
	}

	func testFeatureWithDescriptionWithTwoLinesWithEmptyLineBetween() {
		when_parsing([
			"Feature: feature",
			"First",
			"",
			"Second",
		])
		
		then_feature(shouldHaveDescription: "First\n\nSecond")
	}

	// MARK: - scenario
	func testScenariosWithDescription() {
		when_parsing([
			"Feature: feature",
			"Scenario:",
			"This is a description",
			"",
			"Scenario:",
			"   First",
			"   Second",
		])
		
		then_scenario(0, shouldHaveDescription: "This is a description")
		then_scenario(1, shouldHaveDescription: "   First\n   Second")
	}

	func testScenarioWithDescriptionWithEmptyLine() {
		when_parsing([
			"Feature: feature",
			"Scenario: scenario",
			"",
			"   First",
			"",
			"   Second",
		])
		
		then_scenario(0, shouldHaveDescription: "   First\n\n   Second")
	}

	
	// MARK: - scenario outline
	func testScenarioOutlinessWithDescription() {
		when_parsing([
			"Feature: feature",
			"Scenario Outline: one",
			"This is a description",
			"",
			"Examples:",
			"|foo|",
			"|bar|",
			"",
			"Scenario Outline: two",
			"   First",
			"   Second",
			"",
			"Examples:",
			"|foo|",
			"|bar|",
		])
		
		then_scenario(0, shouldHaveDescription: "This is a description")
		then_scenario(1, shouldHaveDescription: "   First\n   Second")
	}

	// MARK: - Givens, whens and thens
	private func then_feature(shouldHaveDescription description: String,
							  file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualFeature.description, description, file: file, line: line)
	}

	private func then_scenario(_ index: Int, shouldHaveDescription description: String,
							   file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualFeature.scenarios[index].description, description, file: file, line: line)
	}

}
