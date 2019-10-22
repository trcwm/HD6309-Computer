EESchema Schematic File Version 4
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "HD6309 SDCARD + I2C INTERFACE"
Date "2019-10-07"
Rev "A"
Comp "Moseley Instruments"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L HD6309_sdcard:74HC541 U2
U 1 1 5D9A747E
P 4150 2300
F 0 "U2" H 4450 2135 50  0000 C CNN
F 1 "74HCT541" H 4450 2226 50  0000 C CNN
F 2 "Package_SO:SOIC-20W_7.5x12.8mm_P1.27mm" H 4550 2850 50  0001 C CNN
F 3 "" H 4550 2850 50  0000 C CNN
	1    4150 2300
	-1   0    0    1   
$EndComp
$Comp
L Connector_Generic:Conn_01x10 J2
U 1 1 5D9A892D
P 1000 1400
F 0 "J2" H 918 2017 50  0000 C CNN
F 1 "Conn_01x10" H 918 1926 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x10_P2.54mm_Vertical" H 1000 1400 50  0001 C CNN
F 3 "~" H 1000 1400 50  0001 C CNN
	1    1000 1400
	-1   0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x08 J1
U 1 1 5D9A9B47
P 700 2700
F 0 "J1" H 618 3217 50  0000 C CNN
F 1 "Conn_01x08" H 618 3126 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 700 2700 50  0001 C CNN
F 3 "~" H 700 2700 50  0001 C CNN
	1    700  2700
	-1   0    0    -1  
$EndComp
$Comp
L Regulator_Linear:LM1117-3.3 U3
U 1 1 5D9AA3B5
P 4300 1000
F 0 "U3" H 4300 1242 50  0000 C CNN
F 1 "LM1117-3.3" H 4300 1151 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-223-3_TabPin2" H 4300 1000 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm1117.pdf" H 4300 1000 50  0001 C CNN
	1    4300 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C1
U 1 1 5D9AAE3B
P 3750 1200
F 0 "C1" H 3842 1246 50  0000 L CNN
F 1 "100n" H 3842 1155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3750 1200 50  0001 C CNN
F 3 "~" H 3750 1200 50  0001 C CNN
	1    3750 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 1100 3750 1000
Wire Wire Line
	3750 1000 4000 1000
$Comp
L Device:C_Small C2
U 1 1 5D9AB622
P 4850 1200
F 0 "C2" H 4942 1246 50  0000 L CNN
F 1 "100n" H 4942 1155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 4850 1200 50  0001 C CNN
F 3 "~" H 4850 1200 50  0001 C CNN
	1    4850 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4850 1100 4850 1000
$Comp
L power:GND #PWR0101
U 1 1 5D9AC0B2
P 3750 1400
F 0 "#PWR0101" H 3750 1150 50  0001 C CNN
F 1 "GND" H 3755 1227 50  0000 C CNN
F 2 "" H 3750 1400 50  0001 C CNN
F 3 "" H 3750 1400 50  0001 C CNN
	1    3750 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 1400 3750 1350
Wire Wire Line
	3750 1350 4300 1350
Wire Wire Line
	4300 1350 4300 1300
Connection ~ 3750 1350
Wire Wire Line
	3750 1350 3750 1300
Wire Wire Line
	4300 1350 4850 1350
Wire Wire Line
	4850 1350 4850 1300
Connection ~ 4300 1350
Wire Wire Line
	4600 1000 4850 1000
Wire Wire Line
	4850 1000 5000 1000
Connection ~ 4850 1000
$Comp
L power:+3V3 #PWR0102
U 1 1 5D9AD0C7
P 5000 1000
F 0 "#PWR0102" H 5000 850 50  0001 C CNN
F 1 "+3V3" H 5015 1173 50  0000 C CNN
F 2 "" H 5000 1000 50  0001 C CNN
F 3 "" H 5000 1000 50  0001 C CNN
	1    5000 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	1200 1000 1500 1000
Wire Wire Line
	1500 1000 1500 800 
$Comp
L power:+5V #PWR0103
U 1 1 5D9AD9D3
P 1500 800
F 0 "#PWR0103" H 1500 650 50  0001 C CNN
F 1 "+5V" H 1515 973 50  0000 C CNN
F 2 "" H 1500 800 50  0001 C CNN
F 3 "" H 1500 800 50  0001 C CNN
	1    1500 800 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1200 1100 1750 1100
