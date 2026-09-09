# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1

    dut._log.info("Test 4-bit ALU")

    # ---------------------------------
    # ADD: 5 + 3 = 8
    # ---------------------------------
    # ui_in[3:0] = A = 5
    # ui_in[7:4] = B = 3
    dut.ui_in.value = (3 << 4) | 5

    # ALU_FUN = 0000
    dut.uio_in.value = 0b0000

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 8

    # ---------------------------------
    # SUB: 7 - 2 = 5
    # ---------------------------------
    dut.ui_in.value = (2 << 4) | 7
    dut.uio_in.value = 0b0001

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 5

    # ---------------------------------
    # MUL: 3 * 4 = 12
    # ---------------------------------
    dut.ui_in.value = (4 << 4) | 3
    dut.uio_in.value = 0b0010

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 12

    # ---------------------------------
    # DIV: 8 / 2 = 4
    # ---------------------------------
    dut.ui_in.value = (2 << 4) | 8
    dut.uio_in.value = 0b0011

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 4

    # ---------------------------------
    # AND: 12 AND 10 = 8
    # ---------------------------------
    dut.ui_in.value = (10 << 4) | 12
    dut.uio_in.value = 0b0100

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 8

    # ---------------------------------
    # OR: 12 OR 3 = 15
    # ---------------------------------
    dut.ui_in.value = (3 << 4) | 12
    dut.uio_in.value = 0b0101

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 15

    # ---------------------------------
    # NAND
    # 1100 NAND 1010 = 0111
    # ---------------------------------
    dut.ui_in.value = (10 << 4) | 12
    dut.uio_in.value = 0b0110

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 7

    # ---------------------------------
    # NOR
    # 1100 NOR 0011 = 0000
    # ---------------------------------
    dut.ui_in.value = (3 << 4) | 12
    dut.uio_in.value = 0b0111

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 0

    # ---------------------------------
    # XOR
    # 1100 XOR 1010 = 0110
    # ---------------------------------
    dut.ui_in.value = (10 << 4) | 12
    dut.uio_in.value = 0b1000

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 6

    # ---------------------------------
    # XNOR
    # 1100 XNOR 1010 = 1001
    # ---------------------------------
    dut.ui_in.value = (10 << 4) | 12
    dut.uio_in.value = 0b1001

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 9

    # ---------------------------------
    # A == B
    # ---------------------------------
    dut.ui_in.value = (5 << 4) | 5
    dut.uio_in.value = 0b1010

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 1

    # ---------------------------------
    # A > B
    # ---------------------------------
    dut.ui_in.value = (3 << 4) | 7
    dut.uio_in.value = 0b1011

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 2

    # ---------------------------------
    # A < B
    # ---------------------------------
    dut.ui_in.value = (7 << 4) | 3
    dut.uio_in.value = 0b1100

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 3

    # ---------------------------------
    # SHIFT RIGHT
    # 8 >> 1 = 4
    # ---------------------------------
    dut.ui_in.value = 8
    dut.uio_in.value = 0b1101

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 4

    # ---------------------------------
    # SHIFT LEFT
    # 3 << 1 = 6
    # ---------------------------------
    dut.ui_in.value = 3
    dut.uio_in.value = 0b1110

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value.integer == 6

    dut._log.info("All 4-bit ALU tests passed")
