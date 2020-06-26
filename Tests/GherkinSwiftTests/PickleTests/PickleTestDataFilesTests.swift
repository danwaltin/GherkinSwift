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
	let goodTests = [
		//"descriptions",
		"empty",
		"incomplete_feature_1",
		"incomplete_feature_2",
		"minimal"]

	func test_goodTestDataFiles() {

		let goodPath = "testdata/good"
		
		var failedTests = [String]()
		
		for test in goodTests {
			let expected = expectedJson(path: goodPath, test: test)
				.trim()
			
			let actual = parseAndGetJson(path: goodPath, test: test)
				.replacingOccurrences(of: " :", with: ":")
				.trim()
		
			if actual != expected {
				failedTests.append(test)
			}
			XCTAssertEqual(actual, expected, "Wrong json for '\(test)'")
		}
		
		XCTAssertEqual(failedTests, [])
	}
	
	private func expectedJson(path: String, test: String) -> String {
		return testFileContent(of: filePath(path, test + ".feature.ast.ndjson"))
	}
	
	private func parseAndGetJson(path: String, test: String) -> String {
		let pickledFile = gherkinFile(path: path, test: test)

		return getJson(from: pickledFile)
	}
	
	private func getJson(from pickledFile: GherkinFile) -> String {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
		let actualJson = try! encoder.encode(pickledFile)

		return String(data: actualJson, encoding: .utf8)!
	}
	
	private func gherkinFile(path: String, test: String) -> GherkinFile {
		
		let file = filePath(path, test + ".feature")
		let lines = testFileContent(of: file).allLines()

		return parser().pickle(lines: lines, fileUri: file)
	}
	
	private func testFileContent(of file: String) -> String {
		let thisSourceFile = URL(fileURLWithPath: #file)
		let currentDirectory = thisSourceFile.deletingLastPathComponent()
		let parentDirectory = currentDirectory.deletingLastPathComponent()
		
		let testFileURL = parentDirectory.appendingPathComponent(file)
		let data = try! Data(contentsOf: testFileURL)
		
		return String(data: data, encoding: .utf8)!
	}

	private func filePath(_ folder: String, _ file: String) -> String {
		return folder + "/" + file
	}
	
	private func parser() -> GherkinFeatureParser {
		return GherkinFeatureParser()
	}
}

