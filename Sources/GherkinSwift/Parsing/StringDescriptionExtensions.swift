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
//  StringDescriptionExtensions.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-27.
//
// ------------------------------------------------------------------------

import Foundation

extension Array where Element == String {
	
	func asDescription() -> String? {
		if count == 0 {
			return nil
		}
		
		let description = joined(separator: newLine).withoutLeadingNewLines().withoutEndingNewLines()

		return description.trim().count > 0 ? description : nil
	}
	
}

extension String {
	func withoutLeadingNewLines() -> String {
		var s = self
		
		while s.first?.isNewline == true {
			s = String(s.dropFirst())
		}
		
		return s
	}

	func withoutEndingNewLines() -> String {
		var s = self
		
		while s.last?.isNewline == true {
			s = String(s.dropLast())
		}
		
		return s
	}
}
