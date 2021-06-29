module main

struct CInstruction {
	comp string // includes a field
	dest string
	jump string
}

struct AInstruction {
	value string
}

// type MObject = AInstruction | CInstruction

interface MObject {
	to_asm() string
}

fn parse_line(line string) ?MObject {
	// remove comments
	cmd := clean_line(line) ?
	return if cmd[0] == `@` {
		MObject(parse_a_instruction(cmd))
	} else {
		MObject(parse_c_instruction(cmd))
	}
}

// input without the '@'
fn parse_a_instruction(cmd string) AInstruction {
	return AInstruction{
		value: cmd[1..]
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

fn (a AInstruction) to_asm() string {
	return decbin(a.value.u16())
}

fn (c CInstruction) to_asm() string {
	comp := comp_map[c.comp]
	dest := dest_map[c.dest]
	jump := jump_map[c.jump]
	return '111$comp$dest$jump'
}
