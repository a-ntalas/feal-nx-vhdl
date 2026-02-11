library ieee;
use ieee.std_logic_1164.all;



entity k is
generic (N : integer := 32);
port(
k: in std_logic_vector(127 downto 0);
dummy: out std_logic_vector(31 downto 0)
);
end k;

architecture easy of k is
  component fk is
  port(
  a: in std_logic_vector(31 downto 0);
  b: in std_logic_vector(31 downto 0);
  f: out std_logic_vector(31 downto 0)
  );
  end component;

  type type_32x3 is array(0 to 2) of std_logic_vector(31 downto 0);
  type type_32xM is array(0 to N/2 + 3) of std_logic_vector(31 downto 0);

  signal q : type_32x3;
  signal a, b, fk_1, fk_2, fk_out, d: type_32xM;
      
  begin

    a(0) <= k(127 downto 96);
    b(0) <= k(95 downto 64);

    fk_1(0) <= a(0);
    fk_2(0) <= b(0) xor q(0);

    U0: fk port map (a => fk_1(0) , b => fk_2(0) , f => fk_out(0));

    q(0) <= k(63 downto 32) xor k(31 downto 0);
    q(1) <= k(63 downto 32);
    q(2) <= k(31 downto 0);

UN: for i in 1 to N/2 + 3 generate
        a(i) <= b(i-1);
        b(i) <= fk_out(i-1);
        d(i) <= a(i-1);
        
        fk_1(i) <= a(i);
        fk_2(i) <= (b(i) xor q(i mod 3)) xor d(i);

        UN: fk port map (a => fk_1(i) , b => fk_2(i) , f => fk_out(i));

    end generate;

    dummy <= fk_out(N/2+3);

end easy;

-- add_force {/k/k} -radix hex {0123456789abcdef0123456789abcdef 0ns}