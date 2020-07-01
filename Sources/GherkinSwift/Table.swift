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
//  Table.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-19.
//
// ------------------------------------------------------------------------

public struct Table : Equatable {
	public let columns: [String]
	public let rows: [TableRow]
	public let headerLocation: Location

	public init(columns: [String], headerLocation: Location) {
		self.init(columns: columns, rows: [], headerLocation: headerLocation)
	}
	
	init(columns: [String], rows: [TableRow], headerLocation: Location) {
		self.columns = columns
		self.rows = rows
		self.headerLocation = headerLocation
	}
	
	var header: TableHeader {
		return TableHeader(location: headerLocation)
	}

	public func addingRow(cells: [TableCell], location: Location) -> Table {
		var copyOfCurrentRows = rows
		copyOfCurrentRows.append(tableRow(cells, location))
		
		return Table(columns: columns, rows: copyOfCurrentRows, headerLocation: headerLocation)
	}

	public func addingRow(cells: [String: TableCell]) -> Table {
		assertValidAddedColumns(Array(cells.keys))

		var copyOfCurrentRows = rows
		copyOfCurrentRows.append(TableRow(cells: cells, location: Location.zero()))

		return Table(columns: columns, rows: copyOfCurrentRows, headerLocation: headerLocation)
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

extension Table {
	func addingRowWithCellValues(_ cellValues: [String]) -> Table {
		return addingRow(cells: cellValues.map {TableCell(value: $0, location: Location.zero())}, location: Location.zero())
	}
}
