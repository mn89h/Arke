--------------------------------------------------------------------------------------
-- DESIGN UNIT  : NoC test bench                                                           --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Aug 10th, 2015                                                    --
-- VERSION      : v1.0                                                             --
-- HISTORY      : Version 0.1 - Aug 10th, 2015                                      --
--              : Version 0.2.1 - Set 18th, 2015                                    --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.Arke_pkg.all;
use ieee.numeric_std.all;

entity NoC_Wrapper is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        
        -- LOCAL input and output port for each node
        x          : in std_logic_vector(0 to DIM_X-1);
        y          : in std_logic_vector(0 to DIM_Y-1);
        z          : in std_logic_vector(0 to DIM_Z-1);
        data_in     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        control_in  : in std_logic_vector(CONTROL_WIDTH-1 downto 0);


        data_out    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        control_out : out std_logic_vector(CONTROL_WIDTH-1 downto 0)
    );
end NoC_Wrapper;

architecture structural of NoC_Wrapper is
       
    signal data_in_arr     : Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal data_out_arr    : Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_in_arr  : Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_out_arr : Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);

    signal xV : natural;
    signal yV : natural;
    signal zV : natural;

begin
    
    xV <= to_integer(unsigned(x));
    yV <= to_integer(unsigned(y));
    zV <= to_integer(unsigned(z));

    data_in_arr(xV,yV,zV) <= data_in;
    control_in_arr(xV,yV,zV) <= control_in;

    data_out <= data_out_arr(xV,yV,zV);
    control_out <= control_out_arr(xV,yV,zV);


    NoC: entity work.NoC
    port map(
        clk         => clk,
        rst         => rst,
        data_in     => data_in_arr,
        control_in  => control_in_arr,
        data_out    => data_out_arr,
        control_out => control_out_arr
    );
    
    
end structural;
