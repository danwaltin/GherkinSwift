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
//  CommentCollector.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-27.
//
// ------------------------------------------------------------------------

import Foundation

class CommentCollector {
	
	private var comments = [Comment]()
	
	func collectComment(_ line: Line) {
		if line.number == 1 && line.text.isLanguageSpecification() {
			return // this is not a comment!
		}
		let location = Location(column: 1, line: line.number)
		comments.append(Comment(text: line.text.trimRight("\r"), location: location))
	}
	
	func getComments() -> [Comment] {
		return comments
	}
}
