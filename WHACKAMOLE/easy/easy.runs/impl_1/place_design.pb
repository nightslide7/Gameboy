
6
Command: %s
53*	vivadotcl2
place_designZ4-113
x
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
Implementation2
	xc7vx485tZ17-347
h
0Got license for feature '%s' and/or device '%s'
310*common2
Implementation2
	xc7vx485tZ17-349
U
,Running DRC as a precondition to command %s
22*	vivadotcl2
place_designZ4-22
5
Running DRC with %s threads
24*drc2
4Z23-27
;
DRC finished with %s
79*	vivadotcl2

0 ErrorsZ4-198
\
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199
:

Starting %s Task
103*constraints2
PlacerZ18-103
b
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
4Z30-611
I

Phase %s%s
101*constraints2
1 2
Placer InitializationZ18-101
¯
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2
00:00:00.012

00:00:002	
933.9532
0.000Z17-268
R

Phase %s%s
101*constraints2
1.1 2
Mandatory Logic OptimizationZ18-101
1
Pushed %s inverter(s).
98*opt2
0Z31-138
I
=Phase 1.1 Mandatory Logic Optimization | Checksum: 1113ffbff
*common
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.02 ; elapsed = 00:00:00.02 . Memory (MB): peak = 933.953 ; gain = 4.035
]

Phase %s%s
101*constraints2
1.2 2)
'Build Super Logic Region (SLR) DatabaseZ18-101
T
HPhase 1.2 Build Super Logic Region (SLR) Database | Checksum: 1113ffbff
*common
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.15 ; elapsed = 00:00:00.16 . Memory (MB): peak = 937.238 ; gain = 7.320
E

Phase %s%s
101*constraints2
1.3 2
Add ConstraintsZ18-101
<
0Phase 1.3 Add Constraints | Checksum: 1113ffbff
*common
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.16 ; elapsed = 00:00:00.16 . Memory (MB): peak = 937.238 ; gain = 7.320
R

Phase %s%s
101*constraints2
1.4 2
Routing Based Site ExclusionZ18-101
I
=Phase 1.4 Routing Based Site Exclusion | Checksum: 1113ffbff
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.16 ; elapsed = 00:00:00.16 . Memory (MB): peak = 940.242 ; gain = 10.324
B

Phase %s%s
101*constraints2
1.5 2
Build MacrosZ18-101
9
-Phase 1.5 Build Macros | Checksum: 119f2606a
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.17 ; elapsed = 00:00:00.17 . Memory (MB): peak = 940.242 ; gain = 10.324
V

Phase %s%s
101*constraints2
1.6 2"
 Implementation Feasibility checkZ18-101
M
APhase 1.6 Implementation Feasibility check | Checksum: 119f2606a
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.18 ; elapsed = 00:00:00.18 . Memory (MB): peak = 940.242 ; gain = 10.324
E

Phase %s%s
101*constraints2
1.7 2
Pre-Place CellsZ18-101
<
0Phase 1.7 Pre-Place Cells | Checksum: 119f2606a
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.18 ; elapsed = 00:00:00.19 . Memory (MB): peak = 940.242 ; gain = 10.324
h

Phase %s%s
101*constraints2
1.8 24
2IO Placement/ Clock Placement/ Build Placer DeviceZ18-101
_
SPhase 1.8 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 119f2606a
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.82 ; elapsed = 00:00:00.77 . Memory (MB): peak = 998.320 ; gain = 68.402
P

Phase %s%s
101*constraints2
1.9 2
Build Placer Netlist ModelZ18-101
I

Phase %s%s
101*constraints2
1.9.1 2
Place Init DesignZ18-101
@
4Phase 1.9.1 Place Init Design | Checksum: 1d7a3ec66
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.85 ; elapsed = 00:00:00.84 . Memory (MB): peak = 998.320 ; gain = 68.402
G
;Phase 1.9 Build Placer Netlist Model | Checksum: 1d7a3ec66
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.85 ; elapsed = 00:00:00.84 . Memory (MB): peak = 998.320 ; gain = 68.402
N

Phase %s%s
101*constraints2
1.10 2
Constrain Clocks/MacrosZ18-101
Y

Phase %s%s
101*constraints2	
1.10.1 2"
 Constrain Global/Regional ClocksZ18-101
