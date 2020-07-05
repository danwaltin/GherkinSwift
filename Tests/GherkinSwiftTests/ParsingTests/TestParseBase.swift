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
	var actualGherkinDocument: GherkinDocument!
	
	func when_parsingDocument(_ document: String) {
		actualGherkinDocument = parseDocument(document, parser: parser())
	}

	func when_parsing(_ lines: [String]) {
		actualGherkinDocument = parse(lines, parser: parser())
	}

	private func parse(_ lines: [String], parser: GherkinFeatureParser) -> GherkinDocument {
		return parser.pickle(lines: lines, fileUri: "").gherkinDocument
	}

	func parseDocument(_ document: String, parser: GherkinFeatureParser) -> GherkinDocument {
		let lines = document.allLines()
		return parse(lines, parser: parser)
	}

	func parser() -> GherkinFeatureParser {
		return GherkinFeatureParser()
	}
		
	// MARK: - Factory methods
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
	
	// MARK: - Assertions
	var assert: Asserter {
		return Asserter(actualDocument: actualGherkinDocument)
	}
}

