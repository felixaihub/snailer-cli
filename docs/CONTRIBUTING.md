# Contributing to Snailer

Thank you for your interest in contributing to Snailer! This document provides guidelines and best practices for contributing to our project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

---

## Code of Conduct

### Our Pledge

We as members, contributors, and leaders pledge to make participation in our community a harassment-free experience for everyone, regardless of age, body size, visible or invisible disability, ethnicity, sex characteristics, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behaviors include:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behaviors include:**
- The use of sexualized language or imagery and unwelcome sexual attention
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported to the project team at conduct@snailer.dev. All complaints will be reviewed and investigated promptly and fairly.

---

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Rust** (latest stable): Install via [rustup](https://rustup.rs/)
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

- **Git**: Version 2.x or higher

- **Code Editor**: We recommend VS Code with the rust-analyzer extension

### First-Time Setup

1. **Fork the repository**

   Click the "Fork" button at the top-right of the [repository page](https://github.com/your-org/snailer).

2. **Clone your fork**

   ```bash
   git clone https://github.com/YOUR_USERNAME/snailer.git
   cd snailer
   ```

3. **Add upstream remote**

   ```bash
   git remote add upstream https://github.com/your-org/snailer.git
   ```

4. **Install Rust tooling**

   ```bash
   rustup component add rustfmt clippy
   cargo install cargo-edit cargo-watch
   ```

5. **Build the project**

   ```bash
   cargo build
   ```

6. **Run tests**

   ```bash
   cargo test
   ```

### Environment Configuration

Create a `.env` file in the project root (never commit this file):

```bash
# AI API Keys (at least one required)
ANTHROPIC_API_KEY=sk-ant-xxxxx
OPENAI_API_KEY=sk-xxxxx
XAI_API_KEY=xai-xxxxx

# Optional: gRPC Configuration
SNAILER_GRPC_ADDR=https://snailer.ai:443
SNAILER_GRPC_INSECURE=0

# Development
RUST_LOG=debug
RUST_BACKTRACE=1
```

---

## Development Workflow

### Branch Naming Convention

Use descriptive branch names that follow this pattern:

```
<type>/<issue-number>-<brief-description>

Examples:
feature/123-add-http-tool
fix/456-null-pointer-agent
docs/789-update-readme
refactor/101-simplify-tool-registry
```

**Types:**
- `feature/` - New features or enhancements
- `fix/` - Bug fixes
- `docs/` - Documentation only changes
- `refactor/` - Code refactoring without behavior changes
- `test/` - Adding or updating tests
- `perf/` - Performance improvements
- `chore/` - Build process, dependencies, tooling

### Workflow Steps

1. **Sync with upstream**

   ```bash
   git checkout main
   git fetch upstream
   git rebase upstream/main
   git push origin main
   ```

2. **Create a feature branch**

   ```bash
   git checkout -b feature/123-add-http-tool
   ```

3. **Make your changes**

   - Write clean, well-documented code
   - Follow our [coding standards](#coding-standards)
   - Add tests for new functionality
   - Update documentation as needed

4. **Commit your changes**

   Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

   ```bash
   git add .
   git commit -m "feat(tools): add HTTP request tool

   Implements HTTP GET/POST requests with custom headers.
   Includes timeout handling and error recovery.

   Closes #123"
   ```

5. **Keep your branch updated**

   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

6. **Push to your fork**

   ```bash
   git push origin feature/123-add-http-tool
   ```

7. **Create a Pull Request**

   - Go to your fork on GitHub
   - Click "Pull Request"
   - Fill out the PR template
   - Link related issues

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type** (required):
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `build`: Build system changes
- `ci`: CI/CD changes
- `chore`: Other changes that don't modify src or test files

**Scope** (optional): Component affected (e.g., `agent`, `tools`, `api`)

**Subject** (required): Brief description (< 72 chars)

**Body** (optional): Detailed explanation

**Footer** (optional): Breaking changes, issue references

**Examples:**

```bash
# Simple fix
git commit -m "fix(agent): prevent null pointer in tool execution"

# Feature with body
git commit -m "feat(tools): add HTTP request tool

Implements HTTP GET/POST with the following features:
- Custom headers support
- Timeout configuration
- Automatic retry with exponential backoff
- JSON/form data encoding

Closes #123"

# Breaking change
git commit -m "refactor(api)!: rename ApiClient to ModelClient

BREAKING CHANGE: ApiClient has been renamed to ModelClient.
Users need to update their imports."
```

---

## Coding Standards

### Rust Style Guide

We follow the official [Rust Style Guide](https://doc.rust-lang.org/nightly/style-guide/) with additional project-specific conventions.

#### Formatting

**Always run before committing:**

```bash
cargo fmt --all
```

**Check formatting without modifying files:**

```bash
cargo fmt --all -- --check
```

#### Linting

**Run Clippy with all warnings:**

```bash
cargo clippy --all-targets --all-features -- -D warnings
```

**Common Clippy fixes:**

```bash
# Auto-fix safe suggestions
cargo clippy --fix --all-targets --all-features
```

### Code Organization

#### Module Structure

```rust
// src/your_module.rs

//! Module-level documentation.
//!
//! This module provides...

// Standard library imports
use std::collections::HashMap;
use std::path::PathBuf;

// External crate imports
use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use tokio::sync::RwLock;

// Internal crate imports
use crate::agent::Agent;
use crate::tools::ToolRegistry;

// Constants
const DEFAULT_TIMEOUT: u64 = 30_000;
const MAX_RETRIES: usize = 3;

// Type aliases
type ToolResult = Result<String, ToolError>;

// Public types
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct YourType {
    // Public fields first
    pub id: String,
    pub name: String,

    // Private fields
    cache: HashMap<String, String>,
}

// Trait implementations
impl Default for YourType {
    fn default() -> Self {
        Self {
            id: String::new(),
            name: String::new(),
            cache: HashMap::new(),
        }
    }
}

// Main implementation
impl YourType {
    /// Creates a new instance.
    ///
    /// # Examples
    ///
    /// ```
    /// use snailer::YourType;
    /// let instance = YourType::new("id", "name");
    /// ```
    pub fn new(id: impl Into<String>, name: impl Into<String>) -> Self {
        Self {
            id: id.into(),
            name: name.into(),
            cache: HashMap::new(),
        }
    }

    // Public methods
    pub fn process(&mut self) -> Result<()> {
        self.validate()?;
        self.execute()?;
        Ok(())
    }

    // Private methods
    fn validate(&self) -> Result<()> {
        // Implementation
        Ok(())
    }

    fn execute(&mut self) -> Result<()> {
        // Implementation
        Ok(())
    }
}

// Tests module at the end
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new() {
        let instance = YourType::new("test_id", "test_name");
        assert_eq!(instance.id, "test_id");
        assert_eq!(instance.name, "test_name");
    }
}
```

### Naming Conventions

#### Functions and Variables

```rust
// ✅ Good: Snake case, descriptive
fn execute_tool_with_timeout(tool_name: &str, timeout_ms: u64) -> Result<String>
let retry_count = 0;
let is_enabled = true;

// ❌ Bad: Camel case, abbreviations
fn ExecuteTool(t: &str, to: u64) -> Result<String>
let rc = 0;
let enabled = true;  // Ambiguous
```

#### Types and Traits

```rust
// ✅ Good: Pascal case, descriptive
struct ToolRegistry;
enum BulletType;
trait Executable;

// ❌ Bad: Snake case, generic
struct tool_registry;
enum bullet_type;
trait Exec;
```

#### Constants

```rust
// ✅ Good: Screaming snake case
const MAX_ITERATIONS: usize = 50;
const DEFAULT_TIMEOUT_MS: u64 = 30_000;

// ❌ Bad: Other cases
const maxIterations: usize = 50;
const default_timeout: u64 = 30000;
```

### Error Handling

**Use `Result` types, not `panic!`:**

```rust
// ✅ Good: Proper error handling
pub fn read_file(path: &Path) -> Result<String> {
    let content = std::fs::read_to_string(path)
        .with_context(|| format!("Failed to read file: {}", path.display()))?;
    Ok(content)
}

// ❌ Bad: Using panic
pub fn read_file(path: &Path) -> String {
    std::fs::read_to_string(path).expect("file must exist")
}
```

**Custom error types when appropriate:**

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ToolError {
    #[error("Tool not found: {0}")]
    NotFound(String),

    #[error("Tool execution failed: {0}")]
    ExecutionFailed(String),

    #[error("Timeout after {0}ms")]
    Timeout(u64),

    #[error(transparent)]
    Io(#[from] std::io::Error),
}
```

### Documentation

#### Public API Documentation

Every public item must have documentation:

```rust
/// Executes a tool and returns the result.
///
/// This function looks up the tool by name, validates parameters,
/// and executes it with proper error handling and timeout.
///
/// # Arguments
///
/// * `tool_name` - The name of the tool to execute (e.g., "read_file")
/// * `params` - JSON parameters for the tool
/// * `timeout_ms` - Maximum execution time in milliseconds
///
/// # Returns
///
/// Returns `Ok(String)` with the tool output on success, or `Err(ToolError)`
/// if the tool is not found, parameters are invalid, or execution fails.
///
/// # Errors
///
/// This function will return an error if:
/// - The tool is not registered
/// - Parameters don't match the tool's schema
/// - Execution times out
/// - The tool itself returns an error
///
/// # Examples
///
/// ```
/// use snailer::ToolRegistry;
/// use serde_json::json;
///
/// let registry = ToolRegistry::new(".");
/// let result = registry.execute_tool(
///     "read_file",
///     json!({"path": "README.md"}),
///     30000
/// )?;
/// ```
///
/// # Panics
///
/// This function does not panic under normal circumstances.
///
/// # Safety
///
/// This function is safe to call from multiple threads.
pub fn execute_tool(
    &self,
    tool_name: &str,
    params: Value,
    timeout_ms: u64
) -> Result<String, ToolError> {
    // Implementation
}
```

#### Module Documentation

```rust
//! Tool execution and management.
//!
//! This module provides the [`ToolRegistry`] for managing and executing
//! tools that the AI agent can use. Tools are registered with JSON schemas
//! defining their parameters, and executed with runtime validation.
//!
//! # Architecture
//!
//! The tool system follows a registry pattern where:
//! 1. Tools are defined with name, description, and JSON schema
//! 2. The registry validates parameters against schemas
//! 3. Tools are executed with timeout and error handling
//!
//! # Examples
//!
//! ```
//! use snailer::tools::ToolRegistry;
//!
//! let registry = ToolRegistry::new(".");
//! let tools = registry.get_tools();
//! ```
```

### Async/Await Best Practices

```rust
// ✅ Good: Clear async boundaries
pub async fn fetch_data(url: &str) -> Result<String> {
    let response = reqwest::get(url).await?;
    let text = response.text().await?;
    Ok(text)
}

// ✅ Good: Use tokio::spawn for concurrent tasks
pub async fn process_many(items: Vec<String>) -> Result<Vec<String>> {
    let tasks: Vec<_> = items
        .into_iter()
        .map(|item| tokio::spawn(async move { process_item(item).await }))
        .collect();

    let results = futures::future::try_join_all(tasks).await?;
    Ok(results)
}

// ❌ Bad: Blocking in async context
pub async fn bad_read_file(path: &Path) -> Result<String> {
    // Don't do this! Blocks the async runtime
    Ok(std::fs::read_to_string(path)?)
}

// ✅ Good: Use tokio::fs for async file I/O
pub async fn good_read_file(path: &Path) -> Result<String> {
    Ok(tokio::fs::read_to_string(path).await?)
}
```

### Performance Guidelines

**Use appropriate data structures:**

```rust
// ✅ Good: Vec for sequential access
let items: Vec<String> = vec![];

// ✅ Good: HashMap for key-value lookups
let cache: HashMap<String, String> = HashMap::new();

// ✅ Good: BTreeMap for sorted iteration
let sorted: BTreeMap<String, i32> = BTreeMap::new();
```

**Avoid unnecessary allocations:**

```rust
// ✅ Good: Borrowing
fn process_string(s: &str) -> usize {
    s.len()
}

// ❌ Bad: Unnecessary clone
fn process_string(s: String) -> usize {
    s.len()
}

// ✅ Good: Cow for conditional cloning
use std::borrow::Cow;

fn maybe_modify(s: &str, should_modify: bool) -> Cow<str> {
    if should_modify {
        Cow::Owned(s.to_uppercase())
    } else {
        Cow::Borrowed(s)
    }
}
```

**Use iterators instead of collecting:**

```rust
// ✅ Good: Iterator chain
let sum: i32 = items
    .iter()
    .filter(|&&x| x > 0)
    .map(|&x| x * 2)
    .sum();

// ❌ Bad: Multiple collections
let filtered: Vec<_> = items.iter().filter(|&&x| x > 0).collect();
let doubled: Vec<_> = filtered.iter().map(|&&x| x * 2).collect();
let sum: i32 = doubled.iter().sum();
```

---

## Testing

### Test Organization

```rust
#[cfg(test)]
mod tests {
    use super::*;

    // Unit tests
    mod unit {
        use super::*;

        #[test]
        fn test_function_name() {
            // Arrange
            let input = "test";

            // Act
            let result = function_under_test(input);

            // Assert
            assert_eq!(result, expected);
        }
    }

    // Integration tests
    mod integration {
        use super::*;

        #[tokio::test]
        async fn test_async_flow() {
            // Test implementation
        }
    }
}
```

### Testing Best Practices

**1. Test one thing per test:**

```rust
// ✅ Good: Focused test
#[test]
fn test_bullet_creation_sets_default_utility() {
    let bullet = Bullet::new("content");
    assert_eq!(bullet.utility, 0.5);
}

#[test]
fn test_bullet_creation_sets_usage_count_to_zero() {
    let bullet = Bullet::new("content");
    assert_eq!(bullet.usage_count, 0);
}

// ❌ Bad: Testing multiple things
#[test]
fn test_bullet_creation() {
    let bullet = Bullet::new("content");
    assert_eq!(bullet.utility, 0.5);
    assert_eq!(bullet.usage_count, 0);
    assert!(bullet.id.is_some());
    // Too many assertions
}
```

**2. Use descriptive test names:**

```rust
// ✅ Good: Descriptive
#[test]
fn test_execute_tool_returns_error_when_tool_not_found()

#[test]
fn test_bullet_utility_increases_after_successful_usage()

// ❌ Bad: Generic
#[test]
fn test_execute()

#[test]
fn test_bullet()
```

**3. Test error cases:**

```rust
#[test]
fn test_read_file_returns_error_for_nonexistent_file() {
    let registry = ToolRegistry::new(".");
    let result = registry.execute_tool(
        "read_file",
        json!({"path": "nonexistent.txt"}),
        30000
    );

    assert!(result.is_err());
    assert!(matches!(result.unwrap_err(), ToolError::Io(_)));
}
```

**4. Use fixtures for complex test data:**

```rust
#[cfg(test)]
mod tests {
    use super::*;

    fn create_test_bullet() -> Bullet {
        Bullet {
            id: Uuid::new_v4(),
            content: "Test content".to_string(),
            bullet_type: BulletType::KNOWLEDGE,
            layer: Layer::PROJECT,
            utility: 0.5,
            usage_count: 0,
            last_used: None,
            confidence: 0.8,
            tags: vec![],
        }
    }

    #[test]
    fn test_using_fixture() {
        let bullet = create_test_bullet();
        // Use bullet in test
    }
}
```

### Running Tests

```bash
# Run all tests
cargo test

# Run specific test
cargo test test_bullet_creation

# Run tests with output
cargo test -- --nocapture

# Run tests in parallel (default)
cargo test -- --test-threads=4

# Run doc tests
cargo test --doc

# Run integration tests only
cargo test --test '*'

# Run with coverage (requires tarpaulin)
cargo tarpaulin --out Html
```

### Benchmarking

```rust
#[cfg(test)]
mod benches {
    use super::*;
    use criterion::{black_box, criterion_group, criterion_main, Criterion};

    fn bench_bullet_selection(c: &mut Criterion) {
        let store = create_test_store();

        c.bench_function("select_relevant_bullets", |b| {
            b.iter(|| {
                store.select_relevant_bullets(
                    black_box("test query"),
                    black_box(20)
                )
            })
        });
    }

    criterion_group!(benches, bench_bullet_selection);
    criterion_main!(benches);
}
```

---

## Documentation

### README Updates

If your PR adds a new feature, update the README.md:

1. Add to Features section
2. Update Usage examples
3. Add to Table of Contents

### Changelog

Update `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/):

```markdown
## [Unreleased]

### Added
- HTTP request tool for external API calls (#123)

### Fixed
- Null pointer exception in agent tool execution (#456)

### Changed
- Improved error messages for tool validation

### Deprecated
- Old API client interface (use ModelClient instead)

### Removed
- Legacy tool execution method

### Security
- Fixed path traversal vulnerability in file operations
```

### API Documentation

Generate and review API documentation:

```bash
# Generate docs
cargo doc --no-deps --open

# Check for missing docs
cargo doc --no-deps 2>&1 | grep warning

# Generate docs with private items
cargo doc --no-deps --document-private-items
```

---

## Pull Request Process

### Before Submitting

**Pre-submission checklist:**

- [ ] Code compiles without warnings
  ```bash
  cargo build --all-targets --all-features
  ```

- [ ] All tests pass
  ```bash
  cargo test
  ```

- [ ] Code is formatted
  ```bash
  cargo fmt --all -- --check
  ```

- [ ] No Clippy warnings
  ```bash
  cargo clippy --all-targets --all-features -- -D warnings
  ```

- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] Commit messages follow conventions

