# Snailer CLI 

Snailer CLI is an agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster by executing routine tasks, explaining complex code, and handling git workflows — all through natural language commands.

Note: This repository contains installers and documentation only (MIT). The Snailer binary is distributed under a separate EULA (see EULA.md).

## Install

### Homebrew
```
brew tap felixaihub/snailer
brew install snailer
```

### npm (wrapper downloads the binary)
```
npm i -g @felixaihub/snailer
# or
npx @felixaihub/snailer@latest --help
```

## Quick Start
```
snailer --help
```

## Documentation
- NEXT_ACTION DSL: docs/agent/NEXT_ACTION_DSL.md
- Domain presets: docs/agent/domain-presets.md
- Runbook: docs/agent/runbook.md
- Safety/Approval: docs/agent/safety-approval.md

## License
- Installers/docs: MIT (LICENSE)
- Binary: EULA (EULA.md)

## Contributing
See CONTRIBUTING.md. Good first issues and templates are provided.
