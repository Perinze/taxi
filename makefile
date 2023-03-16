taxi: taxi_test.v taxi.v motion_detector.v distance_accumulator.v distance_meter.v timer.v wait_display.v wait_meter.v
	iverilog -o taxi_test taxi_test.v taxi.v motion_detector.v distance_accumulator.v distance_meter.v timer.v wait_display.v wait_meter.v
	./taxi_test
	gtkwave taxi_test.vcd
	
timer: timer.v timer_test.v
	iverilog -o timer_test timer.v timer_test.v
	./timer_test
	gtkwave timer_test.vcd

processor: dff.v timer.v processor.v processor_test.v
	iverilog -o processor_test dff.v timer.v processor.v processor_test.v
	./processor_test
	gtkwave processor_test.vcd
	
rom: rom.v rom_test.v
	iverilog -o rom_test rom.v rom_test.v
	./rom_test
	gtkwave rom_test.vcd