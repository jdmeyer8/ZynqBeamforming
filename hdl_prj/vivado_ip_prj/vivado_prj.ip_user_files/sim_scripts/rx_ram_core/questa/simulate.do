onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rx_ram_core_opt

do {wave.do}

view wave
view structure
view signals

do {rx_ram_core.udo}

run -all

quit -force
