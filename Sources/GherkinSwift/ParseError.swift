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
//  ParseError.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-15.
//
// ------------------------------------------------------------------------

public struct ParseError {
	public let message: String
	public let source: ParseErrorSource
}

public struct ParseErrorSource {
	public let location: Location
	public let uri: String
}

extension ParseError {
	static func invalidGherkin( _ tags: String, atLine line: Line) -> ParseError {
		return ParseError.withMessage(
			"expected: \(tags), got '\(line.text.trim())'",
			atLineNumber: line.number,
			inFile: line.file)
	}
	
	static func invalidLanguage(_ language: String, atLineNumber lineNumber: Int, file: String) -> ParseError {
		return ParseError.withMessage(
			"Language not supported: \(language)",
			atLineNumber: lineNumber,
			inFile: file)
	}

	static func inconsistentCellCount(atLine line: Line) -> ParseError {
		return ParseError.withMessage(
			"inconsistent cell count within the table",
			atLineNumber: line.number,
			column: line.text.indentation() + 1,
			inFile: line.file)
	}

	private static func withMessage( _ message: String,
									 atLineNumber lineNumber: Int,
									 column: Int = 1,
									 inFile fileUri: String) -> ParseError {
		return ParseError(
			message: message,
			source: ParseErrorSource(
				location: Location(column: column, line: lineNumber),
				uri: fileUri))
	}
	
}
