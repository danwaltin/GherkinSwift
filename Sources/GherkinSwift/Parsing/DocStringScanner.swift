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
	
	private var docStringLines = [String]()
	
	init(configuration: ParseConfiguration) {
		self.configuration = configuration
	}
	
	func scan(_ line: Line) {
		switch state {
		case .started:
			if isDocString(line) {
				state = .scanningDocString
			}
			
		case .scanningDocString:
			if isDocString(line) {
				state = .done
			} else {
				docStringLines.append(line.text)
			}
			
		case .done:
			// ignore...
			break
		}
	}
	
	func getDocString() -> DocString? {
		if state == .started {
			return nil
		}
		
		return DocString(lines: docStringLines)
	}
	
	func isDocString(_ line: Line) -> Bool {
		return line.hasPrefix(configuration.docStringSeparator)
	}
}
