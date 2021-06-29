module main

// type Line = string

struct CInstruction {
	comp byte
	dest byte
	jump byte
}

struct AInstruction {
	value u16
}

type MObject = AInstruction | CInstruction

fn parse_line(line string) ?MObject {
	// remove comments
	cmd := clean_line(line) ?

	print('cmd.len: $cmd | $cmd.len')
	println('')

	return MObject{}
}

// clean_line removes comments and whitespace
// returns error on empty lines
fn clean_line(line string) ?string {
	cmd_end := line.index('//') or { line.len }
	cmd := line[0..cmd_end].trim_space()

	// return on empty lines
	if cmd.len < 1 {
		return error('log: empty line')
	}
	return cmd
}
