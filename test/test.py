# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

READ_MODE = 0b0
WRITE_MODE = 0b1
MEMORY_CELLS = 4

async def start_and_reset(dut, rst_cycles: int = 10):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    await reset(dut, rst_cycles)

async def reset(dut, rst_cycles: int = 10):
    # Reset
    dut._log.info("Reset")
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

    dut.uio_in.value = 0b000
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b00000000

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
            dut.uio_in.value = (WRITE_MODE << 2) | addr
            dut.ui_in.value = data
            await ClockCycles(dut.clk, 2)

            # Get data out from memory
            dut.uio_in.value = (READ_MODE << 2) | addr
            await ClockCycles(dut.clk, 2)
            assert dut.uo_out.value == data

@cocotb.test()
async def mem_fill(dut):
    await start_and_reset(dut, 5)

    for addr in range(MEMORY_CELLS):
        # Fill memory cells
        dut._log.info(f"Testing mem{addr} fill")

        dut._log.info(f"Setting mem{addr}")
        dut.uio_in.value = (WRITE_MODE << 2) | addr
        dut.ui_in.value = 0xFF
        await ClockCycles(dut.clk, 1)
    
        dut._log.info(f"Reading mem{addr}")
        dut.ui_in.value = 0x00
        dut.uio_in.value = (READ_MODE << 2) | addr
        await ClockCycles(dut.clk, 2)
        assert dut.uo_out.value == 0xFF

        # Empty memory cells
        dut._log.info(f"Testing mem{addr} empty")
        
        dut._log.info(f"Resetting mem{addr}")
        dut.uio_in.value = (WRITE_MODE << 2) | addr
        dut.ui_in.value = 0x00
        await ClockCycles(dut.clk, 1)
    
        dut._log.info(f"Reading mem{addr}")
        dut.ui_in.value = 0x00
        dut.uio_in.value = (READ_MODE << 2) | addr
        await ClockCycles(dut.clk, 2)
        assert dut.uo_out.value == 0x00
