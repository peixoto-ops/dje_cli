# PJE CLI Assistant - QWEN Documentation

## Project Overview

The PJE CLI Assistant is a command-line tool written in Bash designed to interact with the Brazilian Judicial Process Electronic (PJE) API. This tool allows lawyers to query, manage, and track their legal processes directly from the terminal, offering a more efficient alternative to the web-based PJE interface.

The project leverages the PJE Communication API to search for legal processes, retrieve their history of proceedings (andamentos), and perform actions such as downloading PDF documents or opening them in a web browser.

### Key Features
- Query legal processes by lawyer's name and OAB number
- Display interactive lists of processes and their proceedings
- Download PDF documents of court communications
- Open documents in the default web browser
- Configurable lawyer credentials through an external configuration file
- Cross-platform support (Linux/macOS)

## Project Structure

The project consists of the following directory structure:

```
dje_cli/
├── docs/
│   ├── api/
│   │   └── orienta_documenta_api.md
│   ├── guia/
│   │   ├── contribuicao.md
│   │   ├── convencao_commit.md
│   │   └── multiplataforma.md
│   ├── specs/
│   │   └── spec_kit.md
│   └── protocolos/
│       └── documentacao_frontmatter.md
├── src/
│   ├── pje_cli.sh
│   └── config/
│       └── pje.conf.example
├── conversas/
│   └── chat-Zai.md
├── scripts/
│   └── build.sh
├── tests/
├── .github/
│   └── workflows/
│       ├── package.yml
│       ├── release.yml
│       └── semantic-versioning.yml
├── releases/
├── CHANGELOG.md
├── LICENSE
├── package.json
├── QWEN.md
├── README.md
└── VERSION
```

## Building and Running

### Dependencies

The script requires the following tools to be installed on the system:

- **Bash**: The script is written for Bash (version 4.0+ recommended)
- **curl**: For making HTTP requests to the PJE API
- **jq**: A command-line JSON processor, essential for parsing API responses
- **xdg-open** (Linux) or **open** (macOS): For opening URLs in the default browser

### Installation

1. Ensure all dependencies are installed on your system:
   ```bash
   # For Debian/Ubuntu
   sudo apt-get install curl jq
   
   # For Fedora/CentOS
   sudo dnf install curl jq
   
   # For macOS (with Homebrew)
   brew install curl jq
   ```

2. Create a configuration file `pje.conf` with your lawyer credentials:
   ```bash
   # Example pje.conf
   NOME_ADV="YOUR FULL NAME"
   NUMERO_OAB="YOUR OAB NUMBER"
   UF_OAB="YOUR OAB STATE"
   ```

3. Make the script executable:
   ```bash
   chmod +x pje_cli.sh
   ```

4. Run the script:
   ```bash
   ./pje_cli.sh
   ```

### Usage

The script provides an interactive menu system:

1. The script first loads your credentials from `pje.conf`
2. It queries the PJE API for all processes associated with your credentials
3. You can select a specific process from the list
4. View the history of proceedings for the selected process
5. For each proceeding, you can choose to:
   - Open the document in your web browser
   - Download the PDF to your local machine
   - Return to the previous menu

## Development Conventions

### Coding Style
- Use descriptive function names in Portuguese for clarity to the legal audience
- Include comments in Portuguese explaining complex logic
- Follow Bash best practices for error handling and user input validation
- Use `clear` command between menu transitions for better user experience
- Implement cross-platform compatibility using system detection functions

### Error Handling
- Check for the presence of all required dependencies at startup
- Validate configuration file existence and required parameters
- Handle API errors gracefully with informative messages
- Validate user inputs and provide clear error feedback

### API Interaction
- All API calls use the PJE Communication API at `https://comunicaapi.pje.jus.br/api/v1/comunicacao`
- Process unique filtering using `jq -r '.items[].numero_processo' | sort | uniq` to avoid duplicate process listings
- URL-encode user parameters (especially names with spaces)
- Use proper HTTP headers for JSON content negotiation

### Cross-Platform Compatibility
- Use `#!/usr/bin/env bash` shebang for better compatibility
- Implement OS detection function to handle platform-specific commands
- Support for Linux (xdg-open), macOS (open), and Windows (start) for opening URLs

### Security Considerations
- Credentials should be stored in the external `pje.conf` file rather than hardcoded
- Ensure the configuration file has appropriate permissions to prevent unauthorized access
- The script does not store sensitive data persistently beyond the configuration file

### Git Commit Conventions
Use Conventional Commits standard with the following types:
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Test-related changes
- `chore`: Maintenance tasks
- `build`: Build system changes
- `ci`: CI configuration changes

### Documentation Protocol with Frontmatter
All documentation files should include YAML frontmatter:
```yaml
---
title: "Title of Document"
date_created: "YYYY-MM-DD"
last_modified: "YYYY-MM-DD"
tags:
  - tag1
  - tag2
project: "PJE CLI Assistant"
related:
  - "Related file"
---
```

## Technical Implementation Details

The project is structured around four main functions:

1. **Configuration Loading** (`carregar_configuracoes`): Loads and validates the `pje.conf` file
2. **Process Querying** (`consultar_e_selecionar_processo`): Queries all processes associated with the lawyer
3. **History Display** (`exibir_historico_e_acoes`): Shows proceedings for a selected process
4. **Action Menu** (`menu_acoes`): Provides options to open or download documents

Each function is designed to be modular and handle its specific responsibility while maintaining a clean user interface through the terminal.

The API endpoints used include:
- `GET /api/v1/comunicacao` with parameters for querying by lawyer credentials
- `GET /api/v1/comunicacao` with process number parameter for getting history
- `GET /api/v1/comunicacao/{hash}/certidao` for retrieving specific documents as PDFs