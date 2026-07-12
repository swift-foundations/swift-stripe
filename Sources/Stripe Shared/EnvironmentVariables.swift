//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 13/08/2025.
//

import Dependencies
import Foundation
import ServerFoundation
import ServerFoundationEnvVars

extension EnvVars {
    package static var development: Self {
        @Dependency(\.projectRoot) var projectRoot
        // Try to load from .env file if it exists, otherwise return empty env vars
        // This allows tests to run in CI without requiring a .env file
        do {
            return try .live(
                environmentConfiguration: .projectRoot(projectRoot, environment: "development")
            )
        } catch {
            // In CI or environments without .env files, return empty environment variables
            return .init([:])
        }
    }
}

extension URL {
    package static var stripe: URL {
        .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
