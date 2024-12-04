# envpicker

A simple CLI tool for managing multiple environment files in your Node.js projects.

## Overview

envpicker helps developers easily manage and switch between different environment files (`.env`) in their local development environment. It provides simple commands to initialize, list, activate, and delete environment configurations.

## Installation

Install globally using npm:

```bash
npm install -g envpicker
```

Or use directly with npx:

```bash
npx envpicker [command]
```

## Usage

### Available Commands

```bash
envpicker [command]

Commands:
  list              List all available environments
  activate [env]    Switch to specified environment
  deactivate        Remove active environment
  init              Initialize default environment files
  delete [env]      Delete specific environment file
```

### Basic Operations

1. Initialize default environment files:
```bash
envpicker init
```
This will create:
- `env/.env.development`
- `env/.env.staging`
- `env/.env.production`

2. List available environments:
```bash
envpicker list
```

3. Activate an environment:
```bash
envpicker activate development
```

4. Deactivate current environment:
```bash
envpicker deactivate
```

5. Delete an environment:
```bash
envpicker delete development
```

## File Structure

The tool expects your project to have the following structure:

```
your-project/
├── env/
│   ├── .env.development
│   ├── .env.staging
│   └── .env.production
├── .env (created when environment is activated)
└── package.json
```

## Requirements

- Node.js
- Bash/Shell environment

## Limitations

- CLI-only tool (no GUI interface)
- Designed for local development use

## Bug Reports and Feature Requests

Please submit any bugs or feature requests to our [issues page](https://github.com/Candra-Julius/envpicker/issues).

## License

ISC License

## Security

Note: This tool is intended for local development use only. Be careful with your environment files and never commit them to version control.