Wire Wire Line
	1750 1100 1750 900 
Wire Wire Line
	1750 900  1850 900 
Wire Wire Line
	1850 900  1850 950 
$Comp
L power:GND #PWR0104
U 1 1 5D9AE2A6
P 1850 950
F 0 "#PWR0104" H 1850 700 50  0001 C CNN
F 1 "GND" H 1855 777 50  0000 C CNN
F 2 "" H 1850 950 50  0001 C CNN
F 3 "" H 1850 950 50  0001 C CNN
	1    1850 950 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1200 1200 1500 1200
Text GLabel 1500 1200 2    50   Output ~ 0
~RD
Text GLabel 1700 1300 2    50   Output ~ 0
~WR
Wire Wire Line
	1200 1300 1700 1300
Wire Wire Line
	900  2400 1600 2400
Wire Wire Line
	900  2600 1400 2600
Wire Wire Line
	900  2800 1200 2800
Wire Wire Line
	900  3000 1000 3000
Wire Wire Line
	3450 3100 900  3100
$Comp
L power:+5V #PWR0105
U 1 1 5D9B481C
P 3200 3450
F 0 "#PWR0105" H 3200 3300 50  0001 C CNN
F 1 "+5V" H 3215 3623 50  0000 C CNN
F 2 "" H 3200 3450 50  0001 C CNN
F 3 "" H 3200 3450 50  0001 C CNN
	1    3200 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 3450 3200 3550
Wire Wire Line
	3200 3550 3350 3550
Wire Wire Line
	3350 3550 3350 3300
Wire Wire Line
	3350 3300 3450 3300
Wire Wire Line
	3000 3200 3450 3200
Text GLabel 3000 3200 0    50   Input ~ 0
~RD
NoConn ~ 1200 1600
NoConn ~ 1200 1700
NoConn ~ 1200 1800
NoConn ~ 1200 1900
Wire Wire Line
	4250 2400 4400 2400
Wire Wire Line
	4400 2400 4400 2250
$Comp
L power:GND #PWR0106
U 1 1 5D9B97C9
P 4550 2250
F 0 "#PWR0106" H 4550 2000 50  0001 C CNN
F 1 "GND" H 4555 2077 50  0000 C CNN
F 2 "" H 4550 2250 50  0001 C CNN
F 3 "" H 4550 2250 50  0001 C CNN
	1    4550 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	4550 2250 4400 2250
$Comp
L HD6309_sdcard:74HC574 U1
U 1 1 5D9BB470
P 2250 4850
F 0 "U1" H 2550 6115 50  0000 C CNN
F 1 "74HC574" H 2550 6024 50  0000 C CNN
F 2 "Package_SO:SOIC-20W_7.5x12.8mm_P1.27mm" H 2650 5400 50  0001 C CNN
F 3 "" H 2650 5400 50  0000 C CNN
	1    2250 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2150 3950 1600 3950
Wire Wire Line
	1600 3950 1600 2400
Connection ~ 1600 2400
Wire Wire Line
	1600 2400 3450 2400
Wire Wire Line
	1500 4050 2150 4050
Wire Wire Line
	1500 2500 900  2500
Wire Wire Line
	2150 4150 1400 4150
Wire Wire Line
	1400 4150 1400 2600
Wire Wire Line
	2150 4250 1300 4250
Wire Wire Line
	1300 4250 1300 2700
Wire Wire Line
	1300 2700 900  2700
Wire Wire Line
	2150 4350 1200 4350
Wire Wire Line
	1200 4350 1200 2800
Wire Wire Line
	2150 4450 1100 4450
Wire Wire Line
	1100 4450 1100 2900
Wire Wire Line
	1100 2900 900  2900
Wire Wire Line
	2150 4550 1000 4550
Wire Wire Line
	1000 4550 1000 3000
Wire Wire Line
	2150 4650 900  4650
Wire Wire Line
	900  4650 900  3100
Connection ~ 900  3100
$Comp
L power:GND #PWR0107
U 1 1 5D9C9A9B
P 2050 4850
F 0 "#PWR0107" H 2050 4600 50  0001 C CNN
F 1 "GND" H 2055 4677 50  0000 C CNN
F 2 "" H 2050 4850 50  0001 C CNN
F 3 "" H 2050 4850 50  0001 C CNN
	1    2050 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 4850 2050 4750
Wire Wire Line
	2050 4750 2150 4750
