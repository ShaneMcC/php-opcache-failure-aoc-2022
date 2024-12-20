# PHP Opcache Failure

** This appears to be fixed in 8.4 **

The included `run.php` is based on an implementation of [Advent of Code 2022 day 14](https://adventofcode.com/2022/day/14) from [shanemcc/aoc-2022](https://github.com/shanemcc/aoc-2022) that appears to trigger opcache bugs in php 8.0, 8.1, 8.2 and 8.3 when using in-memory opcache.

To try and reduce the scope of the problem, the input parsing has been removed, and replaced with a static 2D `$map[$y][$x]` (in `input.php`).
Spaces that are occupied by rock are set as '#', spaces that are air are not set.

## Bug #1: JIT setting failure. (run.php)

Line 21: `$loc = [$x, $y + 1];` appears to result in an array with a `null` second value.

If  we change line 22 to: `if ($loc[1] == null) { $loc = [$x, $y + 1]; }` then this second time it sets correctly.

## Bug #2: JIT comparison failure. (run2.php)

If we modify the algorithm slightly (to include some floor-checks related to the part 2 of the puzzle, but not really relevant here other than changing the comparisons) then the trigger point moves.

Line 19: `if (!isset($map[$y + 1][$x]) && (($y + 1) != $floor)) {` does not match.
Line 23: `} else if (!isset($map[$y + 1][$x]) && (($y + 1) != $floor)) {` (the same comparison) does match.

If the `die()` on Line 24 is commented out then everything continues to work as expected (except we occasionally end up in this branch rather than the one above.). We do not trigger the 'Setting failure' within this branch.

(In the longer-form version of this we end up in this branch a lot more often.)

If we replace line 7 with `$floor = max(array_keys($map)) + 2;` then we go back to only triggering Bug #1

## Demonstration

Run `./run.sh 8.3`:

This will do a one-time build of a docker image based on `php:8.3-cli` with the `opcache` extension enabled, and then print:
```
Running with PHP version: 8.3
run.php No Jit: Part 1: 284
run.php Jit: JIT setting failure.
run2.php No Jit: Part 1: 284
run2.php Jit: JIT comparison failure.

php version: PHP 8.3.14 (cli) (built: Dec  3 2024 02:22:41) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.3.14, Copyright (c) Zend Technologies
    with Zend OPcache v8.3.14, Copyright (c), by Zend Technologies
```

Run `./run.sh 8.4`:

This will do a one-time build of a docker image based on `php:8.4-cli` with the `opcache` extension enabled, and then print:
```
Running with PHP version: 8.4
run.php No Jit: Part 1: 284
run.php Jit: Part 1: 284
run2.php No Jit: Part 1: 284
run2.php Jit: Part 1: 284

php version: PHP 8.4.1 (cli) (built: Dec  3 2024 02:20:46) (NTS)
Copyright (c) The PHP Group
Built by https://github.com/docker-library/php
Zend Engine v4.4.1, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.1, Copyright (c), by Zend Technologies
```
