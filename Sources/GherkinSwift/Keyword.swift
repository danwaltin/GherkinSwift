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
//  Keyword.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-08.
//
// ------------------------------------------------------------------------

let keywordFeature = "Feature:"
let keywordBackground = "Background:"
let keywordScenarioOutline = "Scenario Outline:"
let keywordScenario = "Scenario:"
let keywordExamples = "Examples:"
let keywordAsterisk = "*"
let keywordGiven = "Given"
let keywordWhen = "When"
let keywordThen = "Then"
let keywordAnd = "And"
let keywordBut = "But"

let tableSeparator: Character = "|"
let commentToken = "#"

enum Keyword {
	case none
	case feature
	case background
	case scenario
	case scenarioOutline
	case examples
	case given
	case when
	case then
	case and
	case but
	case asterisk
	
	case table
	case comment
	
	//	case tag
		
	
	private static let keywordMap: [Keyword: String] = [
		.feature         : keywordFeature,
		.background      : keywordBackground,
		.scenario        : keywordScenario,
		.scenarioOutline : keywordScenarioOutline,
		.examples        : keywordExamples,
		.given           : keywordGiven,
		.when            : keywordWhen,
		.then            : keywordThen,
		.and             : keywordAnd,
		.but             : keywordBut,
		.asterisk        : keywordAsterisk,
		.table           : String(tableSeparator),
		.comment         : commentToken
		
	]
	
	
	static func createFrom(text: String) -> Keyword {
		let trimmed = text.trim()
		
		for items in keywordMap {
			if trimmed.hasPrefix(items.value) {
				return items.key
			}
		}
		
		return .none
	}
	
	/**
	Remove the keyword from the given text
	*/
	func removeFrom(text: String) -> String {
		if let k = keywordAsText() {
			return text.removeKeyword(k)
		}
		return text
	}
	
	/**
	The 1-based column in the given text at which the keyword begins
	*/
	func startColumnIn(text: String) -> Int {
		if let k = keywordAsText() {
			return text.startColumnFor(text: k)
		}
		return 1
	}

	/**
	Does this keyword represent a scanario step?
	*/
	func isStep() -> Bool {
		let stepKeywords: [Keyword] = [.asterisk, .given, .when, .then, .and, .but]
		return stepKeywords.contains(self)
	}

	private func keywordAsText() -> String? {
		if Keyword.keywordMap.keys.contains(self) {
			return Keyword.keywordMap[self]
		}
		return nil
	}
}

