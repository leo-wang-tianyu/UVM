# 12-bit SPI Master (SystemVerilog)

Simple SPI master written in SystemVerilog in edaplayground with a class-based testbench.

https://www.edaplayground.com/x/dcjk


## Files

- SPI master RTL and interface
- Testbench with generator, driver, monitor, and scoreboard

## Features

- 12-bit SPI transmission
- LSB-first shift on `mosi`
- Internal clock divider (`sclk = clk/20`)
- Active-low chip select (`cs`)
- Self-checking testbench using mailboxes and events
- Randomized stimulus with automatic checking

