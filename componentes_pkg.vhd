library IEEE;
use IEEE.std_logic_1164.all;

package componentes_pkg is
    component contador_johnson is
        generic (
            constant N:positive);
        port (
        rst   : in std_logic;
        hab   : in std_logic;
        clk   : in std_logic;
        Q     : out std_logic_vector (N-1 downto 0);
        Co    : out std_logic);
    end component;

    component contador is
        generic (
            constant N : natural);
        port (
        rst   : in std_logic;
        D     : in std_logic_vector (N-1 downto 0);
        carga : in std_logic;
        hab   : in std_logic;
        clk   : in std_logic;
        Q     : out std_logic_vector (N-1 downto 0);
        Co    : out std_logic);
    end component;

    component teclado_matricial is
        port (
        clk     : in std_logic;
        hab     : in std_logic;
        rst     : in std_logic;
        columna : in std_logic_vector (2 downto 0);
        fila    : in std_logic_vector (3 downto 0)); 
    end component;

    component ingreso_numero is 
        port (); 
    end component;

    component sumador is 
        port (); 
    end component;

    component restador is 
        port (); 
    end component;

    component multiplicador is 
        port (); 
    end component;

    component divisor is 
        port (); 
    end component;

end package;

----------------- CONTADOR JOHNSON ---------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity contador_johnson is
    generic (
        constant N:positive);
    port (
        rst   : in std_logic;
        hab   : in std_logic;
        clk   : in std_logic;
        Q     : out std_logic_vector (N-1 downto 0);
        Co    : out std_logic);
end contador_johnson;

architecture solucion of contador_johnson is
    signal Qact, Qsig : std_logic_vector (N-1 downto 0);
begin

    MEMORIA : process (rst, clk)
    begin
        if rst = '1' then
            Qact <= (others => '0');
        elsif (clk 'event and clk = '1') then
            Qact <= Qsig;
        end if;
    end process;

    LOGICA_ES : process (hab, Qact)
    begin
        if hab = '1' then
            Qsig <= Qact (N-2 downto 0) & not Qact(N-1);
        else
            Qsig <= Qact;
        end if;
    end process;

    LOGICA_SAL: process (Qact)
    begin
        Q <= Qact;
        if Qact(N-1) = '1' and Qact(N-2) = '0' then
            Co <= '1';
        else
            Co <= '0';
        end if;
    end process;

end solucion;

--------------------- CONTADOR ------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity contador is 
    generic (
        constant N : natural);
    port (
    rst   : in std_logic;
    D     : in std_logic_vector (N-1 downto 0);
    carga : in std_logic;
    hab   : in std_logic;
    clk   : in std_logic;
    Q     : out std_logic_vector (N-1 downto 0);
    Co    : out std_logic);
end contador;

architecture solucion_contador of contador is
    signal EstadoActual, EstadoSig : std_logic_vector (N-1 downto 0);
begin
    
    MEMORIA : process(all)
    begin
        if rst = '1' then 
            EstadoActual <= (others => '0');
        elsif rising_edge(clk) then 
            EstadoActual <= EstadoSig;
        end if;
    end process;
    
    LOGICA_SAL: process (all)
        begin 
            Q <= EstadoActual;
            if EstadoActual = (N-1 downto 0 => '1') then 
                Co <= '1'; 
            else 
                Co <= '0';
            end if;
        end process;

    LOGICA_ES : process (all)
    begin
        if hab = '0' then EstadoSig <= EstadoActual;
        elsif carga ='1' then EstadoSig <= D;
        else EstadoSig <= std_logic_vector(unsigned (EstadoActual) + 1);       
        end if ;
    end process;

end architecture;

--------------- TECLADO_MATRICIAL ------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity teclado_matricial is 
    port (
    clk             : in std_logic;
    hab             : in std_logic;
    rst             : in std_logic;
    columna         : in std_logic_vector (2 downto 0);
    fila            : in std_logic_vector (3 downto 0);
    digito_elegido  : out std_logic_vector (3 downto 0);
    remover_digito  : out std_logic;
    ingresar_digito : out std_logic);
end teclado_matricial;

architecture solucion of teclado_matricial is
    signal desborde : std_logic;

    component contador_johnson is
        generic (
            constant N:positive);
        port (
        rst   : in std_logic;
        hab   : in std_logic;
        clk   : in std_logic;
        Q     : out std_logic_vector (N-1 downto 0);
        Co    : out std_logic);
    end component;

begin

Contador_Johnson : contador_johnson generic map (N => 4) port map ( 
        rst     => rst,
        hab     => hab,
        clk     => clk,
        Q       => not fila,
        Co      => desborde
    );

ingresar_digito <= '1' when (columna = "001" and fila = "0001") else
                <= '0';

remover_digito <= '1' when (columna = "100" and fila = "0001") else
               <= '0';

digito_elegido <= "0000" when (columna = "010" and fila = "0001") else
               <= "0001" when (columna = "100" and fila = "1000") else
               <= "0010" when (columna = "010" and fila = "1000") else
               <= "0011" when (columna = "001" and fila = "1000") else
               <= "0100" when (columna = "100" and fila = "0100") else
               <= "0101" when (columna = "010" and fila = "0100") else
               <= "0110" when (columna = "001" and fila = "0100") else
               <= "0111" when (columna = "100" and fila = "0010") else
               <= "1000" when (columna = "010" and fila = "0010") else
               <= "1001" when (columna = "001" and fila = "0010") else
               <= "1111";         
end architecture;

--------------- INGRESO_NUMERO ---------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity ingreso_numero is 
    port (
        clk            : in std_logic;
        remover        : in std_logic;
        ingresar       : in std_logic;
        digito         : in std_logic_vector (3 downto 0);
        numero_elegido : out integer; 
    );
end ingreso_numero;

architecture solucion of ingreso_numero is
    signal X_sig, X_act, Y_sig, Y_act, digito_entero : integer;
    signal cont_sig, cont_act : std_logic_vector (3 downto 0);

    component contador is
        generic (
            constant N : natural);
        port (
        rst   : in std_logic;
        D     : in std_logic_vector (N-1 downto 0);
        carga : in std_logic;
        hab   : in std_logic;
        clk   : in std_logic;
        Q     : out std_logic_vector (N-1 downto 0);
        Co    : out std_logic);
    end component;

begin

digito_entero <= to_integer(digito); 

MEMORIA : process (all)
begin
    if rising_edge(clk) then
        X_act <= X_sig;
        cont_act <= cont_sig;
    end if;
end process; 

end architecture;

------------------ SUMADOR -------------------------

------------------ RESTADOR ------------------------

------------------ MULTIPLICADOR -------------------

-------------------- DIVISOR -----------------------