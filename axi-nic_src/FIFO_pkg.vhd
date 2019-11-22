library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

--entity STD_FIFO is
--	Generic (
--		-- fifo_width  : positive := FIFO_WIDTH;
--		type		  data_type; -- VHDL-2008+ / Vivado 2019.1+ - replaces vectors w/ fifo_width generic and (de-)serialize functions
--		fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
--	);
--	Port ( 
--		clk		: in  std_logic;
--		rst		: in  std_logic;
--		WriteEn	: in  std_logic;
--		DataIn	: in  data_type;
--		ReadEn	: in  std_logic;
--		DataOut	: out data_type;
--		Empty	: out std_logic;
--		Full	: out std_logic
--	);
--end STD_FIFO;
--
--architecture Behavioral of STD_FIFO is
--		type fifo_memory is array (0 to fifo_depth - 1) of data_type;
--		signal Memory : fifo_memory;
--		
--		signal Head : natural range 0 to fifo_depth - 1;
--		signal Tail : natural range 0 to fifo_depth - 1;
--		
--		signal Looped : boolean;
--
--begin
--
--	-- Memory Pointer Process
--	fifo_proc : process (clk)
--	begin
--		if rising_edge(clk) then
--			if rst = '1' then
--				Head <= 0;
--				Tail <= 0;
--				
--				Looped <= false;
--				
--				Full  <= '0';
--				Empty <= '1';
--				-- DataOut <= (others => '0'); -- not possible on data_type
--			else
--				if ((ReadEn = '1')) then
--					if ((Looped = true) or (Head /= Tail)) then
--						-- Update data output
--						DataOut <= Memory(Tail);
--						
--						-- Update Tail pointer as needed
--						if (Tail = fifo_depth - 1) then
--							Tail <= 0;
--							
--							Looped <= false;
--						else
--							Tail <= Tail + 1;
--						end if;
--						
--						
--					end if;
--				end if;
--				
--				if (WriteEn = '1') then
--					if ((Looped = false) or (Head /= Tail)) then
--						-- Write Data to Memory
--						Memory(Head) <= DataIn;
--						
--						-- Increment Head pointer as needed
--						if (Head = fifo_depth - 1) then
--							Head <= 0;
--							
--							Looped <= true;
--						else
--							Head <= Head + 1;
--						end if;
--					end if;
--				end if;
--				
--				-- Update Empty and Full flags
--				if (Head = Tail) then
--					if Looped then
--						Full <= '1';
--					else
--						Empty <= '1';
--					end if;
--				else
--					Empty	<= '0';
--					Full	<= '0';
--				end if;
--			end if;
--		end if;
--	end process;
--		
--end Behavioral;


-- WrRqA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity STD_FIFO_WrRqA is
	Generic (
		fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
	);
	Port ( 
		clk		: in  std_logic;
		rst		: in  std_logic;
		WriteEn	: in  std_logic;
		DataIn	: in  AXI4_Full_Wr_RqA;
		ReadEn	: in  std_logic;
		DataOut	: out AXI4_Full_Wr_RqA;
		Empty	: out std_logic;
		Full	: out std_logic
	);
end STD_FIFO_WrRqA;

architecture Behavioral of STD_FIFO_WrRqA is
	type fifo_memory is array (0 to fifo_depth - 1) of AXI4_Full_Wr_RqA;
	signal Memory : fifo_memory;
	
	signal Head : natural range 0 to fifo_depth - 1;
	signal Tail : natural range 0 to fifo_depth - 1;
	
	signal Looped : boolean;

begin

	-- Memory Pointer Process
	fifo_proc : process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Head <= 0;
				Tail <= 0;
				
				Looped <= false;
				
				Full  <= '0';
				Empty <= '1';
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = fifo_depth - 1) then
							Tail <= 0;
							
							Looped <= false;
						else
							Tail <= Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) <= DataIn;
						
						-- Increment Head pointer as needed
						if (Head = fifo_depth - 1) then
							Head <= 0;
							
							Looped <= true;
						else
							Head <= Head + 1;
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

-- WrRqD

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity STD_FIFO_WrRqD is
	Generic (
		fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
	);
	Port ( 
		clk		: in  std_logic;
		rst		: in  std_logic;
		WriteEn	: in  std_logic;
		DataIn	: in  AXI4_Full_Wr_RqD;
		ReadEn	: in  std_logic;
		DataOut	: out AXI4_Full_Wr_RqD;
		Empty	: out std_logic;
		Full	: out std_logic
	);
end STD_FIFO_WrRqD;

architecture Behavioral of STD_FIFO_WrRqD is
	
	type fifo_memory is array (0 to fifo_depth - 1) of AXI4_Full_Wr_RqD;
	signal Memory : fifo_memory;
	
	signal Head : natural range 0 to fifo_depth - 1;
	signal Tail : natural range 0 to fifo_depth - 1;
	
	signal Looped : boolean;