### PR Template

When creating a PR, fill out this template:

```markdown
## Description

Brief description of what this PR does.

## Motivation and Context

Why is this change required? What problem does it solve?
Fixes #(issue number)

## How Has This Been Tested?

Describe the tests you ran and their results.

- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing: (describe steps)

## Types of Changes

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] Documentation update

## Checklist

- [ ] My code follows the code style of this project
- [ ] My change requires a change to the documentation
- [ ] I have updated the documentation accordingly
- [ ] I have added tests to cover my changes
- [ ] All new and existing tests passed
- [ ] I have updated the CHANGELOG.md

## Screenshots (if appropriate)

## Additional Notes

Any additional information for reviewers.
```

### Review Process

**What to expect:**

1. **Automated checks** (GitHub Actions):
   - Build verification
   - Test execution
   - Lint checks
   - Security scanning

2. **Code review** by maintainers:
   - Usually within 2-3 business days
   - May request changes
   - Approval from at least 1 maintainer required

3. **Merge**:
   - Squash and merge (default)
   - All commits squashed into one
   - PR title becomes commit message

**Addressing feedback:**

```bash
# Make requested changes
vim src/your_file.rs

# Commit
git add .
git commit -m "fix: address review comments"

# Push
git push origin feature/123-your-feature

# PR automatically updates
```

