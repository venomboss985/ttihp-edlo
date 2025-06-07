# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


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

    dut.ui_in.value = 0b0000
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b0000

@cocotb.test()
async def mem_save(dut):
    await start_and_reset(dut, 5)

    dut._log.info("Testing memory save")

    for addr in range(4):
        dut._log.info(f"Addr: mem{addr}")
        for data in range(4):
            await reset(dut, 1)
            dut._log.info(f"Data: {bin(data)}")
            dut.ui_in.value = (addr << 2) | data
            await ClockCycles(dut.clk, 2)
            assert dut.uo_out.value == (data << addr*2)

@cocotb.test()
async def mem_fill(dut):
    await start_and_reset(dut, 5)

    dut._log.info("Testing memory fill")
    for addr in range(4):
        dut._log.info(f"Setting mem{addr}")
        dut.ui_in.value = (addr << 2) | 0b11
        await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b11111111

    for addr in range(4):
        dut._log.info(f"Resetting mem{addr}")
        dut.ui_in.value = (addr << 2) | 0b00
        await ClockCycles(dut.clk, 1)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0b00000000
