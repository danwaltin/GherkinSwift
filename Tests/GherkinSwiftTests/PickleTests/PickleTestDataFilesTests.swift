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
//  PickleTestDataFilesTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-19.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

@available(OSX 10.15, *)
class PickleTestDataFilesTests: XCTestCase {
	// MARK: - good test data
	let goodPath = "testdata/good"
	let goodExtension = ".feature.ast.ndjson"
	
	let goodTests = [
		"background",
		"datatables_with_new_lines",
		"datatables",
		"descriptions",
		"docstrings",
		"empty",
		"example_token_multiple",
		"example_tokens_everywhere",
		"i18n_emoji",
		"i18n_fr",
		"i18n_no",
		"incomplete_background_1",
		"incomplete_background_2",
		"incomplete_feature_1",
		"incomplete_feature_2",
		"incomplete_feature_3",
		"incomplete_scenario",
		"incomplete_scenario_outline",
		"language",
		"minimal",
		"minimal-example",
		"padded_example",
		"readme_example",
		"scenario_outline_no_newline",
		"scenario_outline_with_docstring",
		"scenario_outline_with_value_with_dollar_sign",
		"scenario_outlines_with_tags",
		"scenario_outline",
		"several_examples",
		"spaces_in_language",
		"tagged_feature_with_scenario_outline",
		"tags",
		"very_long",
	]
	/*
	These test cases are not implemented yet
	
	"complex_background",
	"escaped_pipes",
	"rule_without_name_and_description",
	"rule",
	*/
	
	//  MARK: - bad test data
	let badPath = "testdata/bad"
	let badExtension = ".feature.errors.ndjson"
	
	let badTests: [String] = [
		"inconsistent_cell_count",
		"invalid_language",
		"multiple_parser_errors",
		"not_gherkin",
		"single_parser_error",
	]
	
	/*
	These test cases are not implemented yet
	
	"unexpected_eof",
	"whitespace_in_tags",
	*/
	
	// MARK: - test cases
	func test_goodTestDataFiles() {
		executeTests(goodTests,
					 path: goodPath,
					 fileExtension: goodExtension)
	}
	
	func test_badTestDataFiles() {
		executeTests(badTests,
					 path: badPath,
					 fileExtension: badExtension)
	}
	
	// MARK: - helpers
	private func executeTests(_ tests: [String], path: String, fileExtension: String,
							  file: StaticString = #file, line: UInt = #line) {
		
		var failedTests = [String]()
		
		for test in tests {
			let success = executeTest(test: test, path: path, fileExtension: fileExtension, file: file, line: line)
			
			if !success {
				failedTests.append(test)
			}
		}
		
		XCTAssertEqual(failedTests, [], file: file, line: line)
	}
	
	private func executeTest(test: String, path: String, fileExtension: String,
							 file: StaticString = #file, line: UInt = #line) -> Bool {
		
		let expected = expectedJson(path: path, test: test, fileExtension: fileExtension)
			.withoutIds()
			.trim()
		
		let actual = parseAndGetJson(path: path, test: test)
			.replacingOccurrences(of: " :", with: ":")
			.trim()
		
		XCTAssertEqual(actual, expected, "Wrong json for '\(test)'", file: file, line: line)
		
		return actual == expected
	}
	
	private func expectedJson(path: String, test: String, fileExtension: String) -> String {
		return testFileContent(of: filePath(path, test + fileExtension))
	}
	
	private func parseAndGetJson(path: String, test: String) -> String {
		let pickledFile = gherkinFile(path: path, test: test)
		
		return getJson(from: pickledFile)
	}
	
	private func getJson(from pickledFile: PickleResult) -> String {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
		let actualJson = try! encoder.encode(pickledFile)
		
		return String(data: actualJson, encoding: .utf8)!
	}
	
	private func gherkinFile(path: String, test: String) -> PickleResult {
		
		let file = filePath(path, test + ".feature")
		let lines = parser().getAllLinesInFile(url: testFileUrl(of: file))
		
		return parser().pickle(lines: lines, fileUri: file)
	}
	
	private func testFileContent(of file: String) -> String {
		let data = try! Data(contentsOf: testFileUrl(of: file))
		
		return String(data: data, encoding: .utf8)!
	}
	
	private func testFileUrl(of file: String) -> URL {
		let thisSourceFile = URL(fileURLWithPath: #file)
		let currentDirectory = thisSourceFile.deletingLastPathComponent()
		let parentDirectory = currentDirectory.deletingLastPathComponent()
		
		return parentDirectory.appendingPathComponent(file)
	}
	
	private func filePath(_ folder: String, _ file: String) -> String {
		return folder + "/" + file
	}
	
	private func parser() -> GherkinFeatureParser {
		return GherkinFeatureParser(
			configuration: ParseConfiguration(),
			languages: LanguagesConfiguration(defaultLanguageKey: "en"))
	}
}

extension String {
	func withoutIds() -> String {
		return self
			.allLines()
			.filter{ !$0.trim().starts(with: "\"id\":") }
			.joined(separator: newLine)
	}
}
