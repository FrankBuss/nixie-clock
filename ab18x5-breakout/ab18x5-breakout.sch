EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:ab18x5
LIBS:Oscillators
LIBS:ab18x5-breakout-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date "20 apr 2017"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Crystal Y1
U 1 1 58F96103
P 4100 2800
F 0 "Y1" H 4100 2950 50  0000 C CNN
F 1 "Crystal" H 4100 2650 50  0000 C CNN
F 2 "crystal:crystal" H 4100 2800 50  0001 C CNN
F 3 "" H 4100 2800 50  0001 C CNN
	1    4100 2800
	0    1    1    0   
$EndComp
$Comp
L AB1815 U1
U 1 1 58F964D3
P 5450 3450
F 0 "U1" H 5950 2150 60  0000 C CNN
F 1 "AB1815" H 4900 4500 60  0000 C CNN
F 2 "qfn16:qfn16" H 5450 2950 60  0001 C CNN
F 3 "" H 5450 2950 60  0000 C CNN
	1    5450 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 2650 4450 2650
Wire Wire Line
	4100 2950 4450 2950
$Comp
L C C1
U 1 1 58F96539
P 3750 3450
F 0 "C1" H 3775 3550 50  0000 L CNN
F 1 "47pF" H 3775 3350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 3788 3300 50  0001 C CNN
F 3 "" H 3750 3450 50  0001 C CNN
	1    3750 3450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR01
U 1 1 58F965BC
P 3750 3650
F 0 "#PWR01" H 3750 3400 50  0001 C CNN
F 1 "GND" H 3750 3500 50  0000 C CNN
F 2 "" H 3750 3650 50  0001 C CNN
F 3 "" H 3750 3650 50  0001 C CNN
	1    3750 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 3250 3750 3250
Wire Wire Line
	3750 3250 3750 3300
Wire Wire Line
	3750 3600 3750 3650
$Comp
L CONN_01X07 J1
U 1 1 58F96620
P 2700 3900
F 0 "J1" H 2700 4300 50  0000 C CNN
F 1 "CONN_01X07" V 2800 3900 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x07_Pitch2.54mm" H 2700 3900 50  0001 C CNN
F 3 "" H 2700 3900 50  0001 C CNN
	1    2700 3900
	-1   0    0    1   
$EndComp
Wire Wire Line
	4450 3650 4350 3650
Wire Wire Line
	4450 4050 4350 4050
Wire Wire Line
	4450 4250 4350 4250
Wire Wire Line
	4450 4450 4350 4450
Wire Wire Line
	6400 2650 6500 2650
Wire Wire Line
	6400 2850 6500 2850
Wire Wire Line
	6400 3250 6500 3250
Wire Wire Line
	6400 3650 6500 3650
Wire Wire Line
	6400 3850 6500 3850
Wire Wire Line
	6400 4050 6500 4050
Wire Wire Line
	6400 4250 6500 4250
Wire Wire Line
	6400 4450 6500 4450
Wire Wire Line
	5450 4900 5450 5000
Wire Wire Line
	5450 2200 5450 2100
Text Label 5450 2100 0    60   ~ 0
VCC
Text Label 6500 2650 0    60   ~ 0
nRST
Text Label 6500 2850 0    60   ~ 0
WDI
Text Label 6500 3250 0    60   ~ 0
EXTI
Text Label 6500 3650 0    60   ~ 0
nEXTR
Text Label 6500 3850 0    60   ~ 0
nCE
Text Label 6500 4050 0    60   ~ 0
SCL
Text Label 6500 4250 0    60   ~ 0
SDO
Text Label 6500 4450 0    60   ~ 0
SDI
Text Label 5450 5000 0    60   ~ 0
VSS
Text Label 4350 3650 2    60   ~ 0
VBAT
Text Label 4350 4050 2    60   ~ 0
FOUT/nIRQ
Text Label 4350 4250 2    60   ~ 0
PSW/nIRQ2
Text Label 4350 4450 2    60   ~ 0
CLKOUT/nIRQ3
$Comp
L CONN_01X07 J2
U 1 1 58F96967
P 2700 3000
F 0 "J2" H 2700 3400 50  0000 C CNN
F 1 "CONN_01X07" V 2800 3000 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x07_Pitch2.54mm" H 2700 3000 50  0001 C CNN
F 3 "" H 2700 3000 50  0001 C CNN
	1    2700 3000
	-1   0    0    1   
$EndComp
Text Label 2900 4200 0    60   ~ 0
nRST
Text Label 2900 4100 0    60   ~ 0
WDI
Text Label 2900 4000 0    60   ~ 0
nEXTR
Text Label 2900 3900 0    60   ~ 0
PSW/nIRQ2
Text Label 2900 3800 0    60   ~ 0
VBAT
Text Label 2900 3700 0    60   ~ 0
SDO
Text Label 2900 3600 0    60   ~ 0
SCL
Text Label 2900 2700 0    60   ~ 0
CLKOUT/nIRQ3
Text Label 2900 2800 0    60   ~ 0
SDI
Text Label 2900 2900 0    60   ~ 0
EXTI
Text Label 2900 3000 0    60   ~ 0
FOUT/nIRQ
Text Label 2900 3100 0    60   ~ 0
nCE
Text Label 2900 3200 0    60   ~ 0
VCC
Text Label 2900 3300 0    60   ~ 0
VSS
$Comp
L GND #PWR?
U 1 1 58F96E80
P 5450 5000
F 0 "#PWR?" H 5450 4750 50  0001 C CNN
F 1 "GND" H 5450 4850 50  0000 C CNN
F 2 "" H 5450 5000 50  0001 C CNN
F 3 "" H 5450 5000 50  0001 C CNN
	1    5450 5000
	1    0    0    -1  
$EndComp
$EndSCHEMATC
