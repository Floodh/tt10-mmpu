# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")



    #   tests   

    #   send input
    #   row 0
    dut.ui_in.value = 2     #   mat3x3_0
    dut.uio_in.value = 3    #   mat3x3_1
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 7
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 3
    dut.uio_in.value = 1
    await ClockCycles(dut.clk, 1)
    #   row 1
    dut.ui_in.value = 1
    dut.uio_in.value = 2
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 5
    dut.uio_in.value = 1
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 8
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 1)
    #   row 2
    dut.ui_in.value = 0
    dut.uio_in.value = 1
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 4 #
    dut.uio_in.value = 2
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 1
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 1)

    #   read outputs
    #   row 0
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 23
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 13
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 14
    #   row 1
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 21
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 21
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 33
    #   row 2
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 9
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 6
    await ClockCycles(dut.clk, 1)
    #assert dut.uo_out.value == 4
    await ClockCycles(dut.clk, 10)
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    #assert dut.uo_out.value == 50
    #assert dut.uo_out.value == 255

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.

    #   
    #       2,  7,  3               3,  0,  1               23, 13, 14
    #   (   1,  5,  8   )   *   (   2,  1,  0   )   =   (   21, 21, 33  )
    #       0,  4,  1               1,  2,  4                9,  6,  4
    #
