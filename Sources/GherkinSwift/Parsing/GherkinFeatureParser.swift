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
//  GherkinFeatureParser.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import Foundation

public class GherkinFeatureParser : FeatureParser {
	
	public init() {
	}
	
	public func pickle(lines: [String], fileUri: String) -> GherkinFile {
		let featureScanner = FeatureScanner()
		let commentCollector = CommentCollector()
		
		let theLines = getLines(lines)
		for line in theLines {
			featureScanner.scan(line, commentCollector, allLines: theLines)
		}
		
		let feature = featureScanner.getFeature()
		let comments = commentCollector.getComments()
		
		return GherkinFile(gherkinDocument: GherkinDocument(
			comments: comments,
			feature: feature,
			uri: fileUri))
	}

	public func getAllLinesInFile(url: URL) -> [String] {
		let data = try! Data(contentsOf: url)
		let content = String(data: data, encoding: .utf8)!
		
		return content.allLines().map { $0.replacingOccurrences(of: "\\n", with: "\n")}
	}
	
	private func getLines(_ lines:[String]) -> [Line] {
		return lines.enumerated().map{ (index, text) in Line(text: text, number: index + 1) }
	}
}