P
DPhase 1.10.1 Constrain Global/Regional Clocks | Checksum: 1d7a3ec66
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.85 ; elapsed = 00:00:00.85 . Memory (MB): peak = 998.320 ; gain = 68.402
E
9Phase 1.10 Constrain Clocks/Macros | Checksum: 1d7a3ec66
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.85 ; elapsed = 00:00:00.85 . Memory (MB): peak = 998.320 ; gain = 68.402
@
4Phase 1 Placer Initialization | Checksum: 1d7a3ec66
*common
z

%s
*constraints2c
aTime (s): cpu = 00:00:00.86 ; elapsed = 00:00:00.85 . Memory (MB): peak = 998.320 ; gain = 68.402
D

Phase %s%s
101*constraints2
2 2
Global PlacementZ18-101
;
/Phase 2 Global Placement | Checksum: 10c1a423c
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:02 . Memory (MB): peak = 1027.090 ; gain = 97.172
D

Phase %s%s
101*constraints2
3 2
Detail PlacementZ18-101
P

Phase %s%s
101*constraints2
3.1 2
Commit Multi Column MacrosZ18-101
G
;Phase 3.1 Commit Multi Column Macros | Checksum: 10c1a423c
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:02 . Memory (MB): peak = 1027.090 ; gain = 97.172
R

Phase %s%s
101*constraints2
3.2 2
Commit Most Macros & LUTRAMsZ18-101
I
=Phase 3.2 Commit Most Macros & LUTRAMs | Checksum: 183e152b0
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:02 . Memory (MB): peak = 1027.090 ; gain = 97.172
L

Phase %s%s
101*constraints2
3.3 2
Area Swap OptimizationZ18-101
C
7Phase 3.3 Area Swap Optimization | Checksum: 1149e9518
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:02 . Memory (MB): peak = 1027.090 ; gain = 97.172
K

Phase %s%s
101*constraints2
3.4 2
Timing Path OptimizerZ18-101
B
6Phase 3.4 Timing Path Optimizer | Checksum: 1149e9518
*common
u

%s
*constraints2^
\Time (s): cpu = 00:00:03 ; elapsed = 00:00:02 . Memory (MB): peak = 1027.090 ; gain = 97.172
V

Phase %s%s
101*constraints2
3.5 2"
 Commit Small Macros & Core LogicZ18-101
M
APhase 3.5 Commit Small Macros & Core Logic | Checksum: 1a687953f
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
H

Phase %s%s
101*constraints2
3.6 2
Re-assign LUT pinsZ18-101
?
3Phase 3.6 Re-assign LUT pins | Checksum: 1a687953f
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
;
/Phase 3 Detail Placement | Checksum: 1a687953f
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
\

Phase %s%s
101*constraints2
4 2*
(Post Placement Optimization and Clean-UpZ18-101
L

Phase %s%s
101*constraints2
4.1 2
Post Placement CleanupZ18-101
B
6Phase 4.1 Post Placement Cleanup | Checksum: b7af457f
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
F

Phase %s%s
101*constraints2
4.2 2
Placer ReportingZ18-101
<
0Phase 4.2 Placer Reporting | Checksum: b7af457f
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
M

Phase %s%s
101*constraints2
4.3 2
Final Placement CleanupZ18-101
C
7Phase 4.3 Final Placement Cleanup | Checksum: 64118025
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
R
FPhase 4 Post Placement Optimization and Clean-Up | Checksum: 64118025
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
4
(Ending Placer Task | Checksum: ce2c1a3b
*common
v

%s
*constraints2_
]Time (s): cpu = 00:00:04 ; elapsed = 00:00:03 . Memory (MB): peak = 1072.129 ; gain = 142.211
u
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
272
12
02
0Z4-41
C
%s completed successfully
29*	vivadotcl2
place_designZ4-42
O

DEBUG : %s144*timing2*
(Generate clock report | CPU: 0.17 secs 
Z38-163
‚
vreport_utilization: Time (s): cpu = 00:00:00.04 ; elapsed = 00:00:00.08 . Memory (MB): peak = 1072.129 ; gain = 0.000
*common
[

DEBUG : %s134*designutils21
/Generate Control Sets report | CPU: 0.03 secs 
Z20-134
4
Writing XDEF routing.
211*designutilsZ20-211
A
#Writing XDEF routing logical nets.
209*designutilsZ20-209
A
#Writing XDEF routing special nets.
210*designutilsZ20-210
®
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write XDEF Complete: 2
00:00:00.212
00:00:00.212

1072.1292
0.000Z17-268


End Record