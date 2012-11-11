onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bemicro_tb/bemicro_top/clk
add wave -noupdate /bemicro_tb/bemicro_top/reset
add wave -noupdate /bemicro_tb/bemicro_top/pb
add wave -noupdate /bemicro_tb/bemicro_top/led
add wave -noupdate /bemicro_tb/bemicro_top/state
add wave -noupdate -radix ascii /bemicro_tb/bemicro_top/state_str
add wave -noupdate -radix hexadecimal /bemicro_tb/bemicro_top/reset_cnt
add wave -noupdate -radix hexadecimal /bemicro_tb/bemicro_top/pb0_cntr
add wave -noupdate /bemicro_tb/bemicro_top/pb1_cntr
add wave -noupdate /bemicro_tb/bemicro_top/pb0_saturated
add wave -noupdate /bemicro_tb/bemicro_top/pb1_saturated
add wave -noupdate /bemicro_tb/bemicro_top/pb0_event
add wave -noupdate /bemicro_tb/bemicro_top/pb1_event
add wave -noupdate /bemicro_tb/bemicro_top/pb2_event
add wave -noupdate -group {Fcn 0 (binary counter)} /bemicro_tb/bemicro_top/counter0/clk
add wave -noupdate -group {Fcn 0 (binary counter)} /bemicro_tb/bemicro_top/counter0/reset
add wave -noupdate -group {Fcn 0 (binary counter)} /bemicro_tb/bemicro_top/counter0/event0
add wave -noupdate -group {Fcn 0 (binary counter)} /bemicro_tb/bemicro_top/counter0/event1
add wave -noupdate -group {Fcn 0 (binary counter)} /bemicro_tb/bemicro_top/counter0/count
add wave -noupdate -group {Fcn 1 (gray counter)} /bemicro_tb/bemicro_top/counter1/clk
add wave -noupdate -group {Fcn 1 (gray counter)} /bemicro_tb/bemicro_top/counter1/reset
add wave -noupdate -group {Fcn 1 (gray counter)} /bemicro_tb/bemicro_top/counter1/event0
add wave -noupdate -group {Fcn 1 (gray counter)} /bemicro_tb/bemicro_top/counter1/event1
add wave -noupdate -group {Fcn 1 (gray counter)} /bemicro_tb/bemicro_top/counter1/count
add wave -noupdate -group {Fcn 2 (Life 0)} /bemicro_tb/bemicro_top/life_1d_0/clk
add wave -noupdate -group {Fcn 2 (Life 0)} /bemicro_tb/bemicro_top/life_1d_0/reset
add wave -noupdate -group {Fcn 2 (Life 0)} /bemicro_tb/bemicro_top/life_1d_0/event0
add wave -noupdate -group {Fcn 2 (Life 0)} /bemicro_tb/bemicro_top/life_1d_0/event1
add wave -noupdate -group {Fcn 2 (Life 0)} /bemicro_tb/bemicro_top/life_1d_0/life_state
add wave -noupdate -group {Fcn 2 (Life 0)} /bemicro_tb/bemicro_top/life_1d_0/mode
add wave -noupdate -group {Fcn 2 (Life 0)} /bemicro_tb/bemicro_top/life_1d_0/delay_cntr
add wave -noupdate -group {Fcn 3 (Life 1)} /bemicro_tb/bemicro_top/life_1d_1/clk
add wave -noupdate -group {Fcn 3 (Life 1)} /bemicro_tb/bemicro_top/life_1d_1/reset
add wave -noupdate -group {Fcn 3 (Life 1)} /bemicro_tb/bemicro_top/life_1d_1/event0
add wave -noupdate -group {Fcn 3 (Life 1)} /bemicro_tb/bemicro_top/life_1d_1/event1
add wave -noupdate -group {Fcn 3 (Life 1)} /bemicro_tb/bemicro_top/life_1d_1/life_state
add wave -noupdate -group {Fcn 3 (Life 1)} /bemicro_tb/bemicro_top/life_1d_1/mode
add wave -noupdate -group {Fcn 3 (Life 1)} /bemicro_tb/bemicro_top/life_1d_1/delay_cntr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17699 ps} 0}
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {18894 ps}