$Comp
L power:GND #PWR0108
U 1 1 5D9CB7DC
P 2000 3750
F 0 "#PWR0108" H 2000 3500 50  0001 C CNN
F 1 "GND" H 2005 3577 50  0000 C CNN
F 2 "" H 2000 3750 50  0001 C CNN
F 3 "" H 2000 3750 50  0001 C CNN
	1    2000 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 3750 2000 3700
Wire Wire Line
	2000 3700 2150 3700
Wire Wire Line
	2150 3700 2150 3850
$Comp
L power:+5V #PWR0109
U 1 1 5D9CD3A7
P 3050 3650
F 0 "#PWR0109" H 3050 3500 50  0001 C CNN
F 1 "+5V" H 3065 3823 50  0000 C CNN
F 2 "" H 3050 3650 50  0001 C CNN
F 3 "" H 3050 3650 50  0001 C CNN
	1    3050 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	3050 3650 3050 3850
Wire Wire Line
	3050 3850 2950 3850
Text GLabel 3100 4750 2    50   Input ~ 0
~WR
Wire Wire Line
	3100 4750 2950 4750
$Comp
L power:GND #PWR0110
U 1 1 5D9DA89F
P 1450 7300
F 0 "#PWR0110" H 1450 7050 50  0001 C CNN
F 1 "GND" H 1455 7127 50  0000 C CNN
F 2 "" H 1450 7300 50  0001 C CNN
F 3 "" H 1450 7300 50  0001 C CNN
	1    1450 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 7300 1450 7200
$Comp
L Transistor_FET:2N7002 Q2
U 1 1 5D9DCC52
P 2400 7000
F 0 "Q2" H 2606 7046 50  0000 L CNN
F 1 "2N7002" H 2606 6955 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 2600 6925 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N7002.pdf" H 2400 7000 50  0001 L CNN
	1    2400 7000
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R2
U 1 1 5D9E4608
P 2500 6550
F 0 "R2" H 2559 6596 50  0000 L CNN
F 1 "2k2" H 2559 6505 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 2500 6550 50  0001 C CNN
F 3 "~" H 2500 6550 50  0001 C CNN
	1    2500 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 6650 2500 6750
$Comp
L Device:R_Small R1
U 1 1 5D9E6E22
P 1450 6550
F 0 "R1" H 1509 6596 50  0000 L CNN
F 1 "2k2" H 1509 6505 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1450 6550 50  0001 C CNN
F 3 "~" H 1450 6550 50  0001 C CNN
	1    1450 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 6650 1450 6750
Wire Wire Line
	1450 6450 1450 6400
Wire Wire Line
	1450 6400 2500 6400
Wire Wire Line
	2500 6400 2500 6450
$Comp
L Transistor_FET:2N7002 Q1
U 1 1 5D9D6C60
P 1350 7000
F 0 "Q1" H 1556 7046 50  0000 L CNN
F 1 "2N7002" H 1556 6955 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 1550 6925 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N7002.pdf" H 1350 7000 50  0001 L CNN
	1    1350 7000
	1    0    0    -1  
$EndComp
Text GLabel 3250 3950 2    50   Output ~ 0
MOSI
Wire Wire Line
	3250 3950 2950 3950
Text GLabel 3250 4050 2    50   Output ~ 0
SCK
Wire Wire Line
	2950 4050 3250 4050
Wire Wire Line
	2950 4150 3250 4150
Text GLabel 3250 4150 2    50   Output ~ 0
~SS
Text GLabel 3250 4250 2    50   Output ~ 0
GPIO0
Wire Wire Line
	3250 4250 2950 4250
Wire Wire Line
	2950 4650 3250 4650
Text GLabel 3250 4650 2    50   Output ~ 0
SCL
Text GLabel 3250 4550 2    50   Output ~ 0
SDA
Wire Wire Line
	2950 4550 3250 4550
Wire Wire Line
	2950 4350 3250 4350
Wire Wire Line
	2950 4450 3250 4450
Text GLabel 3250 4350 2    50   Output ~ 0
GPIO1
Text GLabel 3250 4450 2    50   Output ~ 0
GPIO2
Text GLabel 2100 7000 0    50   Input ~ 0
SDA
Wire Wire Line
	2100 7000 2200 7000
