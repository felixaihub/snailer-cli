<div align="center">

# 🐌 Snailer CLI

**AI-Powered Development Agent for Your Terminal**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust](https://img.shields.io/badge/rust-1.75%2B-orange.svg)](https://www.rust-lang.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](docs/CONTRIBUTING.md)

</div>

---

## 🚀 What is Snailer?

Snailer is an **intelligent AI coding agent** that lives in your terminal, understands your codebase, and helps you code faster by:

- 🔍 **Understanding Context**: Automatically learns from your project structure and coding patterns
- 🛠️ **Executing Tasks**: Performs file operations, code refactoring, and git workflows
- 🧠 **Self-Improving**: Uses ACE (Agentic Context Engineering) to learn from experience
- 💬 **Natural Language**: Just describe what you want in plain English

```bash
# Example: Let Snailer refactor your code
snailer "refactor the authentication module to use async/await"

# Example: Complex multi-step tasks
snailer "find all TODO comments, create GitHub issues, and remove them from code"
```

---

## ✨ Features

### 🤖 Intelligent Agent System

- **Tool-Based Execution**: 10+ built-in tools (file operations, search, git, shell)
- **Multi-Model Support**: Claude, GPT, Grok, Gemini
- **Context Management**: Automatic context extraction and curation
- **Cancelable Operations**: Press ESC anytime to stop

### 🧠 Self-Learning with ACE

Snailer uses **ACE (Agentic Context Engineering)** to improve over time:

- Learns from successful and failed executions
- Builds a knowledge base of project-specific patterns
- Applies learned lessons to future tasks
- Becomes smarter with each interaction

[Learn more about ACE →](docs/ACE_SYSTEM.md)

### 🛠️ Built-in Tools

| Tool | Description |
|------|-------------|
| `read_file` | Read file contents with optional line ranges |
| `write_file` | Create or overwrite files |
| `edit_file` | Precise text replacement in files |
| `search_repo` | Search code with ripgrep (respects .gitignore) |
| `find_files` | Find files by name pattern |
| `shell_command` | Execute shell commands with timeout |
| `list_directory` | List directory contents |
| `delete_file` | Delete files safely |
| `move_file` | Move or rename files |

[View all tools →](docs/TOOL_SYSTEM.md)

### 🎯 Execution Modes

- **Simple Mode**: Quick Q&A without tool execution
- **Agent Mode**: Full tool-based task execution (default)
- **GRPO Mode**: Experimental multi-attempt optimization

---

## 📦 Installation

### Homebrew (macOS/Linux)

```bash
brew install snailer
```

### npm (Cross-platform)

```bash
# Global installation
npm install -g @felixaihub/snailer

# Or use npx (no installation)
npx @felixaihub/snailer@latest --help
```

---

## 📚 Documentation

### 📖 Core Documentation

| Document | Description |
|----------|-------------|
| [**Agent Architecture**](docs/AGENT_ARCHITECTURE.md) | Complete guide to Snailer's agent system, execution modes, and tool loop |
| [**Tool System**](docs/TOOL_SYSTEM.md) | All built-in tools, how to add custom tools, and best practices |
| [**ACE System**](docs/ACE_SYSTEM.md) | Self-learning context management with bullets and curation |
| [**Contributing Guide**](docs/CONTRIBUTING.md) | How to contribute: setup, workflow, coding standards, testing |


---

## 🤝 Contributing

We welcome contributions! Snailer is built to be **contributor-friendly** with comprehensive documentation and examples.

### 🎯 Good First Issues

- 📝 Documentation improvements
- ✅ Adding tests
- 🔧 New tool implementations
- 🐛 Bug fixes

### 💡 Contribution Areas

| Area | Difficulty | Examples |
|------|------------|----------|
| **Documentation** | 🟢 Beginner | Fix typos, add examples, improve clarity |
| **Testing** | 🟢 Beginner | Add unit tests, integration tests |
| **Tools** | 🟡 Intermediate | HTTP requests, database queries, image processing |
| **Performance** | 🟡 Intermediate | Token optimization, caching, async improvements |
| **ACE System** | 🔴 Advanced | Bullet selection algorithms, reflection quality |
| **Architecture** | 🔴 Advanced | Plugin system, multi-agent collaboration |

**Read the full guide:** [CONTRIBUTING.md](docs/CONTRIBUTING.md)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         User Input                          │
│                    (Natural Language)                       │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│                      Agent Core                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Context Manager (ACE)                               │  │
│  │  - Bullet selection                                  │  │
│  │  - Self-learning from experience                     │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Tool Execution Loop                                 │  │
│  │  - AI planning                                       │  │
│  │  - Tool selection                                    │  │
│  │  - Result processing                                 │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│                     Tool Registry                           │
│  [read_file] [write_file] [edit_file] [search_repo]        │
│  [find_files] [shell_command] [git_*] ...                  │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│                   File System / Git / Shell                 │
└─────────────────────────────────────────────────────────────┘
```

[Learn more about architecture →](docs/AGENT_ARCHITECTURE.md)

---

## 🔒 Privacy & Security

- **Local-First**: All processing happens on your machine
- **No Code Upload**: Your code never leaves your machine
- **API Key Security**: Keys stored locally, never transmitted except to AI providers
- **Opt-in Analytics**: Usage tracking can be disabled with `SNAILER_TRACK_USAGE=0`

---

## 📄 License

This project is dual-licensed:

- **Documentation & Installers**: MIT License ([LICENSE](LICENSE))
- **Binary Distribution**: End-User License Agreement ([EULA.md](EULA.md))

By using Snailer, you agree to the terms in both licenses.

---

<div align="center">

**Made with ❤️ by the Snailer Team**

[Website](https://snailer.ai)

⭐ **Star us on GitHub** if you find Snailer useful!

</div>
