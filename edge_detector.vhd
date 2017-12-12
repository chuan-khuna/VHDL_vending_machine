library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
  port(
    in_put: in std_logic;
    clk: in std_logic;
    out_falling: out std_logic
  );
end edge_detector;

architecture behavioral of edge_detector is
  signal temp: std_logic;
  
  begin    
    process(clk)
      begin
        if rising_edge(clk) then  
          temp <= in_put;
        end if;
    end process;

    out_falling <= not(not(temp) or in_put);    -- pulse at falling edge of input
  
end behavioral;
