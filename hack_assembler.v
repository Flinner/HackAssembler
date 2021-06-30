module main

import os
import term

type AString = []string

type DeferredFn = fn (mut AString, int, AInstruction, mut Symbols)

struct Deferred {
mut:
	i           int
	instruction AInstruction
	symbols     Symbols
	asm_lines   AString
}

fn main() {
	term.erase_clear() // tmp
	settings := handle_args()

	lines := os.read_lines(settings.filename) or { panic("can't read file") }
	mut asm_lines := []string{len: lines.len}

	defer_hack(mut asm_lines, lines)

	println('asm_lines ${asm_lines.join('\n')}')
}

fn defer_hack(mut asm_lines []string, lines []string) {
	mut symbols := init_symbols()
	mut i := 0

	// mut defered_functions := []fn ([]string, int, AInstruction, Symbols) {len:lines.len}
	mut deferred_functions := []Deferred{len: 9}

	for line in lines {
		// Returns Mobject
		parsed := parse_line(line) or { continue }

		match parsed {
			Label {
				symbols[parsed.name] = i
			}
			CInstruction {
				// doesn't actually use the argument `symbols`
				asm_lines[i] = parsed.to_asm(mut symbols)
			}
			AInstruction {
				// cases
				// 1. its is a predefined symbols, (R1,SCREEN,..), just return the map
				// 2. its is a variable (1,2,3...), return it
				// 3. new symbol, write it to the symbols map, return its value
				println('to be deferred')
				// asm_lines[i] = parsed.to_asm(mut symbols)

				deferred_functions << Deferred{
					i: i
					asm_lines: mut asm_lines
					instruction: parsed
					symbols: mut symbols
				}
			}
			else {}
		}
		i++
	}
	for mut deferred in deferred_functions {
		println(deferred.asm_lines)
		deferred.asm_lines[deferred.i] = 'deferred'
	}
	// println(asm_lines.join('\n'))
	// println(asm_lines)
}

fn real_main(mut asm_lines []string, lines []string) {
}