$Comp
L power:GND #PWR0111
U 1 1 5DA17BEF
P 2500 7300
F 0 "#PWR0111" H 2500 7050 50  0001 C CNN
F 1 "GND" H 2505 7127 50  0000 C CNN
F 2 "" H 2500 7300 50  0001 C CNN
F 3 "" H 2500 7300 50  0001 C CNN
	1    2500 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 7300 2500 7200
Text GLabel 950  7000 0    50   Input ~ 0
SCL
Wire Wire Line
	950  7000 1150 7000
Wire Wire Line
	2500 6750 2800 6750
Connection ~ 2500 6750
Wire Wire Line
	2500 6750 2500 6800
Wire Wire Line
	1450 6750 1750 6750
Connection ~ 1450 6750
Wire Wire Line
	1450 6750 1450 6800
Text GLabel 2800 6750 2    50   Output ~ 0
I2C_SDA
Text GLabel 1750 6750 2    50   Output ~ 0
I2C_SCL
Text GLabel 4450 2500 2    50   Input ~ 0
I2C_SDA
Wire Wire Line
	4450 2500 4250 2500
$Comp
L Connector_Generic:Conn_01x03 J_I2C_VOLTAGE1
U 1 1 5DA2B26D
P 3150 6000
F 0 "J_I2C_VOLTAGE1" H 3230 6042 50  0000 L CNN
F 1 "Conn_01x03" H 3230 5951 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 3150 6000 50  0001 C CNN
F 3 "~" H 3150 6000 50  0001 C CNN
	1    3150 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 6000 2500 6000
Wire Wire Line
	2500 6000 2500 6400
Connection ~ 2500 6400
Wire Wire Line
	2950 5900 2500 5900
Wire Wire Line
	2500 5900 2500 5700
$Comp
L power:+3V3 #PWR0112
U 1 1 5DA31B80
P 2500 5700
F 0 "#PWR0112" H 2500 5550 50  0001 C CNN
F 1 "+3V3" H 2515 5873 50  0000 C CNN
F 2 "" H 2500 5700 50  0001 C CNN
F 3 "" H 2500 5700 50  0001 C CNN
	1    2500 5700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0113
U 1 1 5DA35D25
P 2700 6250
F 0 "#PWR0113" H 2700 6100 50  0001 C CNN
F 1 "+5V" H 2715 6423 50  0000 C CNN
F 2 "" H 2700 6250 50  0001 C CNN
F 3 "" H 2700 6250 50  0001 C CNN
	1    2700 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 6250 2700 6350
Wire Wire Line
	2700 6350 2850 6350
Wire Wire Line
	2850 6350 2850 6100
Wire Wire Line
	2850 6100 2950 6100
$Comp
L power:+5V #PWR0114
U 1 1 5DA39338
P 3750 900
F 0 "#PWR0114" H 3750 750 50  0001 C CNN
F 1 "+5V" H 3765 1073 50  0000 C CNN
F 2 "" H 3750 900 50  0001 C CNN
F 3 "" H 3750 900 50  0001 C CNN
	1    3750 900 
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 900  3750 1000
Connection ~ 3750 1000
$Comp
L Connector:SD_Card J3
U 1 1 5DA3D279
P 9150 1900
F 0 "J3" H 9150 2565 50  0000 C CNN
F 1 "SD_Card" H 9150 2474 50  0000 C CNN
F 2 "Connector_Card:SD_TE_2041021" H 9150 1900 50  0001 C CNN
F 3 "http://portal.fciconnect.com/Comergent//fci/drawing/10067847.pdf" H 9150 1900 50  0001 C CNN
F 4 "649-10067847-001RLF" H 9150 1900 50  0001 C CNN "PN"
	1    9150 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8250 2100 8000 2100
Wire Wire Line
	8000 2100 8000 2450
$Comp
L power:GND #PWR0115
U 1 1 5DA52644
P 8000 2450
F 0 "#PWR0115" H 8000 2200 50  0001 C CNN
F 1 "GND" H 8005 2277 50  0000 C CNN
F 2 "" H 8000 2450 50  0001 C CNN
F 3 "" H 8000 2450 50  0001 C CNN
	1    8000 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 2100 8000 1800
Wire Wire Line
	8000 1800 8250 1800
Connection ~ 8000 2100
$Comp
L power:+3V3 #PWR0116
U 1 1 5DA565DE
P 7800 1900
F 0 "#PWR0116" H 7800 1750 50  0001 C CNN
F 1 "+3V3" H 7815 2073 50  0000 C CNN
F 2 "" H 7800 1900 50  0001 C CNN
F 3 "" H 7800 1900 50  0001 C CNN
	1    7800 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 1900 8250 1900
