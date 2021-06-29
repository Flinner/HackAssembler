module main

import os

fn main() {
	// symbols := init_symbols()

	settings := handle_args()
	println('filename1: $settings.filename\n')
	lines := os.read_lines(settings.filename) or { panic("can't read file") }
	mut asm_lines := []string{}

	for line in lines {
		// Returns Mobject
		parsed := parse_line(line) or { continue }
		//		println('parsed: $parsed.to_asm()')

		asm_lines << parsed.to_asm()
	}
	println(asm_lines.join('\n'))
}
