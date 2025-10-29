<div align="center">

# 🐌 Snailer CLI

**AI-Powered Development Agent for Your Terminal**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust](https://img.shields.io/badge/rust-1.75%2B-orange.svg)](https://www.rust-lang.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](docs/CONTRIBUTING.md)
[![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-red.svg)](https://github.com/felixaihub/snailer-cli)

</div>

---

## 🎓 Open Source Contribution Program

> **🌟 Join our open-source training program!** This is a **production-ready** Rust-based AI coding agent actively used in real-world projects. We welcome contributors of all skill levels to learn, contribute, and build their portfolio.

### 🎯 Career Benefits

- ✅ **First PR Merged** → Earn **Collaborator** access (with branch protection & PR requirements)
- 📝 **Portfolio Material**: Real open-source contributions you can showcase
- 💼 **Resume/Portfolio Examples**: We provide templates for highlighting your contributions
- 🚀 **Direct Career Impact**: Evidence-based achievements (documentation, diagrams, OSS contributions)

### 💡 What You'll Work On

This repository contains **two production AI agents**:
1. **CLI Coding Agent**: Rust-based terminal agent (Claude Code/Codex workflow)
2. **iOS AI Development Agent**: Automated iOS app development workflow

**Your contributions will be used as reference materials and can directly impact your career growth!**

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

### 🚀 How to Start Contributing

1. **Join the Program**: Read through this README and [CONTRIBUTING.md](docs/CONTRIBUTING.md)
2. **Pick an Issue**: Look for issues labeled `good first issue` or `help wanted`
3. **Ask Questions**: Use GitHub Discussions or Q&A section - don't hesitate!
4. **Submit PR**: Follow our PR template and contribution guidelines
5. **Get Merged**: First PR merged → Earn Collaborator access! 🎉

### 🎯 Good First Issues

Start here if you're new to open source:

- 📝 **Documentation**: Fix typos, add examples, improve clarity
- ✅ **Testing**: Add unit tests, integration tests
- 🎨 **Diagrams**: Create architecture diagrams, flow charts
- 🔧 **Tools**: Implement new tool integrations
- 🐛 **Bug Fixes**: Resolve reported issues

### 💡 Contribution Areas by Skill Level

| Area | Difficulty | Examples | Impact |
|------|------------|----------|--------|
| **Documentation** | 🟢 Beginner | README improvements, code comments | High visibility for portfolio |
| **Testing** | 🟢 Beginner | Unit tests, integration tests | Critical for production |
| **Tools** | 🟡 Intermediate | HTTP tools, database tools | Direct feature impact |
| **Performance** | 🟡 Intermediate | Caching, async optimization | Production improvements |
| **ACE System** | 🔴 Advanced | Bullet algorithms, reflection | Research contribution |
| **Architecture** | 🔴 Advanced | Plugin system, multi-agent | Design leadership |

### 📊 Your Contributions Can Become References

**Your work in this repository can be**
- ✅ Referenced in technical documentation
- ✅ Used as case studies in training materials
- ✅ Featured in blog posts and presentations
- ✅ Listed on your resume as production OSS contributions

### 💬 Questions & Support

- **GitHub Discussions**: For general questions and discussions
- **Q&A Issues**: Create an issue with the `question` label
- **Discord/Slack**: Join our community (link in discussions)

**Don't hesitate to ask!** Every question helps improve our documentation and helps future contributors.

**Read the full guide:** [CONTRIBUTING.md](docs/CONTRIBUTING.md)

---

## 🏗️ Architecture

Snailer uses a modular, **4-layer architecture** designed for extensibility and production reliability:

```
┌──────────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                           │
│  ┌──────────────────────┐        ┌──────────────────────────────┐  │
│  │   CLI Interface      │        │   TUI (Terminal UI)          │  │
│  │   (clap-based)       │        │   (ratatui-based)            │  │
│  └──────────────────────┘        └──────────────────────────────┘  │
└───────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Application Layer                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     Agent Runtime                            │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │   │
│  │  │  Execution   │  │   Context    │  │    Failover      │  │   │
│  │  │   Engine     │  │   Manager    │  │    Manager       │  │   │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     ACE Learning System                      │   │
│  │  ┌──────────┐   ┌──────────┐   ┌──────────┐                │   │
│  │  │Generator │──▶│Reflector │──▶│ Curator  │                │   │
│  │  └──────────┘   └──────────┘   └──────────┘                │   │
│  └─────────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Integration Layer                            │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │   Tool Registry  │  │  AI API Client   │  │   Database      │  │
│  │   (File, Git,    │  │  (Multi-Model)   │  │   (SQLite)      │  │
│  │    Shell, etc.)  │  │                  │  │                 │  │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘  │
└───────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Infrastructure Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────────┐    │
│  │ File System  │  │  AI Providers │  │  Analytics Service    │    │
│  │              │  │  (Claude, GPT,│  │  (Supabase/gRPC)      │    │
│  │              │  │   Grok, etc.) │  │                       │    │
│  └──────────────┘  └──────────────┘  └───────────────────────┘    │
└──────────────────────────────────────────────────────────────────────┘
```

### 📖 Architecture Documentation

| Document | Description |
|----------|-------------|
| [**System Architecture**](ARCHITECTURE.md) | Complete system design, module diagrams, data flow, and deployment architecture |
| [**Agent Architecture**](docs/AGENT_ARCHITECTURE.md) | Agent execution modes, tool loop, and context management |
| [**ACE System**](docs/ACE_SYSTEM.md) | Self-learning context engineering system |

### 🔬 Research & References

Snailer's architecture is based on cutting-edge research:

- **ACE (Agentic Context Engineering)**: Self-improving context management system
- **Context Compression**: Dual-paper approach (LMLINGUA + Selective Context Filtering)
- **Multi-Model Orchestration**: Unified API with automatic failover

For detailed references and paper citations, see [ARCHITECTURE.md](ARCHITECTURE.md)

---

## 🔒 Privacy & Security

- **Local-First**: All processing happens on your machine
- **No Code Upload**: Your code never leaves your machine
- **API Key Security**: Keys stored locally, never transmitted except to AI providers
- **Opt-in Analytics**: Usage tracking can be disabled with `SNAILER_TRACK_USAGE=0`

---

## 📚 Learning Resources

### For Contributors

| Resource | Description | Level |
|----------|-------------|-------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | System design and module diagrams | All levels |
| [docs/AGENT_ARCHITECTURE.md](docs/AGENT_ARCHITECTURE.md) | Agent implementation details | Intermediate |
| [docs/ACE_SYSTEM.md](docs/ACE_SYSTEM.md) | Self-learning system | Advanced |
| [docs/TOOL_SYSTEM.md](docs/TOOL_SYSTEM.md) | Tool development guide | Intermediate |
| [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) | Contribution guidelines | All levels |

### Portfolio Templates

We provide templates to help you showcase your contributions:

- **Resume Bullet Points**: Example descriptions for your contributions
- **Cover Letter Examples**: How to discuss OSS contributions in applications
- **Portfolio Project Descriptions**: Technical write-ups of your work

*Templates will be available in the `docs/portfolio-templates/` directory*

---

## 🌟 Community

### Stay Connected

- 💬 **GitHub Discussions**: Ask questions, share ideas, get help
- 🐛 **Issue Tracker**: Report bugs, request features, track work
- 📖 **Wiki**: Community-maintained guides and tutorials
- 🎓 **Training Program**: Structured learning path for contributors

### Recognition

Contributors who make significant contributions will be:
- ✅ Listed in our `CONTRIBUTORS.md` file
- ✅ Mentioned in release notes
- ✅ Given Collaborator access (after first PR merge)
- ✅ Featured in case studies (with permission)

---

## 📄 License

This project is dual-licensed:

- **Source Code & Documentation**: MIT License ([LICENSE](LICENSE))
- **Binary Distribution**: End-User License Agreement ([EULA.md](EULA.md))

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

<div align="center">

**Made with ❤️ by the Snailer Team and Our Amazing Contributors**

[Website](https://snailer.ai) • [Documentation](ARCHITECTURE.md) • [Contributing](docs/CONTRIBUTING.md) • [Discussions](https://github.com/felixaihub/snailer-cli/discussions)

⭐ **Star us on GitHub** if you find Snailer useful!

**Join our open-source training program and build your portfolio today!**

</div>
