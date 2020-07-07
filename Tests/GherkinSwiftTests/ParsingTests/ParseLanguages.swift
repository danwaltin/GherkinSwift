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
//  ParseLanguages.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-05.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseLanguages: TestParseBase {
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
	
	func test_language_withBasicKeywords() {
		given_languages(
			["sv" : L(feature: ["Egenskap"],
				scenario: ["Scenario"],
				given: ["Givet"],
				when: ["När"],
				then: ["Så"])])

		when_parsingDocument(
		"""
		#language:sv
		Egenskap: Egenskap
		Scenario: scenario
		    Givet x
		    När y
		    Så z
		""")

		then_featureNameShouldBe("feature name")

		then_shouldReturnScenariosWithNames([
			"scenario name"]
		)

		then_shouldReturnScenarioWith(numberOfSteps: 3)
		then_shouldReturnScenarioWithStep(.Given, "x", atIndex: 0)
		then_shouldReturnScenarioWithStep(.When, "y", atIndex: 1)
		then_shouldReturnScenarioWithStep(.Then, "z", atIndex: 2)
	}
	
	private func given_languages(_ languages: [String: Language]) {
		
	}

	// MARK: - Givens, whens, thens
	private func L(feature: [String],
				   scenario: [String] = [],
				   given: [String] = [],
				   when: [String] = [],
				   then: [String] = []) -> Language {
		return Language(name: "name", native: "native",
						feature: feature,
						given: given,
						scenario: scenario,
						then: then,
						when: when)
	}
	
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
}
