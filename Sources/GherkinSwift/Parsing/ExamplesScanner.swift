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
//  ExamplesScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-29.
//
// ------------------------------------------------------------------------

class ExamplesScanner {
	var name = ""
	
	private var parseErrors = [ParseError]()

	var isScanningDescription = false
	var descriptionLines = [String]()

	private var location = Location.zero()

	var isScanningTable = false
	let tableScanner: TableScanner

	private let tags: [Tag]
	
	init(tags: [Tag], tableScanner: TableScanner) {
		self.tags = tags
		self.tableScanner = tableScanner
	}
	
	func scan(_ line: Line, fileUri: String) {
		handleName(line)
		handleTable(line, fileUri: fileUri)
		handleDescription(line)
	}
	
	private func handleName(_ line: Line) {
		if line.isEmpty() {
			return
		}

		if line.hasKeyword(.examples) {
			name = line.keywordRemoved()
			location = Location(column: line.columnForKeyword(), line: line.number)
		}
	}
	
	private func handleDescription(_ line: Line) {
		if isScanningDescription && !isScanningTable {
			descriptionLines.append(line.text)
		} else if !line.hasKeyword(.examples) && !line.hasKeyword(.table) && !isScanningDescription &&  !line.isEmpty() {
			isScanningDescription = true
			descriptionLines.append(line.text)
		}
	}
	
	private func handleTable(_ line: Line, fileUri: String) {
		if line.isEmpty() {
			return
		}

		isScanningTable = isScanningTable || line.hasKeyword(.table)
		
		if isScanningTable {
			if !tableScanner.lineBelongsToTable(line) {
				let tags = "#TableRow, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty"
				parseErrors.append(
					ParseError.invalidGherkin(tags, atLine: line, inFile: fileUri))
			} else {
				tableScanner.scan(line)
			}
		}
	}

	func getExamples() -> (examples: ScenarioOutlineExamples, errors: [ParseError]) {
		let tableWithErrors = tableScanner.getTable()
		
		parseErrors.append(contentsOf: tableWithErrors.errors)
		
		let examples = ScenarioOutlineExamples(name: name,
											   description: descriptionLines.asDescription(),
											   tags: tags,
											   location: location,
											   table: tableWithErrors.table)
		
		return (examples, parseErrors)
	}
}
