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
//  ParseCommentsTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-26.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class ParseCommentsTests: TestSuccessfulParseBase {
	func testScenarioWithComment() {
		when_parsingDocument(
		"""
		Feature: feature

		Scenario: one
		# This is a comment!

		Scenario: two
		   # Another comment!

		Scenario: three
		   Given something
		      | foo |
		      # Third comment
		      | bar |
		""")
		
		then_document(shouldHaveComments: [
			"# This is a comment!",
			"   # Another comment!",
			"      # Third comment"])
	}

	func testCommentsInTheFeatureAndTheBackground() {
		when_parsingDocument(
		"""
		# This is a comment!
		Feature: feature
		  # Another comment!

		Background:
		   # Third comment
		   Given something
		      | foo |
		      # Fourth comment
		      | bar |

		Scenario: scenario

		""")
		
		then_document(shouldHaveComments: [
			"# This is a comment!",
			"  # Another comment!",
			"   # Third comment",
			"      # Fourth comment"])
	}

	func testDocumentWithNothingButAComment() {
		when_parsingDocument(
		"""
		  # This is the only thing
		""")
		
		then_document(shouldHaveComments: [
			"  # This is the only thing"])
	}
}
