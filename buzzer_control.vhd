library ieee;
use ieee.std_logic_1164.all;

entity buzzer_control is
  port(
    clk: in std_logic;
    buzzer_in: in std_logic;
    buzzer_out: out std_logic
  );
end buzzer_control;

architecture behavioral of buzzer_control is
  
  constant max: integer := 10-1;  -- 1/10x of clock freq
  signal tmp: std_logic := '0';
  signal count: integer := 0;
  signal EN: std_logic := '0';
  
  
  begin
    process(clk)
      begin
      if rising_edge(clk) then
        if buzzer_in = '1' then
          EN <= '1';
        end if;
      
        if EN = '1' then
          count <= count + 1;
          tmp <= '1';
          if count = max then
            count <= 0;
            tmp <= '0';
            EN <= '0';
          end if;
        end if;
      end if;
      
    end process;
    
  buzzer_out <= tmp;
  
end behavioral;
