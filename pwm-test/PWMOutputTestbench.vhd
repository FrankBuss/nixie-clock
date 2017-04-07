-- Copyright (c) 2017 Frank Buss (fb@frank-buss.de)
-- See license.txt for license

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity PWMOutputTestbench is
end;

architecture rtl of PWMOutputTestbench is

signal clock: std_logic := '0';
signal reset: std_logic := '0';

signal off1Time : unsigned(31 downto 0) := (others => '0');
signal onTime   : unsigned(31 downto 0) := (others => '0');
signal off2Time : unsigned(31 downto 0) := (others => '0');

signal cycleStart: std_logic := '0';
signal pwmOut: std_logic := '0';

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
	pwmOutput_instance: PWMOutput
	port map (
		clock		=> clock,
		reset		=> reset,
		off1Time => off1Time,
		onTime  => onTime,
		off2Time => off2Time,
		cycleStart => cycleStart,
		pwmOut	=> pwmOut
	);

	clock_process: process
	begin
		while true loop
			wait for 5 ns; clock <= not clock;
		end loop;
	end process;
	
	stimulus: process
	procedure waitBit is
	begin
		wait for 20 ns;
	end;
	procedure SpiStart is
	begin
	end;
	begin
		-- Reset durchführen
		wait for 20 ns; reset  <= '1';
		wait for 20 ns; reset  <= '0';
		wait for 1 us;

		wait for 1 us;
		-- assert DSP1_RESET = '1' severity failure;
		
		off1Time <= to_unsigned(10, 32);
		onTime <= to_unsigned(0, 32);
		off2Time <= to_unsigned(0, 32);

		wait for 1 us;

		off1Time <= to_unsigned(0, 32);
		onTime <= to_unsigned(10, 32);
		off2Time <= to_unsigned(0, 32);


		wait for 1 us;

		off1Time <= to_unsigned(10, 32);
		onTime <= to_unsigned(10, 32);
		off2Time <= to_unsigned(0, 32);

		wait for 1 us;

		off1Time <= to_unsigned(0, 32);
		onTime <= to_unsigned(0, 32);
		off2Time <= to_unsigned(10, 32);

		wait for 1 us;

		off1Time <= to_unsigned(10, 32);
		onTime <= to_unsigned(0, 32);
		off2Time <= to_unsigned(10, 32);

		wait for 1 us;
		
		off1Time <= to_unsigned(0, 32);
		onTime <= to_unsigned(10, 32);
		off2Time <= to_unsigned(10, 32);

		wait for 1 us;

		off1Time <= to_unsigned(10, 32);
		onTime <= to_unsigned(10, 32);
		off2Time <= to_unsigned(10, 32);

		wait for 1 us;

		-- Ende der Simulation anzeigen
		assert false report "no failure, simulation successful" severity failure;
		
	end process;

end;
