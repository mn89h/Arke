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
    generic (
        X_WIDTH :integer := integer(ceil(log2(real(DIM_X)))),
        Y_WIDTH :integer := integer(ceil(log2(real(DIM_Y)))),
        Z_WIDTH :integer := integer(ceil(log2(real(DIM_Z))))
    
    );
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        
        -- LOCAL input and output port for each node
        x          : in std_logic_vector(0 to DIM_X-1);
        y          : in std_logic_vector(0 to DIM_Y-1);
        z          : in std_logic_vector(0 to DIM_Z-1);
        data_in     : in std_logic_vector((DIM_X * DIM_Y * DIM_Z * DATA_WIDTH) - 1 downto 0);
        control_in  : in std_logic_vector((DIM_X * DIM_Y * DIM_Z * CONTROL_WIDTH) - 1 downto 0);


        data_out    : out std_logic_vector((DIM_X * DIM_Y * DIM_Z * DATA_WIDTH) - 1 downto 0);
        control_out : out std_logic_vector((DIM_X * DIM_Y * DIM_Z * CONTROL_WIDTH) - 1 downto 0)
    );
end NoC_Wrapper;

function to_CtrlVec(arr: Array3D_control) return STD_LOGIC_VECTOR is
    variable vec : STD_LOGIC_VECTOR((arr'length * CONTROL_WIDTH) - 1 downto 0);
    begin
        for ix in 0 to DIM_X-1 loop
            for iy in 0 to DIM_Y-1 loop
                for iz in 0 to DIM_Z-1 loop
                    vec((i * CONTROL_WIDTH) + CONTROL_WIDTH - 1 downto (i * CONTROL_WIDTH))
                end loop;
            end loop;
        end loop;
    return vec;
end function
function to_DataVec(arr: Array3D_data) return STD_LOGIC_VECTOR is
    variable vec : STD_LOGIC_VECTOR((arr'length * DATA_WIDTH) - 1 downto 0);
    begin
        for i in arr'range loop
            vec((i * DATA_WIDTH) + DATA_WIDTH - 1 downto (i * DATA_WIDTH)) := --TODOOOOOOOO difficult
        end loop;
    return vec;
end function


function to_DataArr(vec: STD_LOGIC_VECTOR) return Array3D_data is
    variable arr : Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    begin
        for i in vec'range loop
            vec((i * DATA_WIDTH) + DATA_WIDTH - 1 downto (i * DATA_WIDTH))
        end loop;
    return vec;
end function

function to_DataVec(arr: Array3D_data) return STD_LOGIC_VECTOR is
    variable vec : STD_LOGIC_VECTOR((arr'length * DATA_WIDTH) - 1 downto 0);
    begin
        for i in arr'range loop
            vec((i * DATA_WIDTH) + DATA_WIDTH - 1 downto (i * DATA_WIDTH))
        end loop;
    return vec;
end function

architecture structural of NoC_Wrapper is
       
    signal data_in_arr     : Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal data_out_arr    : Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_in_arr  : Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_out_arr : Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);

begin
    for x in 0 to DIM_X-1 loop
        for y in 0 to DIM_Y-1 loop
            for z in 0 to DIM_Z-1 loop
                data_in_arr(x,y,z) <= data_in((DIM_X-x) * (DIM_Y-y) * (DIM_Z-z) * DATA_WIDTH downto );


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