$Comp
L Device:R_Small R3
U 1 1 5DA5EF61
P 8100 4950
F 0 "R3" H 8159 4996 50  0000 L CNN
F 1 "10k" H 8159 4905 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 4950 50  0001 C CNN
F 3 "~" H 8100 4950 50  0001 C CNN
	1    8100 4950
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R5
U 1 1 5DA5FA28
P 8800 4950
F 0 "R5" H 8859 4996 50  0000 L CNN
F 1 "10k" H 8859 4905 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8800 4950 50  0001 C CNN
F 3 "~" H 8800 4950 50  0001 C CNN
	1    8800 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 5150 8250 5150
Wire Wire Line
	8650 5150 8800 5150
Wire Wire Line
	8800 5150 8800 5050
Wire Wire Line
	8100 5050 8100 5150
$Comp
L Transistor_FET:2N7002 Q3
U 1 1 5DA5A8B6
P 8450 5050
F 0 "Q3" V 8701 5050 50  0000 C CNN
F 1 "2N7002" V 8792 5050 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 8650 4975 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N7002.pdf" H 8450 5050 50  0001 L CNN
	1    8450 5050
	0    1    1    0   
$EndComp
Wire Wire Line
	8450 4850 8450 4800
Wire Wire Line
	8450 4800 8100 4800
Wire Wire Line
	8100 4800 8100 4850
Wire Wire Line
	8100 4800 8100 4700
Connection ~ 8100 4800
$Comp
L power:+3V3 #PWR0117
U 1 1 5DA72D65
P 8100 4700
F 0 "#PWR0117" H 8100 4550 50  0001 C CNN
F 1 "+3V3" H 8115 4873 50  0000 C CNN
F 2 "" H 8100 4700 50  0001 C CNN
F 3 "" H 8100 4700 50  0001 C CNN
	1    8100 4700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0118
U 1 1 5DA73B52
P 8800 4700
F 0 "#PWR0118" H 8800 4550 50  0001 C CNN
F 1 "+5V" H 8815 4873 50  0000 C CNN
F 2 "" H 8800 4700 50  0001 C CNN
F 3 "" H 8800 4700 50  0001 C CNN
	1    8800 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 4700 8800 4850
Text GLabel 8950 5150 2    50   Input ~ 0
MOSI
Wire Wire Line
	8950 5150 8800 5150
Connection ~ 8800 5150
Text GLabel 8000 5150 0    50   Output ~ 0
MOSI_3V
Wire Wire Line
	8000 5150 8100 5150
Connection ~ 8100 5150
$Comp
L Device:R_Small R4
U 1 1 5DA85E27
P 8100 6000
F 0 "R4" H 8159 6046 50  0000 L CNN
F 1 "10k" H 8159 5955 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 6000 50  0001 C CNN
F 3 "~" H 8100 6000 50  0001 C CNN
	1    8100 6000
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R6
U 1 1 5DA85E31
P 8800 6000
F 0 "R6" H 8859 6046 50  0000 L CNN
F 1 "10k" H 8859 5955 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8800 6000 50  0001 C CNN
F 3 "~" H 8800 6000 50  0001 C CNN
	1    8800 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 6200 8250 6200
Wire Wire Line
	8650 6200 8800 6200
Wire Wire Line
	8800 6200 8800 6100
Wire Wire Line
	8100 6100 8100 6200
$Comp
L Transistor_FET:2N7002 Q4
U 1 1 5DA85E3F
P 8450 6100
F 0 "Q4" V 8701 6100 50  0000 C CNN
F 1 "2N7002" V 8792 6100 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 8650 6025 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N7002.pdf" H 8450 6100 50  0001 L CNN
	1    8450 6100
	0    1    1    0   
$EndComp
Wire Wire Line
	8450 5900 8450 5850
Wire Wire Line
	8450 5850 8100 5850
Wire Wire Line
	8100 5850 8100 5900
Wire Wire Line
	8100 5850 8100 5750
Connection ~ 8100 5850
$Comp
L power:+3V3 #PWR0119
U 1 1 5DA85E4E
P 8100 5750
F 0 "#PWR0119" H 8100 5600 50  0001 C CNN
F 1 "+3V3" H 8115 5923 50  0000 C CNN
F 2 "" H 8100 5750 50  0001 C CNN
F 3 "" H 8100 5750 50  0001 C CNN
	1    8100 5750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0120
