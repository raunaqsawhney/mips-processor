# mips-processor
5 Cycle-accurate Implementation of a pipelined MIPS processor

This is a term project for my Computer Architecture course, wherein, the task is to design a 5-Cycle pipelined MIPS ISA processor.
The design is primarily done in Verilog HDL, and includes the 5 stages of the pipeline (Fetch, Decode, Execute, Memory, and Writeback), along with the register file as seperate entities.

These entities are included as modules into the pipeline entity, which acts as the driver for the CPU.
