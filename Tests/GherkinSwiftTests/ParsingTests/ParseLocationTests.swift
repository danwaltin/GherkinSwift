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
	func test_Locations_Feature_At_1_1() {
		when_parsingDocument(
			"""
			Feature: feature
			""")
		
		then_feature(shouldHaveLocation: Location(column: 1, line: 1))
	}
	
	func test_Locations_Feature() {
		when_parsingDocument(
			"""
			@tag
			 Feature: feature
			""")
		
		then_feature(shouldHaveLocation: Location(column: 2, line: 2))
	}
	
	func test_Locations_Scenarios() {
		when_parsingDocument(
		"""
		Feature: feature

		 Scenario: scenario 1

		   Scenario: scenario 2
		""")
		
		then_scenario(0, shouldHaveLocation: Location(column: 2, line: 3))
		then_scenario(1, shouldHaveLocation: Location(column: 4, line: 5))
	}
	
	func test_Locations_ScenarioOutlines() {
		when_parsingDocument(
			"""
			Feature: feature

			 Scenario Outline: scenario 1

			   Examples:
			      |foo|
			      |bar|

			   Scenario Outline: scenario 2

			   Examples:
			      |foo|
			      |bar|
			""")
		
		then_scenario(0, shouldHaveLocation: Location(column: 2, line: 3))
		then_scenario(1, shouldHaveLocation: Location(column: 4, line: 9))
	}
	
	func test_Locations_Steps_Scenario() {
		when_parsingDocument(
		"""
		Feature: feature

		Scenario: scenario
		    Given: given with table
		       | alpha |
		       | beta  |
		   When: when
		  Then: then
		""")
		
		then_step(0, forScenario: 0, shouldHaveLocation: Location(column: 5, line: 4))
		then_step(1, forScenario: 0, shouldHaveLocation: Location(column: 4, line: 7))
		then_step(2, forScenario: 0, shouldHaveLocation: Location(column: 3, line: 8))
	}
	
	func test_Locations_Steps_ScenarioOutline() {
		when_parsingDocument(
		"""
		Feature: feature

		Scenario Outline: scenario
		    Given: given
		   When: when
		  Then: then

		Examples:
		    |foo|
		    |bar|
		""")
		
		then_step(0, forScenario: 0, shouldHaveLocation: Location(column: 5, line: 4))
		then_step(1, forScenario: 0, shouldHaveLocation: Location(column: 4, line: 5))
		then_step(2, forScenario: 0, shouldHaveLocation: Location(column: 3, line: 6))
	}
	
	func test_Locations_ScenarioOutlineExamples() {
		when_parsingDocument(
		"""
		Feature: feature

		Scenario Outline: one
		   Given: given
			                   
		Examples:
		  | foo   |
		  | alpha |
		  | beta |

		  Examples: Plopp
		     | bar  |
		     | gamma |

		Scenario Outline: two
		   Given: given

		    Examples:
		       | foo   |
		       | alpha |
		""")
		
		then_examples(0, forScenario: 0, shouldHaveLocation: Location(column: 1, line: 6))
		then_examples(1, forScenario: 0, shouldHaveLocation: Location(column: 3, line: 11))
		then_examples(0, forScenario: 1, shouldHaveLocation: Location(column: 5, line: 18))
	}
	
	func test_Locations_ScenarioOutlineCells() {
		when_parsingDocument(
		"""
		Feature: feature

		Scenario Outline: scenario
		   Given: given

		Examples:
		   | foo   | bar   |
		     |alpha   | beta  |
		     |  gamma | delta |
		   | equal|    equal |
		""")
		
		then_headerCell("foo", shouldHaveLocation: Location(column: 6, line: 7))
		then_headerCell("bar", shouldHaveLocation: Location(column: 14, line: 7))

		then_rowCell("foo", atExampleRow: 0, shouldHaveLocation: Location(column: 7, line: 8))
		then_rowCell("bar", atExampleRow: 0, shouldHaveLocation: Location(column: 17, line: 8))
		then_rowCell("foo", atExampleRow: 1, shouldHaveLocation: Location(column: 9, line: 9))
		then_rowCell("bar", atExampleRow: 1, shouldHaveLocation: Location(column: 17, line: 9))
		then_rowCell("foo", atExampleRow: 2, shouldHaveLocation: Location(column: 6, line: 10))
		then_rowCell("bar", atExampleRow: 2, shouldHaveLocation: Location(column: 16, line: 10))
	}

	func test_Locations_ScenarioOutlineTableBodyAndHeader() {
		when_parsingDocument(
			"""
			Feature: feature

			Scenario Outline: scenario
			   Given: given

			   Examples: one
			    | foo   |
			      | bar |
			     | baz  |

			   Examples: two
			       | alpha   |
			     | beta      |
			         | gamma |

			   Examples: three

			      | person |

			      | ada    |

			      | alan   |
			""")
		
		then_examplesTableHeader(atExample: 0, shouldHaveLocation: Location(column: 5, line: 7))
		then_examplesTableRow(0, atExample: 0, shouldHaveLocation: Location(column: 7, line: 8))
		then_examplesTableRow(1, atExample: 0, shouldHaveLocation: Location(column: 6, line: 9))

		then_examplesTableHeader(atExample: 1, shouldHaveLocation: Location(column: 8, line: 12))
		then_examplesTableRow(0, atExample: 1, shouldHaveLocation: Location(column: 6, line: 13))
		then_examplesTableRow(1, atExample: 1, shouldHaveLocation: Location(column: 10, line: 14))

		then_examplesTableHeader(atExample: 2, shouldHaveLocation: Location(column: 7, line: 18))
		then_examplesTableRow(0, atExample: 2, shouldHaveLocation: Location(column: 7, line: 20))
		then_examplesTableRow(1, atExample: 2, shouldHaveLocation: Location(column: 7, line: 22))
	}

	func test_Locations_Tags() {
		when_parsingDocument(
		"""
		@f1
		@f2
		Feature: feature
		
		@s1  @s2
		Scenario: one
		
		  @so1
		 @so2
		Scenario Outline: two
		""")
		
		then_featureTag(0, shouldHaveLocation: Location(column: 1, line: 1))
		then_featureTag(1, shouldHaveLocation: Location(column: 1, line: 2))
		
		then_scenarioTag(0, forScenario: 0, shouldHaveLocation: Location(column: 1, line: 5))
		then_scenarioTag(1, forScenario: 0, shouldHaveLocation: Location(column: 6, line: 5))
		
		then_scenarioTag(0, forScenario: 0, shouldHaveLocation: Location(column: 3, line: 8))
		then_scenarioTag(1, forScenario: 0, shouldHaveLocation: Location(column: 2, line: 9))
	}

	func test_Locations_Comments() {
		when_parsingDocument(
		"""
		Feature: feature

		Scenario: one
		# comment one
		  # comment two
		Scenario: two
		     # comment three
		""")
		
		then_comment(0, shouldHaveLocation: Location(column: 1, line: 4))
		then_comment(1, shouldHaveLocation: Location(column: 1, line: 5))
		then_comment(2, shouldHaveLocation: Location(column: 1, line: 7))
	}
	
	private func then_feature(shouldHaveLocation location: Location,
							  file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualFeature.location, location,
					   file: file, line: line)
	}
	
	private func then_scenario(_ index: Int, shouldHaveLocation location: Location,
							   file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(scenario(at: index).location, location,
					   file: file, line: line)
	}
	
	private func then_step(_ stepIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
						   file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(scenario(at: scenarioIndex).steps[stepIndex].location, location,
					   file: file, line: line)
	}
	
	private func then_examples(_ examplesIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
							   file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(scenario(at: scenarioIndex).examples[examplesIndex].location, location,
					   file: file, line: line)
	}
	
	private func then_featureTag(_ tagIndex: Int, shouldHaveLocation location: Location,
							  file: StaticString = #file, line: UInt = #line) {
		XCTFail("not implemented")
//		XCTAssertEqual(actualFeature.tags[tagIndex].location, location,
//					   file: file, line: line)
	}

	private func then_scenarioTag(_ tagIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
							  file: StaticString = #file, line: UInt = #line) {
		XCTFail("not implemented")
//		XCTAssertEqual(scenario(at: scenarioIndex).tags[tagIndex].location, location,
//					   file: file, line: line)
	}

	private func then_comment(_ commentIndex: Int, shouldHaveLocation location: Location,
							  file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualGherkinDocument.comments[commentIndex].location, location,
					   file: file, line: line)
	}
	
	private func then_headerCell(_ headerCell: String, shouldHaveLocation location: Location,
						   file: StaticString = #file, line: UInt = #line) {
		
		XCTAssertEqual(scenario(at: 0).examples[0].table.header[headerCell].location, location,
					   file: file, line: line)
	}

	private func then_rowCell(_ column: String, atExampleRow rowIndex: Int, shouldHaveLocation location: Location,
						   file: StaticString = #file, line: UInt = #line) {
		
		XCTAssertEqual(scenario(at: 0).examples[0].table.rows[rowIndex][column].location, location,
					   file: file, line: line)
	}
	
	private func then_examplesTableHeader(atExample exampleIndex: Int, shouldHaveLocation location: Location,
										  file: StaticString = #file, line: UInt = #line) {
		
		XCTAssertEqual(scenario(at: 0).examples[exampleIndex].table.headerLocation, location,
					   file: file, line: line)
	}

	private func then_examplesTableRow(_ rowIndex: Int, atExample exampleIndex: Int, shouldHaveLocation location: Location,
										  file: StaticString = #file, line: UInt = #line) {
		
		XCTAssertEqual(scenario(at: 0).examples[exampleIndex].table.rows[rowIndex].location, location,
					   file: file, line: line)
	}
}
