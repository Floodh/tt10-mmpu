library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_mmpu is
    port (
        ui_in   : in  std_logic_vector(7 downto 0);
        uo_out  : out std_logic_vector(7 downto 0);
        uio_in  : in  std_logic_vector(7 downto 0);
        uio_out : out std_logic_vector(7 downto 0);
        uio_oe  : out std_logic_vector(7 downto 0);
        ena     : in  std_logic;
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_mmpu;

architecture Behavioral of tt_um_mmpu is
    signal mat3x3_0     :   unsigned(71 downto 0) := (others => '0');
    signal mat3x3_1     :   unsigned(71 downto 0) := (others => '0');
    signal driver_count :   unsigned( 4 downto 0) := (others => '0');
    signal shift_count  :   unsigned( 1 downto 0) := (others => '0');
begin
    uio_out <= "00000000";
    uio_oe  <= "00000000";

    process(clk, rst_n)
        variable result : std_logic_vector(15 downto 0); 
    begin

        if rst_n = '0' then
            mat3x3_0        <=  (others => '0');
            mat3x3_1        <=  (others => '0');
            driver_count    <=  (others => '0');
            uo_out          <=  (others => '0');
        elsif rising_edge(clk) then
            
            driver_count <= driver_count + 1;
            if driver_count < 10 then
                --  inputs
                mat3x3_0(71  downto 64)  <= unsigned(ui_in(7 downto 0));
                mat3x3_1(71  downto 64)  <= unsigned(uio_in(7 downto 0));
                --  rotations           
                mat3x3_0(63 downto 0) <= mat3x3_0(71 downto 8);
                mat3x3_1(63 downto 0) <= mat3x3_1(71 downto 8);
            else
                result :=     std_logic_vector(       
                    mat3x3_0( 7 downto  0) * mat3x3_1( 7 downto   0) +
                    mat3x3_0(15 downto  8) * mat3x3_1(31 downto  24) +
                    mat3x3_0(23 downto 16) * mat3x3_1(55 downto  48)
                );

                uo_out <= result(7 downto 0);
                
                --  colum shift left every clock cycle
                --  row 0
                mat3x3_1(15 downto  0) <= mat3x3_1(23 downto 8);
                mat3x3_1(23 downto 16) <= mat3x3_1( 7 downto 0);
                --  row 1
                mat3x3_1(39 downto 24) <= mat3x3_1(47 downto 32);
                mat3x3_1(47 downto 40) <= mat3x3_1(31 downto 24);
                --  row 2
                mat3x3_1(63 downto 48) <= mat3x3_1(71 downto 56);
                mat3x3_1(71 downto 64) <= mat3x3_1(55 downto 48);

                shift_count <= shift_count + 1;
                if shift_count(1 downto 0) = "10" then
                    --  row shift up every fourth clock cycle
                    --  colum 0
                    mat3x3_0( 7 downto  0) <= mat3x3_0(31 downto 24);
                    mat3x3_0(31 downto 24) <= mat3x3_0(55 downto 48);  
                    mat3x3_0(55 downto 48) <= mat3x3_0( 7 downto 0);                   
                    --  colum 1
                    mat3x3_0(15 downto  8) <= mat3x3_0(39 downto 32);
                    mat3x3_0(39 downto 32) <= mat3x3_0(63 downto 56);  
                    mat3x3_0(63 downto 56) <= mat3x3_0(15 downto  8);
                    --  colum 1
                    mat3x3_0(23 downto 16) <= mat3x3_0(47 downto 40);
                    mat3x3_0(47 downto 40) <= mat3x3_0(71 downto 64);  
                    mat3x3_0(71 downto 64) <= mat3x3_0(23 downto 16);
                    shift_count <= "00";
                end if;
            end if;
        end if;
    end process;
end Behavioral;