library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lcd16x2_ctrl is
  port (
    clk: in std_logic;
    state: in std_logic;
    item: in  std_logic_vector(1 downto 0);
    digit1: in std_logic_vector(7 downto 0);
    digit0: in std_logic_vector(7 downto 0);  

    lcd_e: out std_logic;
    lcd_rs: out std_logic;
    lcd_rw: out std_logic;
    lcd_db: out std_logic_vector(7 downto 4));
end entity lcd16x2_ctrl;

architecture behavior of lcd16x2_ctrl is

  signal line1: std_logic_vector(127 downto 0);
  signal line2: std_logic_vector(127 downto 0);

  constant CLK_PERIOD_NS : positive := 5; -- 50 Mhz

  signal rst: std_logic;
  signal line1_buffer: std_logic_vector(127 downto 0);
  signal line2_buffer: std_logic_vector(127 downto 0);

begin  
  DUT : entity work.lcd_ip
    generic map (
      CLK_PERIOD_NS => CLK_PERIOD_NS)
    port map (
      clk          => clk,
      rst          => rst,
      lcd_e        => lcd_e,
      lcd_rs       => lcd_rs,
      lcd_rw       => lcd_rw,
      lcd_db       => lcd_db,
      line1_buffer => line1_buffer,
      line2_buffer => line2_buffer
    );

  rst <= '0';

  line1_buffer <= line1;
  line2_buffer <= line2;

  process(clk)
    begin
    if rising_edge(clk) then
      if state = '0' then   -- X"hex"
        line1(127 downto 120) <= X"53";   -- S
        line1(119 downto 112) <= X"45";   -- E
        line1(111 downto 104) <= X"4C";   -- L
        line1(103 downto 96)  <= X"45";   -- E
        line1(95 downto 88)   <= X"43";   -- C
        line1(87 downto 80)   <= X"54";   -- T
        line1(79 downto 72)   <= X"20"; 
        line1(71 downto 64)   <= X"49";   -- I
        line1(63 downto 56)   <= X"54";   -- T
        line1(55 downto 48)   <= X"45";   -- E
        line1(47 downto 40)   <= X"4D";   -- M
        line1(39 downto 32)   <= X"20";   
        line1(31 downto 24)   <= X"20";
        line1(23 downto 16)   <= X"20";
        line1(15 downto 8)    <= X"20";
        line1(7 downto 0)     <= X"20";
      end if;

      if state = '1' then
        line1(127 downto 120) <= X"45";   -- E
        line1(119 downto 112) <= X"4E";   -- N
        line1(111 downto 104) <= X"54";   -- T
        line1(103 downto 96)  <= X"45";   -- E
        line1(95 downto 88)   <= X"52";   -- R
        line1(87 downto 80)   <= X"20";
        line1(79 downto 72)   <= X"43";   -- C 
        line1(71 downto 64)   <= X"4F";   -- O
        line1(63 downto 56)   <= X"49";   -- I
        line1(55 downto 48)   <= X"4E";   -- N
        line1(47 downto 40)   <= X"20";
        line1(39 downto 32)   <= X"20";   
        line1(31 downto 24)   <= X"20";
        line1(23 downto 16)   <= X"20";
        line1(15 downto 8)    <= X"20";
        line1(7 downto 0)     <= X"20";
      end if;

      case item is
          when "00" =>
            line2(127 downto 120) <= X"49";  -- I
            line2(119 downto 112) <= X"37";  -- 7
            line2(111 downto 104) <= X"20";
            line2(103 downto 96)  <= X"37";  -- 7
            line2(95 downto 88)   <= X"37";  -- 7
            line2(87 downto 80)   <= X"30";  -- 0
            line2(79 downto 72)   <= X"30";  -- 0
            line2(71 downto 64)   <= X"4B";  -- K
            line2(63 downto 56)   <= X"20";
            line2(55 downto 48)   <= X"20";
            line2(47 downto 40)   <= X"20";
            line2(39 downto 32)   <= X"20";
            line2(31 downto 24)   <= X"20";
            line2(23 downto 16)   <= X"20";
            line2(15 downto 8)    <= digit1; -- price 1
            line2(7 downto 0)     <= digit0; -- price 0

          when "01" =>
            line2(127 downto 120) <= X"49";  -- I
            line2(119 downto 112) <= X"35";  -- 5
            line2(111 downto 104) <= X"20";
            line2(103 downto 96)  <= X"37";  -- 7
            line2(95 downto 88)   <= X"36";  -- 6
            line2(87 downto 80)   <= X"30";  -- 0
            line2(79 downto 72)   <= X"30";  -- 0
            line2(71 downto 64)   <= X"75";  -- K
            line2(63 downto 56)   <= X"20";
            line2(55 downto 48)   <= X"20";
            line2(47 downto 40)   <= X"20";
            line2(39 downto 32)   <= X"20";
            line2(31 downto 24)   <= X"20";
            line2(23 downto 16)   <= X"20";
            line2(15 downto 8)    <= digit1; -- price 1
            line2(7 downto 0)     <= digit0; -- price 0

          when "10" =>
            line2(127 downto 120) <= X"52";  -- R
            line2(119 downto 112) <= X"37";  -- 7
            line2(111 downto 104) <= X"20";
            line2(103 downto 96)  <= X"31";  -- 1
            line2(95 downto 88)   <= X"37";  -- 7
            line2(87 downto 80)   <= X"30";  -- 0
            line2(79 downto 72)   <= X"30";  -- 0
            line2(71 downto 64)   <= X"58";  -- X
            line2(63 downto 56)   <= X"20";
            line2(55 downto 48)   <= X"20";
            line2(47 downto 40)   <= X"20";
            line2(39 downto 32)   <= X"20";
            line2(31 downto 24)   <= X"20";
            line2(23 downto 16)   <= X"20";
            line2(15 downto 8)    <= digit1; -- price 1
            line2(7 downto 0)     <= digit0; -- price 0

          when "11" =>
            line2(127 downto 120) <= X"52";  -- R
            line2(119 downto 112) <= X"35";  -- 5
            line2(111 downto 104) <= X"20";
            line2(103 downto 96)  <= X"31";  -- 1
            line2(95 downto 88)   <= X"36";  -- 7
            line2(87 downto 80)   <= X"30";  -- 0
            line2(79 downto 72)   <= X"30";  -- 0
            line2(71 downto 64)   <= X"58";  -- X
            line2(63 downto 56)   <= X"20";
            line2(55 downto 48)   <= X"20";
            line2(47 downto 40)   <= X"20";
            line2(39 downto 32)   <= X"20";
            line2(31 downto 24)   <= X"20";
            line2(23 downto 16)   <= X"20";
            line2(15 downto 8)    <= digit1;  -- price 1
            line2(7 downto 0)     <= digit0;  -- price 0
        end case;
      end if;
  end process;
end architecture behavior;
