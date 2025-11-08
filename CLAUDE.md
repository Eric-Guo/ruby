# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Ruby programming language interpreter (CRuby/MRI) source code. Ruby is an interpreted object-oriented language. The interpreter is primarily written in C with optional Rust-based JIT compilers (YJIT and ZJIT), and a modern Prism parser written in C.

## Quick Reference

### Build Commands

**From tarball:**
```bash
./configure --prefix="${HOME}/.rubies/ruby-3.0"
make -j$(sysctl -n hw.ncpu)
make install
```

**From git:**
```bash
./autogen.sh
./configure --prefix="${HOME}/.rubies/ruby-3.0"
make -j$(sysctl -n hw.ncpu)
make install
```

**With JIT compilers:**
```bash
./configure --enable-yjit  # or --enable-zjit
```

**Build in separate directory (recommended):**
```bash
mkdir build && cd build
../configure --prefix="${HOME}/.rubies/ruby-3.0"
make -j$(sysctl -n hw.ncpu)
make install
```

### Test Commands

**Bootstrap tests (fast, on miniruby):**
```bash
make btest
make btest BTESTS="../bootstraptest/test_string.rb"
make btest BTESTS="--sets=string,class"
```

**Ruby tests (on full Ruby):**
```bash
make test
make test OPTS=-v
```

**Comprehensive test suite:**
```bash
make test-all
make test-all TESTS="../test/ruby/test_string.rb"
make test-all TESTS="../test/ruby/test_string.rb --name=TestString#test_to_s"
make test-all TESTS=-v
```

**Ruby spec tests:**
```bash
make test-spec
make test-spec SPECOPTS="../spec/ruby/core/string/"
make test-spec SPECOPTS="../spec/ruby/core/string/to_s_spec.rb"
```

**Bundler tests:**
```bash
make test-bundler
make test-bundler BUNDLER_SPECS=commands/exec_spec.rb
```

**Run all tests (recommended before committing):**
```bash
make check
```

**Parallel execution (faster):**
```bash
make test-all -j8
export MAKEFLAGS="--jobs $(sysctl -n hw.ncpu)"
```

### Debug Commands

**Debug with lldb/gdb:**
```bash
# Create test.rb with your Ruby code
echo 'puts "Hello"' > test.rb

make lldb    # Debug miniruby
make gdb     # Debug miniruby
make lldb-ruby  # Debug full Ruby
make gdb-ruby   # Debug full Ruby
```

**Compile with debug flags:**
```bash
./configure cppflags="-DRUBY_DEBUG=1 -DUSE_RUBY_DEBUG_LOG=1" optflags="-O0 -fno-omit-frame-pointer"
```

## High-Level Architecture

### Core Components

1. **Virtual Machine (VM)**: Stack-based bytecode interpreter
   - Entry point: `ruby.c`
   - VM core: `vm.c`, `vm_core.h`, `vm_insnhelper.c`
   - Execution: `vm_eval.c`, `vm_method.c`
   - Bytecode instructions: `insns.def`

2. **Object System**: Core Ruby objects and classes
   - Objects: `object.c`, `class.c`
   - Core data structures: `string.c`, `array.c`, `hash.c`
   - Numerics: `numeric.c`, `bignum.c`, `rational.c`, `complex.c`

3. **Parser**: Prism parser (modern recursive descent)
   - Source: `prism_compile.c`, `prism/` directory
   - Grammar: `parse.y`
   - AST nodes: `ast.c`, `node.h`

4. **Compiler**: Ruby to bytecode compiler
   - Implementation: `compile.c`
   - Instruction sequences: `iseq.c`, `iseq.h`

5. **Garbage Collector**: Incremental mark-and-sweep GC
   - Implementation: `gc.c`, `gc.rb`
   - Internal headers: `internal/gc.h`

6. **I/O System**: File and stream I/O
   - Implementation: `io.c`, `io_buffer.c`
   - File operations: `file.c`, `dir.c`

7. **JIT Compilers** (optional, written in Rust):
   - YJIT: `yjit/`, `yjit.c`, `yjit.h` (production-ready)
   - ZJIT: `zjit/`, `zjit.c`, `zjit.h` (experimental)

8. **Threading & Concurrency**:
   - Threads: `thread.c`, `thread_pthread.c`, `thread_win32.c`
   - Ractors (Ruby actors): `ractor.c`, `ractor_sync.c`
   - Fiber coroutines: `cont.c`, `coroutine/` directory

### Standard Library

- **Ruby code**: `lib/` directory (default gems: bundler, erb, set, yaml, etc.)
- **C extensions**: `ext/` directory (openssl, readline, json, objspace, etc.)

## Directory Structure

```
/Users/guochunzhong/git/oss/ruby_3_0/
├── *.c, *.h              # Core interpreter source (C)
├── lib/                  # Ruby standard library
├── ext/                  # C extensions
├── test/                 # Main test suite (Ruby)
├── spec/                 # Ruby spec tests
├── bootstraptest/        # Bootstrap tests (miniruby)
├── tool/                 # Development tools
├── doc/                  # Documentation
├── benchmark/            # Performance benchmarks
├── include/              # Public headers
├── internal/             # Internal headers
├── yjit/                 # YJIT Rust source
├── zjit/                 # ZJIT Rust source
├── prism/                # Prism parser source
├── jit/                  # JIT infrastructure
└── coroutine/            # Platform-specific coroutines
```

## Key Source Files

