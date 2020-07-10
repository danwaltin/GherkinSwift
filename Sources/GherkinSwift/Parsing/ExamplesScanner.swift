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
	
	func scan(_ line: Line) {
		handleName(line)
		handleTable(line)
		handleDescription(line)
	}
	
	private func handleName(_ line: Line) {
		if line.isEmpty() {
			return
		}

		if line.keyword == .examples {
			name = line.keywordRemoved()
			location = Location(column: line.columnForKeyword(), line: line.number)
		}
	}
	
	private func handleDescription(_ line: Line) {
		if isScanningDescription && !isScanningTable {
			descriptionLines.append(line.text)
		} else if line.keyword != .examples && line.keyword != .table && !isScanningDescription &&  !line.isEmpty() {
			isScanningDescription = true
			descriptionLines.append(line.text)
		}
	}
	
	private func handleTable(_ line: Line) {
		if line.isEmpty() {
			return
		}

		isScanningTable = isScanningTable || line.keyword == .table
		
		if isScanningTable {
			tableScanner.scan(line)
		}
	}

	func getExamples() -> ScenarioOutlineExamples {
		return ScenarioOutlineExamples(name: name,
									   description: descriptionLines.asDescription(),
									   tags: tags,
									   location: location,
									   table: tableScanner.getTable()!)
	}
}
