# Crackme

### A simple serial-validation program written in x86 Assembly
This program has a passkey encrypted with the rot13 cipher. Upon start, the passkey is decrypted and continually checked against user input. Program will output to stdout whether the serial key was correct.

## Requirements
  * Intel x86 architecture
  * [NASM](https://en.wikipedia.org/wiki/Netwide_Assembler)
  * [ld](https://linux.die.net/man/8/ld-linux)

## Installation & Build
1. clone this repo:
```
git clone https://github.com/michaelmoreno/asm-crackme.git
```
3. Assemble code and produce executable.
```
nasm -f elf64 crackme.asm && ld -o crackme crackme.o
```
4. Execute binary
```
./crackme
```