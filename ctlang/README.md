
# CTLang

This is the compiler for the CTLang cryptographic programming language.
CTLang is a domain-specific language that aids you in writing constant-time code for cryptographic routines
that need to be free from timing side channels.

## Installation

To install you can either build the source or download ```ctlang.byte```. We recommend to build from source if possible.

```ctlang.byte``` is the executable used to compile CTLang programs. Execute ```./ctlang.byte -help``` for a list of the command line options.

## Usage

#### Basic Usage

Run ```./ctlang.byte ex.ctlang``` to compile a CTLang program where ```ex.ctlang``` is the name of your file.

#### Debugging

Many debugging options and intermediate data structures are available. Run ```./ctlang.byte -help``` for all options.

## Set Up And Build On Local Machine

CTLang is developed using Ocaml and LLVM 6.0. Make sure both of these are installed.
On OS X it can be done with brew.

```
brew install ocaml
brew install llvm60
```

We also need dependency management for Ocaml.

```brew install opam```

Then we need the actual dependencies for Ocaml.

```
opam switch 4.06.0
eval $(opam config env)
opam switch import ocamlswitch.txt
```

If you have not setup oasis, then you must do that first.

```oasis setup```

Make sure the Z3 lib is in the path:

```export LD_LIBRARY_PATH="$HOME/.opam/4.06.0/lib/z3"```

Finally we can build the compiler.

```make```

If you want to add a dependency, add it to ```_oasis```, then run the 3 previous commands again.

This will give us the ```ctlang.byte``` executable.

To install CTLang, run the command

```make install```

This will add CTLang to your path so that you can compile const files with the command,

```ctlang```

## Link to a C library

CTLang is designed to be called from C code. In order to do so, write your CTLang functions and compile them. This will output an object file. This can then be linked to a C file. For example:

```ctlang ex.ctlang```

Then we compile the calling C file:

```
clang -c main.c
```

Next, we link them together:

```clang -o final main.o ex.o```

Finally, we can run the executable:

```./final```
