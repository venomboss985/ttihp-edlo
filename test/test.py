# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import random

ADDR_BITS = 4
MEMORY_CELLS = 2**ADDR_BITS

STR_CYCLES = 1
LDR_CYCLES = 2
LDAB_CYCLES = 2
ADD_CYCLES = 2
SUB_CYCLES = 2
LDRN_CYCLES = 2
STRN_CYCLES = 1

NOP  = 0x0 # No operation
STR  = 0x1 # Store in register (RAM)
LDR  = 0x2 # Load from register (RAM)
LDA  = 0x3 # Load into A reg (input data)
LDB  = 0x4 # Load into B reg (input data)
LDAR = 0x5 # Load into A reg (RAM)
LDBR = 0x6 # Load into B reg (RAM)
ADD  = 0x7 # Add A and B registers
SUB  = 0x8 # Subtract A and B registers
STRN = 0x9 # Store return into register (RAM)
LDRN = 0xA # Load return from register (output data)

async def start_and_reset(dut, rst_cycles: int = 10):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    await reset(dut, rst_cycles, True)

async def reset(dut, rst_cycles: int = 10, verbose: bool = False):
    # Reset
    if verbose: dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, rst_cycles)
    dut.rst_n.value = 1

@cocotb.test()
async def mem_rst(dut):
    await start_and_reset(dut)

    dut._log.info("Testing reset memory")

    dut.uio_in.value = 0x00
    dut.ui_in.value = 0x00
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 'xxxxxxxx'

@cocotb.test()
async def mem_save(dut):
    await start_and_reset(dut, 5)

    dut._log.info("Testing memory save")

    for addr in range(MEMORY_CELLS):
        dut._log.info(f"Addr: mem{addr}")
        for data in range(0xFF):
            await reset(dut, 1)

            # Load data in memory
            # dut._log.info(f"Data: {bin(data)}")
            dut.uio_in.value = (STR << ADDR_BITS) | addr
            dut.ui_in.value = data
            await ClockCycles(dut.clk, STR_CYCLES)

            # Get data out from memory
            dut.uio_in.value = (LDR << ADDR_BITS) | addr
            await ClockCycles(dut.clk, LDR_CYCLES)
            assert dut.uo_out.value == data

@cocotb.test()
async def mem_fill(dut):
    await start_and_reset(dut, 5)

    for addr in range(MEMORY_CELLS):
        # Fill memory cells
        dut._log.info(f"Testing mem{addr} fill")

        dut._log.info(f"Setting mem{addr}")
        dut.uio_in.value = (STR << ADDR_BITS) | addr
        dut.ui_in.value = 0xFF
        await ClockCycles(dut.clk, STR_CYCLES)
    
        dut._log.info(f"Reading mem{addr}")
        dut.ui_in.value = 0x00
        dut.uio_in.value = (LDR << ADDR_BITS) | addr
        await ClockCycles(dut.clk, LDR_CYCLES)
        assert dut.uo_out.value == 0xFF

        # Empty memory cells
        dut._log.info(f"Testing mem{addr} empty")
        
        dut._log.info(f"Resetting mem{addr}")
        dut.uio_in.value = (STR << ADDR_BITS) | addr
        dut.ui_in.value = 0x00
        await ClockCycles(dut.clk, STR_CYCLES)
    
        dut._log.info(f"Reading mem{addr}")
        dut.ui_in.value = 0x00
        dut.uio_in.value = (LDR << ADDR_BITS) | addr
        await ClockCycles(dut.clk, LDR_CYCLES)
        assert dut.uo_out.value == 0x00

@cocotb.test()
async def data_leakage(dut):
    await start_and_reset(dut, 5)

    data = [random.randint(0, 255) for _ in range(MEMORY_CELLS)]

    dut._log.info(f"Filling memory with random values")
    for addr in range(MEMORY_CELLS):
        # Fill memory cells
        dut._log.info(f"Setting mem{addr} to 0x{data[addr]:02x}")
        dut.uio_in.value = (STR << ADDR_BITS) | addr
        dut.ui_in.value = data[addr]
        await ClockCycles(dut.clk, STR_CYCLES)
    
    for addr in range(MEMORY_CELLS):
        dut._log.info(f"Reading mem{addr}")
    
        dut.ui_in.value = 0x00
        dut.uio_in.value = (LDR << ADDR_BITS) | addr
        await ClockCycles(dut.clk, LDR_CYCLES)
        assert dut.uo_out.value == data[addr]

