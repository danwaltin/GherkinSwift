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
//  ParseSeveralFeaturesWithSameInstance.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class ParseSeveralFeaturesWithSameInstance : TestParseBase {

	func test_parsingTwoFeaturesWithTheSameParserInstance() {
		let instance = parser()
		
		let one = parseDocument(
			"""
			@tagF1
			Feature: f1
			@tagS1
			Scenario: s1
			    Given g1
			""",
			parser: instance).feature!
		
		let two = parseDocument(
			"""
			@tagF2
			Feature: f2
			@tagS21
			Scenario: s2.1
			    Given g2.1.1
			    Given g2.1.2
			@tagS22
			Scenario: s2.2
			    Given g2.2.1
			""",
			parser: instance).feature!
		
		XCTAssertEqual(one,
					   feature("f1", [Tag(name: "tagF1", location: Location(column: 1, line: 1))], Location(column: 1, line: 2), [
						scenario("s1", [Tag(name: "tagS1", location: Location(column: 1, line: 3))], Location(column: 1, line: 4), [
							given("g1", Location(column: 5, line: 5))
							])
						]
			)
		)

		XCTAssertEqual(two,
					   feature("f2", [Tag(name: "tagF2", location: Location(column: 1, line: 1))], Location(column: 1, line: 2),[
						scenario("s2.1", [Tag(name: "tagS21", location: Location(column: 1, line: 3))], Location(column: 1, line: 4), [
							given("g2.1.1", Location(column: 5, line: 5)),
							given("g2.1.2", Location(column: 5, line: 6))]),
						scenario("s2.2", [Tag(name: "tagS22", location: Location(column: 1, line: 7))], Location(column: 1, line: 8), [
							given("g2.2.1", Location(column: 5, line: 9))
							])
						]
			)
		)
	}
	
	private func feature(_ name: String, _ tags: [Tag], _ location: Location, _ scenarios: [Scenario]) -> Feature {
		return Feature(name: name, description: nil, background: nil, tags: tags, location: location, scenarios:  scenarios)
	}
	
	private func scenario(_ name: String, _ tags: [Tag], _ location: Location, _ steps: [Step]) -> Scenario {
		return Scenario(name: name, description: nil, tags: tags, location: location, steps: steps, examples: [], localizedKeyword: "Scenario")
	}
	
	private func given(_ text: String, _ location: Location) -> Step {
		return Step.given(text, location: location)
	}
	
	private func t(_ name: String) -> Tag {
		return Tag(name: name, location: Location.zero())
	}
}
