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

extension PickleResult : Encodable {
	enum CodingKeys: String, CodingKey {
		case gherkinDocument
		case parseError
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		switch self {
		case .success(let document):
			try container.encode(document, forKey: .gherkinDocument)
		case .error(let errors):
			for error in errors {
				try container.encode(error, forKey: .parseError)
			}
		}
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

extension ParseError : Encodable {
	enum CodingKeys: String, CodingKey {
		case message
		case source
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(message, forKey: .message)
		try container.encode(source, forKey: .source)
	}
}

extension ParseErrorSource : Encodable {
	enum CodingKeys: String, CodingKey {
		case location
		case uri
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(location, forKey: .location)
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
		case tags
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(localizedKeyword, forKey: .keyword)
		try container.encode(language, forKey: .language)
		try container.encode(location, forKey: .location)
		if name.count > 0 {
			try container.encode(name, forKey: .name)
		}
		
		if let description = description {
			try container.encode(description, forKey: .description)
		}

		if tags.count > 0 {
			try container.encode(tags, forKey: .tags)
		}

		if children.count > 0 {
			try container.encode(children, forKey: .children)
		}
	}
}

extension Background : Encodable {
	enum CodingKeys: String, CodingKey {
		case keyword
		case location
		case name
		case description
		case steps
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode("Background", forKey: .keyword)
		try container.encode(location, forKey: .location)
		if name.count > 0 {
			try container.encode(name, forKey: .name)
		}

		if let description = description {
			try container.encode(description, forKey: .description)
		}

		if steps.count > 0 {
			try container.encode(steps, forKey: .steps)
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
		case tags
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(localizedKeyword, forKey: .keyword)
		try container.encode(location, forKey: .location)
		if name.count > 0 {
			try container.encode(name, forKey: .name)
		}

		if let description = description {
			try container.encode(description, forKey: .description)
		}

		if steps.count > 0 {
			try container.encode(steps, forKey: .steps)
		}
		
		if tags.count > 0 {
			try container.encode(tags, forKey: .tags)
		}

		if examples.count > 0 {
			try container.encode(examples, forKey: .examples)
		}
	}
}

extension Tag : Encodable {
	enum CodingKeys: String, CodingKey {
		case name
		case location
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode("\(tagToken)\(name)", forKey: .name)
		try container.encode(location, forKey: .location)
	}
}

extension Step : Encodable {
	enum CodingKeys: String, CodingKey {
		case keyword
		case location
		case text
		case dataTable
		case docString
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(localizedKeyword, forKey: .keyword)
		try container.encode(location, forKey: .location)
		try container.encode(text, forKey: .text)
		
		if let table = tableParameter {
			try container.encode(table, forKey: .dataTable)
		}

		if let docString = docStringParameter {
			try container.encode(docString, forKey: .docString)
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
		case tags
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

		if tags.count > 0 {
			try container.encode(tags, forKey: .tags)
		}

		if let table = table {
			try container.encode(table.header, forKey: .tableHeader)
			if table.rows.count > 0 {
				try container.encode(table.rows, forKey: .tableBody)
			}
		}
	}
}

extension DocString : Encodable {
	enum CodingKeys: String, CodingKey {
		case delimiter
		case content
		case location
		case mediaType
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(separator, forKey: .delimiter)
		try container.encode(content, forKey: .content)
		try container.encode(location, forKey: .location)
		if let mediaType = mediaType {
			try container.encode(mediaType, forKey: .mediaType)
		}
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