### After Merge

1. **Delete your branch:**
   ```bash
   git branch -d feature/123-your-feature
   git push origin --delete feature/123-your-feature
   ```

2. **Sync your fork:**
   ```bash
   git checkout main
   git fetch upstream
   git rebase upstream/main
   git push origin main
   ```

3. **Celebrate! 🎉** You've contributed to Snailer!

---

## Community

### Communication Channels

- **GitHub Issues**: Bug reports, feature requests
  - Use issue templates
  - Search before creating
  - Provide minimal reproducible examples

- **GitHub Discussions**: Questions, ideas
  - General questions
  - Feature proposals
  - Show and tell

- **Discord**: Real-time chat
  - Quick questions
  - Community support
  - Pair programming

### Getting Help

**Before asking:**
1. Search existing issues and discussions
2. Read relevant documentation
3. Try to create a minimal reproducible example

**When asking:**
- Provide context (what you're trying to do)
- Show what you've tried
- Include error messages and stack traces
- Specify your environment (OS, Rust version, etc.)

**Good question example:**

```markdown
## Problem
I'm trying to add a new tool but getting a compilation error.

## Environment
- OS: macOS 13.0
- Rust: 1.75.0
- Snailer: main branch (commit abc123)

## What I tried
1. Created `src/tools/http.rs`
2. Added tool definition in `define_tools()`
3. Added routing in `execute_tool()`

## Error
```
error[E0277]: the trait bound `HttpTool: ToolExecutor` is not satisfied
  --> src/tools/http.rs:45:10
```

## Code
\`\`\`rust
// Relevant code snippet
\`\`\`

## Question
How do I properly implement the `ToolExecutor` trait?
```

### Recognition

Contributors are recognized in:
- [Contributors page](https://github.com/your-org/snailer/graphs/contributors)
- Release notes
- Annual contributor spotlight

---

## Appendix

### Useful Commands

```bash
# Development
cargo watch -x check                 # Continuous compilation check
cargo watch -x test                  # Continuous testing
cargo watch -x 'run -- --help'       # Continuous run

# Cleaning
cargo clean                          # Remove build artifacts
cargo clean --doc                    # Remove generated docs

# Dependencies
cargo tree                           # Show dependency tree
cargo outdated                       # Check for outdated dependencies
cargo audit                          # Security audit

# Release
cargo build --release                # Optimized build
cargo bloat --release                # Binary size analysis
```

### Learning Resources

**Rust:**
- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
- [Async Book](https://rust-lang.github.io/async-book/)

**Testing:**
- [Rust Testing Guide](https://doc.rust-lang.org/book/ch11-00-testing.html)
- [Criterion.rs](https://github.com/bheisler/criterion.rs) (benchmarking)

**Project-specific:**
- [Agent Architecture](./AGENT_ARCHITECTURE.md)
- [Tool System](./TOOL_SYSTEM.md)
- [ACE System](./ACE_SYSTEM.md)

### License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Snailer!** 🙏

Your contributions make this project better for everyone.

Questions? Reach out on [Discord](https://discord.gg/snailer) or open a [Discussion](https://github.com/your-org/snailer/discussions).
