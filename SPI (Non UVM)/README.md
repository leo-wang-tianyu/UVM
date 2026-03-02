# SPI (Non-UVM) — SystemVerilog

This folder contains a simple SPI implementation and class-based (non-UVM) verification environment.

EDA Playground: https://www.edaplayground.com/x/tG9c

## Contents

- **SPI Master** – 12-bit SPI transmitter (LSB-first)
- **SPI Slave** – 12-bit SPI receiver
- **Top module** – connects master → slave
- **Testbench** – transaction, generator, driver, monitor, scoreboard using mailboxes and events

## Features

- Self-checking testbench
- Randomized stimulus
- SPI clock generated internally by master
- Active-low chip select (`cs`)
- Transfer completion signaled with `done`

## Purpose

This project demonstrates structured SystemVerilog verification, focusing on clean testbench architecture and DUT integration.
