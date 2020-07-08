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
//  TableScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

class TableScanner {
	
	var hasScannedColumns = false
	var columns = [String]()
	var headerRow: TableRow!
	var rows = [TableRow]()
	
	var hasTable = false
	
	var headerLine = 0
	var headerColumn = 0

	var hasStartedOnBody = false
	var bodyLine = 0
	var bodyColumn = 0

	func scan(_ line: Line) {
		hasTable = true
		
		if hasScannedColumns {
			addRow(line)
		} else {
			createColumns(line)
		}
	}

	func getTable() -> Table? {
		if !hasTable {
			return nil
		}
		
		let headerLocation = Location(column: headerColumn,
									  line: headerLine)
		
		return Table(header: headerRow,
					 columns: columns,
					 rows: rows,
					 headerLocation: headerLocation)
	}

	private func createColumns(_ line: Line) {
		columns = lineItems(line.text)
		
		headerLine = line.number
		headerColumn = line.text.startColumnFor(character: tableSeparator)
		
		let location = Location(column: line.text.startColumnFor(character: tableSeparator), line: line.number)
		headerRow = TableRow(cells: cells(line), location: location)
		
		hasScannedColumns = true
	}

	private func addRow(_ line: Line) {
		let location = Location(column: line.text.startColumnFor(character: tableSeparator), line: line.number)
		
		rows.append(TableRow(cells: cells(line), location: location))
	}
	
	private func cells(_ line: Line) -> [TableCell] {
		
		let i = line.text.firstIndex(of: tableSeparator)!
		let d = line.text.distance(from: line.text.startIndex, to: i)
		
		var cellValues = line.text.components(separatedBy: String(tableSeparator))
		cellValues.removeLast()
		cellValues.remove(at: 0)

		var cells = [TableCell]()
		
		// + 1 because tableSeparator is at index zero based, and cell location starts one column to the right:
		var previousCellColumn = d + 1 + String(tableSeparator).count

		var columnIndex = 0
		for cellValue in cellValues {
			let numberOfColumnsFromSeparatorToNonWhitespace = cellValue.count - cellValue.trimLeft().count
			let col = previousCellColumn + numberOfColumnsFromSeparatorToNonWhitespace
			
			let column = columns[columnIndex]
			let cell = TableCell(value: cellValue.trimSpaces(),
								 location: Location(column: col, line: line.number),
								 header: column)
			cells.append(cell)
			
			previousCellColumn += cellValue.count + String(tableSeparator).count
			columnIndex += 1
		}
		
		return cells
	}

	private func lineItems(_ line: String) -> [String] {
		var v = line.components(separatedBy: String(tableSeparator))
		v.removeLast()
		v.remove(at: 0)
		
		var items = [String]()
		for cell in v {
			items.append(cell.trim())
		}
		
		return items
	}

}
