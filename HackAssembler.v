module main

import os

fn main() {
	// symbols := init_symbols()

	settings := handle_args()
	println('filename1: $settings.filename')
	lines := os.read_lines(settings.filename) or { panic("can't read file") }
	for line in lines {
		// Returns Mobject
		parsed := parse_line(line) or { continue }
		println('$parsed')
	}
}
