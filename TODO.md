# TODO

### Notes
* Memory module
    * Current memory module failed during leakage test, but due to needing clock signal, was rather space efficient
    * Tested area use with different configurations (@16B)
        * `always @(posedge clock) if (we)`: Keeps current function, but very inefficient
        * `always @(posedge we)`: Changed `we` to pulsed signal and very inefficient
        * `always @(we)`: Changed `we` to active high, a little less efficient from baseline
        * `always @(posedge clock && we)`: Build failed /shrug
    * Options are to either
        * Change the behaviour of the `we` pin to a pulse to get more space
        * Leave as currently configured to fix leakage test results and keep normal behaviour, but not a lot of room left for compute
        * Create a buffer for the memory to attempt to keep normal behaviour
    * Maybe have `busy` flag and an `output_enable` bit to try the data bus idea again
    * Might need a memory controller after all... :(
* ALU
    * MAYBE need to separate the registers from the logic to make architecting easier to manage
    * Carry flag?
    * Overflow flag?

## MVP
- [ ] Target specs
    - 8-bit data IO
    - >8 bytes addressable RAM
    - 4KHz input clock
- [ ] Recursive instructions?
- [ ] Good docs

## PRIORITY
- [x] ALU
    - [x] Working `ADD` instruction
    - [x] Working `SUB` instruction
    - [x] Store return buffer into RAM from input address instruction (after operation clock cycles)

## BACKLOG
- [x] ALU
    - [x] Store RTN instruction
- [ ] Tests
    - [ ] Store addition into RAM
    - [ ] Subtract 2 numbers from RAM
    - [ ] Store 4 numbers into RAM, add them both together, store the subtracted 2 new values, and load the last value from RAM

## OPTIONAL
- [ ] Works at higher clock speeds (aim for 1MHz)
- [ ] Selected address always output on `uo_out` pins
- [ ] Works on FPGA
- [ ] Update tests for pulsed `we`?

### Ideas
- [ ] Signed/unsigned instruction flag
- [ ] Done flag


## RETIRED

## REVISIT