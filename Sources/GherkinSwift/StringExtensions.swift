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
//  StringExtensions.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import Foundation

internal let newLine = "\n"
internal let tripleWhitespace = "   "
internal let doubleWhitespace = "  "
internal let singleWhitespace = " "

public extension String {
	
	func trim() -> String {
		return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}

	func indentation() -> Int {
		return self.count - self.trimLeft().count
	}
	
	func trimSpaces() -> String {
		return trimmingCharacters(in: NSCharacterSet.whitespaces)
	}

	func trimLeft() -> String {
		guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
	}
	
	func trimRight(_ s: Character) -> String {
		var newString = self

		while newString.last! == s {
			newString = String(newString.dropLast())
		}

		return newString
	}
	
	func appendLine() -> String {
		return self + newLine
	}
	
	func appendLine(_ line: String) -> String {
		if self == "" {
			return self + line
		}
		return self + newLine + line
	}
	
	func compactWhitespace() -> String {
		return _remove(tripleWhitespace)._remove(doubleWhitespace)
	}
	
	private func _remove(_ whitespace: String) -> String {
		if count < whitespace.count {
			return self
		}
		
		if !contains(whitespace) {
			return self
		}
		
		return replacingOccurrences(of: whitespace, with: singleWhitespace)
	}
	
	func allLines() -> [String] {
		if self == "" {
			return []
		}
		
		return components(separatedBy: newLine)
	}
	
	func deleteText(_ text: String) -> String {
		return replacingOccurrences(of: text, with: "")
	}
	
	/**
	The 1-based column at which the text begins
	*/
	func startColumnFor(text: String) -> Int {
		let r = range(of: text)!
		let index: Int = distance(from: startIndex, to: r.lowerBound)
		
		return index + 1

	}

	/**
	The 1-based column at which the character begins
	*/
	func startColumnFor(character: Character) -> Int {
		return startColumnFor(text: String(character))
	}
}
