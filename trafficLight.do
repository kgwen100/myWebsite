add wave *
force clk 0 0, 1 5 -repeat 10
force rst 0 0
force rst 1 60

force rst 0 100

run 300 ns
