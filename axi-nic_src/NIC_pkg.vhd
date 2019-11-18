--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Arke Package                                                       --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : v1.0                                                             --
-- HISTORY      : Version 0.1 - Apr 8th, 2015                                       --
--              : Version 0.2.1 - Set 18th, 2015                                    --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package NIC_pkg is
    
    ---------------
    -- Constants --
    ---------------
                                        ---------------------
                                        -- Parameterizable --
                                        ---------------------
    
    -- Dimension X and Y need to be greater than 1, for 2D NoCs use Z = 1
    -- X grows from left to right, Y grows from front to back, Z grows from bottom to top
    constant STD_FIFO_DATA_WIDTH    : integer := 16;
    constant STD_FIFO_FIFO_DEPTH    : integer := 8;

    constant AXI4_FULL_DATA_WIDTH   : integer := 64;
    constant AXI4_FULL_ADDR_WIDTH   : integer := 32;

    type AXI4_Full_Wr_RqA is record
        id      <= std_logic_vector(11 downto 0);
        addr    <= std_logic_vector(AXI4_FULL_ADDR_WIDTH-1 downto 0);
        len     <= std_logic_vector(3 downto 0);
        size    <= std_logic_vector(2 downto 0);
        burst   <= std_logic_vector(1 downto 0);
        lock    <= std_logic_vector(1 downto 0);
        cache   <= std_logic_vector(2 downto 0);
        prot    <= std_logic_vector(2 downto 0);
        qos     <= std_logic_vector(2 downto 0);
    end record;

    type AXI4_Full_Wr_RqD is record
        id      <= std_logic_vector(11 downto 0);
        data    <= std_logic_vector(AXI4_FULL_DATA_WIDTH-1 downto 0);
        strb    <= std_logic_vector(3 downto 0);
        last    <= std_logic;
    end record;

    type AXI4_Full_Wr_Rsp is record
        id      <= std_logic_vector(11 downto 0);
        resp    <= std_logic_vector(1 downto 0);
    end record;

    type AXI4_Full_Rd_RqA is record
        id      <= std_logic_vector(11 downto 0);
        addr    <= std_logic_vector(AXI4_FULL_ADDR_WIDTH-1 downto 0);
        len     <= std_logic_vector(3 downto 0);
        size    <= std_logic_vector(2 downto 0);
        burst   <= std_logic_vector(1 downto 0);
        lock    <= std_logic_vector(1 downto 0);
        cache   <= std_logic_vector(2 downto 0);
        prot    <= std_logic_vector(2 downto 0);
        qos     <= std_logic_vector(2 downto 0);
    end record;

    type AXI4_Full_Rd_Rsp is record
        id      <= std_logic_vector(11 downto 0);
        data    <= std_logic_vector(AXI4_FULL_DATA_WIDTH-1 downto 0);
        resp    <= std_logic_vector(1 downto 0);
        last    <= std_logic;
    end record;
    
    

end NIC_pkg;