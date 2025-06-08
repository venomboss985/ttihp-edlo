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

## MVP
- [ ] Target specs
    - 8-bit data IO
    - >8 bytes addressable RAM
    - 4KHz input clock
- [ ] Recursive instructions
- [ ] Automatic A/B registering
- [ ] Good docs

## PRIORITY
- [x] Create modular addresable memory
    - [x] Make parametric
    - [x] Up to 4-bit address input
    - [x] 8-bit data input
    - [x] Account for clock cycle delays
- [ ] Update tests for pulsed `we`?

## BACKLOG
- [ ] ALU
    - [ ] 4-bit instruction input
    - [ ] A, B, and Return registers
    - [ ] Load/store A/B instruction
    - [ ] Load/store Return instruction
    - [ ] Addition instruction (consider carry/overflow bit)
    - [ ] Subtraction instruction (consider carry/overflow bit)

## OPTIONAL
- [ ] Works at higher clock speeds (aim for 1MHz)
- [ ] Selected address always output on `uo_out` pins
- [ ] Works on FPGA

### Ideas
- [ ] Signed/unsigned instruction flag
- [ ] Done flag


## RETIRED

## REVISIT