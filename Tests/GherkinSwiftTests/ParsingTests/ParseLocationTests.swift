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
//  ParseLocationTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ParseLocationTests: TestParseBase {
	func test_Locations_Rows() {
		when_parsingFeature([
			"Feature: feature     ",
			"                     ",
			"Scenario: scenario 1 ",
			"   Given: given 1    ",
			"   When: when 1      ",
			"   Then: then 1      ",
			"                     ",
			"Scenario: scenario 2 ",
			"   Given: given 2    ",
			"   When: when 2      ",
			"   Then: then 2      ",
		])
		
		then_feature(shouldHaveLocation: Location(column: 1, line: 1))

		then_scenario(0, shouldHaveLocation: Location(column: 1, line: 3))
		then_scenario(1, shouldHaveLocation: Location(column: 1, line: 8))

		then_step(0, forScenario: 0, shouldHaveLocation: Location(column: 1, line: 4))
		then_step(1, forScenario: 0, shouldHaveLocation: Location(column: 1, line: 5))
		then_step(2, forScenario: 0, shouldHaveLocation: Location(column: 1, line: 6))

		then_step(0, forScenario: 1, shouldHaveLocation: Location(column: 1, line: 9))
		then_step(1, forScenario: 1, shouldHaveLocation: Location(column: 1, line: 10))
		then_step(2, forScenario: 1, shouldHaveLocation: Location(column: 1, line: 11))
	}

	func test_Locations_Feature() {
		when_parsingFeature([
			"",
			" Feature: feature",
		])
		
		then_feature(shouldHaveLocation: Location(column: 2, line: 2))
	}

	func test_Locations_ColumnsScenarios() {
		when_parsingFeature([
			"Feature: feature     ",
			"                     ",
			" Scenario: scenario 1 ",
			"                     ",
			"   Scenario: scenario 2 ",
		])
		
		then_scenario(0, shouldHaveLocation: Location(column: 2, line: 3))
		then_scenario(1, shouldHaveLocation: Location(column: 4, line: 5))
	}

	func test_Locations_ColumnsSteps() {
		when_parsingFeature([
			"Feature: feature   ",
			"                   ",
			"Scenario: scenario ",
			"    Given: given   ",
			"   When: when      ",
			"  Then: then       ",
		])
		
		then_step(0, forScenario: 0, shouldHaveLocation: Location(column: 5, line: 4))
		then_step(1, forScenario: 0, shouldHaveLocation: Location(column: 4, line: 5))
		then_step(2, forScenario: 0, shouldHaveLocation: Location(column: 3, line: 6))
	}


	private func then_feature(shouldHaveLocation location: Location, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualFeature.location, location, file: file, line: line)
	}

	private func then_scenario(_ index: Int, shouldHaveLocation location: Location, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualFeature.scenarios[index].location, location, file: file, line: line)
	}

	private func then_step(_ stepIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualFeature.scenarios[scenarioIndex].steps[stepIndex].location, location, file: file, line: line)
	}
}
