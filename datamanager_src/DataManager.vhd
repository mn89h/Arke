--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Data Manager                                                      --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Jul 9th, 2015                                                     --
-- VERSION      : v1.0                                                             --
-- HISTORY      : Version 0.1 - Jul 9th, 2015                                       --
--              : Version 0.2.1 - Set 18th, 2015                                    --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use work.Text_Package.all;
use std.textio.all;
use work.Arke_pkg.all;

entity DataManager is 
    generic(
            fileNameIn  : string;
            fileNameOut : string
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        
        data_in     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        control_in  : in std_logic_vector(CONTROL_WIDTH-1 downto 0);
        
        data_out    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        control_out : out std_logic_vector(CONTROL_WIDTH-1 downto 0)
    );
end DataManager;


architecture behavioral of DataManager is
begin
    SEND: block
        
    constant RAM_SZ : integer := 39;
    type Mem_Type is array(0 to RAM_SZ-1) of std_logic_vector((DATA_WIDTH+3) downto 0);
    type state is (S0, S1);

        impure function init_mem(fileNameIn_v : in string) return Mem_Type is
            file flitFile : text open read_mode is fileNameIn_v;
            variable flitLine : line;
            variable temp_bv  : string(1 to 5);
            variable temp_mem : Mem_Type;
        begin
            for i in Mem_Type'range loop
                readline(flitFile, flitLine);
                read(flitLine, temp_bv);
                temp_mem(i) := StringToStdLogicVector(temp_bv);
            end loop;
            return temp_mem;
        end function;

        
        signal ram_send     : Mem_Type := init_mem(fileNameIn);
        signal currentState : state;
        signal words        : std_logic_vector(DATA_WIDTH+3 downto 0); --  eop + word 
        signal counter      : integer range 0 to RAM_SZ;

    begin
        process(clk, rst)
        begin 
            if rst = '1' then
                currentState <= S1;
                counter <= 0;
            elsif rising_edge(clk) then
                case currentState is
                    when S0 =>
                        if (counter < RAM_SZ) or (control_in(STALL_GO)='0') then
                            if(control_in(STALL_GO)='1') then
                                words <= ram_send(counter);
                                currentState <= S0;
                                counter <= counter + 1;
                            else -- Local port haven't space on buffer
                                currentState <= S0;
                            end if;
                        else -- End of File
                            currentState <= S1;
                        end if;

                    when S1 =>
                        if (counter < RAM_SZ) then
                            currentState <= S0;
                        else
                            currentState <= S1;
                        end if;
                end case;
            end if;
        end process;
        data_out <= words(DATA_WIDTH-1 downto 0);
        control_out(EOP) <= words(DATA_WIDTH);
        control_out(TX) <= '1' when currentState = S0 else '0';
    end block SEND;
    
    RECIEVE: block
        type state is (S0);    
        constant RAM_SZ : integer := 39;
        type Mem_Type is array(0 to RAM_SZ-1) of std_logic_vector((DATA_WIDTH+3) downto 0);

        signal currentState : state;
        signal ram_recv     : Mem_Type;
        signal counter      : integer range 0 to RAM_SZ;
        signal completeLine : std_logic_vector(DATA_WIDTH+3 downto 0);
    begin
        completeLine <= b"000" & control_in(EOP) & data_in;
        process(clk, rst)
        begin
            if rst = '1' then
                currentState <= S0;
                control_out(STALL_GO) <= '0';
                counter <= 0;
            elsif rising_edge(clk) then
                case currentState is
                    when S0 =>
                        if control_in(RX) = '1' then
                            ram_recv(counter) <= completeLine;
                            counter <= counter + 1;
                        end if;
                        currentState <= S0;
                end case;
                control_out(STALL_GO) <= '1';
            end if;
        end process;
    end block RECIEVE;
    
end architecture;