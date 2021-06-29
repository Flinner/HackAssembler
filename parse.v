module main

struct CInstruction {
	comp string
	dest string
	jump string
}

struct AInstruction {
	value string
}

type MObject = AInstruction | CInstruction

fn parse_line(line string) ?MObject {
	// remove comments
	cmd := clean_line(line) ?
	mut mobject := MObject{}

	if cmd[0] == `@` {
		mobject = parse_a_instruction(cmd[1..])
	} else {
		mobject = parse_c_instruction(cmd)
	}

	return mobject
}

// input without the '@'
fn parse_a_instruction(cmd string) AInstruction {
	// bits := decbin(cmd.u16())
	return AInstruction{
		value: cmd
	}
}

fn parse_c_instruction(cmd string) CInstruction {
	return CInstruction{
		comp: comp(cmd)
		dest: dest(cmd)
		jump: jump(cmd)
	}
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
