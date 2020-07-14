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

let keywordAsterisk = "*"

let tableSeparator: Character = "|"
let commentToken = "#"
let tagToken: Character = "@"

struct Keyword {
	private let type: KeywordType
	let localized: String
	
	private init(type: KeywordType, localizedKeyword: String) {
		self.type = type
		self.localized = localizedKeyword
	}
	
	func isType(_ t: KeywordType) -> Bool {
		return type == t
	}
	
	static func none() -> Keyword {
		return Keyword(type: .none, localizedKeyword: "")
	}
	
	static func createFrom(text: String,
						   language: Language) -> Keyword {
		let k = KeywordFactory.keywordTypeFrom(text: text, language: language)
		return Keyword(type: k.type, localizedKeyword: k.localizedKeyword)
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
		return KeywordType.isStep(type: type)
	}
	
	private func keywordAsText() -> String? {
		if KeywordType.allCases.contains(type) {
			switch type {
			case .feature, .background, .scenario, .scenarioOutline, .examples:
				return localized + ":"
			default:
				return localized
			}
		}
		return nil
	}
}

struct KeywordFactory {
	static func keywordTypeFrom(text: String,
								language: Language) -> (type: KeywordType, localizedKeyword: String) {
		
		let trimmed = text.trim()
		
		let map: [(items: [String], type: KeywordType)] = [
			(language.feature,         .feature),
			(language.background,      .background),
			(language.scenarioOutline, .scenarioOutline),
			(language.examples,        .examples),
			(language.scenario,        .scenario),
			(language.given,           .given),
			(language.when,            .when),
			(language.then,            .then),
			(language.and,             .and),
			(language.but,             .but),
		]
		
		for item in map {
			if let localized = mapToLocalized(trimmed,
											  localizedItems: item.items,
											  keywordType: item.type) {
				return localized
			}
		}
		
		if trimmed.hasPrefix(String(tableSeparator)) {
			return (.table, String(tableSeparator))
		}
		
		if trimmed.hasPrefix(commentToken) {
			return (.comment, commentToken)
		}
		
		if trimmed.hasPrefix(String(tagToken)) {
			return (.tag, String(tagToken))
		}
		
		return (.none, "")
	}
	
	private static func mapToLocalized(_ line: String,
									   localizedItems: [String],
									   keywordType: KeywordType) -> (type: KeywordType, localizedKeyword: String)? {
		for localized in localizedItems {
			if line.hasPrefix(localized) {
				if KeywordType.isStep(type: keywordType) && localized.trim() == keywordAsterisk {
					return (.asterisk, localized)
				}
				return (keywordType, localized)
			}
		}
		return nil
	}
}
