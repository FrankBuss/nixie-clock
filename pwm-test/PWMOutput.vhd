-- Copyright (c) 2017 Frank Buss (fb@frank-buss.de)
-- See license.txt for license

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity PWMOutput is
	port (
		-- clock
		clock		: in std_logic;
		
		-- resets all internal timers and the state machine
		reset		: in std_logic;
		
		-- timings, latched at cycle start
		off1Time : in unsigned(31 downto 0);
		onTime   : in unsigned(31 downto 0);
		off2Time : in unsigned(31 downto 0);

		-- high pulse for one clock cycle indicates new cycle start
		cycleStart: out std_logic;

		-- generated PWM signal
		pwmOut	: out std_logic
	);
end entity PWMOutput;

architecture rtl of PWMOutput is

	type StateType is (
		PWM_OFF1,
		PWM_ON,
		PWM_OFF2
	);

	signal state: StateType := PWM_OFF1;

	signal onTimeLatched : unsigned(31 downto 0);
	signal off2TimeLatched : unsigned(31 downto 0);
	
	signal counter: unsigned(31 downto 0);

	signal outBuffer: std_logic;

begin

	process(clock)	
	begin
		if rising_edge(clock) then 
			if reset = '1' then
				cycleStart <= '1';
				onTimeLatched <= onTime;
				off2TimeLatched <= off2Time;
				state <= PWM_OFF1;
				counter <= off1Time;
				outBuffer <= '0';
			else
				cycleStart <= '0';
				case state is
					when PWM_OFF1 =>
						if counter = 0 then
							if onTimeLatched = 0 then
								outBuffer <= '0';
								if off2TimeLatched = 0 then
									onTimeLatched <= onTime;
									off2TimeLatched <= off2Time;
									counter <= off1Time;
									cycleStart <= '1';
								else
									state <= PWM_OFF2;
									counter <= off2TimeLatched;
								end if;
								outBuffer <= '0';
							else
								state <= PWM_ON;
								counter <= onTimeLatched;
								outBuffer <= '1';
							end if;
						end if;
					when PWM_ON =>
						if counter = 0 then
							outBuffer <= '0';
							if off2TimeLatched = 0 then
								onTimeLatched <= onTime;
								off2TimeLatched <= off2Time;
								cycleStart <= '1';
								if off1Time = 0 then
									counter <= onTime;
									outBuffer <= '1';
								else
									state <= PWM_OFF1;
									counter <= off1Time;
									outBuffer <= '0';
								end if;
							else
								state <= PWM_OFF2;
								counter <= off2Time;
								outBuffer <= '0';
							end if;
						end if;
					when PWM_OFF2 =>
						if counter = 0 then
							cycleStart <= '1';
							onTimeLatched <= onTime;
							off2TimeLatched <= off2Time;
							if off1Time = 0 then
								if onTime = 0 then
									counter <= off2Time;
									outBuffer <= '0';
									cycleStart <= '1';
								else
									state <= PWM_ON;
									counter <= onTime;
									outBuffer <= '1';
								end if;
							else
								state <= PWM_OFF1;
								counter <= off1Time;
								outBuffer <= '0';
							end if;
						end if;
				end case;

				if counter > 0 then
					counter <= counter - 1;
				end if;
				
				if onTimeLatched = 0 then
					outBuffer <= '0';
				end if;
				
			end if;
		end if;
	end process;

	pwmOut <= outBuffer;

end architecture rtl;
