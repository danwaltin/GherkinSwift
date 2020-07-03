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
//  ScenarioOutlineScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

class ScenarioOutlineScanner : ScenarioScanner {
//	var isScanningExamples = false
//	var currentExamplesScanner: ScenarioOutlineExamplesScanner!
//	var examplesScanners = [ScenarioOutlineExamplesScanner]()
//
//	override func scan(line: Line, _ commentCollector: CommentCollector) {
//		if line.isScenarioOutline() {
//			name = line.removeKeyword(keywordScenarioOutline)
//			lineNumber = line.number
//			columnNumber = line.columnForKeyword(keywordScenarioOutline)
//
//
//		} else if line.isExamples() {
//			isScanningExamples = true
//			currentExamplesScanner = ScenarioOutlineExamplesScanner()
//			examplesScanners += [currentExamplesScanner]
//
//			currentExamplesScanner.scan(line: line)
//
//		} else if isScanningExamples {
//			currentExamplesScanner.scan(line: line)
//
//		} else {
//			super.scan(line: line, commentCollector)
//		}
//	}
//
//	override func getScenarios() -> [Scenario] {
//		var scenarios = [Scenario]()
//		scenarios.append(Scenario(name: name,
//								  description: descriptionLines.asDescription(),
//								  tags: scenarioTags,
//								  location: location(),
//								  steps: steps(),
//								  examples: examples()))
//
//		return scenarios
//	}
	
//	func examples() -> [ScenarioOutlineExamples] {
//		return examplesScanners.map{$0.getExamples()}
//	}
	
//	private func replacePlaceHolders(_ step: Step, _ examplesRow: TableRow) -> Step {
//		return Step(
//			type: step.type,
//			text: replacePlaceHolders(step.text, examplesRow),
//			location: Location(column: 0, line: 0),
//			tableParameter: replacePlaceHolders(step.tableParameter, examplesRow))
//	}
//	
//	private func replacePlaceHolders(_ table: Table?, _ examplesRow: TableRow) -> Table? {
//		if table == nil {
//			return nil
//		}
//		
//		var newTable = Table(columns: replacePlaceHolders(table!.columns, examplesRow))
//		for row in table!.rows {
//			let keys = cellsWithReplacedKeys(row, examplesRow)
//			let values = replacePlaceHolders(keys, examplesRow)
//			newTable = newTable.addingRow(cells: values)
//		}
//		return newTable
//	}
//	
//	private func cellsWithReplacedKeys(_ row: TableRow, _ examplesRow: TableRow) -> [String: String] {
//		let rowCells = row.cells
//		var rowCellsWithReplacedKeys = [String: String]()
//		for oldKey in rowCells.keys {
//			let newKey = replacePlaceHolders(oldKey, examplesRow)
//			let value = rowCells[oldKey]
//			rowCellsWithReplacedKeys[newKey] = value
//		}
//		
//		return rowCellsWithReplacedKeys
//	}
//	
//	private func replacePlaceHolders(_ cells: [String: String], _ examplesRow: TableRow) -> [String: String] {
//		var replaced = [String: String]()
//		
//		for cell in cells {
//			let newValue = replacePlaceHolders(cell.value, examplesRow)
//			replaced[cell.key] = newValue
//		}
//		return replaced
//	}
//	
//	private func replacePlaceHolders(_ items: [String], _ examplesRow: TableRow) -> [String] {
//		var replaced = [String]()
//		for item in items {
//			replaced.append(replacePlaceHolders(item, examplesRow))
//		}
//		
//		return replaced
//	}
//	
//	private func replacePlaceHolders(_ value: String, _ examplesRow: TableRow) -> String {
//		
//		var newText = value
//		
//		for column in examplesRow.cells.keys {
//			let placeHolder = "<\(column)>"
//			
//			if value.contains(placeHolder) {
//				let value = "\(examplesRow[column])"
//				newText = newText.replacingOccurrences(of: placeHolder, with: value)
//			}
//		}
//		
//		return newText
//	}
}
