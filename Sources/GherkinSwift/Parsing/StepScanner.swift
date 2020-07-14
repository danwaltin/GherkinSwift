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
	
	var text = ""
	var location = Location(column: 0, line: 0)
	var step: Step!
	var keyword = Keyword.none()
	
	let tableScanner: TableScanner
	let docStringScanner: DocStringScanner

	init(tableScanner: TableScanner, docStringScanner: DocStringScanner) {
		self.tableScanner = tableScanner
		self.docStringScanner = docStringScanner
	}

	func getStep() -> Step {
		return Step(step.type,
					step.text,
					location: location,
					tableParameter: tableScanner.getTable(),
					docStringParameter: docStringScanner.getDocString(),
					localizedKeyword: keyword.localized)
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

		if line.hasKeyword(.asterisk) {
			step = Step(.asterisk, line.keywordRemoved(), localizedKeyword: "")
		}

		if line.hasKeyword(.given) {
			step = Step(.given, line.keywordRemoved(), localizedKeyword: "")
		}

		if line.hasKeyword(.when) {
			step = Step(.when, line.keywordRemoved(), localizedKeyword: "")
		}

		if line.hasKeyword(.then) {
			step = Step(.then, line.keywordRemoved(), localizedKeyword: "")
		}

		if line.hasKeyword(.and) {
			step = Step(.and, line.keywordRemoved(), localizedKeyword: "")
		}

		if line.hasKeyword(.but) {
			step = Step(.but, line.keywordRemoved(), localizedKeyword: "")
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