U 1 1 5DA85E58
P 8800 5750
F 0 "#PWR0120" H 8800 5600 50  0001 C CNN
F 1 "+5V" H 8815 5923 50  0000 C CNN
F 2 "" H 8800 5750 50  0001 C CNN
F 3 "" H 8800 5750 50  0001 C CNN
	1    8800 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 5750 8800 5900
Text GLabel 8950 6200 2    50   Input ~ 0
SCK
Wire Wire Line
	8950 6200 8800 6200
Connection ~ 8800 6200
Text GLabel 8000 6200 0    50   Output ~ 0
SCK_3V
Wire Wire Line
	8000 6200 8100 6200
Connection ~ 8100 6200
$Comp
L Device:R_Small R7
U 1 1 5DA8DAEF
P 9900 4950
F 0 "R7" H 9959 4996 50  0000 L CNN
F 1 "10k" H 9959 4905 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9900 4950 50  0001 C CNN
F 3 "~" H 9900 4950 50  0001 C CNN
	1    9900 4950
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R10
U 1 1 5DA8DAF9
P 10600 4950
F 0 "R10" H 10659 4996 50  0000 L CNN
F 1 "10k" H 10659 4905 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 10600 4950 50  0001 C CNN
F 3 "~" H 10600 4950 50  0001 C CNN
	1    10600 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 5150 10050 5150
Wire Wire Line
	10450 5150 10600 5150
Wire Wire Line
	10600 5150 10600 5050
Wire Wire Line
	9900 5050 9900 5150
$Comp
L Transistor_FET:2N7002 Q5
U 1 1 5DA8DB07
P 10250 5050
F 0 "Q5" V 10501 5050 50  0000 C CNN
F 1 "2N7002" V 10592 5050 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 10450 4975 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N7002.pdf" H 10250 5050 50  0001 L CNN
	1    10250 5050
	0    1    1    0   
$EndComp
Wire Wire Line
	10250 4850 10250 4800
Wire Wire Line
	10250 4800 9900 4800
Wire Wire Line
	9900 4800 9900 4850
Wire Wire Line
	9900 4800 9900 4700
Connection ~ 9900 4800
$Comp
L power:+3V3 #PWR0121
U 1 1 5DA8DB16
P 9900 4700
F 0 "#PWR0121" H 9900 4550 50  0001 C CNN
F 1 "+3V3" H 9915 4873 50  0000 C CNN
F 2 "" H 9900 4700 50  0001 C CNN
F 3 "" H 9900 4700 50  0001 C CNN
	1    9900 4700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0122
U 1 1 5DA8DB20
P 10600 4700
F 0 "#PWR0122" H 10600 4550 50  0001 C CNN
F 1 "+5V" H 10615 4873 50  0000 C CNN
F 2 "" H 10600 4700 50  0001 C CNN
F 3 "" H 10600 4700 50  0001 C CNN
	1    10600 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	10600 4700 10600 4850
Text GLabel 10750 5150 2    50   Input ~ 0
~SS
Wire Wire Line
	10750 5150 10600 5150
Connection ~ 10600 5150
Text GLabel 9800 5150 0    50   Output ~ 0
~SS_3V
Wire Wire Line
	9800 5150 9900 5150
Connection ~ 9900 5150
$Comp
L Device:R_Small R8
U 1 1 5DA8DB31
P 9900 6000
F 0 "R8" H 9959 6046 50  0000 L CNN
F 1 "10k" H 9959 5955 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9900 6000 50  0001 C CNN
F 3 "~" H 9900 6000 50  0001 C CNN
	1    9900 6000
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R11
U 1 1 5DA8DB3B
P 10600 6000
F 0 "R11" H 10659 6046 50  0000 L CNN
F 1 "10k" H 10659 5955 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 10600 6000 50  0001 C CNN
F 3 "~" H 10600 6000 50  0001 C CNN
	1    10600 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 6200 10050 6200
Wire Wire Line
	10450 6200 10600 6200
Wire Wire Line
	10600 6200 10600 6100
Wire Wire Line
	9900 6100 9900 6200
$Comp
L Transistor_FET:2N7002 Q6
U 1 1 5DA8DB49
P 10250 6100
F 0 "Q6" V 10501 6100 50  0000 C CNN
F 1 "2N7002" V 10592 6100 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 10450 6025 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N7002.pdf" H 10250 6100 50  0001 L CNN
	1    10250 6100
	0    1    1    0   
