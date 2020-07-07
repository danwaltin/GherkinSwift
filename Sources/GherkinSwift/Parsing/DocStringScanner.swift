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
//  DocStringScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-06.
//
// ------------------------------------------------------------------------

class DocStringScanner {
	enum State {
		case started
		case scanningDocString
		case done
	}
	
	private var state: State = .started
	private let configuration: ParseConfiguration
	
	private var separator = ""
	private var docStringLines = [String]()
	private var location = Location.zero()
	private var mediaType: String? = nil
	
	private var separatorIndentation = 0
	
	init(configuration: ParseConfiguration) {
		self.configuration = configuration
	}
	
	func scan(_ line: Line) {
		switch state {
		case .started:
			if isDocString(line) {
				separator = whichSeparator(line)
				separatorIndentation = line.text.indentation()
				
				if line.text.trim().count > separator.count {
					mediaType = line.text.trim().replacingOccurrences(of: separator, with: "")
				}
				location = Location(column: line.columnForKeyword(separator), line: line.number)
				state = .scanningDocString
			}
			
		case .scanningDocString:
			if isEndSeparator(line) {
				state = .done
			} else {
				docStringLines.append(correctlyIndented(line))
			}
			
		case .done:
			// ignore...
			break
		}
	}
	
	private func correctlyIndented(_ line: Line) -> String {
		if line.isEmpty() {
			return line.text
		}
		
		let indentation = max(0, line.text.indentation() - separatorIndentation)

		let indentationPrefix = String(repeating: " ", count: indentation)
		return indentationPrefix + line.text.trimLeft()
	}
	
	func getDocString() -> DocString? {
		if state == .started {
			return nil
		}
		
		return DocString(separator: separator,
						 content: docStringLines.joined(separator: newLine),
						 location: location,
						 mediaType: mediaType)
	}
	
	func isDocString(_ line: Line) -> Bool {
		return line.hasPrefix(configuration.docStringSeparator) || line.hasPrefix(configuration.alternativeDocStringSeparator)
	}
	
	private func isEndSeparator(_ line: Line) -> Bool {
		return line.hasPrefix(separator)
	}
	
	private func whichSeparator(_ line: Line) -> String {
		if line.hasPrefix(configuration.docStringSeparator) {
			return configuration.docStringSeparator
		}
		
		return configuration.alternativeDocStringSeparator
	}
}
