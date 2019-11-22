-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 19.11.2019 16:07:39 GMT

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.NIC_pkg.all;
library vunit_lib;
context vunit_lib.vunit_context;

entity tb_STD_FIFO_RdRqA is
    generic (runner_cfg : string := runner_cfg_default);
end tb_STD_FIFO_RdRqA;

architecture tb of tb_STD_FIFO_RdRqA is

    component STD_FIFO_RdRqA
        generic (fifo_depth	: positive := STD_FIFO_FIFO_DEPTH
        );
        port (clk     : in std_logic;
              rst     : in std_logic;
              WriteEn : in std_logic;
              DataIn  : in axi4_full_rd_rqa;
              ReadEn  : in std_logic;
              DataOut : out axi4_full_rd_rqa;
              Empty   : out std_logic;
              Full    : out std_logic
        );
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic := '1';

    signal AXI_arvalid     : std_logic := '0';
    signal AXI_arready     : std_logic := '0';
    signal AXI_rdrqA_data  : AXI4_Full_Rd_RqA;
    signal rdrqA_get_valid : std_logic := '0';
    signal rdrqA_get_en    : std_logic := '0';
    signal rdrqA_get_data  : AXI4_Full_Rd_RqA;
    signal lol             : AXI4_Full_Rd_RqA := ((others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'));
		
    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : STD_FIFO_RdRqA
    port map (clk     => clk,
              rst     => rst,
              WriteEn         => AXI_arvalid,     --in awvalid
              DataIn          => AXI_rdrqA_data,  --in awaddr, etc
              ReadEn          => rdrqA_get_en,    --in external_ifc
              DataOut         => rdrqA_get_data,  --out external_ifc
              "NOT"(Empty)    => rdrqA_get_valid, --out external_ifc
              "NOT"(Full)     => AXI_arready      --out awready
              );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    procedure check_cycle (
      constant AXI_arvalid_value      : in std_logic;
      constant AXI_arready_value      : in std_logic;
      constant AXI_rdrqA_data_value   : in AXI4_Full_Rd_RqA;
      constant rdrqA_get_valid_value  : in std_logic;
      constant rdrqA_get_en_value     : in std_logic;
      constant rdrqA_get_data_value   : in AXI4_Full_Rd_RqA
    ) is
    begin
        AXI_rdrqA_data <= AXI_rdrqA_data_value;
        if(AXI_arready = '1') then
            AXI_arvalid <= AXI_arvalid_value;
        end if;
        rdrqA_get_en <= rdrqA_get_en_value;
        if(rdrqA_get_valid = '1') then
            lol <= rdrqA_get_data;
        end if;
        wait until rising_edge(clk);
        if AXI_arready_value /= 'X' then
            assert AXI_arready = AXI_arready_value
            report "AXI_arready - expected '" & to_string(AXI_arready_value) &
                "' got '" & to_string(AXI_arready) & "'";
        end if;
        if rdrqA_get_valid_value /= 'X' then
            assert rdrqA_get_valid = rdrqA_get_valid_value
            report "rdrqA_get_valid - expected '" & to_string(rdrqA_get_valid_value) &
                "' got '" & to_string(rdrqA_get_valid) & "'";
        end if;
        if rdrqA_get_data_value.addr /= "XXXXXXXX" then
            assert rdrqA_get_data.addr = rdrqA_get_data_value.addr
            report "rdrqA_get_data - expected " & to_string(to_integer(signed(rdrqA_get_data_value.addr))) &
                " got " & to_string(to_integer(signed(rdrqA_get_data.addr)));
        end if;
        
    end procedure;
    begin
        test_runner_setup(runner, runner_cfg);

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        wait for 20 ns;
        rst <= '0';

        check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '1',
        AXI_rdrqA_data_value => (
          id => "000000000000",
          addr => "01010101",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        ),
        rdrqA_get_en_value => '1',
        rdrqA_get_valid_value => '0',
        rdrqA_get_data_value => (
          id => "XXXXXXXXXXXX",
          addr => "UUUUUUUU",
          len => "XXXX",
          size => "XXX",
          burst => "XX",
          lock => "XX",
          cache => "XXX",
          prot => "XXX",
          qos => "XXX"
        )
      );

      -- Cycle 1 - get_valid correct?
      check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '1',
        AXI_rdrqA_data_value => (
          id => "000000000000",
          addr => "11111111",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        ),
        rdrqA_get_en_value => '0',
        rdrqA_get_valid_value => '1',
        rdrqA_get_data_value => (
          id => "XXXXXXXXXXXX",
          addr => "01010101",
          len => "XXXX",
          size => "XXX",
          burst => "XX",
          lock => "XX",
          cache => "XXX",
          prot => "XXX",
          qos => "XXX"
        )
      );

      -- Cycle 2 get_valid and get_data correct? arready correct?.
      check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '1',
        AXI_rdrqA_data_value => (
          id => "000000000000",
          addr => "00111111",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        ),
        rdrqA_get_en_value => '1',
        rdrqA_get_valid_value => '0',
        rdrqA_get_data_value => (
          id => "000000000000",
          addr => "01010101",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        )
      );
      check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '1',
        AXI_rdrqA_data_value => (
          id => "000000000000",
          addr => "01111111",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        ),
        rdrqA_get_en_value => '1',
        rdrqA_get_valid_value => '0',
        rdrqA_get_data_value => (
          id => "000000000000",
          addr => "01010101",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        )
      );
      check_cycle (
        AXI_arready_value => '1',
        AXI_arvalid_value => '1',
        AXI_rdrqA_data_value => (
          id => "000000000000",
          addr => "11111111",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        ),
        rdrqA_get_en_value => '1',
        rdrqA_get_valid_value => '0',
        rdrqA_get_data_value => (
          id => "000000000000",
          addr => "01010101",
          len => "0000",
          size => "000",
          burst => "00",
          lock => "00",
          cache => "000",
          prot => "000",
          qos => "000"
        )
      );
        test_runner_cleanup(runner);
    end process;


end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_STD_FIFO_RdRqA of tb_STD_FIFO_RdRqA is
    for tb
    end for;
end cfg_tb_STD_FIFO_RdRqA;