library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_axi_bridge is
    Port (

        ------------------------------------------------
        -- SPI SIGNALS
        ------------------------------------------------

        sclk    : in  STD_LOGIC;
        cs      : in  STD_LOGIC;
        mosi    : in  STD_LOGIC;
        miso    : out STD_LOGIC;

        ------------------------------------------------
        -- RESET
        ------------------------------------------------

        reset   : in STD_LOGIC;

        ------------------------------------------------
        -- AXI4-LITE WRITE ADDRESS CHANNEL
        ------------------------------------------------

        awaddr  : out STD_LOGIC_VECTOR(7 downto 0);
        awvalid : out STD_LOGIC;

        ------------------------------------------------
        -- AXI4-LITE WRITE DATA CHANNEL
        ------------------------------------------------

        wdata   : out STD_LOGIC_VECTOR(7 downto 0);
        wvalid  : out STD_LOGIC;

        ------------------------------------------------
        -- AXI4-LITE READ ADDRESS CHANNEL
        ------------------------------------------------

        araddr  : out STD_LOGIC_VECTOR(7 downto 0);
        arvalid : out STD_LOGIC;

        ------------------------------------------------
        -- AXI4-LITE READ DATA CHANNEL
        ------------------------------------------------

        rdata   : out STD_LOGIC_VECTOR(7 downto 0);
        rvalid  : out STD_LOGIC

    );
end spi_axi_bridge;

architecture Behavioral of spi_axi_bridge is

    ------------------------------------------------
    -- FSM STATES
    ------------------------------------------------

    type state_type is (
        IDLE,
        GET_ADDRESS,
        WRITE_DATA,
        READ_DATA
    );

    signal current_state : state_type := IDLE;

    ------------------------------------------------
    -- SHIFT REGISTERS
    ------------------------------------------------

    signal rx_shift_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    signal tx_shift_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    ------------------------------------------------
    -- BIT COUNTER
    ------------------------------------------------

    signal bit_count : integer range 0 to 7 := 0;

    ------------------------------------------------
    -- COMMAND + ADDRESS
    ------------------------------------------------

    signal command_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    signal address_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    ------------------------------------------------
    -- SIMPLE AXI MEMORY
    ------------------------------------------------

    type reg_array is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);

    signal axi_mem : reg_array := (others => (others => '0'));

begin

    ------------------------------------------------
    -- MAIN PROCESS
    ------------------------------------------------

    process(sclk, reset)

    begin

        ------------------------------------------------
        -- RESET
        ------------------------------------------------

        if reset = '1' then

            current_state <= IDLE;

            bit_count <= 0;

            awvalid <= '0';
            wvalid  <= '0';
            arvalid <= '0';
            rvalid  <= '0';

            miso <= '0';

        ------------------------------------------------
        -- SPI CLOCK
        ------------------------------------------------

        elsif rising_edge(sclk) then

            ------------------------------------------------
            -- ACTIVE ONLY WHEN CS = 0
            ------------------------------------------------

            if cs = '0' then

                ------------------------------------------------
                -- SHIFT RECEIVE
                ------------------------------------------------

                rx_shift_reg <= rx_shift_reg(6 downto 0) & mosi;

                ------------------------------------------------
                -- SHIFT TRANSMIT
                ------------------------------------------------

                tx_shift_reg <= tx_shift_reg(6 downto 0) & '0';

                ------------------------------------------------
                -- BYTE COMPLETE
                ------------------------------------------------

                if bit_count = 7 then

                    bit_count <= 0;

                    ------------------------------------------------
                    -- FSM
                    ------------------------------------------------

                    case current_state is

                        ------------------------------------------------
                        -- IDLE
                        ------------------------------------------------

                        when IDLE =>

                            command_reg <= rx_shift_reg(6 downto 0) & mosi;

                            ------------------------------------------------
                            -- WRITE COMMAND
                            ------------------------------------------------

                            if (rx_shift_reg(6 downto 0) & mosi) = "00000001" then

                                current_state <= GET_ADDRESS;

                            ------------------------------------------------
                            -- READ COMMAND
                            ------------------------------------------------

                            elsif (rx_shift_reg(6 downto 0) & mosi) = "00000010" then

                                current_state <= GET_ADDRESS;

                            end if;

                        ------------------------------------------------
                        -- GET ADDRESS
                        ------------------------------------------------

                        when GET_ADDRESS =>

                            address_reg <= rx_shift_reg(6 downto 0) & mosi;

                            ------------------------------------------------
                            -- NEXT STATE
                            ------------------------------------------------

                            if command_reg = "00000001" then

                                current_state <= WRITE_DATA;

                            elsif command_reg = "00000010" then

                                current_state <= READ_DATA;

                            end if;

                        ------------------------------------------------
                        -- WRITE DATA
                        ------------------------------------------------

                        when WRITE_DATA =>

                            ------------------------------------------------
                            -- AXI WRITE
                            ------------------------------------------------

                            awaddr  <= address_reg;

                            awvalid <= '1';

                            wdata   <= rx_shift_reg(6 downto 0) & mosi;

                            wvalid  <= '1';

                            ------------------------------------------------
                            -- STORE IN MEMORY
                            ------------------------------------------------

                            axi_mem(to_integer(unsigned(address_reg(3 downto 0))))
                            <= rx_shift_reg(6 downto 0) & mosi;

                            current_state <= IDLE;

                        ------------------------------------------------
                        -- READ DATA
                        ------------------------------------------------

                        when READ_DATA =>

                            ------------------------------------------------
                            -- AXI READ
                            ------------------------------------------------

                            araddr  <= address_reg;

                            arvalid <= '1';

                            rdata <= axi_mem(
                            to_integer(unsigned(address_reg(3 downto 0)))
                            );

                            rvalid <= '1';

                            tx_shift_reg <= axi_mem(
                            to_integer(unsigned(address_reg(3 downto 0)))
                            );

                            current_state <= IDLE;

                    end case;

                else

                    bit_count <= bit_count + 1;

                end if;

            end if;

        end if;

    end process;

    ------------------------------------------------
    -- MISO OUTPUT
    ------------------------------------------------

    miso <= tx_shift_reg(7);

end Behavioral;