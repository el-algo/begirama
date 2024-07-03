# Begirama
Begirama is a custom compiled and Stack-oriented programming language. The syntax resembles that of [Firth](https://github.com/bigskysoftware/littlemanstackmachine.org) and Lua. The compiler was made with *Flex* as the lexer and *Bison* as the parser.

## Features
* Simple and coherent grammar.
* One word instructions.
* Indentation flexibility.
* Admits one data type (integers).
* Fast One-pass Compiler.

## Installation
### Linux
Works on x86-64 Ubuntu. Bison, Flex, GCC, NASM and ld required for building.

#### Clone
```bash
git clone https://github.com/el-algo/begirama.git
```

#### Build
```bash
make lang
```

#### Compiling .beg source files
```bash
make comp <Begirama file path>
```

#### Running compiled programs
```bash
./<program_name>.beg.bin
```

## Example
```
main
    0 10 33 100 108 114 111 119 32 44 111 108 108 101 72
    do
        if_zero
            break
        else
            say
            pop
        end
    loop
end_program
```
More examples available in the example folder.
