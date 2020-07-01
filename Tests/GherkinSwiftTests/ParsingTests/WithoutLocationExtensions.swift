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

extension Table {
	func withoutLocation() -> Table {
		return Table(header: header.withoutLocation(),
					 columns: columns,
					 rows: rows.map{ $0.withoutLocation()},
					 headerLocation: Location.zero())
	}
}

extension TableRow {
	func withoutLocation() -> TableRow {
		
		return TableRow(cells: cells.mapValues{ $0.withoutLocation()}, location: Location.zero())
	}
}

extension TableCell {
	func withoutLocation() -> TableCell {
		return TableCell(value: value, location: Location.zero())
	}
}
