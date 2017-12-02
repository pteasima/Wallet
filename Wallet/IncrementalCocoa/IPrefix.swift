//
//  IPrefix.swift
//  Wallet
//
//  Created by Petr Šíma on 28/11/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//



import Foundation

/// Describes a provider of reactive extensions.
///
/// - note: `ReactiveExtensionsProvider` does not indicate whether a type is
///         reactive. It is intended for extensions to types that are not owned
///         by the module in order to avoid name collisions and return type
///         ambiguities.
public protocol IncrementalExtensionsProvider: class {}

extension IncrementalExtensionsProvider {
    /// A proxy which hosts reactive extensions for `self`.
    public var i: Incremental<Self> {
        get { return Incremental(self) }
        set { /*do nothing*/ } //we need this proxy to allow mutation, but the setter doesnt have to do anything, the changes will have been made on the base object itself
    }

    /// A proxy which hosts static reactive extensions for the type of `self`.
    public static var i: Incremental<Self>.Type {
        return Incremental<Self>.self
    }
}

/// A proxy which hosts reactive extensions of `Base`.
public struct Incremental<Base> {
    /// The `Base` instance the extensions would be invoked with.
    public let base: Base

    /// Construct a proxy
    ///
    /// - parameters:
    ///   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

