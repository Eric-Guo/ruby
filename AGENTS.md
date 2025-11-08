# Ruby Interpreter Development Guide

## Project Overview

This is the Ruby programming language interpreter (CRuby/MRI) source code repository. Ruby is an interpreted object-oriented programming language designed for simplicity and productivity. The interpreter is written primarily in C with optional JIT compilers written in Rust.

**Key Components:**
- **Core Interpreter**: Written in C, implements Ruby VM, object system, and standard library
- **Prism Parser**: Modern Ruby parser written in C
- **YJIT**: Production-ready JIT compiler written in Rust (optional)
- **ZJIT**: Experimental JIT compiler written in Rust (optional)
- **Standard Library**: Ruby and C extensions providing core functionality

## Technology Stack

### Core Technologies
- **Language**: C (interpreter core), Ruby (standard library), Rust (JIT compilers)
- **Build System**: Autotools (autoconf/automake) + custom Makefiles
- **Parser**: Prism (modern recursive descent parser)
- **VM**: Stack-based bytecode virtual machine
- **GC**: Incremental mark-and-sweep garbage collector

### Optional Components
- **YJIT**: Rust-based JIT compiler for performance optimization
- **ZJIT**: Experimental Rust-based JIT compiler
- **Rust Workspace**: Cargo-based build for JIT components

## Project Structure

```
/Users/guochunzhong/git/oss/ruby_3_0/
├── *.c                    # Core interpreter source files
├── *.h                    # Header files
├── lib/                   # Ruby standard library
├── ext/                   # C extensions for standard library
├── test/                  # Ruby test suite
├── spec/                  # Ruby spec tests (ruby/spec)
├── bootstraptest/         # Bootstrap tests (run on miniruby)
├── tool/                  # Development tools and scripts
├── doc/                   # Documentation
├── benchmark/             # Performance benchmarks
├── yjit/                  # YJIT Rust source code
├── zjit/                  # ZJIT Rust source code
├── jit/                   # JIT infrastructure
├── prism/                 # Prism parser source
└── coroutine/             # Platform-specific coroutine implementations
```

### Key Source Files
- `ruby.c`: Main interpreter entry point and command-line processing
- `vm.c`: Virtual machine implementation
- `vm_core.h`: VM data structures and core definitions
- `object.c`: Ruby object system implementation
- `class.c`: Class and module implementation
- `string.c`, `array.c`, `hash.c`: Core data structure implementations
- `io.c`: Input/output operations
- `gc.c`: Garbage collector implementation
- `compile.c`: Bytecode compiler
- `prism_compile.c`: Prism parser integration

## Build Process

### Prerequisites
- C compiler (GCC, Clang, or MSVC)
- autoconf 2.67+ (for building from git)
- gperf 3.1+ (for certain source files)
- Ruby 3.1+ (for building from git)
- git 2.32+
- Optional: Rust 1.58.0+ (for YJIT/ZJIT)
- Optional: OpenSSL, libyaml, zlib (for RubyGems)

### Quick Build Instructions
```bash
# From tarball
./configure
make -j
make install

# From git repository
./autogen.sh
./configure
make -j
make install
```

### Configuration Options
- `--enable-yjit`: Enable YJIT compiler
- `--enable-zjit`: Enable ZJIT compiler
- `--enable-shared`: Build shared library
- `--disable-install-doc`: Skip documentation installation
- `--with-opt-dir`: Specify additional library locations

## Testing Strategy

### Test Suites
1. **Bootstrap Tests** (`make btest`)
   - Run on Miniruby (minimal Ruby interpreter)
   - Test core language functionality
   - Fast execution for basic validation

2. **Ruby Tests** (`make test`)
   - Run on full Ruby interpreter
   - Test standard library and extensions

3. **Comprehensive Tests** (`make test-all`)
   - Extensive test suite
   - Test all components including extensions

4. **Ruby Spec** (`make test-spec`)
   - Ruby language specification tests
   - Cross-implementation compatibility tests

5. **Bundler Tests** (`make test-bundler`)
   - RubyGems and Bundler functionality

### Running Tests
```bash
# Bootstrap tests
make btest

# Specific bootstrap test
make btest BTESTS="../bootstraptest/test_string.rb"

# All Ruby tests
make test-all

# Specific test file
make test-all TESTS="../test/ruby/test_string.rb"

# Ruby spec tests
make test-spec

# Parallel execution (faster)
make test-spec SPECOPTS=-j
```

## Development Workflow

### Code Organization
- **Core VM**: `vm*.c`, `vm*.h` files
- **Object System**: `object.c`, `class.c`, `*.c` (per class)
- **Parser**: `prism/` directory and `prism_*.c` files
- **Extensions**: `ext/` directory with C extensions
- **Standard Library**: `lib/` directory with Ruby files

### JIT Development
- **YJIT**: Rust code in `yjit/` directory
- **ZJIT**: Rust code in `zjit/` directory
- Build with `--enable-yjit` or `--enable-zjit`
- Run tests with `make yjit-test` or `make zjit-test`

### Contributing Guidelines
- Follow existing code style and conventions
- Add tests for new functionality
- Update documentation as needed
- Run full test suite before submitting changes
- Use appropriate commit message format

## Performance and Optimization

### JIT Compilers
- **YJIT**: Production-ready, significant performance improvements
- **ZJIT**: Experimental, research-focused
- Both require Rust toolchain for development

### Benchmarking
- Benchmark suite in `benchmark/` directory
- Performance regression testing via CI
- Platform-specific optimizations in `coroutine/` directory

## Security Considerations

- Input validation in parser and core methods
- Memory safety in C extensions
- Sandboxing capabilities for untrusted code
- Regular security audits and updates

## Platform Support

### Supported Platforms
- Linux (x86_64, ARM64, RISC-V, etc.)
- macOS (x86_64, Apple Silicon)
- Windows (MinGW, MSVC)
- Various Unix systems (FreeBSD, OpenBSD, etc.)

### Platform-Specific Code
- `coroutine/`: Architecture-specific coroutine implementations
- `win32/`: Windows-specific code
- `missing/`: Compatibility layers for missing functions

## Version Information

Current development version (from source):
- Ruby version: Development branch (3.x series)
- API version: 3.0.0+
- Release date: Development snapshot

For specific version information, see `version.h` and `version.c` files.

## Additional Resources

- **Documentation**: `doc/` directory and https://docs.ruby-lang.org/
- **Bug Reports**: https://bugs.ruby-lang.org/
- **Mailing List**: ruby-talk@ml.ruby-lang.org
- **Contributing Guide**: `doc/contributing/` directory
- **Build Instructions**: `doc/contributing/building_ruby.md`