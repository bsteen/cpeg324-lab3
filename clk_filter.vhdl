library ieee;
use ieee.std_logic_1164.all;

entity clk_filter is
  port(
    clk_in : in std_logic;
    clk_out : out std_logic;
    S: in std_logic;
    trigger: in std_logic
  );
end entity clk_filter;

architecture structural of clk_filter is
  component dff is
     port
     (
        clk : in std_logic;
        R : in std_logic;
        D : in std_logic;
        Q : out std_logic
     );
  end component dff;
  component dl is
     port
     (
        E : in std_logic;
        D : in std_logic;
        Q : out std_logic
     );
  end component dl;
signal Q0,Q1,Q2,Q3,Q4,D3,D4 : std_logic;
begin
  dff0 : dff port map(clk_in,Q3,'1',Q0);
  dff1 : dff port map(clk_in,Q4,Q0,Q1);
  dff2 : dff port map(clk_in,open,Q1,Q2);
  dl0: dl port map(clk_in,D3,Q3);
  dl1: dl port map(clk_in,D4,Q4);

  D3<=S and D4;
  D4<=trigger and Q2 and Q1 and Q0;

  with Q2 select clk_out <=
    clk_in when '1',
    '0' when others;



end architecture structural;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff is
   port
   (
      clk : in std_logic;
      R : in std_logic;
      D : in std_logic;
      Q : out std_logic
   );
end entity dff;

architecture behavioral of dff is
begin
   process (clk) is
   begin
      if clk'event and clk='1' then
         if (R='1') then
            Q <= '0';
         else
            Q <= D;
         end if;
      end if;
   end process;
end architecture behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dl is
   port
   (
      E : in std_logic;
      D : in std_logic;
      Q : out std_logic
   );
end entity dl;

architecture behavioral of dl is
begin
   process (E) is
   begin
      if E='1' then
        Q <= D;
      end if;
   end process;
end architecture behavioral;
