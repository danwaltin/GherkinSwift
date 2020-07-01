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
			c.append(cell.value)
		}
		return c
	}

	static func withColumns(_ columns: [String]) -> Table {
		var cells = [TableCell]()
		for column in columns {
			cells.append(TableCell(value: column, location: Location.zero(), header: column))
		}
		let header = TableRow(cells: cells, location: Location.zero())
		return Table(header: header, columns: columns, rows: [], headerLocation: Location.zero())
	}
	
	func addingRow(cells: [TableCell], location: Location) -> Table {
		var copyOfCurrentRows = rows
		copyOfCurrentRows.append(TableRow(cells: cells, location: location))
		
		return Table(header: header, columns: columns, rows: copyOfCurrentRows, headerLocation: headerLocation)
	}
}
