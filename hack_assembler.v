module main

import os
import term

fn main() {
	term.erase_clear() // tmp

	mut symbols := init_symbols()

	settings := handle_args()
	println('filename1: $settings.filename\n')
	lines := os.read_lines(settings.filename) or { panic("can't read file") }

	mut asm_lines := []string{len: lines.len}
	mut i := 0

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
				defer {
					asm_lines[i] = parsed.to_asm(mut symbols)
				}
			}
			else {}
		}
		i++
	}
	// println(asm_lines.join('\n'))
	// println(asm_lines)
}
