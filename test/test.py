# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer


async def run_test(dut, a, b, alu_fun, expected):
    # ui_in[3:0] = A
    # ui_in[7:4] = B
    dut.ui_in.value = ((b & 0xF) << 4) | (a & 0xF)

    # uio_in[3:0] = ALU_FUN
    dut.uio_in.value = alu_fun

    # Wait for registered output
    await ClockCycles(dut.clk, 1)
    await Timer(1, unit="ns")

    result = int(dut.uo_out.value)

    dut._log.info(
        f"A={a}, B={b}, ALU_FUN={alu_fun:04b}, "
        f"OUT={result}, EXPECTED={expected}"
    )

    assert result == expected


@cocotb.test()
async def test_project(dut):

    dut._log.info("Start")

    # 100 KHz clock
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Initial values
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    dut._log.info("Reset")

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1

    await Timer(1, unit="ns")

    dut._log.info("Test 4-bit ALU")

    # Arithmetic
    await run_test(dut, 5, 3, 0b0000, 8)   # ADD
    await run_test(dut, 7, 2, 0b0001, 5)   # SUB
    await run_test(dut, 3, 4, 0b0010, 12)  # MUL
    await run_test(dut, 8, 2, 0b0011, 4)   # DIV

    # Logic
    await run_test(dut, 12, 10, 0b0100, 8)   # AND
    await run_test(dut, 12, 3,  0b0101, 15)  # OR
    await run_test(dut, 12, 10, 0b0110, 7)   # NAND
    await run_test(dut, 12, 3,  0b0111, 0)   # NOR
    await run_test(dut, 12, 10, 0b1000, 6)   # XOR
    await run_test(dut, 12, 10, 0b1001, 9)   # XNOR

    # Compare
    await run_test(dut, 5, 5, 0b1010, 1)  # A == B
    await run_test(dut, 7, 3, 0b1011, 2)  # A > B
    await run_test(dut, 3, 7, 0b1100, 3)  # A < B

    # Shift
    await run_test(dut, 8, 0, 0b1101, 4)  # Shift right
    await run_test(dut, 3, 0, 0b1110, 6)  # Shift left

    dut._log.info("ALL 4-BIT ALU TESTS PASSED")
