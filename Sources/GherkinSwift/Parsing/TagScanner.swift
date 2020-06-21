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
//  TagScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------


public class TagScanner {

	public init() {}
	
	var tags = [String]()

	public func scan(line: String) {
		if line.isTag() {
			tags.append(contentsOf: tagsFromLine(line))
		}
	}
	
	public func clear() {
		tags = []
	}
	
	public func getTags() -> [String] {
		return tags
	}

	private func tagsFromLine(_ line: String) -> [String] {
		let parts = line.trim().compactWhitespace().trim().components(separatedBy: .whitespaces)
		return parts.map{$0.removeKeyword(tagToken)}
	}
}