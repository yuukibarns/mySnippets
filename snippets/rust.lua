local snips = {}

snips = {
	s({
		trig = "io",
		name = "io.read_line",
		desc = "io::stdin().read_line(&mut :buf)",
	}, fmta([[io::stdin().read_line(&mut <>)<>]], { i(1), i(0) })),
}

return snips
