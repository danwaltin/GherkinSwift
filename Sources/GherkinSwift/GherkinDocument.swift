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
//  GherkinDocument.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-20.
//
// ------------------------------------------------------------------------
import Foundation

public struct GherkinDocument : Equatable {
	public let comments: [Comment]
	public let feature: Feature?
	public let uri: String
	
	public init(comments: [Comment], feature: Feature?, uri: String) {
		self.comments = comments
		self.feature = feature
		self.uri = uri
	}
}
