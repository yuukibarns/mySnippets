local snips = {}

snips = {
	s({
		trig = "io",
		name = "read_line",
		desc = "io::stdin().read_line(&mut <>).expect();",
	}, fmta([[io::stdin().read_line(&mut <>).expect("Failed to read line!");]], { i(1), i(0) })),

	s({
		trig = "tr",
		name = "transform data type",
		desc = "let <>: <> = <>.trim().parse().expect(<>);",
	}, fmta([[let <>: <> = <>.trim().parse().expect("<>");]], { i(1), i(2), i(3), i(0, "Not a number!") })),
}

return snips
