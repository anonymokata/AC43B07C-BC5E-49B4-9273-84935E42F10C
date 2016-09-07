# Roman Numeral Calculator
The provided addition and subtraction functions are called

    add_roman_numerals(A, B)

and

    subtract_roman_numerals(A, B)

where `A` and `B` are C-strings representing Roman numerals. The output of each
function is a dynamically allocated string representing the sum/difference of
the inputs as a Roman numeral.

## Terminology
Throughout the code I use standard terminology about Roman numerals, such as
"subtractive" and "additive" representations of these numbers. All of the
concepts are discussed on
[Wikipedia](https://en.wikipedia.org/wiki/Roman_numerals#Roman_numeric_system).

# Instructions/Make Targets
All make commands should be executed in the project's root directory.

  * `all` (default):
    Compiles `src/roman_calculator.c` into an archive and shared object file in
    the `build` subdirectory (`build/libroman_calculator.a` and
    `build/libroman_calculator.so`, respectively).
  * `check`:
    Compiles and runs through the [Check](https://libcheck.github.io/check/)
    unit tests found in `tests/check_roman_calculator.c`.
  * `dev`:
    Runs the `all` recipe followed by `check`.
  * `install`:
    Compiles and installs the calculator library in a library directory of your
    choosing (specified by setting the `PREFIX` environment variable) or
    `/usr/local/lib` by default. This exists to cover the unlikely event you
    have a need to frequently link this library into other projects.

## Tested Environments
  * Written on a PC running Linux Mint 17.3 Rosa.
  * Tested on a fresh virtual machine install of Ubuntu 14.04 with
    `git`, `build-essentials`, `pkg-config`, and `check` packages installed.

# Implementation Notes
  * The instructions for this C kata say that

    > As we are in Rome there is no such thing as decimals or int, we need to do
    > this with [...] strings.

    Bearing in mind that we are working in C (where there is a very blurred line
    between pointers and integers), I interpreted the spirit of this constraint
    as

    > Don't explicitly write down any Arabic numerals (0, 1, 2, etc.), and
    > prefer using strings for "significant" calculations.

    For fun, I followed this directive mostly to the letter when implementing
    `add_roman_numerals`, preferring when necessary to use enums and pointer
    arithmetic to avoid explicitly writing down any integers. The only
    exceptions to this are as follows:
      * The occasional 0 or 1 that appears, for instance, when iterating
        (like `for(i = 0; ...)`) or allocating memory involving string lengths
        (like `strlen(string) + 1`). I considered defining an enum like
        `enum Small_Number { NULLA, UNUS }` to get around this (while still
        really sticking with the Roman theme) or by using more pointer
        arithmetic, but both of these solutions would be at the cost of a
        significant loss of clarity. So I decided to avoid them.
      * A pair of constants defined at the beginning of `roman_calculator.c`
        called `MAX_NUMERAL_LENGTH` and `MAX_SUBST_SIZE_DIFF`. The former is
        used to (*very generously*) cap the input size of strings allowed as
        input, and the latter is used when determining how much memory to
        allocate for various result strings. Both could be removed without much
        difficulty, but I've left them in for convenience/the sake of
        readability.
    As a consequence, the algorithm breaks down into string concatenation and a
    few calls to dictionary lookup/substring replacement functions.

    Having said all that, I was aware while writing up my solution to
    `add_roman_numerals` that the intent behind the above instruction might have
    just been to say
    > Don't calculate A +/- B by converting A and B to decimal, performing +/-
    > on the resulting `int`s, and converting back. Finish the kata as if you
    > didn't know place-value number systems existed.
    I implemented `subtract_roman_numerals` while following this weaker rule
    (apart from helper functions that I'd already defined).
  * The definition of Roman numerals in the instructions is not restrictive
    enough to make it so that there is a unique representation of each number as
    a Roman numeral. For example, both "CMXCIX" and "IM" can be used to
    represent 999 based on the rules described in the kata. My addition and
    subtraction functions reflect this, in that they will always output a Roman
    numeral meeting all of the rules from the instructions, but there is no
    guarantee it will be (and, most likely, is *not*) the *shortest* possible
    representation.
  * As I wrote this code as my solution to a kata, I focused primarily on the
    main algorithm itself and not, for example, validating user input. As a
    consequence, unexpected behavior can probably occur given the right
    malformed input to `add_` and `subtract_roman_numerals`. On the other hand,
    while the *output* of the calculator will follow all of the rules for being
    a valid Roman numeral presented in the prompt, the calculator is quite
    flexible in terms of its input; I've intentionally designed it so that
    *unambiguous* Roman numerals can be used as input regardless of how they are
    written. So, for instance, the calculator is perfectly happy to accept
    `"IIIIIIIII"` instead of `"IX"`, but it is not designed to attempt to handle
    an ambiguous numeral such as `"IVX"`, which could be used to denote either
    6 = 10 - (5 - 1) or 4 = (10 - 5) - 1.
  * Zero and the negative numbers were unknown concepts for the Romans, so when
    calling `subtract_roman_numerals(A, B)` and error is thrown (and `NULL` is
    returned) if `A` is less than or equal to `B`.
  * The code meets the C99 standard and likely ANSI C standard if C++ style `//`
    comments are replaced with `/* ... */` blocks.
