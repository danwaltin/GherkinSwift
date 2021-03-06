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
//  ParseTagsTest.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ParseTagsTest : TestSuccessfulParseBase {

	// MARK: - Feature tags
	func test_parseFeatureWithZeroTags_shouldHaveEmptyListOfTags() {
		when_parsingDocument(
		"""
		Feature: feature without tags
		""")
		
		then_feature(shouldHaveTags: [])
	}
	
	func test_parseFeatureWithOneTag() {
		when_parsingDocument(
		"""
		@tag
		Feature: name
		""")

		then_feature(shouldHaveTags: ["tag"])
	}
	
	func test_parseFeatureWithTwoTags_onOneRow() {
		when_parsingDocument(
		"""
		@one @two
		Feature: name
		""")

		then_feature(shouldHaveTags: ["one", "two"])
	}

	func test_parseFeatureWithTwoTags_extraSpaceAfter() {
		when_parsingDocument(
		"""
		@one @two
		Feature: name
		""")

		then_feature(shouldHaveTags: ["one", "two"])
	}

	func test_parseFeatureWithTwoTags_onTwoRows() {
		when_parsingDocument(
		"""
		@one
		@two
		Feature: name
		""")

		then_feature(shouldHaveTags: ["one", "two"])
	}
	
	func test_parseFeatureWithFourTags_onTwoRows_extraSpace() {
		when_parsingDocument(
		"""
		@one @two
		@three @four
		Feature: name
		""")

		then_feature(shouldHaveTags: ["one", "two", "three", "four"])
	}

	func test_parseFeatureWithTwoTags_extraSpaceBetween() {
		when_parsingDocument(
		"""
		@one  @two
		Feature: name
		""")

		then_feature(shouldHaveTags: ["one", "two"])
	}
	
	func test_parseFeatureWithTwoTags_extraTabBetween() {
		when_parsingDocument(
		"""
		@one\t@two
		Feature: name
		""")

		then_feature(shouldHaveTags: ["one", "two"])
	}
	
	// MARK: - Scenario tags
	func test_scenarioWithOneTag() {
		when_parsingDocument(
		"""
		Feature: feature
		@tag
		Scenario: scenario
		    Then something is the result
		""")

		then_scenario(shouldHaveTags: ["tag"])
	}
	
	func test_scenarioWithTwoTags_oneRow() {
		when_parsingDocument(
		"""
		Feature: feature
		@one @two
		Scenario: scenario
		    Then something is the result
		""")

		then_scenario(shouldHaveTags: ["one", "two"])
	}
	
	func test_scenarioWithTwoTags_twoRows() {
		when_parsingDocument(
		"""
		Feature: feature
		@one
		@two
		Scenario: scenario
		    Then something is the result
		""")

		then_scenario(shouldHaveTags: ["one", "two"])
	}
	
	func test_scenarioWithTwoTags_twoExtraSpaces() {
		when_parsingDocument(
		"""
		Feature: feature
		@one   @two
		Scenario: scenario
		    Then something is the result
		""")

		then_scenario(shouldHaveTags: ["one", "two"])
	}

	func test_twoScenarioWithOneTagEach() {
		when_parsingDocument(
		"""
		Feature: feature
		@one
		Scenario: s1
		@two
		Scenario: s2
		""")

		then_scenario(0, shouldHaveTags: ["one"])
		then_scenario(1, shouldHaveTags: ["two"])
	}

	func test_backgroundBeforeScenarioWithTag() {
		when_parsingDocument(
		"""
		Feature: feature
		Background:
		  Given something
		
		@one
		@two
		Scenario: scenario
		    Then something is the result
		""")

		then_scenario(shouldHaveTags: ["one", "two"])
	}

	// MARK: - Scenario Outline tags
	func test_scenarioOutlineWithExamplesTags() {
		when_parsingDocument(
		"""
		Feature: feature
		@tag
		Scenario Outline: scenario
		    Then x
		
		@alpha @beta
		   @gamma
		 Examples:
		    | key |
		    | one |
		
		@delta
		@epsilon
		Examples: e2
		   | key |
		   | two |
		""")

		then_scenario(shouldHaveTags: ["tag"])
		then_examples(0, shouldHaveTags: ["alpha", "beta", "gamma"])
		then_examples(1, shouldHaveTags: ["delta", "epsilon"])
	}

	func test_scenarioOutlineWithOneTagTwoExamples() {
		when_parsingDocument(
		"""
		Feature: feature
		@tag
		Scenario Outline: one
		@tip @top
		Scenario Outline: two
		""")

		
		then_scenario(0, shouldHaveTags: ["tag"])
		then_scenario(1, shouldHaveTags: ["tip", "top"])
	}

	// MARK: - Feature, scenario and scenario outline tags
	func test_featureWithThreeTags_andTwoScenariosWithThreeTagsEach() {
		when_parsingDocument(
		"""
		@f1 @f2
		@f3
		Feature: f
		
		@s1.1
		@s1.2 @s1.3
		Scenario: s1
		    Then x
		
		@s2.1 @s2.2
		@s2.3
		Scenario: s2
		    Then x
		
		@s3.1 @s3.2
		@s3.3
		Scenario Outline: s3
		    Then x
		 Examples:
		    | key |
		    | one |
		    | two |
		
		@s4.1
		Scenario: s4
		    Then x
		""")

		
		then_feature(shouldHaveTags: ["f1", "f2", "f3"])
		then_scenario(0, shouldHaveTags: ["s1.1", "s1.2", "s1.3"])
		then_scenario(1, shouldHaveTags: ["s2.1", "s2.2", "s2.3"])
		then_scenario(2, shouldHaveTags: ["s3.1", "s3.2", "s3.3"])
		then_scenario(3, shouldHaveTags: ["s4.1"])
	}
	
	// MARK: - Tag with a comment
	func test_tagsWithComments() {
		when_parsingDocument(
		"""
		Feature: feature
		@tag1.1 @tag1.2 #comment
		Scenario Outline: one
		@tag#2 #another comment
		Scenario: two
		@tag3 #third comment for @tagThree
		Scenario: three
		@tag4 #comment #with comment
		Scenario: four
		""")

		
		then_scenario(0, shouldHaveTags: ["tag1.1", "tag1.2"])
		then_scenario(1, shouldHaveTags: ["tag#2"])
		then_scenario(2, shouldHaveTags: ["tag3"])
		then_scenario(3, shouldHaveTags: ["tag4"])
	}

	// MARK: - Givens, whens, thens

	private func then_feature(shouldHaveTags tags: [String], file: StaticString = #file, line: UInt = #line) {
		assert.feature(file, line) {
			assert($0, haveTags: tags, file, line)
		}
	}
	
	private func then_scenario(_ index: Int = 0, shouldHaveTags tags: [String], file: StaticString = #file, line: UInt = #line) {
		assert.scenario(index, file, line) {
			assert($0, haveTags: tags, file, line)
		}
	}

	private func then_examples(_ exampleIndex: Int = 0, shouldHaveTags tags: [String], file: StaticString = #file, line: UInt = #line) {
		assert.examples(exampleIndex, forScenario: 0, file, line) {
			assert($0, haveTags: tags, file, line)
		}
	}
	
	private func assert(_ taggable: Taggable, haveTags tags: [String], _ file: StaticString, _ line: UInt) {
		let actual = tagNames(taggable.tags)
		XCTAssertEqual(actual, tags, file: file, line: line)
	}
	
	private func tagNames(_ tags: [Tag]) -> [String] {
		return tags.map { $0.name }
	}
}
