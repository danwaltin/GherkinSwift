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
//  StepScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

class StepScanner {
	enum State {
		case started
		case scanningStep
		case scanningTableParameter
		case scanningDocString
	}

	var state: State = .started
	
	var type = StepType.asterisk
	var text = ""
	var location = Location(column: 0, line: 0)
	var keyword = Keyword.none()
	
	let tableScanner: TableScanner
	let docStringScanner: DocStringScanner

	init(tableScanner: TableScanner, docStringScanner: DocStringScanner) {
		self.tableScanner = tableScanner
		self.docStringScanner = docStringScanner
	}

	func getStep() -> (step: Step, errors: [ParseError]) {
		let tableWithErrors = tableScanner.getTable()
		let step = Step(type,
						text,
						location: location,
						tableParameter: tableWithErrors.table,
						docStringParameter: docStringScanner.getDocString(),
						localizedKeyword: keyword.localized)

		return (step, tableWithErrors.errors)
	}
	
	func lineBelongsToStep(_ line: Line) -> Bool {
		if line.isEmpty() {
			return true
		}

		switch state {
		case .started:
			return line.isStep()
			
		case .scanningStep:
			return shouldStartScanTable(line) || shouldStartScanDocString(line)

		case .scanningTableParameter:
			return tableScanner.lineBelongsToTable(line)

		case .scanningDocString:
			return docStringScanner.lineBelongsToDocString(line)
		}
	}
	
	func scan(_ line: Line) {
		switch state {
		case .started:
			if !line.isEmpty() {
				handleStepText(line)
				state = .scanningStep
			}
			
		case .scanningStep:
			if shouldStartScanTable(line) {
				handleTable(line)
				state = .scanningTableParameter
			}
			if shouldStartScanDocString(line) {
				handleDocString(line)
				state = .scanningDocString
			}

		case .scanningTableParameter:
			handleTable(line)

		case .scanningDocString:
			handleDocString(line)
		}
	}
	
	private func handleStepText(_ line: Line) {
		location = Location(column: line.columnForKeyword(), line: line.number)
		text = line.keywordRemoved()
		keyword = line.keyword
		
		if line.hasKeyword(.asterisk) {
			type = .asterisk
		}

		if line.hasKeyword(.given) {
			type = .given
		}

		if line.hasKeyword(.when) {
			type = .when
		}

		if line.hasKeyword(.then) {
			type = .then
		}

		if line.hasKeyword(.and) {
			type = .and
		}

		if line.hasKeyword(.but) {
			type = .but
		}
	}
	
	private func shouldStartScanTable(_ line: Line) -> Bool {
		return line.hasKeyword(.table)
	}

	private func shouldStartScanDocString(_ line: Line) -> Bool {
		return docStringScanner.isDocString(line)
	}

	private func handleTable(_ line: Line) {
		if line.hasKeyword(.table) {
			tableScanner.scan(line)
		}
	}

	private func handleDocString(_ line: Line) {
		docStringScanner.scan(line)
	}
}
