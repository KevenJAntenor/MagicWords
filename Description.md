# Magic Words Puzzle Solver and Generator

## Project Description
This project involves a Prolog-based solver and generator for the "Magic Words" combinatorial puzzle. It manipulates sequences of integers to explore their combinatorial properties.

## Core Functionalities
- **Solver**: Tackles instances of the "Magic Words" puzzle using Prolog's pattern matching and logical inference.
- **Generator**: Creates new puzzle instances, leveraging Prolog's logic programming.

## Key Concepts
- **Words**: Sequences of strictly positive integers manipulated in the puzzle.
- **Combinatorial Logic**: Utilizes Prolog's capabilities in handling complex combinatorial logic, focusing on prefixes, factors, and other aspects.

## Technical Implementation
- **MagicWords.pl**: Main file containing the logic for solving and generating puzzles.
- **Tests.pl**: Suite of tests ensuring the correctness of the logic.

## Example Usage
Given a set of rewrite rules `R` and a word `w`, the goal is to determine if `w` is `R`-magic. A word is `R`-magic if it can be transformed into the empty word through a series of rewrites based on `R`.

For example, consider the rewrite rule `r = (12, 212)`. We have:

- `312312` rewrites to `3212312` under `r`, as `312312 ⇒_r 3212312`.
- Similarly, `312312` transforms to `3123212` under the same rule.

The program will provide functionality to apply such rules and check if a given word is `R`-magic.

## Using the Program
- Load `MagicWords.pl` in SWI-Prolog.
- Use provided predicates to apply rewrite rules and test for `R`-magic conditions.
