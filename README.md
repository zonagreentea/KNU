# KNU

**Kernel Names Unix**

A small, single-file communication core written in Zsh.

KNU brings connection management, message exchange, and command execution together behind a compact interface. It is designed to be readable, implementable, and iteratable: start with a small core, make its behavior predictable, and build from there.

## Philosophy

- **One file.** Keep the core together and easy to inspect.
- **A small interface.** Connect, communicate, inspect, and disconnect.
- **Minimal dependencies.** Use Zsh and its built-in facilities instead of introducing a large runtime.
- **Explicit behavior.** Make commands and their results easy to understand.
- **Iterative by design.** Extend the implementation without losing the simplicity of the core.

## Requirements

- macOS or another compatible Unix-like environment
- Zsh
- Zsh's `zsh/net/tcp` module for TCP communication

KNU is implemented in Zsh and does not require a separate Python runtime.

## Getting started

Clone the repository:

```sh
git clone https://github.com/zonagreentea/KNU.git
cd KNU
```

Make the entry point executable if necessary:

```sh
chmod +x KNU
```

Check the current connection state:

```sh
./KNU check
```

Display command help:

```sh
./KNU help
```

Run an executable through KNU:

```sh
./KNU execute /usr/bin/printf 'Hello from KNU\n'
```

## Commands

KNU exposes a compact set of operations for working with connections and processes.

| Command | Purpose |
| --- | --- |
| `connect` | Open a connection or listen for an incoming TCP connection |
| `send` | Send a message through a connection |
| `read` | Read a message from a connection |
| `write` | Write the most recently received message to a file |
| `check` | Inspect the current connection state |
| `disconnect` | Close one connection or all connections |
| `execute` | Execute a specified executable with arguments |
| `
