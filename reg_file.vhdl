-- Benjamin Steenkamer and Abraham McIlvaine
-- CPEG 324-010
-- Lab 3: Single Cycle Calculator in VHDL - reg_file.vhdl
-- 5/3/17

library ieee;
use ieee.std_logic_1164.all;
--Contains 4, 8 bit registers that are initialized to 0.
entity reg_file is
  port(
    RA : in std_logic_vector(1 downto 0);
    RB : in std_logic_vector(1 downto 0);
    RW : in std_logic_vector(1 downto 0);
    WD : in std_logic_vector(7 downto 0);
    CLK : in std_logic;
    WE : in std_logic;
    RA_data : out std_logic_vector(7 downto 0);
    RB_data : out std_logic_vector(7 downto 0)
  );
end entity reg_file;

architecture behavioral of reg_file is
  signal R0 : std_logic_vector(7 downto 0) := "00000000";
  signal R1 : std_logic_vector(7 downto 0) := "00000000";
  signal R2 : std_logic_vector(7 downto 0) := "00000000";
  signal R3 : std_logic_vector(7 downto 0) := "00000000";

  begin
    --Reads are combinational.
    with RA select RA_data <=
      R0 when "00",
      R1 when "01",
      R2 when "10",
      R3 when others;
    with RB select RB_data <=
      R0 when "00",
      R1 when "01",
      R2 when "10",
      R3 when others;

    --Writes only happen on the rising edge of the clock.
    process (CLK) is
      begin
        if (CLK'event and CLK='1') then
          if (WE = '1') then
            if (RW = "00") then
              R0 <= WD;
            elsif (RW = "01") then
              R1 <= WD;
            elsif (RW = "10") then
              R2 <= WD;
            elsif (RW = "11") then
              R3 <= WD;
            end if;
          end if;
        end if;
      end process;
    end architecture;
