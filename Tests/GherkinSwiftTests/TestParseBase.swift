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
//  TestParseBase.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class TestParseBase: XCTestCase {
	var actualPickleResult: PickleResult!
	
	var docStringSeparator: String = "..."
	var alternativeDocStringSeparator: String = ",,,"
	var defaultLanguage: String = ""
	var languages: [String: Language] = [:]
	
	override func setUp() {
		setupDefaultTestLanguage()
	}

	func given_defaultLanguage(_ languageCode: String) {
		defaultLanguage = languageCode
	}

	func given_languages(_ languages: [String: Language]) {
		self.languages = languages
	}

	func given_languageWithAsterisk() {
		setupDefaultTestLanguage(given: ["* ", "Given "])
	}
	
	private func setupDefaultTestLanguage(given: [String] = ["Given "]) {
		// Default to the same english language as in
		// the gherkin-languages.json file,
		// but without the extra keywords
		// but potentially different "given" keywords
		given_defaultLanguage("en")
		given_languages(
			["en" : Language(key: "en",
							 name: "English",
							 native: "English",
							 and: ["And "],
							 background: ["Background"],
							 but: ["But "],
							 examples: ["Examples"],
							 feature: ["Feature"],
							 given: given,
							 rule: ["Rule"],
							 scenario: ["Scenario"],
							 scenarioOutline: ["Scenario Outline"],
							 then: ["Then "],
							 when: ["When "])])
	}
	
	func given_docStringSeparator(_ separator: String, alternative: String) {
		docStringSeparator = separator
		alternativeDocStringSeparator = alternative
	}
	
	func when_parsingDocument(_ document: String) {
		when_parsingDocument(document, parser())
	}

	func when_parsingDocument(_ document: String, _ parser: GherkinFeatureParser) {
		actualPickleResult = parseDocument(document, parser: parser)
	}

	func when_parsing(_ lines: [String]) {
		actualPickleResult = parse(lines, parser: parser())
	}

	private func parse(_ lines: [String], parser: GherkinFeatureParser) -> PickleResult {
		return parser.pickle(lines: lines, fileUri: "")
	}

	func parseDocument(_ document: String, parser: GherkinFeatureParser) -> PickleResult {
		let lines = parser.getAllLinesInDocument(document: document)
		return parse(lines, parser: parser)
	}

	func parser() -> GherkinFeatureParser {
		return GherkinFeatureParser(
			configuration: ParseConfiguration(
				docStringSeparator: docStringSeparator,
				alternativeDocStringSeparator: alternativeDocStringSeparator),
			languages: LanguagesConfiguration(
				defaultLanguageKey: defaultLanguage,
				languages: languages))
	}
		
	// MARK: - Factory methods
	func L(feature: [String],
		   background: [String] = [],
		   scenario: [String] = [],
		   scenarioOutline: [String] = [],
		   examples: [String] = [],
		   given: [String] = [],
		   when: [String] = [],
		   then: [String] = [],
		   and: [String] = [],
		   but: [String] = []) -> Language {
		return Language(key: "key", name: "name", native: "native",
						and: and,
						background: background,
						but: but,
						examples: examples,
						feature: feature,
						given: given,
						rule: [],
						scenario: scenario,
						scenarioOutline: scenarioOutline,
						then: then,
						when: when)
	}

	func table(_ col: String,
	           _ r1c1: String) -> Table {
		return Table.withColumns([col])
			.addingRow(cells: [cell(r1c1, col)], location: Location.zero())
	}
	
	func table(_ col: String,
	           _ r1c1: String,
	           _ r2c1: String) -> Table {
		return Table.withColumns([col])
			.addingRow(cells: [cell(r1c1, col)], location: Location.zero())
			.addingRow(cells: [cell(r2c1, col)], location: Location.zero())
	}
	
	func table(_ c1: String, _ c2: String,
	           _ r1c1: String, _ r1c2: String) -> Table {
		return Table.withColumns([c1, c2])
			.addingRow(cells: [cell(r1c1, c1), cell(r1c2, c2)], location: Location.zero())
	}
	
	func table(_ c1: String, _ c2: String,
	           _ r1c1: String, _ r1c2: String,
	           _ r2c1: String, _ r2c2: String) -> Table {
		return Table.withColumns([c1, c2])
			.addingRow(cells: [cell(r1c1, c1), cell(r1c2, c2)], location: Location.zero())
			.addingRow(cells: [cell(r2c1, c1), cell(r2c2, c2)], location: Location.zero())
	}
	
	private func cell(_ value: String, _ header: String) -> TableCell {
		return TableCell(value: value, location: Location.zero(), header: header)
	}
}
