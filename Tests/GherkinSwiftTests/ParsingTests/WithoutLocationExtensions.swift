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
//  WithoutLocationExtensions.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-26.
//
// ------------------------------------------------------------------------

@testable import GherkinSwift

extension DocString {
	func withoutLocation() -> DocString {
		return DocString(separator: separator, content: content, location: Location.zero(), mediaType: mediaType)
	}
}

extension Table {
	func withoutLocation() -> Table {
		var newRows = [TableRow]()
		for row in rows {
			newRows.append(row.withoutLocation())
		}
		return Table(header: header.withoutLocation(),
					 rows: newRows,
					 headerLocation: Location.zero())
	}
}

extension TableRow {
	func withoutLocation() -> TableRow {
		
		return TableRow(cells: cells.map { $0.withoutLocation()}, location: Location.zero())
	}
}

extension TableCell {
	func withoutLocation() -> TableCell {
		return TableCell(value: value, location: Location.zero(), header: header)
	}
}
