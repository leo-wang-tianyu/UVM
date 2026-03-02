# 12-bit SPI Master (SystemVerilog, Non-UVM)

Simple 12-bit SPI master with a class-based, self-checking testbench.

EDA Playground: https://www.edaplayground.com/x/dcjk

## Features

- 12-bit transmission
- LSB-first shift on MOSI
- Internal SPI clock generation
- Active-low chip select (`cs`)
- Mailbox/event-based verification environment

## Testbench Components

- transaction
- generator
- driver
- monitor
- scoreboard
- environment

## Note

See the parent folder for SPI Slave and full Master-Slave integration.
