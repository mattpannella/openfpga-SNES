#
# user core constraints
#
# put your clock groups in here as well as any net assignments
#

set_clock_groups -asynchronous \
 -group { bridge_spiclk } \
 -group { clk_74a } \
 -group { clk_74b } \
 -group { ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk } \
 -group { ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk } \
 -group { ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk } \
 -group { ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk } 

create_generated_clock -name GSU_CACHE_CLK -source [get_pins -compatibility_mode {*|mp1|mf_pllbase_inst|altera_pll_i|*[1].*|divclk}] \
							  -invert [get_pins {ic|snes|main|GSUMap|GSU|CACHE|altsyncram_component|auto_generated|*|clk0}]

create_generated_clock -name CX4_MEM_CLK -source [get_pins -compatibility_mode {*|mp1|mf_pllbase_inst|altera_pll_i|*[1].*|divclk}] \
							  -invert [get_pins {ic|snes|main|CX4Map|CX4|DATA_RAM|altsyncram_component|auto_generated|*|clk0 \
														ic|snes|main|CX4Map|CX4|DATA_ROM|spram_sz|altsyncram_component|auto_generated|altsyncram1|*|clk0 }]

# TODO: There are additional expansion clocks here
derive_clock_uncertainty

set_clock_groups -asynchronous -group [get_clocks { GSU_CACHE_CLK CX4_MEM_CLK }] 

set_max_delay 23 -from [get_registers { ic|icb|* \
													 ic|data_loader|* \
													 ic|snes|main|* \
													 ic|snes|rom_mask[*] \
													 ic|ioctl* |
													 ic|rom_file_size }] \
					  -to   [get_registers { ic|snes|sdram|a[*] \
													 ic|snes|sdram|ram_req* \
													 ic|snes|sdram|we* \
													 ic|snes|sdram|state[*] \
													 ic|snes|sdram|old_* \
													 ic|snes|sdram|busy* \
													 ic|snes|sdram|SDRAM_nCAS \
													 ic|snes|sdram|SDRAM_A[*] \
													 ic|snes|sdram|SDRAM_BA[*] }] 

set_max_delay 23 -from [get_registers { ic|snes|sdram|* }] \
					  -to   [get_registers { ic|snes|main|* \
													 ic|snes|bsram|* \
													 ic|snes|wram|* \
													 ic|snes|vram*|* }]

set_max_delay 23 -from [get_registers { ic|snes|wram|* \
													 ic|snes|bsram|* }] \
					  -to   [get_registers { ic|snes|main|SNES|CPU|P65C816|* }]

set_false_path -to [get_registers { ic|snes|sdram|ds ic|snes|sdram|data[*]}]
