module main

import strconv

struct CInstruction {
	comp string // includes a field
	dest string
	jump string
}

struct AInstruction {
	value string
}

struct Label {
	name string
}

// type MObject = AInstruction | CInstruction | Label

// fn parse_line(line string) ?MObject {
//	// remove comments
//	cmd := clean_line(line) ?
//	return if cmd[0] == `@` {
//		MObject(parse_a_instruction(cmd))
//	} else if cmd[0] == `(` {
//		MObject(parse_label(cmd))
//	} else {
//		MObject(parse_c_instruction(cmd))
//	}
//}

// input without the '@'
fn parse_a_instruction(cmd string) AInstruction {
	return AInstruction{
		value: cmd[1..]
	}
}

// labels are between '(' and ')'
fn parse_label(cmd string) Label {
	return Label{
		name: label(cmd)
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

fn (a AInstruction) to_asm(mut symbols Symbols) string {
	// either
	//1. symbol is known
	//2. is a number
	//3 create symbol
	value := symbols[a.value] or { strconv.atoi(a.value) or {symbols.new(a.value)} }
	return decbin(value)
}

fn (c CInstruction) to_asm(mut symbols Symbols) string {
	comp := comp_map[c.comp]
	dest := dest_map[c.dest]
	jump := jump_map[c.jump]
	return '111$comp$dest$jump'
}

fn comp(cmd string) string {
	return cmd.all_after('=').all_before(';')
	// return cmd.find_between('=', ';')
}

fn dest(cmd string) string {
	return if cmd.contains('=') { cmd.all_before('=') } else { 'null' }
}

fn jump(cmd string) string {
	return if cmd.contains(';') { cmd.all_after(';') } else { 'null' }
}

fn label(cmd string) string {
	return cmd.all_after('(').all_before(')')
	// return cmd.find_between('(', ')')
}
