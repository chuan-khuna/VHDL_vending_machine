library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity Split_digit is
  port(
    price_in : in integer;
    digit_0 : out std_logic_vector(7 downto 0);
    digit_1 : out std_logic_vector(7 downto 0)
  );
end Split_digit;

architecture dataflow of Split_digit is
  begin
  process(price_in)
    begin
    digit_0 <= std_logic_vector( to_unsigned(30 + (price_in mod 10), 8) );
    digit_1 <= std_logic_vector( to_unsigned(30 + (price_in / 10), 8) );
  end process;
end dataflow;