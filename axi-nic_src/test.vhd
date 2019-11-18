entity tristate is
  port(
    a:  in  STD_LOGIC_VECTOR(3 downto 0);
    en: in  STD_LOGIC;
    y:  out STD_LOGIC_VECTOR(3 downto 0)
  );
end;
architecture lol of tristate is begin
    jaja: process begin
        if en='1' then
          y<=a;
        end if;
    end process;
end lol;

library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mux2 is

 port(d0, d1: in  STD_LOGIC_VECTOR(3 downto 0);

 s: in  STD_LOGIC;

 y: out STD_LOGIC_VECTOR(3 downto 0));

end;

architecture struct of mux2 is

 signal sbar: STD_LOGIC;

begin

 sbar <= not s;

 t0:  entity work.tristate(lol)  port  map(
 	a => d0, 
    en => "not"(s),
    "not"(y) => y
 );

 t1:  entity work.tristate(lol)  port  map(d1, s, y);

end;