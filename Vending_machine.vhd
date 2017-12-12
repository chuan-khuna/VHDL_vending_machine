library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Vending_machine is
  port(
    sw: in std_logic_vector(1 downto 0);
    coin_1: in std_logic;
    coin_5: in std_logic;
    coin_10: in std_logic;
    buy: in std_logic;
    clk: in std_logic;
    
    ed_buy_out : out std_logic;
    price_out0: out std_logic_vector(7 downto 0);
    price_out1: out std_logic_vector(7 downto 0);
    state_out: out std_logic;
    item_out: out std_logic_vector(1 downto 0);
    buzzer: out std_logic
  );

end Vending_machine;

architecture Structural of Vending_machine is
  
  signal state: std_logic := '0';
  
  -- debounced sw
  signal db_1: std_logic;
  signal db_5: std_logic;
  signal db_10: std_logic;
  signal db_buy: std_logic;
  
  -- edge detected sw
  signal ed_1: std_logic;
  signal ed_5: std_logic;
  signal ed_10: std_logic;
  signal ed_buy: std_logic;
  
  -- output
  signal buzzer_EN: std_logic := '0';
  signal digit0: std_logic_vector(7 downto 0);
  signal digit1: std_logic_vector(7 downto 0);
  signal price: integer;
  signal item: std_logic_vector(1 downto 0);
  
  component debounceSW is
    port(
      CLK: in std_logic;
      BT: in std_logic;
      result: out std_logic
    );
  end component;
  
  component edge_detector is
    port(
      in_put: in std_logic;
      clk: in std_logic;
      out_falling: out std_logic
    );
  end component;
  
  component Split_digit is
    port(
      price_in : in integer;
      digit_0 : out std_logic_vector(7 downto 0);
      digit_1 : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component buzzer_control is
    port(
      clk: in std_logic;
      buzzer_in: in std_logic;
      buzzer_out: out std_logic
    );
  end component;
  
  
  component lcd16x2_ctrl is
    port(
      clk: in std_logic;
      state: in std_logic;
      item: in  std_logic_vector(1 downto 0);
      digit1: in std_logic_vector(7 downto 0);
      digit0: in std_logic_vector(7 downto 0);  
      
      lcd_e: out std_logic;
      lcd_rs: out std_logic;
      lcd_rw: out std_logic;
      lcd_db: out std_logic_vector(7 downto 4)
    );
  end component;

  begin
  
    debounce_coin1: debounceSW
      port map(clk, coin_1, db_1);
    
    debounce_coin5: debounceSW
      port map(clk, coin_5, db_5);
    
    debounce_coin10: debounceSW
      port map(clk, coin_10, db_10);
      
    debounce_buy: debounceSW
      port map(clk, buy, db_buy);
  
    edge_detect_coin1: edge_detector
      port map(db_1, clk, ed_1);
    
    edge_detect_coin5: edge_detector
      port map(db_5, clk, ed_5);
    
    edge_detect_coin10: edge_detector
      port map(db_10, clk, ed_10);
  
    edge_detect_buy: edge_detector
      port map(db_buy, clk, ed_buy);
  
    split: Split_digit
      port map(price, digit0, digit1);
  
    buzzer_1sec: buzzer_control
      port map(clk, buzzer_EN, buzzer);
      
    controlLCD: lcd16x2_ctrl
      port map(clk, state, item, digit1, digit0);
  
  process(clk)
    begin
      if rising_edge(clk) then
        -- select item state = 0
        -- buy state = 1
        if state = '0' and ed_buy = '1' then
          state <=  '1';
          case sw is
            when "00" => 
              price <= 96;  -- i7 96 baht
              item <= "00";
            when "01" => 
              price <= 65;  -- i5 65 baht
              item <= "01";
            when "10" => 
              price <= 60;  -- r7 60 baht
              item <= "10";
            when "11" => 
              price <= 49;  -- r5 49 baht
              item <= "11";
          end case;
        elsif state = '1' and ed_buy = '1' then
          state <= '0';
          buzzer_EN <= '1';
        end if;
        
        -- state 1--
        if state = '1' then
          if price > 0 then
            if ed_1 = '1' then
              price <= price - 1;
            elsif ed_5 ='1' then
              price <= price - 5;
            elsif ed_10 = '1' then
              price <= price - 10;
            end if;  
          end if;
          
          if price <= 0 then
              --price <= 0;
              state <= '0';
              buzzer_EN <= '1';
          end if;  
          
        -- state 0 --  
        elsif state = '0' then
          buzzer_EN <= '0';
          case sw is
            when "00" => 
              price <= 96;  -- i7 96 baht
              item <= "00";
            when "01" => 
              price <= 65;  -- i5 65 baht
              item <= "01";
            when "10" => 
              price <= 60;  -- r7 60 baht
              item <= "10";
            when "11" => 
              price <= 49;  -- r5 49 baht
              item <= "11";
          end case;
        end if;        
      end if;
    end process;
    
  state_out <= state;
  ed_buy_out <= ed_buy;
  price_out0 <= digit0;
  price_out1 <= digit1;
  item_out <= item;
  
end Structural;


-- convert int to vector 
-- std_logic_vector( to_unsigned((#int), #bits) )
-- import numeric_std