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
//  TableExtensions.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-01.
//
// ------------------------------------------------------------------------

@testable import GherkinSwift

extension Table {
	var columns: [String] {
		var c = [String]()
		for cell in header.cells {
			c.append(cell.value.value)
		}
		return c
	}

	static func withColumns(_ columns: [String]) -> Table {
		var cells = [String: TableCell]()
		for column in columns {
			cells[column] = TableCell(value: column, location: Location.zero())
		}
		let header = TableRow(cells: cells, location: Location.zero())
		return Table(header: header, columns: columns, rows: [], headerLocation: Location.zero())
	}
	
	func addingRowWithCellValues(_ cellValues: [String]) -> Table {
		var cells = [TableCell]()
		for cell in cellValues {
			cells.append(TableCell(value: cell, location: Location.zero()))
		}
		
		return addingRow(cells: cells, location: Location.zero())
	}

	
	func addingRow(cells: [TableCell], location: Location) -> Table {
		var copyOfCurrentRows = rows
		copyOfCurrentRows.append(tableRow(cells, location))
		
		return Table(header: header, columns: columns, rows: copyOfCurrentRows, headerLocation: headerLocation)
	}

	func addingRow(cells: [String: TableCell]) -> Table {
		assertValidAddedColumns(Array(cells.keys))

		var copyOfCurrentRows = rows
		copyOfCurrentRows.append(TableRow(cells: cells, location: Location.zero()))

		return Table(header: header, columns: columns, rows: copyOfCurrentRows, headerLocation: headerLocation)
	}

	private func tableRow(_ cells: [TableCell], _ location: Location) -> TableRow {
		var newRowContent = [String: TableCell]()
		for i in 0...columns.count-1 {
			newRowContent[columns[i]] = cells[i]
		}
		
		return TableRow(cells: newRowContent, location: location)
	}

	private func assertValidAddedColumns(_ addedColumns: [String]) {
		assert(addedColumns.count == columns.count, "Wrong number of added columns. Expected \(columns.count) but got \(addedColumns.count)")

		for added in addedColumns {
			assert(columns.contains(added), "Added column '\(added)' not present in table. Valid columns: \(columns)")
		}
	}

}
