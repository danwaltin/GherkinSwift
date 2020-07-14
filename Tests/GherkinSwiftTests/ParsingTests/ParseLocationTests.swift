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
	// MARK: - feature
	
	func test_location_feature_at_1_1() {
		when_parsingDocument(
			"""
			Feature: feature
			""")
		
		then_feature(shouldHaveLocation: Location(column: 1, line: 1))
	}
	
	func test_location_feature() {
		when_parsingDocument(
			"""
			@tag
			 Feature: feature
			""")
		
		then_feature(shouldHaveLocation: Location(column: 2, line: 2))
	}
	
	// MARK: - scenario
	
	func test_locations_scenarios() {
		when_parsingDocument(
			"""
			Feature: feature

			 Scenario: scenario 1

			   Scenario: scenario 2
			""")
		
		then_scenario(0, shouldHaveLocation: Location(column: 2, line: 3))
		then_scenario(1, shouldHaveLocation: Location(column: 4, line: 5))
	}
	
	func test_locations_steps_scenario() {
		when_parsingDocument(
			"""
		Feature: feature

		Scenario: scenario
		    Given given with table
		       | alpha |
		       | beta  |
		   When when
		  Then then
		""")
		
		then_step(0, forScenario: 0, shouldHaveLocation: Location(column: 5, line: 4))
		then_step(1, forScenario: 0, shouldHaveLocation: Location(column: 4, line: 7))
		then_step(2, forScenario: 0, shouldHaveLocation: Location(column: 3, line: 8))
	}
	
	func test_locations_stepsTableBodyAndHeader_scenario() {
		when_parsingDocument(
			"""
		Feature: feature

		Scenario: scenario
		    Given given with table
		        | alpha |
		      | beta  |
		         | gamma |
		""")
		
		then_stepTableHeader(shouldHaveLocation: Location(column: 9, line: 5))
		then_stepTableRow(0, shouldHaveLocation: Location(column: 7, line: 6))
		then_stepTableRow(1, shouldHaveLocation: Location(column: 10, line: 7))
	}
	
	func test_locations_stepsTableCells_scenario() {
		when_parsingDocument(
			"""
		Feature: feature

		Scenario: scenario
		   Given given with table
		      | foo   | bar   |
		      |  alpha |  beta  |
		      |   gamma |   delta |
			  |      equal |  equal |
		""")
		
		then_stepHeaderCell("foo", shouldHaveLocation: Location(column: 9, line: 5))
		then_stepHeaderCell("bar", shouldHaveLocation: Location(column: 17, line: 5))
		
		then_stepRowCell("foo", atStepRow: 0, shouldHaveLocation: Location(column: 10, line: 6))
		then_stepRowCell("bar", atStepRow: 0, shouldHaveLocation: Location(column: 19, line: 6))
		then_stepRowCell("foo", atStepRow: 1, shouldHaveLocation: Location(column: 11, line: 7))
		then_stepRowCell("bar", atStepRow: 1, shouldHaveLocation: Location(column: 21, line: 7))
		then_stepRowCell("foo", atStepRow: 2, shouldHaveLocation: Location(column: 11, line: 8))
		then_stepRowCell("bar", atStepRow: 2, shouldHaveLocation: Location(column: 20, line: 8))
	}
	
	func test_locations_docString_scenario() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
			"""
		Feature: feature

		Scenario: regular separator
		   Given given with docString
		   ===
		   alpha, beta
		   gamma
		   ===

		Scenario: alternative separator
		   Given given with docString
		      ---
		      alpha, beta
		      gamma
		      ---
		""")
		
		then_docString(forScenario: 0, shouldHaveLocation: Location(column: 4, line: 5))
		then_docString(forScenario: 1, shouldHaveLocation: Location(column: 7, line: 12))
	}

	// MARK: - scenario outline
	
	func test_locations_scenarioOutlines() {
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
	
	func test_locations_steps_scenarioOutline() {
		when_parsingDocument(
			"""
		Feature: feature

		Scenario Outline: scenario
		    Given given
		   When when
		  Then then

		Examples:
		    |foo|
		    |bar|
		""")
		
		then_step(0, forScenario: 0, shouldHaveLocation: Location(column: 5, line: 4))
		then_step(1, forScenario: 0, shouldHaveLocation: Location(column: 4, line: 5))
		then_step(2, forScenario: 0, shouldHaveLocation: Location(column: 3, line: 6))
	}
	
	func test_locations_scenarioOutlineExamples() {
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
	
	func test_locations_scenarioOutlineCells() {
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
		
		then_examplesHeaderCell("foo", shouldHaveLocation: Location(column: 6, line: 7))
		then_examplesHeaderCell("bar", shouldHaveLocation: Location(column: 14, line: 7))
		
		then_examplesRowCell("foo", atExampleRow: 0, shouldHaveLocation: Location(column: 7, line: 8))
		then_examplesRowCell("bar", atExampleRow: 0, shouldHaveLocation: Location(column: 17, line: 8))
		then_examplesRowCell("foo", atExampleRow: 1, shouldHaveLocation: Location(column: 9, line: 9))
		then_examplesRowCell("bar", atExampleRow: 1, shouldHaveLocation: Location(column: 17, line: 9))
		then_examplesRowCell("foo", atExampleRow: 2, shouldHaveLocation: Location(column: 6, line: 10))
		then_examplesRowCell("bar", atExampleRow: 2, shouldHaveLocation: Location(column: 16, line: 10))
	}
	
	func test_locations_scenarioOutlineTableBodyAndHeader() {
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
	
	func test_locations_docString_scenarioOutline() {
		given_docStringSeparator("===", alternative: "---")
		
		when_parsingDocument(
		"""
		Feature: feature

		Scenario Outline: one
		   Given given with docString
		   ===
		   alpha, beta
		   gamma
		   ===

		   Examples:
		     | alpha |

		Scenario Outline: two
		   Given given with docString
		      ===
		      alpha, beta
		      gamma
		      ===

		   Examples:
		      | beta |
		""")
		
		then_docString(forScenario: 0, shouldHaveLocation: Location(column: 4, line: 5))
		then_docString(forScenario: 1, shouldHaveLocation: Location(column: 7, line: 15))
	}
	
	// MARK: - tags
	func test_locations_tags() {
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
		   Given <alpha>
		
		   @e1 @e2
		    @e3
		   Examples:
		      | alpha |
		      | beta  |
		""")
		
		then_featureTag(0, shouldHaveLocation: Location(column: 1, line: 1))
		then_featureTag(1, shouldHaveLocation: Location(column: 1, line: 2))
		
		then_scenarioTag(0, forScenario: 0, shouldHaveLocation: Location(column: 1, line: 5))
		then_scenarioTag(1, forScenario: 0, shouldHaveLocation: Location(column: 6, line: 5))
		
		then_scenarioTag(0, forScenario: 1, shouldHaveLocation: Location(column: 3, line: 8))
		then_scenarioTag(1, forScenario: 1, shouldHaveLocation: Location(column: 2, line: 9))
		
		then_examplesTag(0, forScenario: 1, shouldHaveLocation: Location(column: 4, line: 13))
		then_examplesTag(1, forScenario: 1, shouldHaveLocation: Location(column: 8, line: 13))
		then_examplesTag(2, forScenario: 1, shouldHaveLocation: Location(column: 5, line: 14))
	}
	
	// MARK: - comments
	
	func test_locations_comments() {
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
	
	// MARK: - background
	
	func test_locations_background() {
		when_parsingDocument(
			"""
		Feature: feature

		   Background:
		      Given something
		""")
		
		then_background(shouldHaveLocation: Location(column: 4, line: 3))
	}
	
	// MARK: - Givens whens and thens
	private func then_feature(shouldHaveLocation location: Location,
							  file: StaticString = #file, line: UInt = #line) {
		assert.feature(file, line) {
			XCTAssertEqual($0.location, location, file: file, line: line)
		}
	}
	
	private func then_background(shouldHaveLocation location: Location,
								 file: StaticString = #file, line: UInt = #line) {
		assert.background(file, line) {
			XCTAssertEqual($0.location, location, file: file, line: line)
		}
	}
	
	private func then_scenario(_ index: Int, shouldHaveLocation location: Location,
							   file: StaticString = #file, line: UInt = #line) {
		assert.scenario(index, file, line) {
			XCTAssertEqual($0.location, location, file: file, line: line)
		}
	}
	
	private func then_step(_ stepIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
						   file: StaticString = #file, line: UInt = #line) {
		assert.step(stepIndex, forScenario: scenarioIndex, file, line) {
			XCTAssertEqual($0.location, location, file: file, line: line)
		}
	}
	
	private func then_examples(_ examplesIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
							   file: StaticString = #file, line: UInt = #line) {
		assert.examples(examplesIndex, forScenario: scenarioIndex, file, line) {
			XCTAssertEqual($0.location, location, file: file, line: line)
		}
	}
	
	private func then_featureTag(_ tagIndex: Int, shouldHaveLocation location: Location,
								 file: StaticString = #file, line: UInt = #line) {
		assert.feature(file, line) {
			assertTag(withIndex: tagIndex, $0.tags, hasLocation: location, file, line)
		}
	}
	
	private func then_scenarioTag(_ tagIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
								  file: StaticString = #file, line: UInt = #line) {
		assert.scenario(scenarioIndex, file, line) {
			assertTag(withIndex: tagIndex, $0.tags, hasLocation: location, file, line)
		}
	}
	
	private func then_examplesTag(_ tagIndex: Int, forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
								  file: StaticString = #file, line: UInt = #line) {
		assert.examples(0, forScenario: scenarioIndex, file, line) {
			assertTag(withIndex: tagIndex, $0.tags, hasLocation: location, file, line)
		}
	}
	
	private func assertTag(withIndex tagIndex: Int, _ tags: [Tag], hasLocation location: Location,
						   _ file: StaticString, _ line: UInt) {
		if (tags.count < tagIndex + 1) {
			XCTFail("No tag with index \(tagIndex)", file: file, line: line)
		} else {
			XCTAssertEqual(tags[tagIndex].location, location, file: file, line: line)
		}
	}
	
	private func then_comment(_ commentIndex: Int, shouldHaveLocation location: Location,
							  file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(actualGherkinDocument.comments[commentIndex].location, location,
					   file: file, line: line)
	}
	
	// MARK: - Step table locations
	private func then_stepHeaderCell(_ headerCell: String, shouldHaveLocation location: Location,
									 file: StaticString = #file, line: UInt = #line) {
		assert.stepTableParameter(stepIndex: 0, forScenario: 0, file, line) {
			XCTAssertEqual($0.header[headerCell].location, location,file: file, line: line)
		}
	}
	
	private func then_stepRowCell(_ column: String, atStepRow rowIndex: Int, shouldHaveLocation location: Location,
								  file: StaticString = #file, line: UInt = #line) {
		assert.stepTableParameter(stepIndex: 0, forScenario: 0, file, line) {
			XCTAssertEqual($0.rows[rowIndex][column].location, location,file: file, line: line)
		}
	}
	
	private func then_stepTableHeader(shouldHaveLocation location: Location,
									  file: StaticString = #file, line: UInt = #line) {
		assert.stepTableParameter(stepIndex: 0, forScenario: 0, file, line) {
			XCTAssertEqual($0.headerLocation, location,file: file, line: line)
		}
	}
	
	private func then_stepTableRow(_ rowIndex: Int, shouldHaveLocation location: Location,
								   file: StaticString = #file, line: UInt = #line) {
		assert.stepTableParameter(stepIndex: 0, forScenario: 0, file, line) {
			XCTAssertEqual($0.rows[rowIndex].location, location,file: file, line: line)
		}
	}
	
	// MARK: - Examples table locations
	private func then_examplesHeaderCell(_ headerCell: String, shouldHaveLocation location: Location,
										 file: StaticString = #file, line: UInt = #line) {
		assert.examples(0, forScenario: 0, file, line) {
			XCTAssertEqual($0.table.header[headerCell].location, location,file: file, line: line)
		}
	}
	
	private func then_examplesRowCell(_ column: String, atExampleRow rowIndex: Int, shouldHaveLocation location: Location,
									  file: StaticString = #file, line: UInt = #line) {
		assert.examples(0, forScenario: 0, file, line) {
			XCTAssertEqual($0.table.rows[rowIndex][column].location, location,file: file, line: line)
		}
	}
	
	private func then_examplesTableHeader(atExample exampleIndex: Int, shouldHaveLocation location: Location,
										  file: StaticString = #file, line: UInt = #line) {
		assert.examples(exampleIndex, forScenario: 0, file, line) {
			XCTAssertEqual($0.table.headerLocation, location,file: file, line: line)
		}
	}
	
	private func then_examplesTableRow(_ rowIndex: Int, atExample exampleIndex: Int, shouldHaveLocation location: Location,
									   file: StaticString = #file, line: UInt = #line) {
		assert.examples(exampleIndex, forScenario: 0, file, line) {
			XCTAssertEqual($0.table.rows[rowIndex].location, location,file: file, line: line)
		}
	}
	
	// MARK: - docString locations
	private func then_docString(forScenario scenarioIndex: Int, shouldHaveLocation location: Location,
								file: StaticString = #file, line: UInt = #line) {
		assert.stepDocStringParameter(stepIndex: 0, forScenario: scenarioIndex, file, line) {
			XCTAssertEqual($0.location, location,file: file, line: line)
		}
	}
}
