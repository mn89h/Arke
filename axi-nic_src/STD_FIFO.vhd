library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity STD_FIFO is
	Generic (
		-- data_width  : positive := DATA_WIDTH;
		type		: data_type; -- VHDL-2008+ / Vivado 2019.1+ - replaces data_width generic and (de-)serialize functions for vectors
		fifo_depth	: positive := FIFO_DEPTH
	);
	Port ( 
		clk		: in  std_logic;
		rst		: in  std_logic;
		WriteEn	: in  std_logic;
		DataIn	: in  data_type;
		ReadEn	: in  std_logic;
		DataOut	: out data_type;
		Empty	: out std_logic;
		Full	: out std_logic
	);
end STD_FIFO;

architecture Behavioral of STD_FIFO is

begin

	-- Memory Pointer Process
	fifo_proc : process (clk)
		type fifo_memory is array (0 to fifo_depth - 1) of data_type;
		variable Memory : fifo_memory;
		
		variable Head : natural range 0 to fifo_depth - 1;
		variable Tail : natural range 0 to fifo_depth - 1;
		
		variable Looped : boolean;
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Head := 0;
				Tail := 0;
				
				Looped := false;
				
				Full  <= '0';
				Empty <= '1';
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = fifo_depth - 1) then
							Tail := 0;
							
							Looped := false;
						else
							Tail := Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) := DataIn;
						
						-- Increment Head pointer as needed
						if (Head = fifo_depth - 1) then
							Head := 0;
							
							Looped := true;
						else
							Head := Head + 1;
						end if;
					end if;
				end if;
				
				-- Update Empty and Full flags
				if (Head = Tail) then
					if Looped then
						Full <= '1';
					else
						Empty <= '1';
					end if;
				else
					Empty	<= '0';
					Full	<= '0';
				end if;
			end if;
		end if;
	end process;
		
end Behavioral;