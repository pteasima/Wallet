//
//  Types.swift
//  CorridorTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Corridor

struct Nested: HasInstanceContext {
  var resolve = `default`
}

struct AType: HasInstanceContext {
  var resolve = `default`
}

final class BType: HasInstanceContext {
  var resolve = `default`
  lazy var inline: InlineResolver = { inlineResolved }()
}

struct StaticType: HasStaticContext {
  static var resolve = `default`
}

struct InlineResolver: HasInstanceContext {
  var resolve = `default`
}
