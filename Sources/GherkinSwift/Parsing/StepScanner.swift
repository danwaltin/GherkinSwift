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
	
	let tableScanner: TableScanner
	let docStringScanner: DocStringScanner

	init(tableScanner: TableScanner, docStringScanner: DocStringScanner) {
		self.tableScanner = tableScanner
		self.docStringScanner = docStringScanner
	}

	func getStep() -> Step {
		return Step(type: step.type,
					text: step.text,
					location: location,
					tableParameter: tableScanner.getTable(),
					docStringParameter: docStringScanner.getDocString())
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
		if line.isAsterisk() {
			location = Location(column: line.columnForKeyword(keywordAsterisk), line: line.number)
			step = Step.asterisk(line.removeKeyword(keywordAsterisk))
		}

		if line.isGiven() {
			location = Location(column: line.columnForKeyword(keywordGiven), line: line.number)
			step = Step.given(line.removeKeyword(keywordGiven))
		}

		if line.isWhen() {
			location = Location(column: line.columnForKeyword(keywordWhen), line: line.number)
			step = Step.when(line.removeKeyword(keywordWhen))
		}

		if line.isThen() {
			location = Location(column: line.columnForKeyword(keywordThen), line: line.number)
			step = Step.then(line.removeKeyword(keywordThen))
		}

		if line.isAnd() {
			location = Location(column: line.columnForKeyword(keywordAnd), line: line.number)
			step = Step.and(line.removeKeyword(keywordAnd))
		}

		if line.isBut() {
			location = Location(column: line.columnForKeyword(keywordBut), line: line.number)
			step = Step.but(line.removeKeyword(keywordBut))
		}
	}
	
	private func shouldStartScanTable(_ line: Line) -> Bool {
		return line.isTable()
	}

	private func shouldStartScanDocString(_ line: Line) -> Bool {
		return docStringScanner.isDocString(line)
	}

	private func handleTable(_ line: Line) {
		if line.isTable() {
			tableScanner.scan(line)
		}
	}

	private func handleDocString(_ line: Line) {
		docStringScanner.scan(line)
	}
}
