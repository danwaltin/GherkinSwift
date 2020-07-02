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
//  JsonEncodingExtensions.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import Foundation

extension GherkinFile : Encodable {
	enum CodingKeys: String, CodingKey {
		case gherkinDocument
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(gherkinDocument, forKey: .gherkinDocument)
	}
}

extension GherkinDocument : Encodable {
	enum CodingKeys: String, CodingKey {
		case comments
		case feature
		case uri
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		if comments.count > 0 {
			try container.encode(comments, forKey: .comments)
		}
		
		if let feature = feature {
			try container.encode(feature, forKey: .feature)
		}
		try container.encode(uri, forKey: .uri)
	}
}

extension Comment : Encodable {
	enum CodingKeys: String, CodingKey {
		case text
		case location
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(location, forKey: .location)
		try container.encode(text, forKey: .text)
	}
}

extension Feature : Encodable {
	enum CodingKeys: String, CodingKey {
		case keyword
		case language
		case location
		case name
		case description
		case children
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode("Feature", forKey: .keyword)
		try container.encode("en", forKey: .language)
		try container.encode(location, forKey: .location)
		try container.encode(name, forKey: .name)

		if let description = description {
			try container.encode(description, forKey: .description)
		}

		if children.count > 0 {
			try container.encode(children, forKey: .children)
		}
	}
}

extension Scenario : Encodable {
	enum CodingKeys: String, CodingKey {
		case keyword
		case location
		case name
		case description
		case steps
		case examples
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		let keyword = isOutline() ? "Scenario Outline" : "Scenario"
		try container.encode(keyword, forKey: .keyword)
		try container.encode(location, forKey: .location)
		try container.encode(name, forKey: .name)

		if let description = description {
			try container.encode(description, forKey: .description)
		}

		try container.encode(steps, forKey: .steps)
		
		if examples.count > 0 {
			try container.encode(examples, forKey: .examples)
		}
	}
}

extension Step : Encodable {
	enum CodingKeys: String, CodingKey {
		case keyword
		case location
		case text
		case dataTable
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(keyword + " ", forKey: .keyword)
		try container.encode(location, forKey: .location)
		try container.encode(text, forKey: .text)
		
		if let table = tableParameter {
			try container.encode(table, forKey: .dataTable)
		}
	}
}

extension ScenarioOutlineExamples : Encodable {
	enum CodingKeys: String, CodingKey {
		case keyword
		case location
		case name
		case description
		case tableHeader
		case tableBody
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode("Examples", forKey: .keyword)
		try container.encode(location, forKey: .location)
		
		if name != "" {
			try container.encode(name, forKey: .name)
		}
		
		if let description = description {
			try container.encode(description, forKey: .description)
		}

		try container.encode(table.header, forKey: .tableHeader)
		try container.encode(table.rows, forKey: .tableBody)
	}
}

extension Table : Encodable {
	enum CodingKeys: String, CodingKey {
		case location
		case rows
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(headerLocation, forKey: .location)
		try container.encode(headerAndRows, forKey: .rows)
	}
}

extension TableHeader : Encodable {
	enum CodingKeys: String, CodingKey {
		case location
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(location, forKey: .location)
	}
}

extension TableRow : Encodable {
	enum CodingKeys: String, CodingKey {
		case cells
		case location
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(cells, forKey: .cells)
		try container.encode(location, forKey: .location)
	}
}

extension TableCell : Encodable {
	enum CodingKeys: String, CodingKey {
		case value
		case location
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		if value != "" {
			try container.encode(value, forKey: .value)
		}
		try container.encode(location, forKey: .location)
	}
}
