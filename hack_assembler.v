module main

import os

fn main() {
	settings := handle_args()

	lines := os.read_lines(settings.filename) or { panic("can't read file") }

	mut symbols := init_symbols()
	mut i := 0

	for line in lines {
		// Clean comments and new lines and ignore them
		cleaned := clean_line(line) or { continue }

		// add labels to symbol map
		if cleaned[0] == `(` {
			symbols.write(label(cleaned), i)
			continue
		}
		i++
	}

	for line in lines {
		mut asmb := ''

		// Clean comments and new lines, cleaned in each loop
		// a trade of between memory and cpu usage
		cleaned := clean_line(line) or { continue }

		// ignore lines with labels
		if cleaned[0] == `(` {
			continue
		}

		if cleaned[0] == `@` {
			// A Instruction
			asmb = parse_a_instruction(cleaned).to_asm(mut symbols)
		} else {
			// C Instruction
			asmb = parse_c_instruction(cleaned).to_asm(mut symbols)
		}

		// 'unbufferred' output
		println(asmb)
	}
}
