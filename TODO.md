# TODO

### Notes
* Memory module
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
- [x] Target specs
    - 8-bit data IO
    - \>=8 bytes addressable RAM
    - 4KHz input clock
    - Can perform basic addition and subtraction
    - Data can be stored and retrieved from memory
- [ ] Good enough docs
    - Describe project
    - Usage docs (in `docs/` folder)
    - Block diagram of circuit

## PRIORITY
- [ ] Tests
    - [ ] Store addition into RAM
    - [ ] Subtract 2 numbers from RAM
    - [ ] Store 4 numbers into RAM, add them both together, store the subtracted 2 new values, and load the last value from RAM
    - [ ] Gate level testing?
- [ ] Clock speed in `config.json` significance? (likely just for documentation)
- [ ] Research submission details
- [x] Update README
- [ ] Update `docs/info.md` page

## BACKLOG
- [x] ~~Research program counter~~
- [x] ~~Research OP flags~~
- [ ] Additional instructions?
    - Multiply?
    - Divide?
    - LSH/RSH for A/B registers? (maybe even return register?)
- [x] Project cleanup
    - [x] Fix whitespace and tabspace
    - [x] Fix comments
    - [x] Use `define` statements
    - [x] Use "definitions" header file

## VIDEOS
- [ ] Introduction: What is Tiny Tapeout?
    * What are ASICs and what can they do?
    * What is TT and what is the shuttle program?
    * Who is "printing" the chips?
- [ ] Environment setup
    * Prerequisite knowledge?
    * Software to install
    * Dev container setup (for local hardening)
- [ ] Simple Verilog tutorial
    * Creating the Polygate :tm:
    * Common pitfalls and errors

## OPTIONAL
- [ ] Works on FPGA
- [ ] Build a compiler and assembly language?

## RETIRED
- Recursive instructions

## REVISIT
- Memory cells
