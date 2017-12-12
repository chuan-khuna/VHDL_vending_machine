library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounceSW is
  port(
    CLK: in std_logic;
    BT: in std_logic;
    result: out std_logic
  );
end debounceSW;

architecture debounce of debounceSW is
  signal inff: std_logic_vector(1 downto 0);
  constant max: integer := 5;   -- 100000 = delay 2ms
  signal count: integer range 0 to max := 0; 
  signal keepRes: std_logic := '1';
  
  begin
    result <= keepRes;
  process(CLK)
    begin
      if (rising_edge(CLK)) then
        inff <= inff(0) & BT;
        if (inff(0) /= inff(1)) then
          count <= 0;
        elsif (count < max) then
          count <= count + 1;
        else
          keepRes <= inff(1);
        end if;
      end if;
  end process;
  
end debounce;