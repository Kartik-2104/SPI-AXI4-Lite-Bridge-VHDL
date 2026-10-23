library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_spi_axi_bridge is
end tb_spi_axi_bridge;

architecture Behavioral of tb_spi_axi_bridge is

    ------------------------------------------------
    -- COMPONENT DECLARATION
    ------------------------------------------------

    component spi_axi_bridge
        Port (

            sclk    : in  STD_LOGIC;
            cs      : in  STD_LOGIC;
            mosi    : in  STD_LOGIC;
            miso    : out STD_LOGIC;

            reset   : in  STD_LOGIC;

            awaddr  : out STD_LOGIC_VECTOR(7 downto 0);
            awvalid : out STD_LOGIC;

            wdata   : out STD_LOGIC_VECTOR(7 downto 0);
            wvalid  : out STD_LOGIC;

            araddr  : out STD_LOGIC_VECTOR(7 downto 0);
            arvalid : out STD_LOGIC;

            rdata   : out STD_LOGIC_VECTOR(7 downto 0);
            rvalid  : out STD_LOGIC
        );
    end component;

    ------------------------------------------------
    -- SIGNALS
    ------------------------------------------------

    signal sclk    : STD_LOGIC := '0';
    signal cs      : STD_LOGIC := '1';
    signal mosi    : STD_LOGIC := '0';
    signal miso    : STD_LOGIC;

    signal reset   : STD_LOGIC := '0';

    signal awaddr  : STD_LOGIC_VECTOR(7 downto 0);
    signal awvalid : STD_LOGIC;

    signal wdata   : STD_LOGIC_VECTOR(7 downto 0);
    signal wvalid  : STD_LOGIC;

    signal araddr  : STD_LOGIC_VECTOR(7 downto 0);
    signal arvalid : STD_LOGIC;

    signal rdata   : STD_LOGIC_VECTOR(7 downto 0);
    signal rvalid  : STD_LOGIC;

begin

    ------------------------------------------------
    -- DUT
    ------------------------------------------------

    uut : spi_axi_bridge
        port map (
            sclk    => sclk,
            cs      => cs,
            mosi    => mosi,
            miso    => miso,

            reset   => reset,

            awaddr  => awaddr,
            awvalid => awvalid,

            wdata   => wdata,
            wvalid  => wvalid,

            araddr  => araddr,
            arvalid => arvalid,

            rdata   => rdata,
            rvalid  => rvalid
        );

    ------------------------------------------------
    -- TEST PROCESS
    ------------------------------------------------

    process
    begin

        ------------------------------------------------
        -- RESET
        ------------------------------------------------

        reset <= '1';
        wait for 20 ns;

        reset <= '0';
        wait for 20 ns;

        ------------------------------------------------
        -- WRITE TRANSACTION
        ------------------------------------------------

        cs <= '0';

        -- COMMAND = 00000001

        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';

        -- ADDRESS = 00000100

        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';

        -- DATA = 10101010

        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';

        cs <= '1';

        ------------------------------------------------
        -- GAP
        ------------------------------------------------

        wait for 50 ns;

        ------------------------------------------------
        -- READ TRANSACTION
        ------------------------------------------------

        cs <= '0';

        -- COMMAND = 00000010

        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';

        -- ADDRESS = 00000100

        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '1'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';
        mosi <= '0'; wait for 10 ns; sclk <= '1'; wait for 10 ns; sclk <= '0';

        cs <= '1';

        ------------------------------------------------
        -- FINISH
        ------------------------------------------------

        wait for 200 ns;

        wait;

    end process;

end Behavioral;