component FIFO_MEM is
    port(
        clk_i: in std_logic;
        rst_i: in std_logic;
        wr_en_i: in std_logic;
        rd_en_i: in std_logic;
        wr_data_i: in std_logic_vector(31 downto 0);
        full_o: out std_logic;
        empty_o: out std_logic;
        almost_full_o: out std_logic;
        almost_empty_o: out std_logic;
        rd_data_o: out std_logic_vector(31 downto 0)
    );
end component;

__: FIFO_MEM port map(
    clk_i=>,
    rst_i=>,
    wr_en_i=>,
    rd_en_i=>,
    wr_data_i=>,
    full_o=>,
    empty_o=>,
    almost_full_o=>,
    almost_empty_o=>,
    rd_data_o=>
);
