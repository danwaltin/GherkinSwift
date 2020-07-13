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
let tagToken: Character = "@"

enum KeywordType {
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
	case tag
}

struct Keyword {
	private let type: KeywordType
	private let localizedKeyword: String
	
	private init(type: KeywordType, localizedKeyword: String) {
		self.type = type
		self.localizedKeyword = localizedKeyword
	}
	
	private static let keywordMap: [KeywordType: String] = [
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
		.comment         : commentToken,
		.tag             : String(tagToken)
	]
	
	func isType(_ t: KeywordType) -> Bool {
		return type == t
	}

	static func createFrom(text: String, language: Language) -> Keyword {
		let k = keywordTypeFrom(text: text, language: language)
		return Keyword(type: k.type, localizedKeyword: k.localizedKeyword)
	}
	
	private static func keywordTypeFrom(text: String, language: Language) -> (type: KeywordType, localizedKeyword: String) {
		let trimmed = text.trim()

		if let x = k(trimmed, keywordItems: language.feature, keywordType: .feature, keywordPostfix: ":") {
			return x
		}

		if let x = k(trimmed, keywordItems: language.scenarioOutline, keywordType: .scenario, keywordPostfix: ":") {
			return x
		}

		if let x = k(trimmed, keywordItems: language.scenario, keywordType: .scenario, keywordPostfix: ":") {
			return x
		}

		if let x = k(trimmed, keywordItems: language.given, keywordType: .given, keywordPostfix: "") {
			return x
		}

		if let x = k(trimmed, keywordItems: language.when, keywordType: .when, keywordPostfix: "") {
			return x
		}

		if let x = k(trimmed, keywordItems: language.then, keywordType: .then, keywordPostfix: "") {
			return x
		}


		for items in keywordMap {
			if trimmed.hasPrefix(items.value) {
				return (items.key, items.value)
			}
		}
		
		return (.none, "")
	}
	
	private static func k(_ line: String,
						  keywordItems: [String],
						  keywordType: KeywordType,
						  keywordPostfix: String) -> (type: KeywordType, localizedKeyword: String)? {
		for keyword in keywordItems {
			if line.hasPrefix(keyword) {
				return (keywordType, keyword + keywordPostfix)
			}
		}
		return nil
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
		let stepKeywords: [KeywordType] = [.asterisk, .given, .when, .then, .and, .but]
		return stepKeywords.contains(type)
	}

	private func keywordAsText() -> String? {
		if Keyword.keywordMap.keys.contains(type) {
			return localizedKeyword
		}
		return nil
	}
}

