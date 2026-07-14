import Dependencies
import Foundation
import Witnesses

/// UUID generation dependency for Stripe Web Elements.
///
/// The institute `swift-dependencies` deliberately vends no ambient `\.uuid` key —
/// consumers declare their own extension point. This mirrors the green precedent in
/// `swift-authentication/Sources/Identity Shared/Dependency+UUID.swift`.
///
/// Two things here are load-bearing; both differ from the swift-authentication precedent.
///
/// 1. `typealias Value` must be pinned explicitly. `Witness.Key` inherits
///    `associatedtype Value: ~Copyable & Sendable = Self`
///    (`swift-witnesses/Sources/Witnesses/Witness.Key.swift:26`). Without an explicit
///    binding, `Value` does NOT infer from `liveValue` — it falls back to the `= Self`
///    default, so the key vends a `UUIDGeneratorKey` instead of the closure, `liveValue`
///    stops matching the requirement, and the conformance fails.
///
/// 2. `import Witnesses` is required. `Dependency.Key` is a typealias for `Witness.Key`,
///    whose `previewValue`/`testValue` requirements are satisfied by defaults declared in
///    extensions in the `Witnesses` module. This package enables `MemberImportVisibility`
///    (Package.swift:896), under which extension members of a module that is not directly
///    imported are invisible — so without this import those defaults do not apply.
///    swift-authentication does not enable the feature, which is why the precedent there
///    compiles without the import.
private enum UUIDGeneratorKey: Dependency.Key {
    typealias Value = @Sendable () -> UUID

    static var liveValue: @Sendable () -> UUID { { UUID() } }
}

extension Dependency.Values {
    /// Generates a UUID, used to mint unique DOM element identifiers for mounted Stripe elements.
    public var uuid: @Sendable () -> UUID {
        get { self[UUIDGeneratorKey.self] }
        set { self[UUIDGeneratorKey.self] = newValue }
    }
}
