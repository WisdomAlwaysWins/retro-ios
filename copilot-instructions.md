# Copilot Code Review Instructions

## Language

When performing a code review, always respond in **Korean (한국어)**.

## Project Overview

- iOS/macOS (Mac Catalyst) native retrospective app
- UIKit (code-based, no Storyboard) + Clean Architecture + MVVM + Combine + Coordinator pattern
- Swift 6 with strict concurrency enabled
- Local storage: Core Data
- Real-time: Socket.IO (team retrospective)

## Architecture Rules

- **Domain layer** must only import `Foundation`. Never import UIKit, CoreData, or any external framework.
- **Data layer** must not reference the Presentation layer.
- **Presentation layer** must not directly reference the Data layer. Access data only through Domain protocols.
- Each UseCase handles exactly one business action. Do not combine multiple actions in a single UseCase.
- No business logic in ViewController. Delegate to ViewModel.
- No `import UIKit` in ViewModel.

## Swift 6 Concurrency

- All Domain entities must explicitly conform to `Sendable`.
- Avoid `@unchecked Sendable`. If used, require a comment explaining why.
- Verify `Sendable` conformance when values cross actor boundaries.
- Use `@MainActor` only on UI-related code (ViewController, ViewModel).

## Code Style

- Always specify access control (`private`, `internal`, `public`). Never omit it.
- Mark classes as `final` unless inheritance is intended.
- Use `self` only inside closures. Omit it elsewhere.
- Use `[weak self]` in closures and unwrap with `guard let self`.
- Use `// MARK: -` comments to organize code sections.
- No force unwrapping (`!`). Use `guard let` or `if let`.
- No `print()`. Use `os_log` or `Logger`.
- Max line length: 120 characters.
- Max function body: 40 lines. Suggest splitting if exceeded.

## Naming

- Types: UpperCamelCase (`RetroListViewController`)
- Protocols: UpperCamelCase + `Protocol` suffix (`RetrospectRepositoryProtocol`)
- Functions/Variables: lowerCamelCase (`fetchRetroList()`)
- Booleans: prefix with `is`, `has`, `should` (`isEdited`, `hasTeam`)
- Abbreviations: uppercase for 2 chars, camelCase for 3+ (`id`, `url`, `kptItem`)

## Combine

- Store `AnyCancellable` in `Set<AnyCancellable>`. Do not use individual variables.
- Always use `[weak self]` in `sink` closures.
- Call `receive(on: DispatchQueue.main)` before UI updates.

## Core Data

- Never pass `NSManagedObject` to the Presentation layer. Convert to Domain entity via Mapper.
- Access `viewContext` only on the main thread. Use `performBackgroundTask` for background work.
- Verify that `save()` is called after mutations.

## Testing

- Every UseCase must have unit tests.
- Use mock protocols for Repository testing.
- Test method naming: `test_action_condition_expectedResult` (e.g., `test_createRetro_emptyItems_shouldFail`)

## Review Focus

When reviewing code, prioritize the following checks:

1. Clean Architecture dependency direction (Domain must not know about outer layers)
2. No force unwrapping or force casting
3. Memory leak risks (retain cycles, missing `[weak self]`)
4. Appropriate access control (not unnecessarily `public` or `internal`)
5. Clear naming that follows conventions
6. Functions not too long or doing too much
7. `Sendable` conformance for types crossing actor boundaries
8. Proper error handling (errors not silently ignored)
