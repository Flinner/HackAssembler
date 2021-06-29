module main

// tf! no way to convert ints to binary :|

fn decbin(n u16) string {
	mut s := []string{len: 16, init: '0'}
	mut u := n

	for i := 0; u > 0; i++ {
		s[i] = if u & 1 == 1 { '1' } else { '0' }
		u = u >> 1
	}
	return s.join('').reverse()
}

fn comp(cmd string) string {
	return cmd.find_between('=', ';')
}

fn dest(cmd string) string {
	return if cmd.contains('=') { cmd.all_before('=') } else { 'null' }
}

fn jump(cmd string) string {
	return if cmd.contains(';') { cmd.all_after(';') } else { 'null' }
}
