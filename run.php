#!/usr/bin/php
<?php
	require_once(__DIR__ . '/input.php');
	$source = [545, 94];

	function addSand($map, $source) {

		$count = 0;
		$previousLoc = [];
		while (true) {
			$loc = empty($previousLoc) ? $source : array_pop($previousLoc);
			while (true) {
				[$x, $y] = $loc;
				$startLoc = $loc;

				if ($y > max(array_keys($map))) { break 2; } // We've overflowed.
				if (isset($map[$y][$x])) { break 2; } // Space is already Sand

				if (!isset($map[$y + 1][$x])) {
					$previousLoc[] = $loc;
					$loc = [$x, $y + 1];
					if ($loc[1] == null) { die('JIT setting failure.'."\n"); }
				} else if (!isset($map[$y + 1][$x])) {
					die('JIT comparison failure.'."\n");
					$previousLoc[] = $loc;
					$loc = [$x, $y + 1];
					if ($loc[1] == null) { die('JIT setting failure.'."\n"); }
				} else if (!isset($map[$y + 1][$x - 1])) {
					$previousLoc[] = $loc;
					$loc = [$x - 1, $y + 1];
				} else if (!isset($map[$y + 1][$x + 1])) {
					$previousLoc[] = $loc;
					$loc = [$x + 1, $y + 1];
				} else {
					$map[$y][$x] = 'o';
					$count++;
					break;
				}
			}
		}
		return $count;
	}

	$part1 = addSand($map, $source);
	echo 'Part 1: ', $part1, "\n";
