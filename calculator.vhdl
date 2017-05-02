-- Benjamin Steenkamer and Abraham McIlvaine
-- CPEG 324-010
-- Lab 3: Single Cycle Calculator in VHDL - calculator.vhdl
-- 5/3/17

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
  port(
    I : in std_logic_vector(7 downto 0); --instruction input
    clk : in std_logic
  );
end entity calculator;


architecture structural of calculator is
  component addsub_8bit is
      port(
          input_a, input_b : in std_logic_vector(7 downto 0);
          addsub_sel : in std_logic; --0 = addition, 1 is subtraction.
          sum : out std_logic_vector(7 downto 0)
        );
  end component addsub_8bit;
  component reg_file is
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
  end component reg_file;

  component clk_filter is
    port(
      clk_in : in std_logic;
      clk_out : out std_logic;
      S: in std_logic;
      trigger: in std_logic
    );
  end component clk_filter;

signal filtered_clk,WE,display,WD_sel,trigger,cmp_out : std_logic;
signal RA,RB,RW : std_logic_vector(1 downto 0);
signal WD,RA_data,RB_data,sign_ext_imm,ALU_out: std_logic_vector(7 downto 0);
begin
  reg_file_0 : reg_file port map(RA,RB,RW,WD,filtered_clk,WE,RA_data,RB_data);
  ALU: addsub_8bit port map(RA_data,RB_data,I(7),ALU_out);
  clk_filter_0 : clk_filter port map(clk,filtered_clk,I(4),trigger);

  RB <= I(1 downto 0);
  RW <= I(5 downto 4);
  display <= not (I(7) or I(6) or I(5));

  with display select RA <=
    I(3 downto 2) when '0',
    I(4 downto 3) when others;

  sign_ext_imm(3 downto 0) <= I(3 downto 0);
  with I(3) select sign_ext_imm(7 downto 4) <=
    "1111" when '1',
    "0000" when others;

  --Select whether signed extedend immediate value or ALU results to written to RW.
  WD_sel <= not(I(7) and I(6));
  with WD_sel select WD <=
    sign_ext_imm when '0',
    ALU_out when others;

  WE <= I(7) or I(6);--Is WD written to RW?

  trigger <= (not I(7)) and (not I(6)) and I(5) and cmp_out;

  cmp_out <= (RA_data(7) xnor RB_data(7)) and
            (RA_data(6) xnor RB_data(6)) and
            (RA_data(5) xnor RB_data(5)) and
            (RA_data(4) xnor RB_data(4)) and
            (RA_data(3) xnor RB_data(3)) and
            (RA_data(2) xnor RB_data(2)) and
            (RA_data(1) xnor RB_data(1)) and
            (RA_data(0) xnor RB_data(0));

  --The display function
  process(filtered_clk,display) is
    variable int_val : integer;
    begin
      --report std_logic'image(filtered_clk);
      if((filtered_clk'event and filtered_clk = '1') and (display = '1')) then
        int_val := to_integer(signed(RA_data));
        if(int_val >= 0) then
          if(int_val < 10) then
            report "   " & integer'image(int_val) severity note;
          elsif(int_val < 100) then
            report "  " & integer'image(int_val) severity note;
          else
            report " " & integer'image(int_val) severity note;
          end if;
        else --Display value is negative
          if(int_val > -10) then
            report "  " & integer'image(int_val) severity note;
          elsif(int_val > -100) then
            report " " & integer'image(int_val) severity note;
          else
            report integer'image(int_val) severity note;
          end if;
        end if;
      end if;
  end process;




end architecture structural;
