module main

import os

fn main() {
	settings := handle_args()
	println('filename1: $settings.filename')
	lines := os.read_lines(settings.filename) or { panic("can't read file") }
	for line in lines {
		parse_line(line) or { continue }
	}
}
