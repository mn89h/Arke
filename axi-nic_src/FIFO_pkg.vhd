library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity STD_FIFO is
	Generic (
		data_width	: positive := AXI4_Full_Wr_RqA_WIDTH;
		fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
	);
	Port ( 
		clk			: in  std_logic;
		rst			: in  std_logic;
		WrValid_in	: in  std_logic;
		WrReady_out	: out std_logic;
		WrData_in	: in  std_logic_vector(data_width - 1 downto 0);
		RdReady_in	: in  std_logic;
		RdData_out	: out std_logic_vector(data_width - 1 downto 0);
		RdValid_out	: out std_logic 
	);
end STD_FIFO;

architecture Behavioral of STD_FIFO is
		type fifo_memory is array (0 to fifo_depth - 1) of std_logic_vector(data_width - 1 downto 0);
		signal Memory : fifo_memory;
		
		signal Head : natural range 0 to fifo_depth - 1 := 0;
		signal Tail : natural range 0 to fifo_depth - 1 := 0;
		
		signal Looped : boolean := false;

begin

	-- Memory Pointer Process
	fifo_proc : process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Head <= 0;
				Tail <= 0;
				
				Looped <= false;
				
				WrReady_out  <= '1';
				RdValid_out <= '0';
				Memory <= (others => (others => '0'));
			else
				
				-- if not empty
				if ((Looped = true) or (Head /= Tail)) then
					
					-- read and set valid
					RdData_out <= Memory(Tail);
					RdValid_out <= '1';
					
					if (RdReady_in = '1') then

						-- if full and simultaneous write...
						if ((Head = Tail) and (WrValid_in = '1')) then
							-- ...write and set ready
							Memory(Head) <= WrData_in;
							WrReady_out <= '1';

							-- ...update read and write pointer
							if (Head = fifo_depth - 1) then
								Head <= 0;
								Tail <= 0;
							else
								Head <= Head + 1;
								Tail <= Tail + 1;
							end if;

						-- otherwise update only read pointer
						elsif (Tail = fifo_depth - 1) then
							Looped <= false;
							
							Tail <= 0;
						else
							Tail <= Tail + 1;
						end if;
					end if;
				end if;

				-- if not full
				if ((Looped = false) or (Head /= Tail)) then

					-- write and set ready
					Memory(Head) <= WrData_in;
					WrReady_out <= '1';
					
					if (WrValid_in = '1') then

						-- if empty and simultaneous read...
						if ((Head = Tail) and (RdReady_in = '1')) then
							-- ...read and set ready (no updated pointers)
							RdData_out <= WrData_in;
							RdValid_out <= '1';
		
						-- otherwise update only write pointer
						elsif (Head = fifo_depth - 1) then
							Looped <= true; --look
							
							Head <= 0;
						else
							Head <= Head + 1;
						end if;
					end if;
				end if;
				
				
			end if;
		end if;
	end process;
		
end Behavioral;
