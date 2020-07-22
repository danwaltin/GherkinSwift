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
//  ParseLanguageTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-05.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseLanguageTests: TestSuccessfulParseBase {
	func test_defaultLanguageIsUsed_whenNoLanguageIsGiven() {
		given_defaultLanguage("bpa")
		
		given_languages(
			["apa" : L(feature: ["Aaa"]),
			 "bpa" : L(feature: ["Bbb"])])
		
		when_parsingDocument(
		"""
		Bbb: feature name
		""")
		
		then_featureNameShouldBe("feature name")
	}

	func test_languageMustBeOnLineNumber_1() {
		given_defaultLanguage("bpa")
		
		given_languages(
			["apa" : L(feature: ["Aaa"]),
			 "bpa" : L(feature: ["Bbb"])])
		
		when_parsingDocument(
		"""
		
		#language: apa
		Bbb: feature name
		""")
		
		then_featureNameShouldBe("feature name")
		then_document(shouldHaveComments: [
			"#language: apa"
		])
	}

	func test_language_withBasicKeywords() {
		given_languages(
			["lang" : L(feature: ["Egenskap"],
						background: ["Bakgrund"],
						scenario: ["Testfall"],
						given: ["Givet "],
						when: ["När "],
						then: ["Så "])])
		
		when_parsingDocument(
		"""
		#language:lang
		Egenskap: Feature är Egenskap
		Bakgrund:
		    Givet bakom
		Testfall: Scenario är Testfall
		    Givet x
		    När y
		    Så z
		""")
		
		then_featureNameShouldBe("Feature är Egenskap")
		
		then_shouldReturnBackgroundWith(numberOfSteps: 1)
		then_shouldReturnBackgroundWithStep(.given, "bakom")

		then_shouldReturnScenariosWithNames([
			"Scenario är Testfall"]
		)
		
		then_shouldReturnScenarioWith(numberOfSteps: 3)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.when, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.then, "z", atIndex: 2)
	}

	func test_language_withAndAndBut() {
		given_languages(
			["lang" : L(feature: ["Egenskap"],
						background: ["Bakgrund"],
						scenario: ["Testfall"],
						given: ["Givet "],
						and: ["Och "],
						but: ["Men "])])
		
		when_parsingDocument(
		"""
		#language:lang
		Egenskap: Feature är Egenskap
		Bakgrund:
		    Givet bakom
		Testfall: Scenario är Testfall
		    Givet x
		    Och y
		    Men z
		""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 3)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.and, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.but, "z", atIndex: 2)
	}

	func test_language_scenarioOutline() {
		given_languages(
			// note that for english "scenario"
			// can be called "Example", which is
			// the same beginning as of "Examples"
			// in a scenario outline
			["en" : L(feature: ["Feature"],
					  scenario: ["Example", "Scenario"],
					  scenarioOutline: ["Scenario Outline"],
					  examples: ["Examples"],
					  given: ["Given "]),
			 "sv" : L(feature: ["Egenskap"],
					  scenario: ["Scenario"],
					  scenarioOutline: ["Scenariomall"],
					  examples: ["Exempel"],
					  given: ["Givet "])])

		// english
		when_parsingDocument(
		"""
		#language:en
		Feature: Feature
		Scenario Outline: Scenario outline
		    Given x '<y>'
		Examples:
			| y |
			| 1 |
		""")
		
		then_shouldReturnScenarioWith(numberOfExamples: 1)
		then_shouldReturnScenarioWithExamples(
			atIndex: 0,
			name: "",
			table(
				"y",
				"1"))

		// swedish
		when_parsingDocument(
		"""
		#language:sv
		Egenskap: Egenskap
		Scenariomall: Scenariomall
		    Givet x '<y>'
		Exempel:
			| y |
			| 1 |
		""")
		
		then_shouldReturnScenarioWith(numberOfExamples: 1)
		then_shouldReturnScenarioWithExamples(
			atIndex: 0,
			name: "",
			table(
				"y",
				"1"))
	}

	func test_language_withBasicKeywords_twoKLocalizedeywordsPerType_first() {
		given_languages(
			["lang" : L(feature: ["Feature One", "Feature Two"],
						scenario: ["Scenario One", "Scenario Two"],
						given: ["Given One ", "Given Two "],
						when: ["When One ", "When Two "],
						then: ["Then One ", "Then Two "])])
		
		when_parsingDocument(
			"""
		#language:lang
		Feature One: Feature name
		Scenario One: Scenario name
		    Given One x
		    When One y
		    Then One z
		""")
		
		then_featureNameShouldBe("Feature name")
		
		then_shouldReturnScenariosWithNames([
			"Scenario name"]
		)
		
		then_shouldReturnScenarioWith(numberOfSteps: 3)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.when, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.then, "z", atIndex: 2)
	}
	
	func test_language_withBasicKeywords_twoKLocalizedeywordsPerType_second() {
		given_languages(
			["lang" : L(feature: ["Feature One", "Feature Two"],
						scenario: ["Scenario One", "Scenario Two"],
						given: ["Given One ", "Given Two "],
						when: ["When One ", "When Two "],
						then: ["Then One ", "Then Two "])])
		
		when_parsingDocument(
			"""
		#language:lang
		Feature Two: Feature name
		Scenario Two: Scenario name
		    Given Two x
		    When Two y
		    Then Two z
		""")
		
		then_featureNameShouldBe("Feature name")
		
		then_shouldReturnScenariosWithNames([
			"Scenario name"]
		)
		
		then_shouldReturnScenarioWith(numberOfSteps: 3)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.when, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.then, "z", atIndex: 2)
	}
	
	func test_language_withAsterisksAsSteps() {
		given_languages(
			["given" : L(feature: ["Feature"],
						 scenario: ["Scenario"],
						 given: ["* ", "Given "],
						 when: ["When "],
						 then: ["Then "],
						 and: ["And "],
						 but: ["But "]),
			"when" : L(feature: ["Feature"],
						scenario: ["Scenario"],
						given: ["Given "],
						when: ["* ", "When "],
						then: ["Then "],
						and: ["And "],
						but: ["But "]),
			"then" : L(feature: ["Feature"],
						scenario: ["Scenario"],
						given: ["Given "],
						when: ["When "],
						then: ["* ", "Then "],
						and: ["And "],
						but: ["But "]),
			"and" : L(feature: ["Feature"],
						scenario: ["Scenario"],
						given: ["Given"],
						when: ["When "],
						then: ["Then "],
						and: ["* ", "And "],
						but: ["But "]),
			"but" : L(feature: ["Feature"],
						scenario: ["Scenario"],
						given: ["Given "],
						when: ["When "],
						then: ["Then "],
						and: ["And "],
						but: ["* ", "But "]),
			"allfive" : L(feature: ["Feature"],
						scenario: ["Scenario"],
						given: ["* ", "Given "],
						when: ["* ", "When "],
						then: ["* ", "Then "],
						and: ["* ", "And "],
						but: ["* ", "But "]),
		])

		// Given
		when_parsingDocument(
		"""
		#language:given
		Feature: Feature name
		Scenario: Scenario name
		    * x
		    When y
		    Then z
		    And a
		    But b
		""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 5)
		then_shouldReturnScenarioWithStep(.asterisk, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.when, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.then, "z", atIndex: 2)
		then_shouldReturnScenarioWithStep(.and, "a", atIndex: 3)
		then_shouldReturnScenarioWithStep(.but, "b", atIndex: 4)

		// When
		when_parsingDocument(
		"""
		#language:when
		Feature: Feature name
		Scenario: Scenario name
		    Given x
		    * y
		    Then z
		    And a
		    But b
		""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 5)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.asterisk, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.then, "z", atIndex: 2)
		then_shouldReturnScenarioWithStep(.and, "a", atIndex: 3)
		then_shouldReturnScenarioWithStep(.but, "b", atIndex: 4)

		// Then
		when_parsingDocument(
		"""
		#language:then
		Feature: Feature name
		Scenario: Scenario name
		    Given x
		    When y
		    * z
		    And a
		    But b
		""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 5)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.when, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.asterisk, "z", atIndex: 2)
		then_shouldReturnScenarioWithStep(.and, "a", atIndex: 3)
		then_shouldReturnScenarioWithStep(.but, "b", atIndex: 4)

		// And
		when_parsingDocument(
		"""
		#language:and
		Feature: Feature name
		Scenario: Scenario name
		    Given x
		    When y
		    Then z
		    * a
		    But b
		""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 5)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.when, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.then, "z", atIndex: 2)
		then_shouldReturnScenarioWithStep(.asterisk, "a", atIndex: 3)
		then_shouldReturnScenarioWithStep(.but, "b", atIndex: 4)

		// But
		when_parsingDocument(
		"""
		#language:and
		Feature: Feature name
		Scenario: Scenario name
		    Given x
		    When y
		    Then z
		    And a
		    * b
		""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 5)
		then_shouldReturnScenarioWithStep(.given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.when, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.then, "z", atIndex: 2)
		then_shouldReturnScenarioWithStep(.and, "a", atIndex: 3)
		then_shouldReturnScenarioWithStep(.asterisk, "b", atIndex: 4)


		// All five
		when_parsingDocument(
		"""
		#language:allfive
		Feature: Feature name
		Scenario: Scenario name
		    * x
		    * y
		    * z
		    * a
		    * b
		""")
		
		then_shouldReturnScenarioWith(numberOfSteps: 5)
		then_shouldReturnScenarioWithStep(.asterisk, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.asterisk, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.asterisk, "z", atIndex: 2)
		then_shouldReturnScenarioWithStep(.asterisk, "a", atIndex: 3)
		then_shouldReturnScenarioWithStep(.asterisk, "b", atIndex: 4)
	}
	
	func test_language_identifier_with_spaces() {
		given_languages(
			["sv" : L(feature: ["Egenskap"],
					  scenario: ["Scenario"],
					  given: ["Givet "],
					  when: ["När "],
					  then: ["Så "])])

		// one space
		when_parsingDocument(
		"""
		# language: sv
		Egenskap: Ett mellanslag
		""")
		
		then_featureNameShouldBe("Ett mellanslag")

		// two spaces
		when_parsingDocument(
		"""
		#  language: sv
		Egenskap: Två mellanslag
		""")
		
		then_featureNameShouldBe("Två mellanslag")

		// three spaces
		when_parsingDocument(
		"""
		#  language: sv
		Egenskap: Tre mellanslag
		""")
		
		then_featureNameShouldBe("Tre mellanslag")

		// space before #
		when_parsingDocument(
		"""
		 #language: sv
		Egenskap: Mellanslag innan brädgård
		""")
		
		then_featureNameShouldBe("Mellanslag innan brädgård")

		// space before :
		when_parsingDocument(
		"""
		#language : sv
		Egenskap: Mellanslag innan kolon
		""")
		
		then_featureNameShouldBe("Mellanslag innan kolon")
	}
	
	// MARK: - Givens, whens, thens
	
	private func then_featureNameShouldBe(_ name: String,
										  file: StaticString = #file, line: UInt = #line) {
		assert.feature(file, line) {
			XCTAssertEqual($0.name, name, file: file, line: line)
		}
	}
	
	func then_shouldReturnScenariosWithNames(_ names: [String],
											 file: StaticString = #file, line: UInt = #line) {
		assert.scenarios(withNames: names, file, line)
	}
	
	private func then_shouldReturnScenarioWith(numberOfSteps expected: Int,
											   file: StaticString = #file, line: UInt = #line) {
		assert.scenario(0, file, line) {
			XCTAssertEqual($0.steps.count, expected, file: file, line: line)
		}
	}
	
	private func then_shouldReturnScenarioWithStep(_ stepType: StepType,
												   _ text: String,
												   atIndex index: Int = 0,
												   file: StaticString = #file, line: UInt = #line) {
		assert.step(stepType, text, atIndex: index, forScenario: 0, file, line)
	}
	
	private func then_shouldReturnBackgroundWith(numberOfSteps expected: Int,
												 file: StaticString = #file, line: UInt = #line) {
		assert.background(file, line) {
			XCTAssertEqual($0.steps.count, expected, file: file, line: line)
		}
	}
	
	private func then_shouldReturnBackgroundWithStep(_ stepType: StepType,
													 _ text: String,
													 atIndex index: Int = 0,
													 file: StaticString = #file, line: UInt = #line) {
		assert.backgroundStep(atIndex: index, file, line) {
			XCTAssertEqual($0.type, stepType, file: file, line: line)
			XCTAssertEqual($0.text, text, file: file, line: line)
		}
	}

	private func then_shouldReturnScenarioWith(numberOfExamples expected: Int,
											   file: StaticString = #file, line: UInt = #line) {
		
		assert.scenario(0, file, line) {
			XCTAssertEqual($0.examples.count, expected, file: file, line: line)
		}
	}

	private func then_shouldReturnScenarioWithExamples(atIndex index: Int,
													   name: String,
													   _ table: Table,
													   file: StaticString = #file, line: UInt = #line) {
		assert.examples(index, forScenario: 0, file, line) {
			XCTAssertEqual($0.name, name, file: file, line: line)
			XCTAssertEqual($0.table!.withoutLocation(), table, file: file, line: line)
		}
	}
}
