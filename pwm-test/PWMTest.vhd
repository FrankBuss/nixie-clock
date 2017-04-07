-- Copyright (c) 2017 Frank Buss (fb@frank-buss.de)
-- See license.txt for license

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity PWMTest is
	port (
		clock		: in std_logic;
		led		: out std_logic_vector(8 downto 1);
		j3			: out std_logic_vector(4 downto 0);
		j4			: out std_logic_vector(9 downto 0);
		spiCs		: in std_logic;
		spiClock	: in std_logic;
		spiMosi	: in std_logic
	);
end entity PWMTest;

architecture rtl of PWMTest is

constant PWM_PIN_COUNT: natural := 10;

signal counter: unsigned(31 downto 0);
signal spiCsBuffer: std_logic_vector(3 downto 0);
signal spiClockBuffer: std_logic_vector(3 downto 0);
signal spiCsLatch: std_logic;
signal spiMosiLatch: std_logic;
signal spiClockLatch: std_logic;

signal pwmOutBuffer: std_logic_vector(PWM_PIN_COUNT - 1 downto 0);

signal shiftRegister: unsigned(PWM_PIN_COUNT * 32 * 3 - 1 downto 0);
signal shiftRegisterLatched: unsigned(PWM_PIN_COUNT * 32 * 3 - 1 downto 0);

component PWMOutput is
	port (
		clock		: in std_logic;
		reset		: in std_logic;
		off1Time : in unsigned(31 downto 0);
		onTime   : in unsigned(31 downto 0);
		off2Time : in unsigned(31 downto 0);
		cycleStart: out std_logic;
		pwmOut	: out std_logic
	);
end component;

begin

   GeneratePWM:
   for i in 0 to PWM_PIN_COUNT - 1 generate
		pwmOutput_instance: PWMOutput
		port map (
			clock		=> clock,
			reset		=> '0',
			off1Time => shiftRegisterLatched(i * 32 * 3 + 95 downto i * 32 * 3 + 64),
			onTime  =>  shiftRegisterLatched(i * 32 * 3 + 63 downto i * 32 * 3 + 32),
			off2Time =>  shiftRegisterLatched(i * 32 * 3 + 31 downto i * 32 * 3 + 0),
			cycleStart => open,
			pwmOut	=> pwmOutBuffer(i)
		);
   end generate;
	
	process(clock)	
	begin
		if rising_edge(clock) then 
			spiCsLatch <= spiCs;
			spiClockLatch <= spiClock;
			spiMosiLatch <= spiMosi;
			counter <= counter + 1;
			spiCsBuffer <= spiCsBuffer(2 downto 0) & spiCsLatch;
			spiClockBuffer <= spiClockBuffer(2 downto 0) & spiClockLatch;
			
			-- shift when CS is low and on rising clock edge
			if spiClockBuffer = "0111" and spiCsLatch = '0' then
				shiftRegister <= shiftRegister(shiftRegister'high - 1 downto 0) & spiMosiLatch;
			end if;
			
			-- latch shift register on rising CS edge
			if spiCsBuffer = "0111" then
				shiftRegisterLatched <= shiftRegister;
				--led <= std_logic_vector(shiftRegister(shiftRegister'high downto shiftRegister'high - 7));
			end if;
		end if;
	end process;

	-- led(8 downto 1) <= std_logic_vector(counter(31 downto 24));

	j3(0) <= counter(25);
	j3(1) <= not counter(25);
	j3(2) <= counter(25);
	j3(3) <= not counter(25);
	j3(4) <= counter(25);

	--j4(0) <= counter(25);
	--j4(1) <= not counter(25);
	--j4(2) <= counter(25);
	--j4(3) <= not counter(25);
	--j4(4) <= counter(25);
	--j4(5) <= not counter(25);
	--j4(6) <= counter(25);
	--j4(7) <= not counter(25);
	--j4(8) <= counter(25);
	--j4(9) <= not counter(25);
	
	j4 <= pwmOutBuffer(9 downto 0);
	led <= pwmOutBuffer(7 downto 0);

end architecture rtl;
