
I
 Attempting to get a license: %s
78*common2
ImplementationZ17-78
?
Feature available: %s
81*common2
ImplementationZ17-81
D
 Attempting to get a license: %s
78*common2
	SynthesisZ17-78
:
Feature available: %s
81*common2
	SynthesisZ17-81
s
+Loading parts and site information from %s
36*device2/
-/opt/Xilinx/Vivado/2013.2/data/parts/arch.xmlZ21-36
€
!Parsing RTL primitives file [%s]
14*netlist2E
C/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/rtl/prims/rtl_prims.xmlZ29-14
‰
*Finished parsing RTL primitives file [%s]
11*netlist2E
C/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/rtl/prims/rtl_prims.xmlZ29-11
n
$Using Tcl App repository from '%s'.
323*common2/
-/opt/Xilinx/Vivado/2013.2/data/XilinxTclStoreZ17-362
n
)Updating Tcl app persistent manifest '%s'325*common2*
(/root/.Xilinx/Vivado/tclapp/manifest.tclZ17-364
X
Command: %s
53*	vivadotcl20
.synth_design -top top -part xc7vx485tffg1761-2Z4-113
/

Starting synthesis...

3*	vivadotclZ4-3
s
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2
	xc7vx485tZ17-347
c
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2
	xc7vx485tZ17-349
ˆ
%s*synth2y
wstarting Rtl Elaboration : Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 179.980 ; gain = 63.508

~
synthesizing module '%s'638*oasys2
top2;
7/Gameboy/WHACKAMOLE/easy/easy.srcs/sources_1/new/top.sv2
48@Z8-638
„
synthesizing module '%s'638*oasys2
IBUFDS2;
7/opt/Xilinx/Vivado/2013.2/scripts/rt/data/unisim_comp.v2
60748@Z8-638
L
%s*synth2=
;	Parameter CAPACITANCE bound to: DONT_CARE - type: string 

E
%s*synth26
4	Parameter DIFF_TERM bound to: TRUE - type: string 

E
%s*synth26
4	Parameter DQS_BIAS bound to: FALSE - type: string 

I
%s*synth2:
8	Parameter IBUF_DELAY_VALUE bound to: 0 - type: string 

H
%s*synth29
7	Parameter IBUF_LOW_PWR bound to: TRUE - type: string 

K
%s*synth2<
:	Parameter IFD_DELAY_VALUE bound to: AUTO - type: string 

I
%s*synth2:
8	Parameter IOSTANDARD bound to: DEFAULT - type: string 

›
%done synthesizing module '%s' (%s#%s)256*oasys2
IBUFDS2
12
22;
7/opt/Xilinx/Vivado/2013.2/scripts/rt/data/unisim_comp.v2
60748@Z8-256
•
%done synthesizing module '%s' (%s#%s)256*oasys2
top2
22
22;
7/Gameboy/WHACKAMOLE/easy/easy.srcs/sources_1/new/top.sv2
48@Z8-256
ˆ
%s*synth2y
wfinished Rtl Elaboration : Time (s): cpu = 00:00:02 ; elapsed = 00:00:03 . Memory (MB): peak = 212.066 ; gain = 95.594

†
%s*synth2w
uStart RTL Optimization : Time (s): cpu = 00:00:02 ; elapsed = 00:00:03 . Memory (MB): peak = 212.066 ; gain = 95.594

(
%s*synth2
Report Check Netlist: 

R
%s*synth2C
A-----+-----------------+------+--------+------+-----------------

R
%s*synth2C
A     |Item             |Errors|Warnings|Status|Description      

R
%s*synth2C
A-----+-----------------+------+--------+------+-----------------

R
%s*synth2C
A1    |multi_driven_nets|     0|       0|Passed|Multi driven nets

R
%s*synth2C
A-----+-----------------+------+--------+------+-----------------

J
-Analyzing %s Unisim elements for replacement
17*netlist2
1Z29-17
O
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28
Ž
Loading clock regions from %s
13*device2W
U/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/virtex7/virtex7/xc7vx485t/ClockRegion.xmlZ21-13

Loading clock buffers from %s
11*device2X
V/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/virtex7/virtex7/xc7vx485t/ClockBuffers.xmlZ21-11
Š
&Loading clock placement rules from %s
318*place2J
H/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/virtex7/ClockPlacerRules.xmlZ30-318
ˆ
)Loading package pin functions from %s...
17*device2F
D/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/virtex7/PinFunctions.xmlZ21-17
Œ
Loading package from %s
16*device2[
Y/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/virtex7/virtex7/xc7vx485t/ffg1761/Package.xmlZ21-16
}
Loading io standards from %s
15*device2G
E/opt/Xilinx/Vivado/2013.2/data/./parts/xilinx/virtex7/IOStandards.xmlZ21-15
‰
+Loading device configuration modes from %s
14*device2E
C/opt/Xilinx/Vivado/2013.2/data/parts/xilinx/virtex7/ConfigModes.xmlZ21-14
M
 Attempting to get a license: %s
78*common2
Internal_bitstreamZ17-78
K
Failed to get a license: %s
295*common2
Internal_bitstreamZ17-301
5

Processing XDC Constraints
244*projectZ1-262
<
%Done setting XDC timing constraints.
35*timingZ38-35
p
Parsing XDC File [%s]
179*designutils2:
8/Gameboy/WHACKAMOLE/easy/easy.srcs/constrs_1/new/top.xdcZ20-179
y
Finished Parsing XDC File [%s]
178*designutils2:
8/Gameboy/WHACKAMOLE/easy/easy.srcs/constrs_1/new/top.xdcZ20-178
?
&Completed Processing XDC Constraints

245*projectZ1-263
c
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111
1
%Phase 0 | Netlist Checksum: d14dc6f3
*common
‡
%s*synth2x
vStart RTL Optimization : Time (s): cpu = 00:00:22 ; elapsed = 00:00:23 . Memory (MB): peak = 938.273 ; gain = 821.801

£
%s*synth2“
Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:22 ; elapsed = 00:00:23 . Memory (MB): peak = 938.273 ; gain = 821.801

…
%s*synth2v
tFinished Compilation : Time (s): cpu = 00:00:23 ; elapsed = 00:00:23 . Memory (MB): peak = 938.273 ; gain = 821.801

)
%s*synth2
Report RTL Partitions: 

;
%s*synth2,
*-----+-------------+-----------+---------

;
%s*synth2,
*     |RTL Partition|Replication|Instances

;
%s*synth2,
*-----+-------------+-----------+---------

;
%s*synth2,
*-----+-------------+-----------+---------

}
%s*synth2n
lPart Resources:
DSPs: 2800 (col length:140)
BRAMs: 2060 (col length: RAMB8 0 RAMB16 0 RAMB18 140 RAMB36 70)

Ÿ
%s*synth2
ŒFinished Loading Part and Timing Information : Time (s): cpu = 00:00:30 ; elapsed = 00:00:30 . Memory (MB): peak = 938.273 ; gain = 821.801

0
%s*synth2!
Detailed RTL Component Info : 


%s*synth2
+---Adders : 

?
%s*synth20
.	   2 Input      8 Bit       Adders := 1     

"
%s*synth2
+---Registers : 

?
%s*synth20
.	                8 Bit    Registers := 1     

?
%s*synth20
.	                1 Bit    Registers := 1     

4
%s*synth2%
#Hierarchical RTL Component report 


%s*synth2
Module top 

0
%s*synth2!
Detailed RTL Component Info : 


%s*synth2
+---Adders : 

?
%s*synth20
.	   2 Input      8 Bit       Adders := 1     

"
%s*synth2
+---Registers : 

?
%s*synth20
.	                8 Bit    Registers := 1     

?
%s*synth20
.	                1 Bit    Registers := 1     

—
%s*synth2‡
„Finished Cross Boundary Optimization : Time (s): cpu = 00:00:30 ; elapsed = 00:00:30 . Memory (MB): peak = 938.273 ; gain = 821.801


%s*synth2€
~---------------------------------------------------------------------------------
Start RAM, DSP and Shift Register Reporting

c
%s*synth2T
R---------------------------------------------------------------------------------

”
%s*synth2„
---------------------------------------------------------------------------------
Finished RAM, DSP and Shift Register Reporting

c
%s*synth2T
R---------------------------------------------------------------------------------

‹
%s*synth2|
zFinished Area Optimization : Time (s): cpu = 00:00:30 ; elapsed = 00:00:30 . Memory (MB): peak = 938.273 ; gain = 821.801

›
%s*synth2‹
ˆFinished Applying XDC Timing Constraints : Time (s): cpu = 00:00:30 ; elapsed = 00:00:30 . Memory (MB): peak = 938.273 ; gain = 821.801

?
%s*synth20
.info: start optimizing sub-critical range ...

;
%s*synth2,
*info: done optimizing sub-critical range.


%s*synth2~
|Finished Timing Optimization : Time (s): cpu = 00:00:30 ; elapsed = 00:00:30 . Memory (MB): peak = 938.273 ; gain = 821.801

1
%s*synth2"
 Start control sets optimization

r
%s*synth2c
aFinished control sets optimization. Modified 9 flops. Number of control sets: before: 2 after: 1

Œ
%s*synth2}
{Finished Technology Mapping : Time (s): cpu = 00:00:30 ; elapsed = 00:00:30 . Memory (MB): peak = 938.273 ; gain = 821.801

†
%s*synth2w
uFinished IO Insertion : Time (s): cpu = 00:00:30 ; elapsed = 00:00:31 . Memory (MB): peak = 938.273 ; gain = 821.801

(
%s*synth2
Report Check Netlist: 

R
%s*synth2C
A-----+-----------------+------+--------+------+-----------------

R
%s*synth2C
A     |Item             |Errors|Warnings|Status|Description      

R
%s*synth2C
A-----+-----------------+------+--------+------+-----------------

R
%s*synth2C
A1    |multi_driven_nets|     0|       0|Passed|Multi driven nets

R
%s*synth2C
A-----+-----------------+------+--------+------+-----------------

˜
%s*synth2ˆ
…Finished Renaming Generated Instances : Time (s): cpu = 00:00:30 ; elapsed = 00:00:31 . Memory (MB): peak = 938.273 ; gain = 821.801

•
%s*synth2…
‚Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:30 ; elapsed = 00:00:31 . Memory (MB): peak = 938.273 ; gain = 821.801


%s*synth2€
~---------------------------------------------------------------------------------
Start RAM, DSP and Shift Register Reporting

c
%s*synth2T
R---------------------------------------------------------------------------------

”
%s*synth2„
---------------------------------------------------------------------------------
Finished RAM, DSP and Shift Register Reporting

c
%s*synth2T
R---------------------------------------------------------------------------------

%
%s*synth2
Report BlackBoxes: 

/
%s*synth2 
-----+-------------+---------

/
%s*synth2 
     |BlackBox name|Instances

/
%s*synth2 
-----+-------------+---------

/
%s*synth2 
-----+-------------+---------

%
%s*synth2
Report Cell Usage: 

$
%s*synth2
-----+------+-----

$
%s*synth2
     |Cell  |Count

$
%s*synth2
-----+------+-----

$
%s*synth2
1    |BUFG  |    1

$
%s*synth2
2    |LUT2  |    3

$
%s*synth2
3    |LUT4  |    3

$
%s*synth2
4    |LUT5  |    1

$
%s*synth2
5    |LUT6  |    6

$
%s*synth2
6    |FDRE  |    9

$
%s*synth2
7    |IBUF  |    2

$
%s*synth2
8    |IBUFDS|    1

$
%s*synth2
9    |OBUF  |    8

$
%s*synth2
-----+------+-----

)
%s*synth2
Report Instance Areas: 

-
%s*synth2
-----+--------+------+-----

-
%s*synth2
     |Instance|Module|Cells

-
%s*synth2
-----+--------+------+-----

-
%s*synth2
1    |top     |      |   34

-
%s*synth2
-----+--------+------+-----

”
%s*synth2„
Finished Writing Synthesis Report : Time (s): cpu = 00:00:30 ; elapsed = 00:00:31 . Memory (MB): peak = 938.273 ; gain = 821.801

W
%s*synth2H
FSynthesis finished with 0 errors, 0 critical warnings and 0 warnings.

‘
%s*synth2
Synthesis Optimization Complete : Time (s): cpu = 00:00:30 ; elapsed = 00:00:31 . Memory (MB): peak = 938.273 ; gain = 821.801

J
-Analyzing %s Unisim elements for replacement
17*netlist2
3Z29-17
O
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28
1
Pushed %s inverter(s).
98*opt2
0Z31-138
c
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111
1
%Phase 0 | Netlist Checksum: 52857e09
*common
u
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
152
12
02
0Z4-41
C
%s completed successfully
29*	vivadotcl2
synth_designZ4-42
£
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
synth_design: 2

00:00:342

00:00:342

1027.4572	
873.789Z17-268
‚
vreport_utilization: Time (s): cpu = 00:00:00.04 ; elapsed = 00:00:00.09 . Memory (MB): peak = 1027.457 ; gain = 0.000
*common
S
Exiting %s at %s...
206*common2
Vivado2
Fri Sep 20 16:37:39 2013Z17-206