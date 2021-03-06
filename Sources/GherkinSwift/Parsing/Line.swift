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
//  Line.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import Foundation

extension String {
	func removeKeyword(_ keyword: String) -> String {
		let copy = deleteText(keyword)
		return copy.trim()
	}
}

struct Line {
	let text: String
	let number: Int
	let keyword: Keyword
	let file: String
	
	func hasKeyword(_ type: KeywordType) -> Bool {
		return keyword.isType(type)
	}
	
	func keywordRemoved() -> String {
		return keyword.removeFrom(text: text)
	}
	
	func columnForKeyword() -> Int {
		return keyword.startColumnIn(text: text)
	}
	
	func textWithoutComment() -> String {
		return text.components(separatedBy: " #").first!
	}
	
	func isEmpty() -> Bool {
		return text.trim().isEmpty
	}
	
	func keywordLocation() -> Location {
		return Location(column: keyword.startColumnIn(text: text), line: number)
	}

	func isStep() -> Bool {
		return keyword.isStep()
	}
	
	private func hasPrefix(_ prefix: Character) -> Bool {
		return hasPrefix(String(prefix))
	}

	func hasPrefix(_ prefix: String) -> Bool {
		return text.trim().hasPrefix(prefix)
	}
}