### Core Interpreter
- `ruby.c`: Main entry point and CLI processing
- `vm.c`: Virtual machine implementation
- `vm_core.h`: VM data structures and core definitions
- `vm_insnhelper.c`: VM instruction helper functions
- `object.c`: Object system implementation
- `class.c`: Class and module system
- `compile.c`: Bytecode compiler
- `gc.c`: Garbage collector
- `error.c`: Error handling

### Data Structures
- `string.c`: String implementation
- `array.c`: Array implementation
- `hash.c`: Hash table implementation
- `struct.c`: Struct implementation
- `enum.c`: Enumerable module

### I/O and System
- `io.c`: Input/output operations
- `file.c`: File operations
- `dir.c`: Directory operations
- `process.c`: Process management
- `load.c`: Code loading and require
- `variable.c`: Class/instance variables

### Threading
- `thread.c`: Thread implementation
- `ractor.c`: Ractor (actor model) implementation
- `cont.c`: Continuations and fibers

### Parser and Compiler
- `prism_compile.c`: Prism parser integration
- `parse.y`: Ruby grammar
- `iseq.c`: Instruction sequences
- `ast.c`: AST node management

## Development Workflow

### Making Changes

1. Build Ruby (see Build Commands above)
2. Run tests to verify:
   ```bash
   make btest          # Quick validation
   make test-all       # Comprehensive tests
   make check          # All tests including specs
   ```

3. For JIT changes, build with Rust:
   ```bash
   ./configure --enable-yjit
   make yjit-test
   ```

### Common Development Tasks

**Run a single test:**
```bash
make test-all TESTS="../test/ruby/test_string.rb"
make test-all TESTS="../test/ruby/test_string.rb --name=TestString#test_to_s"
```

**Run bootstrap test:**
```bash
make btest BTESTS="../bootstraptest/test_string.rb"
```

**Debug a failing test:**
```bash
echo 'require "test/unit"; require "../test/ruby/test_string"' > test.rb
make lldb-ruby
```

**Benchmark performance:**
```bash
make benchmark
```

**Clean build artifacts:**
```bash
git clean -xfd  # WARNING: Removes all untracked files
```

### Prerequisites for Building

**Required:**
- C compiler (GCC, Clang, or MSVC)
- autoconf 2.67+ (for git builds)
- Ruby 3.1+ (for building from git)
- git 2.32+

**Optional:**
- Rust 1.58.0+ (for YJIT/ZJIT)
- OpenSSL, libyaml, zlib (for RubyGems)
- libffi (for fiddle)
- gmp (for Bignum acceleration)

## Testing Strategy

### Test Suite Hierarchy

1. **bootstraptest/**: Tests core language features on miniruby
   - Fast execution for basic validation
   - Tests parser, VM, and core objects

2. **test/**: Comprehensive test suite on full Ruby
   - Tests standard library and extensions
   - Integration tests

3. **spec/ruby/**: Ruby language specification tests
   - Cross-implementation compatibility
   - Mirrored from ruby/spec repository

4. **spec/bundler/**: Bundler and RubyGems tests
   - Package management functionality

5. **test-bundler**: Bundler-specific tests

### When to Use Each Test Suite

- **During development**: `make btest` (fast feedback)
- **Before committing**: `make check` (full validation)
- **Performance testing**: `make benchmark`
- **CI verification**: Full test suite via `make check`

## Build System

- **Primary**: GNU Autotools (autoconf/automake)
  - Configuration: `configure.ac` → `configure` script
  - Build rules: `common.mk`, `depend`

- **Rust components**: Cargo workspace
  - YJIT and ZJIT build via Cargo
  - Integrated into main build via Make

- **Custom tools**: Ruby scripts in `tool/` directory
  - `tool/auto-style.rb`: Code style checking
  - `tool/m4*`: M4 macro processing
  - Various generation scripts

## Platform Support

- **Linux**: x86_64, ARM64, RISC-V, s390x
- **macOS**: x86_64, Apple Silicon
- **Windows**: MinGW, MSVC
- **Unix variants**: FreeBSD, OpenBSD, etc.

Platform-specific code:
- `win32/`: Windows implementation
- `coroutine/`: Architecture-specific coroutines
- `missing/`: Compatibility shims

## Useful Make Targets

- `make miniruby`: Build miniruby only (faster for VM changes)
- `make`: Build full Ruby
- `make install`: Install to prefix
- `make btest`: Run bootstrap tests
- `make test`: Run Ruby tests
- `make test-all`: Run comprehensive tests
- `make test-spec`: Run Ruby spec tests
- `make test-bundler`: Run Bundler tests
- `make check`: Run all tests
- `make benchmark`: Run performance benchmarks
- `make clean`: Clean build artifacts
- `make distclean`: Clean all generated files

## Documentation

- **Main README**: `README.md`
- **Contributing**: `doc/contributing/`
  - `building_ruby.md`: Detailed build instructions
  - `testing_ruby.md`: Testing guide
  - `making_changes_to_ruby.md`: Development workflow
- **Online docs**: https://docs.ruby-lang.org/
- **Bug tracker**: https://bugs.ruby-lang.org/

## Additional Notes

- **Miniruby**: Minimal Ruby without external dependencies, used for fast builds during core development
- **Parallel builds**: Use `make -j$(nproc)` to speed up compilation
- **Debug builds**: Configure with debug flags for development
- **Code style**: Run `tool/auto-style.rb` to check style changes
- **YJIT/ZJIT**: Require Rust 1.58+, can be disabled with `--disable-jit-conf`

For more details, see the documentation in `doc/contributing/` and the main `README.md`.