$EndComp
Wire Wire Line
	10250 5900 10250 5850
Wire Wire Line
	10250 5850 9900 5850
Wire Wire Line
	9900 5850 9900 5900
Wire Wire Line
	9900 5850 9900 5750
Connection ~ 9900 5850
$Comp
L power:+3V3 #PWR0123
U 1 1 5DA8DB58
P 9900 5750
F 0 "#PWR0123" H 9900 5600 50  0001 C CNN
F 1 "+3V3" H 9915 5923 50  0000 C CNN
F 2 "" H 9900 5750 50  0001 C CNN
F 3 "" H 9900 5750 50  0001 C CNN
	1    9900 5750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0124
U 1 1 5DA8DB62
P 10600 5750
F 0 "#PWR0124" H 10600 5600 50  0001 C CNN
F 1 "+5V" H 10615 5923 50  0000 C CNN
F 2 "" H 10600 5750 50  0001 C CNN
F 3 "" H 10600 5750 50  0001 C CNN
	1    10600 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	10600 5750 10600 5900
Text GLabel 10750 6200 2    50   Output ~ 0
MISO
Wire Wire Line
	10750 6200 10600 6200
Connection ~ 10600 6200
Text GLabel 9800 6200 0    50   Input ~ 0
MISO_3V
Wire Wire Line
	9800 6200 9900 6200
Connection ~ 9900 6200
Text GLabel 4450 3200 2    50   Input ~ 0
MISO
Wire Wire Line
	4450 3200 4250 3200
$Comp
L power:GND #PWR0125
U 1 1 5DAB4AC3
P 4350 3350
F 0 "#PWR0125" H 4350 3100 50  0001 C CNN
F 1 "GND" H 4355 3177 50  0000 C CNN
F 2 "" H 4350 3350 50  0001 C CNN
F 3 "" H 4350 3350 50  0001 C CNN
	1    4350 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 3300 4350 3300
Wire Wire Line
	4350 3300 4350 3350
Text GLabel 7500 2200 0    50   Output ~ 0
MISO_3V
Wire Wire Line
	7500 2200 8250 2200
NoConn ~ 8250 2300
Text GLabel 7500 2000 0    50   Input ~ 0
SCK_3V
Wire Wire Line
	7500 2000 8250 2000
Text GLabel 7500 1700 0    50   Output ~ 0
MOSI_3V
Wire Wire Line
	7500 1700 8250 1700
Text GLabel 7500 1600 0    50   Input ~ 0
~SS_3V
Wire Wire Line
	7500 1600 8250 1600
NoConn ~ 8250 1500
NoConn ~ 3450 2600
NoConn ~ 3450 2700
NoConn ~ 3450 2800
NoConn ~ 3450 2900
NoConn ~ 3450 3000
NoConn ~ 4250 2600
NoConn ~ 4250 2700
NoConn ~ 4250 2800
NoConn ~ 4250 2900
NoConn ~ 4250 3000
NoConn ~ 1200 1500
NoConn ~ 1200 1400
Wire Wire Line
	1500 2500 1500 4050
Wire Wire Line
	3450 2500 1500 2500
Connection ~ 1500 2500
$Comp
L Device:R_Small R9
U 1 1 5DB4243F
P 10350 1400
F 0 "R9" H 10409 1446 50  0000 L CNN
F 1 "10k" H 10409 1355 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 10350 1400 50  0001 C CNN
F 3 "~" H 10350 1400 50  0001 C CNN
	1    10350 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	10050 1700 10350 1700
Wire Wire Line
	10350 1700 10350 1500
$Comp
L power:+3V3 #PWR0126
U 1 1 5DB48C13
P 10350 1200
F 0 "#PWR0126" H 10350 1050 50  0001 C CNN
F 1 "+3V3" H 10365 1373 50  0000 C CNN
F 2 "" H 10350 1200 50  0001 C CNN
F 3 "" H 10350 1200 50  0001 C CNN
	1    10350 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	10350 1200 10350 1300
Wire Wire Line
	10350 1700 10500 1700
Connection ~ 10350 1700
Text GLabel 4450 3100 2    50   Input ~ 0
CARD_DETECT
Wire Wire Line
	4250 3100 4450 3100
Text GLabel 10500 1700 2    50   Output ~ 0
CARD_DETECT
$EndSCHEMATC