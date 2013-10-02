
4
Command: %s
53*	vivadotcl2

opt_designZ4-113
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
S
,Running DRC as a precondition to command %s
22*	vivadotcl2

opt_designZ4-22
7

Starting %s Task
103*constraints2
DRCZ18-103
5
Running DRC with %s threads
24*drc2
4Z23-27
:
DRC finished with %s
272*project2

0 ErrorsZ1-461
[
BPlease refer to the DRC report (report_drc) for more information.
274*projectZ1-462
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.06 ; elapsed = 00:00:00.06 . Memory (MB): peak = 927.918 ; gain = 5.012
F

Starting %s Task
103*constraints2
Logic OptimizationZ18-103
4
(Logic Optimization | Checksum: 63c57a08
*common
<
%Done setting XDC timing constraints.
35*timingZ38-35
<
%Done setting XDC timing constraints.
35*timingZ38-35
<

Phase %s%s
101*constraints2
1 2

RetargetZ18-101
1
Pushed %s inverter(s).
98*opt2
0Z31-138
0
Retargeted %s cell(s).
49*opt2
0Z31-49
2
&Phase 1 Retarget | Checksum: f55a9f74
*common
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.04 ; elapsed = 00:00:00.03 . Memory (MB): peak = 928.918 ; gain = 1.000
H

Phase %s%s
101*constraints2
2 2
Constant PropagationZ18-101
1
Pushed %s inverter(s).
98*opt2
0Z31-138
.
Eliminated %s cells.
10*opt2
0Z31-10
>
2Phase 2 Constant Propagation | Checksum: f55a9f74
*common
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.05 ; elapsed = 00:00:00.04 . Memory (MB): peak = 928.918 ; gain = 1.000
9

Phase %s%s
101*constraints2
3 2
SweepZ18-101
9
 Eliminated %s unconnected nets.
12*opt2
0Z31-12
:
!Eliminated %s unconnected cells.
11*opt2
0Z31-11
/
#Phase 3 Sweep | Checksum: f55a9f74
*common
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.05 ; elapsed = 00:00:00.04 . Memory (MB): peak = 928.918 ; gain = 1.000
<
%Done setting XDC timing constraints.
35*timingZ38-35
@
4Ending Logic Optimization Task | Checksum: f55a9f74
*common
y

%s
*constraints2b
`Time (s): cpu = 00:00:00.06 ; elapsed = 00:00:00.05 . Memory (MB): peak = 928.918 ; gain = 1.000
F

Starting %s Task
103*constraints2
Power OptimizationZ18-103
@
4Ending Power Optimization Task | Checksum: f55a9f74
*common
s

%s
*constraints2\
ZTime (s): cpu = 00:00:00 ; elapsed = 00:00:00 . Memory (MB): peak = 928.918 ; gain = 0.000
u
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
202
12
02
0Z4-41
A
%s completed successfully
29*	vivadotcl2

opt_designZ4-42
4
Writing XDEF routing.
211*designutilsZ20-211
A
#Writing XDEF routing logical nets.
209*designutilsZ20-209
A
#Writing XDEF routing special nets.
210*designutilsZ20-210
­
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write XDEF Complete: 2
00:00:00.212
00:00:00.222	
928.9182
0.000Z17-268


End Record