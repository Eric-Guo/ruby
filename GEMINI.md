# Gemini Code Assistant Project Context

## Project Overview

This project is the source code for the Ruby programming language. It is a large and complex codebase written primarily in C, with some parts written in Ruby and Rust. The project uses the GNU Build System (autotools) for its build process, and also uses Rust's Cargo for building some of its components.

The project includes the Ruby interpreter, the standard library, and a number of extensions. It also includes a test suite, benchmarks, and documentation.

## Building and Running

The project can be built and run using the following commands:

1.  **Configure the build:**

    ```bash
    ./autogen.sh
    ./configure
    ```

2.  **Build the project:**

    ```bash
    make
    ```

3.  **Run the tests:**

    ```bash
    make test
    ```

## Development Conventions

The project has a number of development conventions that are enforced through the build process and the test suite. These include:

*   **Coding style:** The project has a strict coding style that is enforced by the build process.
*   **Testing:** The project has a comprehensive test suite that is run on every commit.
*   **Documentation:** The project has a large amount of documentation, which is generated from the source code.

## Key Files

*   `README.md`: The main README file for the project.
*   `configure.ac`: The autoconf configuration file.
*   `Makefile.in`: The makefile template.
*   `common.mk`: A makefile fragment that is included in all other makefiles.
*   `Rakefile`: The Rakefile for the project.
*   `ext/`: The directory containing the source code for the Ruby extensions.
*   `lib/`: The directory containing the source code for the Ruby standard library.
*   `test/`: The directory containing the test suite.
*   `benchmark/`: The directory containing the benchmarks.
*   `doc/`: The directory containing the documentation.
*   `Cargo.toml`: The Cargo configuration file for the Rust components of the project.
*   `yjit/`: The directory containing the source code for the YJIT JIT compiler.
*   `zjit/`: The directory containing the source code for the ZJIT JIT compiler.