@cocotb.test()
async def alu_add(dut):
    await start_and_reset(dut, 5)

    dut._log.info(f"Adding 2 numbers")

    # Inputs and expected output
    a_reg = 12
    b_reg = 50
    result = a_reg + b_reg

    # Load number into A register
    dut._log.info(f"Loading {a_reg} into A register")
    dut.ui_in.value = a_reg
    dut.uio_in.value = (LDA << 4)
    await ClockCycles(dut.clk, LDAB_CYCLES)

    # Load number into B register
    dut._log.info(f"Loading {b_reg} into B register")
    dut.ui_in.value = b_reg
    dut.uio_in.value = (LDB << 4)
    await ClockCycles(dut.clk, LDAB_CYCLES)

    # Add A and B registers
    dut._log.info(f"Adding registers")
    dut.ui_in.value = 0x00
    dut.uio_in.value = (ADD << 4)
    await ClockCycles(dut.clk, ADD_CYCLES)

    # Load RTN register
    dut._log.info(f"Loading RTN register")
    dut.uio_in.value = (LDRN << 4)
    await ClockCycles(dut.clk, LDRN_CYCLES)

    # Check output
    dut._log.info(f"Checking output")
    assert dut.uo_out.value == result

@cocotb.test()
async def alu_sub(dut):
    await start_and_reset(dut, 5)

    dut._log.info(f"Subtracting 2 numbers")

    # Inputs and expected outputs
    a_reg = 220
    b_reg = 86
    result = a_reg - b_reg

    # Load number into A register
    dut._log.info(f"Loading {a_reg} into A register")
    dut.ui_in.value = a_reg
    dut.uio_in.value = (LDA << 4)
    await ClockCycles(dut.clk, LDAB_CYCLES)

    # Load number into B register
    dut._log.info(f"Loading {b_reg} into B register")
    dut.ui_in.value = b_reg
    dut.uio_in.value = (LDB << 4)
    await ClockCycles(dut.clk, LDAB_CYCLES)

    # Subtract A and B registers
    dut._log.info(f"Subtracting registers")
    dut.ui_in.value = 0x00
    dut.uio_in.value = (SUB << 4)
    await ClockCycles(dut.clk, SUB_CYCLES)

    # Load RTN register
    dut._log.info(f"Loading RTN register")
    dut.uio_in.value = (LDRN << 4)
    await ClockCycles(dut.clk, LDRN_CYCLES)

    # Check output
    dut._log.info(f"Checking output")
    assert dut.uo_out.value == result

@cocotb.test()
async def alu_strn(dut):
    await start_and_reset(dut, 5)

    dut._log.info(f"Adding 2 numbers")

    # Inputs and expected outputs
    addr = random.randint(0, 15)
    a_reg = 64
    b_reg = 89
    result = a_reg + b_reg

    # Load number into A register
    dut._log.info(f"Loading {a_reg} into A register")
    dut.ui_in.value = a_reg
    dut.uio_in.value = (LDA << 4)
    await ClockCycles(dut.clk, LDAB_CYCLES)

    # Load number into B register
    dut._log.info(f"Loading {b_reg} into B register")
    dut.ui_in.value = b_reg
    dut.uio_in.value = (LDB << 4)
    await ClockCycles(dut.clk, LDAB_CYCLES)

    # Subtract A and B registers
    dut._log.info(f"Adding registers")
    dut.ui_in.value = 0x00
    dut.uio_in.value = (ADD << 4)
    await ClockCycles(dut.clk, SUB_CYCLES)

    # Store RTN register into RAM
    dut._log.info(f"Storing result into RAM")
    dut.uio_in.value = (STRN << 4) | addr
    await ClockCycles(dut.clk, STRN_CYCLES)

    # Check RAM
    dut._log.info(f"Loading RAM")
    dut.uio_in.value = (LDR << 4) | addr
    await ClockCycles(dut.clk, LDR_CYCLES)
    assert dut.uo_out.value == result
