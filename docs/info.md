<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This design has 16 inputs and 8 outputs

* `ui_in` is an 8-bit unsigned integer input
* `uio_in` is an 8-bit input, but certain bits have different functionality
    * The 4 least significant bits is an address input
    * The 4 most significant bits is an instruction input
* `uo_out` is an 8-bit unsigned integer output

The instructions available to you are as follows:

| Hex Input | Instruction | Address | Cycles | Function                      |
|-----------|-------------|---------|--------|-------------------------------|
| 0x0       | NOP         | N/A     | 1      | No operation                  |
| 0x1       | STR         | Any     | 1      | Stores input into memory      |
| 0x2       | LDR         | Any     | 2      | Loads output from memory      |
| 0x3       | LDA         | N/A     | 2      | Loads input into A_REG        |
| 0x4       | LDB         | N/A     | 2      | Loads input into B_REG        |
| 0x5       | LDAR        | Any     | 1      | Loads memory into A_REG       |
| 0x6       | LDBR        | Any     | 1      | Loads memory into B_REG       |
| 0x7       | ADD         | N/A     | 2      | Adds A and B registers        |
| 0x8       | SUB         | N/A     | 2      | Subtracts A and B registers   |
| 0x9       | STRN        | Any     | 1      | Stores ALU return into memory |
| 0xA       | LDRN        | N/A     | 2      | Loads output from ALU return  |

## How to test

You can adapt any of the actual tests from the [CocoTB tests](../test/test.py) that were written for this project into actual hardware via a microcontroller. It'll take a bit of time since there isn't a library made to interface with this, but maybe in the future, I could make one.

## External hardware

There really is no intended use of external hardware, but you can interface with this using a microcontroller, single board computer with GPIO pins, FPGA, or any other logic that has the appropriate IO pins to use it.