begin

	-- Memory Pointer Process
	fifo_proc : process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Head <= 0;
				Tail <= 0;
				
				Looped <= false;
				
				Full  <= '0';
				Empty <= '1';
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = fifo_depth - 1) then
							Tail <= 0;
							
							Looped <= false;
						else
							Tail <= Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) <= DataIn;
						
						-- Increment Head pointer as needed
						if (Head = fifo_depth - 1) then
							Head <= 0;
							
							Looped <= true;
						else
							Head <= Head + 1;
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

--RdRqA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity STD_FIFO_RdRqA is
	Generic (
		fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
	);
	Port ( 
		clk		: in  std_logic;
		rst		: in  std_logic;
		WriteEn	: in  std_logic;
		DataIn	: in  AXI4_Full_Rd_RqA;
		ReadEn	: in  std_logic;
		DataOut	: out AXI4_Full_Rd_RqA;
		Empty	: out std_logic;
		Full	: out std_logic
	);
end STD_FIFO_RdRqA;

architecture Behavioral of STD_FIFO_RdRqA is
	
	type fifo_memory is array (0 to fifo_depth - 1) of AXI4_Full_Rd_RqA;
	signal Memory : fifo_memory;
	
	signal Head : natural range 0 to fifo_depth - 1;
	signal Tail : natural range 0 to fifo_depth - 1;
	
	signal Looped : boolean;
begin

	-- Memory Pointer Process
	fifo_proc : process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Head <= 0;
				Tail <= 0;
				
				Looped <= false;
				
				Full  <= '0';
				Empty <= '1';
				--DataOut <= ((others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'));
			else
			if (ReadEn = '1') then
				if ((Looped = true) or (Head /= Tail)) then
					-- Update data output
					DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = fifo_depth - 1) then
							Tail <= 0;
							
							Looped <= false;
						else
							Tail <= Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) <= DataIn;
						
						-- Increment Head pointer as needed
						if (Head = fifo_depth - 1) then
							Head <= 0;
							
							Looped <= true;
						else
							Head <= Head + 1;
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

--WrRsp

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity STD_FIFO_WrRsp is
	Generic (
		fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
	);
	Port ( 
		clk		: in  std_logic;
		rst		: in  std_logic;
		WriteEn	: in  std_logic;
		DataIn	: in  AXI4_Full_Wr_Rsp;
		ReadEn	: in  std_logic;
		DataOut	: out AXI4_Full_Wr_Rsp;
		Empty	: out std_logic;
		Full	: out std_logic
	);
end STD_FIFO_WrRsp;

architecture Behavioral of STD_FIFO_WrRsp is

	type fifo_memory is array (0 to fifo_depth - 1) of AXI4_Full_Wr_Rsp;
	signal Memory : fifo_memory;
	
	signal Head : natural range 0 to fifo_depth - 1;
	signal Tail : natural range 0 to fifo_depth - 1;
	
	signal Looped : boolean;
begin

	-- Memory Pointer Process
	fifo_proc : process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Head <= 0;
				Tail <= 0;
				
				Looped <= false;
				
				Full  <= '0';
				Empty <= '1';
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = fifo_depth - 1) then
							Tail <= 0;
							
							Looped <= false;
						else
							Tail <= Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) <= DataIn;
						
						-- Increment Head pointer as needed
						if (Head = fifo_depth - 1) then
							Head <= 0;
							
							Looped <= true;
						else
							Head <= Head + 1;
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

--RdRsp

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;

entity STD_FIFO_RdRsp is
	Generic (
		fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
	);
	Port ( 
		clk		: in  std_logic;
		rst		: in  std_logic;
		WriteEn	: in  std_logic;
		DataIn	: in  AXI4_Full_Rd_Rsp;
		ReadEn	: in  std_logic;
		DataOut	: out AXI4_Full_Rd_Rsp;
		Empty	: out std_logic;
		Full	: out std_logic
	);
end STD_FIFO_RdRsp;

architecture Behavioral of STD_FIFO_RdRsp is
	
	type fifo_memory is array (0 to fifo_depth - 1) of AXI4_Full_Rd_Rsp;
	signal Memory : fifo_memory;
	
	signal Head : natural range 0 to fifo_depth - 1;
	signal Tail : natural range 0 to fifo_depth - 1;
	
	signal Looped : boolean;
begin

	-- Memory Pointer Process
	fifo_proc : process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				Head <= 0;
				Tail <= 0;
				
				Looped <= false;
				
				Full  <= '0';
				Empty <= '1';
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = fifo_depth - 1) then
							Tail <= 0;
							
							Looped <= false;
						else
							Tail <= Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) <= DataIn;
						
						-- Increment Head pointer as needed
						if (Head = fifo_depth - 1) then
							Head <= 0;
							
							Looped <= true;
						else
							Head <= Head + 1;
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