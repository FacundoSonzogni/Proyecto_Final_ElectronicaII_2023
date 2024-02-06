library IEEE;
use IEEE.std_logic_1164.all;

entity control_vga is
    port (
        clk       : in std_logic;
        sincr_hor : out std_logic;
        sincr_ver : out std_logic;
        red       : out std_logic;
        green     : out std_logic;
        blue      : out std_logic);
end control_vga;

architecture solucion of control_vga is
    signal cont_vert_sig, cont_vert_act : std_logic_vector (9 downto 0);
    signal cont_hor_sig, cont_hor_act   : std_logic_vector (9 downto 0);
    signal rst_vert, rst_hor            : std_logic;
    signal vertical_on, horizontal_on   : std_logic;
    signal ancho_bloque, largo_bloque   : std_logic; 
begin

contador_horizontal_vertical : process (all)
begin
    if rst_hor = '1' then
        cont_hor_sig <= (others => '0');
    elsif rising_edge(clk) then
        cont_hor_sig <= std_logic_vector (to_unsigned(cont_hor_act) + 1);
    end if;

    if (cont_hor_act = "1100011111") then 
        rst_hor = '1'
    end if;

end process;

contador_vertical : process (all)
begin
    if rst_vert = '1' then
        cont_vert_sig <= (others => '0');
    elsif (cont_hor_act = "1100011111") then
    cont_vert_sig <= std_logic_vector (to_unsigned(cont_ver_act) + 1);   
    end if;

    if (cont_hor_act = "1000001100") then 
        rst_hor = '1'
    end if;

end process;

-- Sincronización Horizontal

sincr_hor <= '0' when (cont_hor_act > "1010001111") and (cont_hor_act < "1011101111") else
             '1';

horizontal_on <= '0' when (cont_hor_act > "1001111111") and (cont_hor_act < "1100011111") else
                 '1';

-- Sincronización Vertical

sincr_ver <= '0' when (cont_vert_act > "0111101001") and (cont_vert_act < "0111101011") else
             '1';

vertical_on <= '0' when (cont_vert_act > "0111011111") and (cont_vert_act < "1000001100") else
               '1';

-- Prueba: Dividir la pantalla en bloques 10x10

ancho_bloque <= '0' when ((cont_hor_act > "0000000000") and (cont_hor_act < "0001000000")) or
                         ((cont_hor_act > "0010000000") and (cont_hor_act < "0011000000")) or
                         ((cont_hor_act > "0100000000") and (cont_hor_act < "0101000000")) or
                         ((cont_hor_act > "0110000000") and (cont_hor_act < "0111000000")) or
                         ((cont_hor_act > "1000000000") and (cont_hor_act < "1001000000")) else
                '1';

largo_bloque <= '0' when ((cont_hor_act > "0000000000") and (cont_hor_act < "0000110000")) or
                         ((cont_hor_act > "0001100000") and (cont_hor_act < "0010010000")) or
                         ((cont_hor_act > "0011000000") and (cont_hor_act < "0011110000")) or
                         ((cont_hor_act > "0100100000") and (cont_hor_act < "0101010000")) or
                         ((cont_hor_act > "0110000000") and (cont_hor_act < "0110110000")) else
                '1';

-- Prueba de color (Toda la pantalla roja+verde)

red <= '1' when ancho_bolque = '1' and largo_bloque = '1' else
       '0';

green <= '1' when ancho_bolque = '1' and largo_bloque = '1' else       
         '0';

blue <= '1' when ancho_bolque = '0' and largo_bloque = '0' else
        '0';
  



end architecture;
