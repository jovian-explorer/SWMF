#^CFG FILE _FALSE_
$tree = [{'name' => 'commandList','attrib' => {'name' => 'BATSRUS: GM, SC and IH Components'},'content' => [{'content' => '

List of MH (GM, IH and SC) commands used in the PARAM.in file


','type' => 't'},{'name' => 'set','attrib' => {'value' => '$_GridSize[0]','name' => 'nI','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'set','attrib' => {'value' => '$_GridSize[1]','name' => 'nJ','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'set','attrib' => {'value' => '$_GridSize[2]','name' => 'nK','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'set','attrib' => {'value' => '$_GridSize[3]','name' => 'MaxBlock','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'set','attrib' => {'value' => '$_GridSize[4]','name' => 'MaxImplBlock','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'set','attrib' => {'value' => '$_nProc and $MaxBlock and $_nProc*$MaxBlock','name' => 'MaxBlockALL','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'set','attrib' => {'value' => '$_NameComp/restartOUT','name' => 'NameRestartOutDir','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'set','attrib' => {'value' => '$_NameComp/IO2','name' => 'NamePlotDir','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'STAND ALONE MODE'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!! STAND ALONE PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

','type' => 't'},{'name' => 'command','attrib' => {'name' => 'COMPONENT'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'NameComp','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'SC','if' => '$_NameComp eq \'SC\'','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'IH','if' => '$_NameComp eq \'IH\'','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'GM','if' => '$_NameComp eq \'GM\'','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#COMPONENT
GM			NameComp

This command is only used in the stand alone mode.

The NameComp variable contains the two-character component ID
for the component which BATSRUS is representing.
If NameComp does not agree with the value of the NameThisComp
variable, BATSRUS stops with an error message.
This command is saved into the restart header file for consistency check.

There is no default value: if the command is not given, the component ID is not checked.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'DESCRIPTION','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'StringDescription','type' => 'string'},'content' => [],'type' => 'e'},{'content' => '

#DESCRIPTION
This is a test run for Jupiter with no rotation.

This command is only used in the stand alone mode.

The StringDescription string can be used to describe the simulation
for which the parameter file is written. The #DESCRIPTION command and
the StringDescription string are saved into the restart file,
which helps in identifying the restart files.

The default value is ``Please describe me!", which is self explanatory.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'ECHO','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoEcho','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#ECHO
T                       DoEcho

This command is only used in the stand alone mode.

If the DoEcho variable is true, the input parameters are echoed back.
The default value for DoEcho is .false., but it is a good idea to
set it to true at the beginning of the PARAM.in file.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PROGRESS','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DnProgressShort','min' => '-1','default' => '10','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DnProgressLong','min' => '-1','default' => '100','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#PROGRESS
10			DnProgressShort
100			DnProgressLong

The frequency of short and long progress reports for BATSRUS in
stand alone mode. These are the defaults. Set -1-s for no progress reports.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TIMEACCURATE','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoTimeAccurate','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#TIMEACCURATE
F               DoTimeAccurate

This command is only used in stand alone mode.

If DoTimeAccurate is set to true, BATSRUS solves
a time dependent problem. If DoTimeAccurate is false, a steady-state
solution is sought for. It is possible to use steady-state mode
in the first few sessions to obtain a steady state solution,
and then to switch to time accurate mode in the following sessions.
In time accurate mode saving plot files, log files and restart files,
or stopping conditions are taken in simulation time, which is the
time relative to the initial time. In steady state mode the simulation
time is not advanced at all, instead the time step or iteration number
is used to control the frequencies of various actions.

The steady-state mode allows BATSRUS to use local time stepping
to accelerate the convergence towards steady state.

The default value depends on how the stand alone code was installed.
See the description of the NEWPARAM command.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'multiple' => 'T','name' => 'BEGIN_COMP','if' => '$_IsStandAlone'},'content' => [{'content' => '

This command is allowed in stand alone mode only for the sake of the 
test suite, which contains these commands when the framework is tested.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'multiple' => 'T','name' => 'END_COMP','if' => '$_IsStandAlone'},'content' => [{'content' => '

This command is allowed in stand alone mode only for the sake of the 
test suite, which contains these commands when the framework is tested.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'RUN','if' => '$_IsStandAlone'},'content' => [{'content' => '

#RUN

This command is only used in stand alone mode.

The #RUN command does not have any parameters. It signals the end
of the current session, and makes BATSRUS execute the session with
the current set of parameters. The parameters for the next session
start after the #RUN command. For the last session there is no
need to use the #RUN command, since the #END command or simply
the end of the PARAM.in file makes BATSRUS execute the last session.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'END'},'content' => [{'content' => '

#END

The #END command signals the end of the included file or the
end of the PARAM.in file. Lines following the #END command are
ignored. It is not required to use the #END command. The end
of the included file or PARAM.in file is equivalent with an 
#END command in the last line.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'PLANET PARAETERS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!! PLANET PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

The planet commands can only be used in stand alone mode.
The commands allow to work with an arbitrary planet.
It is also possible to change some parameters of the planet relative
to the real values.

By default Earth is assumed with its real parameters.
Another planet (moon, comet) can be selected with the #PLANET
(#MOON, #COMET) command. The real planet parameters can be modified 
and simplified with the other planet commands listed in this subsection.
These modified commands cannot precede the #PLANET command!

','type' => 't'},{'name' => 'command','attrib' => {'alias' => 'MOON,COMET','name' => 'PLANET','if' => '$_IsFirstSession and $_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'NamePlanet','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'EARTH/Earth/earth','name' => 'Earth','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'SATURN/Saturn/saturn','name' => 'Saturn'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'New'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NamePlanet eq \'New\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'RadiusPlanet','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MassPlanet','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'OmegaPlanet','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TiltRotation','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypeBField','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'NONE'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'DIPOLE','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$TyepBField eq \'DIPOLE\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'MagAxisThetaGeo','min' => '0','max' => '180','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MagAxisPhiGeo','min' => '0','max' => '360','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DipoleStrength','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => 'not $PlanetCommand'},'content' => [{'content' => '
		PLANET should precede $PlanetCommand
	','type' => 't'}],'type' => 'e'},{'content' => '

#PLANET
New			NamePlanet (rest of parameters read for unknown planet)
6300000.0		RadiusPlanet [m]
5.976E+24		MassPlanet   [kg]
0.000000199		OmegaPlanet  [radian/s]
23.5			TiltRotation [degree]
DIPOLE			TypeBField
11.0			MagAxisThetaGeo [degree]
289.1			MagAxisPhiGeo   [degree]
-31100.0E-9		DipoleStrength  [T]

The NamePlanet parameter contains the name of the planet
with arbitrary capitalization. In case the name of the planet
is not recognized, the following variables are read:
RadiusPlanet is the radius of the planet,
MassPlanet is the mass of the planet, 
OmegaPlanet is the angular speed relative to an inertial frame, and
TiltRotation is the tilt of the rotation axis relative to ecliptic North,
TypeBField, which can be "NONE" or "DIPOLE". 
TypeBField="NONE" means that the planet does not have magnetic field. 
If TypeBField is set to "DIPOLE" then the following variables are read:
MagAxisThetaGeo and MagAxisPhiGeo are the colatitude and longitude
of the north magnetic pole in corotating planetocentric coordinates.
Finally DipoleStrength is the equatorial strength of the magnetic dipole
field. The units are indicated in the above example, which shows the
Earth values approximately.

The default value is NamePlanet="Earth", which is currently
the only recognized planet.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'ROTATIONAXIS','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'IsRotAxisPrimary','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$IsRotAxisPrimary'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'RotAxisTheta','min' => '0','max' => '180','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RotAxisPhi','min' => '0','max' => '360','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'set','attrib' => {'value' => 'ROTATIONAXIS','name' => 'PlanetCommand','type' => 'string'},'content' => [],'type' => 'e'},{'content' => '

#ROTATIONAXIS
T			IsRotAxisPrimary (rest of parameters read if true)
23.5			RotAxisTheta
198.3			RotAxisPhi

If the IsRotAxisPrimary variable is false, the rotational axis
is aligned with the magnetic axis. If it is true, the other two variables
are read, which give the position of the rotational axis at the
initial time in the GSE coordinate system. Both angles are read in degrees
and stored internally in radians.

The default is to use the true rotational axis determined by the
date and time given by #STARTTIME.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'ROTATION','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseRotation','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseRotation'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'RotationPeriod','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'set','attrib' => {'value' => 'MAGNETICAXIS','name' => 'PlanetCommand','type' => 'string'},'content' => [],'type' => 'e'},{'content' => '

#ROTATION
T			UseRotation
24.06575		RotationPeriod [hour] (read if UseRotation is true)

If UseRotation is false, the planet is assumed to stand still, 
and the OmegaPlanet variable is set to zero. 
If UseRotation is true, the RotationPeriod variable is read in hours, 
and it is converted to the angular speed OmegaPlanet given in radians/second.
Note that OmegaPlanet is relative to an inertial coordinate system,
so the RotationPeriod is not 24 hours for the Earth, but the
length of the astronomical day.

The default is to use rotation with the real rotation period of the planet.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'MAGNETICAXIS','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'IsMagAxisPrimary','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$IsMagAxisPrimary'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'MagAxisTheta','min' => '0','max' => '180','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MagAxisPhi','min' => '0','max' => '360','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'set','attrib' => {'value' => 'MAGNETICAXIS','name' => 'PlanetCommand','type' => 'string'},'content' => [],'type' => 'e'},{'content' => '

#MAGNETICAXIS
T			IsMagAxisPrimary (rest of parameters read if true)
34.5			MagAxisTheta [degree]
0.0			MagAxisPhi   [degree]

If the IsMagAxisPrimary variable is false, the magnetic axis
is aligned with the rotational axis. If it is true, the other two variables
are read, which give the position of the magnetic axis at the
initial time in the GSE coordinate system. Both angles are read in degrees
and stored internally in radians.

The default is to use the true magnetic axis determined by the
date and time given by #STARTTIME.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'DIPOLE','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DipoleStrength','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#DIPOLE
-3.11e-5		DipoleStrength [Tesla]

The DipoleStrength variable contains the
magnetic equatorial strength of the dipole magnetic field in Tesla.

The default value is the real dipole strength for the planet.
For the Earth the default is taken to be -31100 nT.
The sign is taken to be negative so that the magnetic axis can
point northward as usual.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'UPDATEB0','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DtUpdateB0','min' => '-1','default' => '0.0001','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

The DtUpdateB0 variable determines how often the position of
the magnetic axis is recalculated. A negative value indicates that
the motion of the magnetic axis during the course of the simulation
is neglected. This is an optimization parameter, since recalculating
the values which depend on the orientation of the magnetic
field can be costly. Since the magnetic field moves relatively
slowly as the planet rotates around, it may not be necessary
to continuously update the magnetic field orientation.

The default value is 0.0001, which means that the magnetic axis
is continuously followed.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'IDEALAXES','if' => '$_IsStandAlone'},'content' => [{'content' => '

#IDEALAXES

The #IDEALAXES command has no parameters. It sets both the rotational
and magnetic axes parallel with the ecliptic North direction. In fact
it is identical with the commands:

#ROTATIONAXIS
T               IsRotAxisPrimary
0.0             RotAxisTheta
0.0             RotAxisPhi

#MAGNETICAXIS
F               IsMagAxisPrimary

but much shorter.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'USER DEFINED INPUT'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!  USER DEFINED INPUT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

','type' => 't'},{'name' => 'command','attrib' => {'alias' => 'USER_FLAGS','name' => 'USERFLAGS'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseUserInnerBcs','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserSource','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserPerturbation','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserOuterBcs','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserICs','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserSpecifyRefinement','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserLogFiles','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserWritePlot','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserAMR','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserEchoInput','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserB0','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserInitSession','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseUserUpdateStates','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#USERFLAGS
F			UseUserInnerBcs
F			UseUserSource
F			UseUserPerturbation
F                       UseUserOuterBcs
F                       UseUserICs
F                       UseUserSpecifyRefinement
F                       UseUserLogFiles
F                       UseUserWritePlot
F                       UseUserAMR
F                       UseUserEchoInput
F                       UseUserB0
F                       UseUserInitSession
F                       UseUserUpdateStates

This command controls the use of user defined routines in ModUser.f90.
For each flag that is set, an associated routine will be called in 
the user module.  Default is .false. for all flags.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'USERINPUTBEGIN'},'content' => [{'content' => '

#USERINPUTBEGIN

This command signals the beginning of the section of the file which 
is read by the subroutine user\\_read\\_inputs in the ModUser.f90 file.
The section ends with the #USERINPUTEND command. 
There is no XML based parameter checking in the user section.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'USERINPUTEND'},'content' => [{'content' => '

#USERINPUTEND

This command signals the end of the section of the file which 
is read by the subroutine user\\_read\\_inputs in the ModUser.f90 file.
The section begins with the #USERINPUTBEGIN command. 
There is no XML based parameter checking in the user section.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'TESTING AND TIMING'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!  TESTING AND TIMING PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'TEST'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'TestString','type' => 'string'},'content' => [],'type' => 'e'},{'content' => '
#TEST
read_inputs

! A space separated list of subroutine names. Default is empty string.
!
! Examples:\\\\
!   read_inputs  - echo the input parameters following the #TEST line\\\\
!   project_B    - info on projection scheme\\\\   
!   implicit     - info on implicit scheme\\\\     
!   krylov       - info on the Krylov solver\\\\   
!   message_count- count messages\\\\
!   initial_refinement\\\\
!   ...
!
! Check the subroutines for call setoktest("...",oktest,oktest_me) to
! see the appropriate strings.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TESTIJK'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'iTest','min' => '-2','max' => '$nI+2','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'jTest','min' => '-2','max' => '$nJ+2','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'kTest','min' => '-2','max' => '$nK+2','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iBlockTest','min' => '1','max' => '$MaxBlock','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iProcTest','min' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#TESTIJK
1                       iTest           (cell index for testing)
1                       jTest           (cell index for testing)
1                       kTest           (cell index for testing)
1                       iBlockTest      (block index for testing)
0                       iProcTest       (processor index for testing)

! The location of test info in terms of indices, block and processor number.
! Note that the user should set #TESTIJK or #TESTXYZ, not both.  If both
! are set, the final one in the session will set the test point.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TESTXYZ'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xTest','min' => '$xMin','max' => '$xMax','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yTest','min' => '$yMin','max' => '$yMax','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zTest','min' => '$zMin','max' => '$zMax','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#TESTXYZ
1.5                     xTest           (X coordinate of cell for testing)
-10.5                   yTest           (Y coordinate of cell for testing)
-10.                    zTest           (Z coordinate of cell for testing)

! The location of test info in terms of coordinates.
! Note that the user should set #TESTIJK or #TESTXYZ, not both.  If both
! are set, the final one in the session will set the test point.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TESTTIME'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nIterTest','min' => '-1','default' => '-1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TimeTest','min' => '-1','default' => '1e30','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#TESTTIME
-1                      nIterTest       (iteration number to start testing)
10.5                    TimeTest        (time to start testing in seconds)

! The time step and physical time to start testing.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TESTVAR'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'iVarTest','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'value' => '1','name' => 'Rho','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '2','name' => 'RhoUx'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '3','name' => 'RhoUy'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '4','name' => 'RhoUz'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '5','name' => 'Bx'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '6','name' => 'By'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '7','name' => 'Bz'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '8','name' => 'e'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '9','name' => 'p'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#TESTVAR
1                       iVarTest

! Index of variable to be tested. Default is rho_="1", i.e. density.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TESTDIM'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'iVarTest','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'value' => '0','name' => 'all'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '1','name' => 'x','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '2','name' => 'y'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '3','name' => 'z'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#TESTDIM
1                       iDimTest

! Index of dimension/direction to be tested. Default is X dimension.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'multiple' => 'T','name' => 'STRICT'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseStrict','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#STRICT
T                       UseStrict

! If true then stop when parameters are incompatible. If false, try to
! correct parameters and continue. Default is true, i.e. strict mode
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'VERBOSE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'lVerbose','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'value' => '-1','name' => 'errors and warnings only'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '0','name' => 'start and end of sessions'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '1','name' => 'normal','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '10','name' => 'calls on test processor'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '100','name' => 'calls on all processors'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#VERBOSE
-1                      lVerbose

! Verbosity level controls the amount of output to STDOUT. Default level is 1.
!\\\\
!   lVerbose $\\leq -1$ only warnings and error messages are shown.\\\\
!   lVerbose $\\geq  0$ start and end of sessions is shown.\\\\
!   lVerbose $\\leq  1$ a lot of extra information is given.\\\\
!   lVerbose $\\leq 10$ all calls of set_oktest are shown for the test processor.\\\\
!   lVerbose $\\leq 100$ all calls of set_oktest are shown for all processors.\\\\
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'DEBUG'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoDebug','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoDebugGhost','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#DEBUG
F                       DoDebug         (use it as if(okdebug.and.oktest)...)
F                       DoDebugGhost    (parameter for show_BLK in library.f90)

! Excessive debug output can be controlled by the global okdebug parameter
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'CODEVERSION','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'CodeVersion','min' => '0','default' => '7.50','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#CODEVERSION
7.50                    CodeVersion

! Checks CodeVersion. Prints a WARNING if it differs from the CodeVersion
! defined in ModMain.f90. Used in newer restart header files. 
! Should be given in PARAM.in when reading old restart files, 
! which do not have version info in the header file.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'USERMODULE','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameUserModule','default' => 'EMPTY','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'VersionUserModule','min' => '0','default' => '1.0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#USERMODULE
TEST PROBLEM Smith
1.3			VersionUserModule

Checks the selected user module. If the name or the version number
differs from that of the compiled user module, a warning is written,
and the code stops in strict mode (see #STRICT command). 
This command and its parameters are written into the restart header file too,
so the user module is checked when a restart is done. 
There are no default values. If the command is not present, the user 
module is not checked.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'EQUATION','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameEquation','default' => 'MHD','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nVar','default' => '8','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#EQUATION
MHD			NameEquation
8			nVar

! Define the equation name and the number of variables.
! If any of these do not agree with the values determined 
! by the code, BATSRUS stops with an error. Used in restart
! header files and can be given in PARAM.in as a check
! and as a description.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PRECISION','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nByteReal','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'value' => '4','name' => 'single precision (4)','default' => '$_nByteReal==4'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '8','name' => 'double precision (8)','default' => '$_nByteReal==8'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '$nByteReal==$_nByteReal or not $UseStrict'},'content' => [{'content' => '
		nByteReal in file must agree with _nByteReal in strict mode.
	','type' => 't'}],'type' => 'e'},{'content' => '

#PRECISION
8                       nByteReal

Define the number of bytes in a real number. If it does not agree
with the value determined by the code, BATSRUS stops with an error
unless the strict mode is switched off.
This is used in restart header files to store (and check) the precision
of the restart files. It is now possible to read restart files with
a precision that differs from the precision the code is compiled with,
but strict mode has to be switched off with the #STRICT command.
The #PRECISION command may also be used to enforce a certain precision.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'CHECKGRIDSIZE','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nI','min' => '$nI','max' => '$nI','default' => '$nI','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nJ','min' => '$nJ','max' => '$nJ','default' => '$nJ','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nK','min' => '$nK','max' => '$nK','default' => '$nK','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MinBlockALL','min' => '1','max' => '$MaxBlockALL','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '

#CHECKGRIDSIZE
       4                        nI
       4                        nJ
       4                        nK
     576                        MinBlockALL

! Checks block size and number of blocks. Stops with an error message,
! if nI, nJ, or nK differ from those set in ModSize. 
! Also stops if number_of_blocks exceeds nBLK*numprocs, where nBLK 
! is defined in ModSize and numprocs is the number of processors.
! This command is used in the restart headerfile to check consistency,
! and it is also useful to check if the executable is consistent with the 
! requirements of the problem described in the PARAM.in file.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'BLOCKLEVELSRELOADED'},'content' => [{'content' => '
#BLOCKLEVELSRELOADED

This command means that the restart file contains the information about
the minimum and maximum allowed refinement levels for each block.
This command is only used in the restart header file.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TIMING','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseTiming','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseTiming'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'Frequency','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'value' => '-3','name' => 'none'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '-2','name' => 'final only','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '-1','name' => 'end of sessions'},'content' => [],'type' => 'e'},{'name' => 'optioninput','attrib' => {'name' => 'every X steps','min' => '1','default' => '100'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nDepthTiming','min' => '-1','default' => '-1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypeTimingReport','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'cumu','name' => 'cumulative','default' => '1'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'list'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'tree'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'content' => '
#TIMING
T                       UseTiming      (rest of parameters read if true)
-2                      DnTiming       (-3 none, -2 final, -1 each session/AMR)
-1                      nDepthTiming   (-1 for arbitrary depth)
tree                    TypeTimingReport   (\'cumu\', \'list\', or \'tree\')

! The default values are shown.
!
! This command can only be used in stand alone mode. In the SWMF the
! #TIMING command should be issued for CON.
!
! If UseTiming=.true., the TIMING module must be on.
! If UseTiming=.false., the execution is not timed.
!
! Dntiming determines the frequency of timing reports.
! If DnTiming .ge.  1, a timing report is produced every dn_timing step.
! If DnTiming .eq. -1, a timing report is shown at the end of each session,
!                    before each AMR, and at the end of the whole run.
! If DnTiming .eq. -2, a timing report is shown at the end of the whole run.
! If DnTiming .eq. -3, no timing report is shown.
!
! nDepthTiming determines the depth of the timing tree. A negative number
! means unlimited depth. If TimingDepth is 1, only the full BATSRUS execution
! is timed.
!
! TypeTimingReport determines the format of the timing reports:
! \'cumu\' - cumulative list sorted by timings
! \'list\' - list based on caller and sorted by timings
! \'tree\' - tree based on calling sequence
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'INITIAL AND BOUNDARY CONDITIONS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!! MAIN INITIAL AND BOUNDARY CONDITION PARAMETERS  !!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'RESTARTINDIR','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameRestartInDir','default' => 'GM/restartIN','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '-d $NameRestartInDir'},'content' => [{'content' => '
		Restart input directory $NameRestartInDir must exist!
	','type' => 't'}],'type' => 'e'},{'content' => '

#RESTARTINDIR
GM/restart_n5000	NameRestartInDir

! The NameRestartInDir variable contains the name of the directory
! where restart files are saved relative to the run directory.
! The directory should be inside the subdirectory with the name 
! of the component.
!
! Default value is "GM/restartIN".
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'RESTARTINFILE','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeRestartInFile','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'block','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'one'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#RESTARTINFILE
one			TypeRestartInFile

This command is normally saved in the restart header file, and it describes
how the restart data was saved: 
into separate files for each grid block (\'block\') 
or into a single direct access file (\'one\').
The default value is \'block\'.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'NEWRESTART','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoRestartBFace','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => ' 

#NEWRESTART
T		DoRestartBFace 

! The RESTARTINDIR/restart.H file always contains the #NEWRESTART command.
! This command is really used only in the restart headerfile.  Generally
! it is not inserted in a PARAM.in file by the user.
!
! The #NEWRESTART command sets the following global variables:
! DoRestart=.true. (read restart files),
! DoRestartGhost=.false.  (no ghost cells are saved into restart file)
! DoRestartReals=.true.   (only real numbers are saved in blk*.rst files).

! The DoRestartBFace parameter tells if the face centered magnetic field
! is saved into the restart files. These values are used by the 
! Constrained Transport scheme.

','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'OUTERBOUNDARY'},'content' => [{'name' => 'foreach','attrib' => {'values' => 'TypeBcEast,TypeBcWest,TypeBcSouth,TypeBcNorth,TypeBcBot,TypeBcTop','name' => 'Side'},'content' => [{'name' => 'parameter','attrib' => {'name' => '$Side','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'coupled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'vary/inflow','default' => '$Side eq \'TypeBcEast\''},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'float/outflow','default' => '$Side ne \'TypeBcEast\''},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'heliofloat'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'reflect'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'periodic'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'fixed'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'shear'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'linetied'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'raeder'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'arcadetop'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'arcadebot'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'arcadebotcont'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'user'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => 'not($TypeBcEast eq \'periodic\' xor $TypeBcWest eq \'periodic\')'},'content' => [{'content' => '
		East and west BCs must be both periodic or neither
	','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => 'not($TypeBcSouth eq \'periodic\' xor $TypeBcNorth eq \'periodic\')'},'content' => [{'content' => '
		South and North BCs must be both periodic or neither
	','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => 'not($TypeBcBot eq \'periodic\' xor $TypeBcTop eq \'periodic\')'},'content' => [{'content' => '
		Bottom and top BCs must be both periodic or neither
	','type' => 't'}],'type' => 'e'},{'content' => '
#OUTERBOUNDARY
outflow                 TypeBcEast
inflow                  TypeBcWest
float                   TypeBcSouth
float                   TypeBcNorth
float                   TypeBcBottom
float                   TypeBcTop

! Default depends on problem type.\\\\
! Possible values:
!\\begin{verbatim}
! coupled       - GM coupled to the IH component (at the \'west\' boundary)
! fixed         - fixed solarwind values
! fixedB1       - fixed solarwind values without correction for the dipole B0
! float/outflow - zero gradient
! heliofloat    - floating for the SC component (requires #FACEOUTERBC)
! linetied      - float P, rho, and B, reflect all components of U
! raeder        - Jimmy Raeder\'s BC
! reflect       - reflective
! periodic      - periodic
! vary/inflow   - time dependent BC (same as fixed for non time_accurate)
! shear         - sheared (intended for shock tube problem only)
! arcadetop     - intended for arcade problem only
! arcadebot     - intended for arcade problem only
! arcadebotcont - intended for arcade problem only
! user          - user defined
!\\end{verbatim}
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'INNERBOUNDARY'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeBcInner','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'reflect'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'float'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'fixed'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ionosphere','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'ionosphereB0/ionosphereb0','name' => 'ionosphereB0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ionospherefloat'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'coronatoih'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'user'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseBody2'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeBcBody2','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'reflect','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'float'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'fixed'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ionosphere'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ionosphereB0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ionospherefloat'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => 'not($TypeBcBody2 =~ /ionosphere/)'},'content' => [{'content' => ' 
	For the second body COROTATION AND AN IONOSPHERIC BOUNDARY DO NOT WORK.
	','type' => 't'}],'type' => 'e'},{'content' => '

#INNERBOUNDARY
ionosphere              TypeBcInner
ionosphere              TypeBcBody2  !read only if UseBody2=T 


This command should appear after the #SECONDBODY command when using 
two bodies. Note: for the second body COROTATION AND AN IONOSPHERIC 
BOUNDARY DO NOT WORK.

Default value for TypeBcBody2 is \'reflect\'.


Possible values for TypeBcInner are:
\\begin{verbatim}
\'reflect\'         - reflect Vr, reflect Vphi to rotation, float Vtheta,
                    reflect Br, float Bphi, float Btheta, float rho, float P
\'float\'           - float Vr, reflect Vphi to rotation, float Vtheta,
                    float B, float rho, float P
\'fixed\'           - Vr=0, Vphi=rotation, Vtheta=0
                    B=B0 (ie B1=0), fix rho, fix P
\'ionosphere\'      - set V as if ionosphere gave V_iono=0
                    float B, fix rho, fix P
\'ionospherefloat\' - set V as if ionosphere gave V_iono=0
                    float B, float rho, float P
\'coronatoih\'      - IH component obtains inner boundary from the SC component
\'user\'            - user defined
\\end{verbatim}
For \'ionosphere\' and \'ionospherefloat\' types and a coupled GM-IE run,
the velocity at the inner boundary is determined by the ionosphere model.

Default value for TypeBcInner is \'ionosphere\' for problem types
Earth, Saturn, Jupiter, and rotation.
For all other problems with an inner boundary the default is \'unknown\',
so the inner boundary must be set.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'EXTRABOUNDARY'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseExtraBoundary','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseExtraBoundary'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeExtraBoundary','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoFixExtraBoundary','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#EXTRABOUNDARY
T		UseExtraBoundary
user		TypeExtraBoundary
F		DoFixExtraboundary

It UseExtraBoundary is true, the user can define an extra boundary
condition in the user files. The TypeExtraBoundary can be used
to select a certain type. The DoFixExtraboundary controls
if resolution change is allowed.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'FACEOUTERBC'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'MaxBoundary','min' => '0','max' => '6','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$MaxBoundary >= 1'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoFixOuterBoundary','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#FACEOUTERBC
0              MaxBoundary            
F              DoFixOuterBoundary)    !read only for MaxBoundary>=East_(=1).

If MaxBoundary is East_(=1) or more then the outer boundaries indexed
between East_ and MaxBoundary are treated using set_BCs.f90 subroutines 
(face values are defined) instead of set_outerBCs.f90 (ghost cell values
are defined).
If DoFixOuterBoundary is .true., there is no resolution
change along the outer boundaries indexed from East_ to MaxBoundary.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'GRID GEOMETRY'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!! GRID GEOMETRY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

','type' => 't'},{'name' => 'command','attrib' => {'name' => 'GRID','if' => '$_IsFirstSession','required' => 'T'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nRootBlockX','min' => '1','default' => '2','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nRootBlockY','min' => '1','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nRootBlockZ','min' => '1','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xMin','default' => '-192.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xMax','min' => '$xMin','default' => '  64.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yMin','default' => ' -64.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yMax','min' => '$yMin','default' => '  64.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zMin','default' => ' -64.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zMax','min' => '$zMin','default' => '  64.0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#GRID
2                       nRootBlockX
1                       nRootBlockY
1                       nRootBlockZ
-224.                   xMin
 32.                    xMax
-64.                    yMin
 64.                    yMax
-64.                    zMin
 64.                    zMax

! The nRootBlockX, nRootBlockY and nRootBlockZ parameters define the 
! number of blocks of the base grid, i.e. the roots of the octree. 
! By varying these parameters, one can setup a grid which is elongated
! in some direction. The xMin, ..., zMax parameters define the physical
! size of the grid.
!
! There is no default value, the grid size must always be given.
! The #GRID command should be used before the #SAVEPLOT command.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'multiple' => 'T','alias' => 'COORDINATESYSTEM','name' => 'COORDSYSTEM'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeCoordSystem','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'GSM','if' => '$_NameComp eq \'GM\'','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'HGI','if' => '$_NameComp eq \'IH\'','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'HGC','if' => '$_NameComp eq \'IH\''},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'HGR','if' => '$_NameComp eq \'SC\'','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'HGI','if' => '$_NameComp eq \'SC\''},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#COORDSYSTEM
GSM			TypeCoordSystem

! TypeCoordSystem defines the coordinate system for the component.
! Currently only one coordinate system is available for GM ("GSM")
! and two for IH ("HGI" or "HGC") and two for SC ("HGR" or "HGI"). 
! In the future "GSE" should be also an option for GM.
! The coordinate systems are defined in share/Library/src/CON_axes.
!
! Default is component dependent: "GSM" for GM, "HGI" for IH, and "HGR" for SC.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'VERTEXBASEDGRID','if' => '$_IsFirstSession and $_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseVertexBasedGrid','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#VERTEXBASEDGRID
F                         UseVertexBasedGrid

For a vertex-based logically cartesian (spherical, cylindircal) grid 
(UseVertexBasedGrid=.true.) the node coordinates are defined
in terms of an arbitrary pointwide transformation of nodes of an 
original cartesian (spherical,cylindrical) block adaptive grid.
Advantage: the possiblity to use the arbitrary transformation.
Disadvantages: the cell center coordinates can not be definied unambigously
and the difference of the state variables across the face does not evaluate
the gradient in the direction, normal to this face (stricly speaking).
Cell-centered grids are used if UseVertexBasedGrid=.false. (default value)
Advantage: for some particular geometries (spherical, cylindrical) the 
control volumes are the Voronoy cells (any face is perpendicular to the line
connecting the centers of the neighboring cells). 
Disadvantages: even in these particular cases it is not easy to properly 
define the face area vectors at the resolution change. More general 
cell-centered grid either is not logically cartesian, or does not consist of 
the Voronoy cells only.

','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'INITIAL TIME'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!! INITIAL TIME AND STEP !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'alias' => 'SETREALTIME','name' => 'STARTTIME','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'iYear','default' => '2000','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iMonth','min' => '1','max' => '12','default' => '3','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iDay','min' => '1','max' => '31','default' => '21','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iHour','min' => '0','max' => '23','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iMinute','min' => '0','max' => '59','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iSecond','min' => '0','max' => '59','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#STARTTIME
2000                    iYear
3                       iMonth
21                      iDay
10                      iHour
45                      iMinute
0                       iSecond

The #STARTTIME command sets the initial date and time for the
simulation in Greenwich Mean Time (GMT) or Universal Time (UT)
in stand alone mode. 
In the SWMF this command checks start times against the SWMF start time 
and warns if the difference exceeds 1 millisecond.
This time is stored in the BATSRUS restart header file.

The default values are shown above.
This is a date and time when both the rotational and the magnetic axes
have approximately zero tilt towards the Sun.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TIMESIMULATION','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'tSimulation','min' => '0','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#TIMESIMULATION
3600.0			tSimulation [sec]

The tSimulation variable contains the simulation time in seconds
relative to the initial time set by the #STARTTIME command.
The #TIMESIMULATION command and tSimulation are saved into the restart 
header file, which provides human readable information about the restart state.

In SWMF the command is ignored (SWMF has its own #TIMESIMULATION command).
In stand alone mode time\\_simulation is set, but in case of a restart,
it gets overwritten by the binary value saved into the .rst binary files. 

The default value is tSimulation=0.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'NSTEP','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nStep','min' => '0','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '

#NSTEP
100			nStep

! Set nStep for the component. Typically used in the restart.H header file.
! Generally it is not inserted in a PARAM.in file by the user.
!
! The default is nStep=0 as the starting time step with no restart.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'NPREVIOUS','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nPrevious','min' => '-1','default' => '-1','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '

#NPREVIOUS
100			nPrev
1.5			DtPrev

! This command should only occur in the restart.H header file.
! If it is present, it indicates that the restart file contains
! the state variables for the previous time step.
! nPrev is the time step number and DtPrev is the length of the previous 
! time step in seconds.
! The previous time step is needed for a second order in time restart 
! with the implicit scheme. 
!
! The default is that the command is not present and no previous time step 
! is saved into the restart files.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'TIME INTEGRATION'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!  TIME INTEGRATION PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'TIMESTEPPING'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nStage','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'value' => '1'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '2','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CflExpl','min' => '0','max' => '1','default' => '0.8','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#TIMESTEPPING
2                       nStage (1 or 2)
0.80                    CflExpl

Parameters for time integration. For explicit time integration nStage
is the number of stages in the Runge-Kutta scheme. For implicit time
stepping nStage=2 corresponds to the BDF2 scheme that
uses the previous time step to make the scheme 2nd order accurate in time.
For explicit time stepping the CPU time is proportional to the number of 
stages. In time accurate runs the 1-stage explicit time stepping scheme 
may work reasonably well with second order spatial discretization, 
especially if the time step is limited to a very small value. 
Using a one stage scheme can speed up the code by a factor of two with 
little compromise in accuracy.

For local time stepping (steady state mode) one should always use the 
2-stage scheme with 2-nd order spatial accuracy to avoid oscillations
(or make the CFL number small, about 0.4). 

For implicit scheme the second order BDF2 scheme is more accurate 
but not more expensive than the first order backward Euler scheme, 
so it is a good idea to use nStage=nOrder. 

To achieve consistency between the spatial and temporal orders of accuracy,
the #SCHEME command always sets nStage to be the same as nOrder. 
The #TIMESTEPPING command can be used to reset nStage if required.

Default is 2-stage scheme with CflExpl=0.8
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'FIXEDTIMESTEP'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseDtFixed','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DtFixedDim','if' => '$UseDtFixed','min' => '0','default' => '1.0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#FIXEDTIMESTEP
T                       UseDtFixed
10.                     DtFixedDim [sec] (read if UseDtFixed is true)

! Default is UseDtFixed=.false. Effective only if DoTimeAccurate is true.
! If UseDtFixed is true, the time step is fixed to DtFixedDim.
!
! This is useful for debugging explicit schemes.

! The real application is, however, for implicit and partially
! implicit/local schemes. The time step is set to DtFixedDim unless the
! update checking decides to reduce the time step for the sake of robustness.

','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PARTSTEADY'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UsePartSteady','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

! If UsePartSteady is true, the partially steady state algorithm is used.
! Only blocks which are changing or next to changing blocks are evolved.
! This scheme can speed up the calculation if part 
! of the domain is in a numerical steady state. 
! In steady state runs the code stops when a full steady state is
! achieved. The conditions for checking the numerical steady state are set 
! by the #PARTSTEADYCRITERIA command.
! Default value is UsePartSteady = .false.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'STEADYCRITERIA','name' => 'PARTSTEADYCRITERIA'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'MinCheckVar','min' => '1','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MaxCheckVar','min' => '$MinCheckVar','default' => '8','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'for','attrib' => {'from' => '$MinCheckVar','to' => '$MaxCheckVar'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'RelativeEps','min' => '0','max' => '1','default' => '0.001','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'AbsoluteEps','min' => '0','default' => '0.0001','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#PARTSTEADYCRITERIA
5               MinCheckVar
8               MaxCheckVar
0.001           RelativeEps(bx)
0.0001          AbsoluteEps(bx)
0.001           RelativeEps(by)
0.0001          AbsoluteEps(by)
0.001           RelativeEps(bz)
0.0001          AbsoluteEps(bz)
0.001           RelativeEps(p)
0.0001          AbsoluteEps(p)

The part steady scheme only evolves blocks which are changing,
or neighbors of changing blocks. The scheme checks the neighbor blocks
every time step if their state variable has changed significantly.
This command allows the user to select the variables to be checked,
and to set the relative and absolute limits for each variable.
Only the state variables indexed from MinCheckVar to MaxCheckVar are checked.
The change in the block is significant if 
\\begin{verbatim}
max(abs(State - StateOld)) / (RelativeEps*abs(State) + AbsoluteEps)
\\end{verbatim}
exceeds 1.0 for any of the checked variables in any cells of the block.
(including body cells but excluding ghost cells).
The RelativeEps variable determines the maximum ratio of the change
and the norm of the old state. The AbsoluteEps variable is only needed
if the old state is very close to zero. It should be set to a positive
value which is much smaller than the typical significantly non-zero
value of the variable.

Default values are such that all variables are checked with
relative error 0.001 and absolute error 0.0001.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'POINTIMPLICIT'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UsePointImplicit','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BetaPointImplicit','if' => '$UsePointImplicit','min' => '0.5','max' => '1','default' => '0.5','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#POINTIMPLICIT
T		UsePointImplicit
0.5		BetaPointImplicit (read if UsePointImplicit is true)

Switches on or off the point implicit scheme. The BetaPointImplicit
parameter (in the 0.5 to 1.0 range) determines the order of accuracy 
for a 2-stage scheme. If BetaPointImplicit=0.5 the point implicit scheme 
is second order accurate in time when used in a 2-stage scheme. 
Larger values may be more robust, but only first order accurate in time.
For a 1-stage scheme (and in the 1st stage of a 2-stage scheme) the
BetaPointImplicit parameter is ignored, and the coefficient is set to 1.

The default values are UsePointImplicit=false and BetaPointImplicit=0.5.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PARTLOCAL'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UsePartLocal','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#PARTLOCAL
T               UsePartLocal

! Default is UsePartLocal=.false. If UsePartLocal is true and the
! run is time accurate, then the blocks selected as "implicit"
! by the criteria defined in #STEPPINGCRITERIA are not used to
! calculate the time step, and all cells are advanced with the
! smaller of the stable and the global time steps.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'IMPLICIT'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UsePointImplicit','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UsePartImplicit','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseFullImplicit','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CflImpl','if' => '$UsePartImplicit or $UseFullImplicit','min' => '0','default' => '100','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '$UsePointImplicit + $UsePartImplicit + $UseFullImplicit <= 1'},'content' => [{'content' => '
		At most one of these logicals can be true!
	','type' => 't'}],'type' => 'e'},{'content' => '

#IMPLICIT
F               UsePointImplicit
F               UsePartImplicit
F               UseFullImplicit
100.0           CflImpl (read if UsePartImplicit or UseFullImplicit is true)

! Default is false for all logicals. Only one of them can be set to true!
! The CFL number is used in the implicit blocks of the fully or partially
! implicit schemes. Ignored if UseDtFixed is true.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'IMPLICIT PARAMETERS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!! PARAMETERS FOR FULL AND PART IMPLICIT TIME INTEGRATION !!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'alias' => 'STEPPINGCRITERIA','name' => 'IMPLICITCRITERIA'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeImplCrit','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'dt','name' => 'Time step','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'r/R','name' => 'Radial distance'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'test','name' => 'Test block'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rImplicit','if' => '$TypeImplCrit eq \'R\'','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#IMPLICITCRITERIA
r		TypeImplCrit (dt or r or test)
10.0		rImplicit    (only read for TypeImplCrit = r)

! Both #IMPLICITCRITERIA and #STEPPINGCRITERIA are acceptable.
! Only effective if PartImplicit or PartLocal is true in a time accurate run.
! Default value is ImplCritType=\'dt\'.
!
! The options are
!\\begin{verbatim}
! if     (TypeImplCrit ==\'dt\'  ) then blocks with DtBLK .gt. DtFixed
! elseif (TypeImplCrit ==\'r\'   ) then blocks with rMinBLK .lt. rImplicit
! elseif (TypeImplCrit ==\'test\') then block iBlockTest on processor iProcTest
!\\end{verbatim}
! and are handled with local/implicit scheme. 
! Here DtBlock is the time step
! allowed by the CFL condition for a given block, while rMinBLK is the
! smallest radial distance for all the cells in the block.\\\\
!
! \\noindent
! The iBlockTest and iProcTest can be defined in the #TESTIJK command.\\\\
! DtFixed must be defined in the #FIXEDTIMESTEP command.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'PARTIMPLICIT','name' => 'PARTIMPL'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UsePartImplicit2','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#PARTIMPLICIT
T		UsePartImplicit2

If UsePartImplicit2 is set to true, the explicit scheme is executed in all
blocks before the implicit scheme is applied in the implicit blocks. This way
the fluxes at the explicit/implicit interface are second order accurate,
and the overall part implicit scheme will be fully second order in time.
When this switch is false, the explicit/implicit interface fluxes are only
first order accurate in time.
A potential drawback of the second order scheme is that the explicit scheme 
may crash in the implicit blocks. This could be avoided with a more 
sophisticated implementation. There may also be a slight speed penalty, 
because the explicit scheme is applied in more blocks. 

The default is UsePartImplicit2 = false for now, which is safe and 
backward compatible.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'IMPLICITSTEP','name' => 'IMPLSTEP'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'ImplCoeff','min' => '0','max' => '1','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseBdf2','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseSourceImpl','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#IMPLSTEP
0.5			ImplCoeff
F			UseBdf2
F			UseSourceImpl

The ImplCoeff is the beta coefficient in front of the implicit terms
for the two-level implicit scheme.
The UseBdf2 parameter decides if the 3 level BDF2 scheme is used or 
a 2 level scheme.
UseSourceImpl true means that the preconditioner should take point
source terms into account. 

For steady state run the default is the backward Euler scheme, which 
corresponds to ImplCoeff=1.0 and UsedBdf2=F.
For second order time accurate run the default is UseBdf2=T, since
BDF2 is a 3 level second order in time and stable implicit scheme.
In both cases the default value for UseSourceImpl is false.

The default values can be overwritten with #IMPLSTEP, but only
after the #TIMESTEPPING command!
For example one could use the 2-level trapezoid scheme with
ImplCoeff=0.5 and UseBDF2=F as shown in the example above. 
The BDF2 scheme determines the coefficient for the implicit terms itself, 
but ImplCoeff is still used in the first time step and after AMR-s, when
the code switches back to the two-level scheme for one time step.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'IMPLICITSCHEME','name' => 'IMPLSCHEME'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nOrderImpl','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'name' => '1','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => '2'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypeFluxImpl','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'Roe/roe/1','name' => 'Roe'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Rusanov/rusanov/2/TVDLF','name' => 'Rusanov','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Linde/linde/3/HLLEL','name' => 'Linde'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Sokolov/sokolov/4/AW','name' => 'Sokolov'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#IMPLSCHEME
1               nOrderImpl
Rusanov         TypeFluxImpl

! This command defines the scheme used in the implicit part (\'left hand side\').
! The default order is first order. The default scheme is the same as the
! scheme selected for the explicit part. 
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'IMPLICITCHECK','name' => 'IMPLCHECK'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'RejectStepLevel','min' => '0','max' => '0.9','default' => '0.3','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RejectStepFactor','min' => '0','max' => '0.9','default' => '0.5','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ReduceStepLevel','min' => '0','max' => '0.9','default' => '0.6','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ReduceStepFactor','min' => '0','max' => '1','default' => '0.9','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'IncreaseStepLevel','min' => '0','max' => '1','default' => '0.8','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'IncreaseStepFactor','min' => '1','max' => '2','default' => '1.05','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#IMPLCHECK
0.3		RejectStepLevel
0.5		RejectStepFactor
0.6		ReduceStepLevel
0.95		ReduceStepFactor
0.8		IncreaseStepLevel
1.05		IncreaseStepFactor

The update checking of the implicit scheme can be tuned with this command.
Update checking is done unless it is switched off (see UPDATECHECK command).
After each (partially) implicit time step, the code computes pRhoRelMin,
which is the minimum of the relative pressure and density drops over 
the whole computational domain. The algorithm is the following:

If pRhoRelMin is less than RejectStepLevel,
the step is rejected, and the time step is reduced by RejectStepFactor;
else if pRhoRelMin is less than ReduceStepLevel,
the step is accepted, but the next time step is reduced by ReduceStepFactor;
else if pRhoRelMin is greater than IncreaseStepFactor,
the step is accepted and the next time step is increased by IncreaseStepFactor,
but it is never increased above the value given in the FIXEDTIMESTEP command.

Assigning ReduceStepFactor=1.0 means that the
time step is not reduced unless the step is rejected.
Assigning IncreaseStepFactor=1.0 means that the 
time step is never increased, only reduced.

Default values are shown.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'NEWTON'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseConservativeImplicit','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseNewton','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseNewton'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseNewMatrix','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MaxIterNewton','min' => '1','default' => '10','type' => 'integer'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#NEWTON
F		UseConservativeImplicit
T               UseNewton
F               UseNewMatrix  (only read if UseNewton is true)
10              MaxIterNewton (only read if UseNewton is true)

! Default is UseConservativeImplicit=F and UseNewton=F, i.e. 
! no conservative fix is used and only one "Newton" iteration is done.
! UseNewMatrix decides whether the Jacobian should be recalculated
! for every Newton iteration. MaxIterNewton is the maximum number
! of Newton iterations before giving up.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'JACOBIAN'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeJacobian','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'prec','name' => 'Preconditioned','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'free','name' => 'No preconditioning'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'JacobianEps','min' => '0','max' => '1.e-5','default' => '$doublePrecision ? 1.e-12 : 1.e-6','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#JACOBIAN
prec            TypeJacobian (prec, free)
1.E-12          JacobianEps

! The Jacobian matrix is always calculated with a matrix free approach,
! however it can be preconditioned  (\'prec\'), or not (\'free\').  The
! Default value is TypeJacobian=\'prec\'.
! JacobianEps contains the machine round off error for numerical derivatives.
! The default value is 1.E-12 for 8 byte reals and 1.E-6 for 4 byte reals.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PRECONDITIONER'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypePrecondSide','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'left'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'symmetric','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'right'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypePrecond','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'MBILU','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'GustafssonPar','min' => '0','max' => '1','default' => '0.5','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#PRECONDITIONER
symmetric       TypePrecondSide (left, symmetric, right)
MBILU           TypePrecond (MBILU)
0.5             GustafssonPar (0. no modification, 1. full modification)

! Default parameters are shown. Right preconditioning does not affect
! the normalization of the residual. The Gustafsson parameter determines
! how much the MBILU preconditioner is modified. The default 0.5 value
! means a relaxed modification.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'KRYLOV'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeKrylov','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'gmres','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'bicgstab'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypeInitKrylov','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'nul','name' => '0','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'old','name' => 'previous'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'explicit'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'explicit','name' => 'scaled explicit'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ErrorMaxKrylov','min' => '0','max' => '0.1','default' => '0.001','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MaxMatvecKrylov','min' => '1','default' => '100','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#KRYLOV
gmres           TypeKrylov  (gmres, bicgstab)
nul             TypeInitKrylov (nul, old, explicit, scaled)
0.001           ErrorMaxKrylov
100             MaxMatvecKrylov

! Default values are shown. Initial guess for the Krylov type iterative scheme
! can be 0 (\'nul\'), the previous solution (\'old\'), the explicit solution
! (\'explicit\'), or the scaled explicit solution (\'scaled\'). The iterative
! scheme stops if the required accuracy is achieved or the maximum number
! of matrix-vector multiplications is exceeded.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'KRYLOVSIZE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nKrylovVector','min' => '1','default' => 'MaxMatvecKrylov','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#KRYLOVSIZE
10		nKrylovVector

! The number of Krylov vectors only matters for GMRES (TypeKrylov=\'gmres\').
! If GMRES does not converge within nKrylovVector iterations, it needs
! a restart, which usually degrades its convergence rate and robustness.
! So nKrylovVector should exceed the number of iterations, but
! it should not exceed the maximum number of iterations MaxMatvecKrylov.
! On the other hand the dynamically allocated memory is also proportional 
! to nKrylovVector. The default is nKrylovVector=MaxMatvecKrylov (in #KRYLOV)
! which can be overwritten by #KRYLOVSIZE after the #KRYLOV command (if any).
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'STOPPING CRITERIA'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!! STOPPING CRITERIA !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

The commands in this group only work in stand alone mode.

','type' => 't'},{'name' => 'command','attrib' => {'name' => 'STOP','if' => '$_IsStandAlone','required' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'MaxIteration','min' => '-1','default' => '-1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'tSimulationMax','min' => '-1','default' => '-1','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#STOP
100			MaxIteration
10.0			tSimulationMax [sec]

This command is only used in stand alone mode.

The MaxIteration variable contains the
maximum number of iterations {\\it since the beginning of the current run}
(in case of a restart, the time steps done before the restart do not count).
If nIteration reaches this value the session is finished.
The tSimulationMax variable contains the maximum simulation time
relative to the initial time determined by the #STARTTIME command.
If tSimulation reaches this value the session is finished.

Using a negative value for either variables means that the
corresponding condition is  not checked. The default values
are MaxIteration=0 and tSimulationMax = 0.0, so the #STOP command
must be used in every session.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'CHECKSTOPFILE','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoCheckStopFile','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#CHECKSTOPFILE
T			DoCheckStopFile

This command is only used in stand alone mode.

If DoCheckStopFile is true then the code checks if the
BATSRUS.STOP file exists in the run directory. This file is deleted at
the beginning of the run, so the user must explicitly create the file
with e.g. the "touch BATSRUS.STOP" UNIX command.
If the file is found in the run directory,
the execution stops in a graceful manner.
Restart files and plot files are saved as required by the
appropriate parameters.

The default is DoCheckStopFile=.true.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'CPUTIMEMAX','if' => '$_IsStandAlone'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'CpuTimeMax','min' => '-1','default' => '-1','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#CPUTIMEMAX
3600                    CpuTimeMax [sec]

This command is only used in stand alone mode.

The CpuTimeMax variable contains the maximum allowed CPU time (wall clock
time) for the execution of the current run. If the CPU time reaches
this time, the execution stops in a graceful manner.
Restart files and plot files are saved as required by the
appropriate parameters.
This command is very useful when the code is submitted to a batch
queue with a limited wall clock time.

The default value is -1.0, which means that the CPU time is not checked.
To do the check the CpuTimeMax variable has to be set to a positive value.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'OUTPUT PARAMETERS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!  OUTPUT PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'RESTARTOUTDIR'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameRestartOutDir','default' => 'GM/restartOUT','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '-d $NameRestartOutDir'},'content' => [{'content' => '
		Restart output directory $NameRestartOutDir must exist
	','type' => 't'}],'type' => 'e'},{'content' => '

#RESTARTOUTDIR
GM/restart_n5000	NameRestartOutDir

! The NameRestartOutDir variable contains the name of the directory
! where restart files are saved relative to the run directory.
! The directory should be inside the subdirectory with the name 
! of the component.
!
! Default value is "GM/restartOUT".
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'RESTARTOUTFILE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeRestartOutFile','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'block'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'one','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#RESTARTOUTFILE
one			TypeRestartOutFile

This command determines if the restart information is saved as an individual 
file for each block (block) or into a single direct access file containing all
blocks (one).  The default value is \'one\'.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SAVERESTART'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoSaveRestart','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$DoSaveRestart'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DnSaveRestart','min' => '-1','default' => '-1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DtSaveRestart','min' => '-1','default' => '-1','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#SAVERESTART
T			DoSaveRestart Rest of parameters read if true
100			DnSaveRestart
-1.			DtSaveRestart [seconds]

! Default is DoSaveRestart=.true. with DnSaveRestart=-1 and 
! DtSaveRestart=-1. This results in the restart file being 
! saved only at the end.  A binary restart file is produced for every 
! block and named as RESTARTOUTDIR/blkGLOBALBLKNUMBER.rst.
! In addition the grid is described by RESTARTOUTDIR/octree.rst
! and an ASCII header file is produced with timestep and time info:
! RESTARTOUTDIR/restart.H
!
! The restart files are overwritten every time a new restart is done,
! but one can change the name of the RESTARTOUTDIR with the #RESTARTOUTDIR
! command from session to session. The default directory name is \'restartOUT\'.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PLOTDIR'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NamePlotDir','default' => 'GM/IO2','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '-d $NamePlotDir'},'content' => [{'content' => '
		Plot directory $NamePlotDir must exist
	','type' => 't'}],'type' => 'e'},{'content' => '

The NamePlotDir variable contains the name of the directory
where plot files and logfiles are saved relative to the run directory.
The directory should be inside the subdirectory with the name
of the component.

Default value is "GM/IO2".
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SAVELOGFILE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoSaveLogfile','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$DoSaveLogfile'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'StringLog','min' => '1','max' => '4','type' => 'strings'},'content' => [{'name' => 'part','attrib' => {'name' => 'TypeLogVar','required' => 'T','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'MHD','name' => 'MHD vars. dimensional','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'FLX','name' => 'Flux vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'RAW','name' => 'Raw vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'VAR','name' => 'Set vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'mhd','name' => 'MHD vars. scaled','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'flx','name' => 'Flux vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'raw','name' => 'Raw vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'var','name' => 'Set vars. scaled'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'part','attrib' => {'multiple' => 'T','name' => 'TypeTime','required' => 'F','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'none','exclusive' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'step'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'date'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'time'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DnSaveLogfile','min' => '-1','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DtSaveLogfile','min' => '-1','default' => '-1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameLogVars','if' => '$TypeLogVar =~ /var/i','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'length' => '100','name' => 'StringLogRadii','if' => '($TypeLogVar=~/flx/i or $NameLogVars=~/flx/i)','min' => '1','max' => '10','type' => 'strings'},'content' => [{'name' => 'part','attrib' => {'multiple' => 'T','name' => 'LogRadii','min' => '$rBody','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'content' => '
#SAVELOGFILE
T                       DoSaveLogfile, rest of parameters read if true
VAR step date           StringLog
100                     DnSaveLogfile
-1.                     DtSaveLogfile [sec]
rho p rhoflx            NameLogVars (read if StrigLog is \'var\' or \'VAR\')
4.0  10.0               rLog  (radii for the flux. Read if vars include \'flx\')

! Default is DoSaveLogfile=.false.
! The logfile can contain averages or point values and other scalar
! quantities.  It is written into an ASCII file named as\\\\
!
! NAMEPLOTDIR/log_TIMESTEP.log\\\\
!
! \\noindent
! where NAMEPLOTDIR can be defined with the #PLOTDIR command (default is IO2).\\\\
! The StringLog can contain two groups of information in arbitrary order.
! The first is LogVar which is a single 3 character string that indicates
! the type of variables that are to be written.  The second group indicates
! the type of time/iteration output format to use.  This second group is
! not required and defaults to something standard for each logvar case.\\\\
! Any of the identifiers for the timetype can be included in arbitrary order.
!
!\\begin{verbatim}
! logvar   = \'mhd\', \'raw\', \'flx\' or \'var\' - unitless output
! logvar   = \'MHD\', \'RAW\', \'FLX\' or \'VAR\' - dimensional output
! timetype = \'none\', \'step\', \'time\', \'date\'
!\\end{verbatim}
!
! The logvar string is not optional and must be found on the line.
! The timetype is optional - when not specified a logical choice is made
!  by the code.
!
! The log_var string defines the variables to print in the log file
! It also controls whether or not the variables will come out in
! dimensional or non-dimensional form by the capitalization of the log_var
! string.
!\\begin{verbatim}
! ALL CAPS  - dimensional
! all lower - dimensionless
!
! \'raw\' - vars: dt rho rhoUx rhoUy rhoUz Bx By Bz E Pmin Pmax
!       - time: step time
! \'mhd\' - vars: rho rhoUx rhoUy rhoUz Bx By Bz E Pmin Pmax
!       - time: step date time
! \'flx\' - vars: rho Pmin Pmax rhoflx pvecflx e2dflx
!       - time: step date time
! \'var\' - vars: READ FROM PARAMETER FILE
!       - time: step time
!\\end{verbatim}
! log_vars is read only when the log_string contains var or VAR.  The choices
! for variables are currently:
!\\begin{verbatim}
! Average value on grid:   rho rhoUx rhoUy rhoUz Ux Uy Uz Bx By Bz P E
! Value at the test point: rhopnt rhoUxpnt rhoUypnt rhoUxpnt Uxpnt Uypnt Uzpnt
!                          Bxpnt Bypnt Bzpnt B1xpnt B1ypnt B1zpnt
!                          Epnt Ppnt Jxpnt Jypnt Jzpnt
!                          theta1pnt theta2pnt phi1pnt phi2pnt statuspnt
! Ionosphere values:       cpcpn cpcps                  
!
! Max or Min on grid:  Pmin Pmax
! Flux values:         Aflx rhoflx Bflx B2flx pvecflx e2dflx
! Other variables:     dt
!\\end{verbatim}
! timetype values mean the following:
!\\begin{verbatim}
!  none  = there will be no indication of time in the logfile (not even an
!                # of steps)
!  step  = # of time steps (n_steps)
!  date  = time is given as an array of 7 integers:  year mo dy hr mn sc msc
!  time  = time is given as a real number - elapsed time since the start of
!          the run.  Units are determined by log_var and unitUSER_t
!\\end{verbatim}
! these can be listed in any combination in the log_string line.\\\\
! R_log is read only when one of the variables used is a \'flx\' variable.  R_log
! is a list of radii at which to calculate the flux through a sphere.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SATELLITE','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nSatellite','min' => '0','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'for','attrib' => {'from' => '1','to' => '$nSatellite'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'StringSatellite','min' => '1','max' => '5','type' => 'strings'},'content' => [{'name' => 'part','attrib' => {'name' => 'TypeSatelliteVar','required' => 'T','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'MHD','name' => 'MHD vars. dimensional','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'FUL','name' => 'All vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'VAR','name' => 'Set vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'mhd','name' => 'MHD vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'ful','name' => 'All vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'var','name' => 'Set vars. scaled'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'part','attrib' => {'name' => 'TypeTrajectory','required' => 'F','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'file','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'eqn','name' => 'equation'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'part','attrib' => {'multiple' => 'T','name' => 'TypeTime','required' => 'F','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'none','exclusive' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'step'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'date'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'time'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DnOutput','min' => '-1','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DtOutput','min' => '-1','default' => '-1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameTrajectoryFile','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '-f $NameTrajectoryFile'},'content' => [{'content' => '
			Trajectory file $NameTrajectoryFile must exist
		','type' => 't'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameSatelliteVars','if' => '$TypeSatelliteVar =~ /\\bvar\\b/i','type' => 'string'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#SATELLITE
2                       nSatellite
MHD file                StringSatellite (variables and traj type)
100                     DnOutput
-1.                     DtOutput [sec]
satellite1.dat          NameTrajectoryFile
VAR eqn step date       StringSatellite
100                     DnOutput
-1.                     DtOutput [sec]
satellite2.dat          NameTrajectoryFile
rho p                   NameSatelliteVars ! Read if StringSatellite 
                                          ! contains \'var\' or \'VAR\'

! The numerical solution can be extracted along one or more satellite
! trajectories. The number of satellites is defined by the 
! nSatellite parameter (default is 0).
!
! For each satellite the StringSatellite parameter determines what
! is saved into the satellite file(s).
! The StringSatellite can contain the following 3 parts in arbitrary order
!\\begin{verbatim}
! satellitevar   = \'mhd\', \'ful\' or \'var\' (unitless output)
!                  \'MHD\', \'FUL\' or \'VAR\' (dimensional output)
! trajectorytype = \'file\' or \'eqn\'
! timetype       = \'none\', \'step\', \'time\', \'date\'
!\\end{verbatim}
! The \'satellitevar\' part is required, 
! the \'trajectorytype\' part is optional (defaults to \'file\'), and
! the \'timetype\' part is also optional (default depends on satellitevar)
!
! The \'satellitevar\' string defines the variables to print in the satellite
! output file.  It also controls whether or not the variables will come out in
! dimensional or non-dimensional form by the capitalization of the
! satellitevars string: ALL CAPS means dimensional, all lower means 
! dimensionless. 
!
! If \'satellitevar\' is set to \'mhd\', the variables 
! \'rho ux uy uz bx by bz p jx jy jz\' will be saved, while \'ful\' implies
! \'rho ux uy uz bx by bz b1x b1y b1z p jx jy jz\'.
!
! If satellitevar is set to \'var\' then the list of variables is read 
! from the NameSatelliteVar parameter as a space separated list. 
! The choices for variables are currently:
!\\begin{verbatim}
! rho, rho, rhouy, rhouz, ux, uy, uz,Bx, By, Bz, B1x, B1y, B1z,
! E, P, Jx, Jy, Jz, theta1, theta2, phi1, phi2, status.
!\\end{verbatim}
!
! If \'trajectorytype\' is \'file\' (default) than the trajectory of the 
! satellite is read from the file given by the NameTrajectoryFile parameter.
! If \'trajectorytype\' is \'eqn\' then the trajectory is defined by an
! equation, which is hard coded in subroutine satellite_trajectory_formula
! in satellites.f90.
!
! The \'timetype\' values mean the following:
!\\begin{verbatim}
!  none  = there will be no indication of time in the logfile 
!          (not even the number of steps),
!  step  = number of time steps (n_steps),
!  date  = time is given as an array of 7 integers:  year mo dy hr mn sc msc,
!  time  = time is given as a real number - elapsed time since the start of
!          the run.  Units are determined by satellitevar and unitUSER_t.
!\\end{verbatim}
!  More than one \'timetype\' can be listed. They can be put together in any
!  combination.\\\\
!
! \\noindent
! The DnOutput and DtOutput parameters determine the frequency of extracting
! values along the satellite trajectories. \\\\
!
! \\noindent
! The extracted satellite information is saved into the files named
!\\begin{verbatim}
! PLOTDIR/sat_TRAJECTORYNAME_nTIMESTEP.sat
!\\end{verbatim}
! where TIMESTEP is the number of time steps (e.g. 000925), 
! and TRAJECTORYNAME is the name of the trajectory file.\\\\
!
! \\noindent
! The default is nSatellite=0, i.e. no satellite data is saved.
!
! Satellite input files contain the trajectory of the satellite.  They should
! have to following format:
!\\begin{verbatim}
! #COOR
! GSM
!
! #START
!  2004  6  24   0   0  58   0  2.9  -3.1 - 3.7  
!  2004  6  24   0   1  58   0  2.8  -3.2 - 3.6  
!\\end{verbatim}
!
! The #COOR command is optional.  It indicates which coordinate system the data
! represents.  The default is GSM, but others are possible.

! The file containing the satellite trajectory should include data in the 
! following order:
!\\begin{verbatim}
! yr mn dy hr min sec msec x y z
!\\end{verbatim}
! with the position variables in units of the body radii or the length scale
! normalization.
!
! The maximum number of lines of data allowed in the input file is 50,000.  
! However, this can be modified by changing the variable Max_Satellite_Npts 
! in the file GM/BATSRUS/ModIO.f90.
','type' => 't'}],'type' => 'e'},{'content' => '

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


','type' => 't'},{'name' => 'command','attrib' => {'name' => 'STEADYSTATESATELLITE','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'SatelliteTimeStart','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SatelliteTimeEnd','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#STEADYSTATESATELLITE
-86400.0                     SatelliteTimeStart [sec]
86400.0                      SatelliteTimeEnd   [sec]
-3600.0                      SatelliteTimeStart [sec]
3600.0                       SatelliteTimeEnd   [sec]

! In the non-time-accurate mode the numerical simulation result converges
! to a steady-state solution. In the course of this simulation mode, the 
! progress in the iteration number is not associated with an increase in the physical 
! time, and the ultimate solution is a  "snapshot" of the parameter distribution at the 
! time instant set by the  #STARTTIME command. Since time does not run, a satellite 
! position cannot be determined in terms of the simulation time. Instead, the parameters 
! along a cut of the satellite trajectory can be saved on file for a given iteration number. 
! The trajectory points can be naturally parameterized by time, so that the cut can be 
! specified with the choice of the start time, end time, and time interval.
! 
! The command #STEADYSTATESATELLITE is required for a steady-state simulation.
! For each of the satellites, the SatelliteTimeStart is a real value that sets the start of 
! trajectory cut,  while SatelliteTimeEnd sets the end of the trajectory cut. Both are in
! seconds with respect to to the time given in #STARTTIME. A negative value means the time 
! prior to  the #STARTTIME. 

! The DtOutput from the #SATELLITE command specifies the frequency of the points along the 
! satellite trajectory for the non-time-accurate mode, while DnOutput keeps to control the
! iteration number at which the data at the trajectory cut are written to the satellite 
! output file.
!
! For more than one satellite (two satellites in the above given example), the start and 
! end times should be set for all of them. 
','type' => 't'}],'type' => 'e'},{'content' => '

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

','type' => 't'},{'name' => 'command','attrib' => {'name' => 'SAVEPLOT'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nPlotFile','min' => '0','max' => '100','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'for','attrib' => {'from' => '1','to' => '$nPlotFile'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'StringPlot','min' => '3','max' => '3','type' => 'strings'},'content' => [{'name' => 'part','attrib' => {'name' => 'plotform','required' => 'T','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'tec','name' => 'TECPLOT'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'idl','name' => 'IDL'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'part','attrib' => {'name' => 'plotarea','required' => 'T','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => '3d/3d_','name' => '3D'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'x=0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'y=0','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'z=0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'sph'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'los'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'lin'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'cut'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'slc','if' => '$plotform =~ /\\btec\\b/'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'dpl','if' => '$plotform =~ /\\btec\\b/'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'blk','if' => '$plotform =~ /\\btec\\b/'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'part','attrib' => {'name' => 'plotvar','required' => 'T','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'MHD','name' => 'MHD vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'FUL','name' => 'All vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'RAW','name' => 'Raw vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'RAY','name' => 'Ray tracing vars. dim.'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'FLX','name' => 'Flux vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'SOL','name' => 'Solar vars. dimensional'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'POS','name' => 'Position vars. dimensional','if' => '$plotarea eq \'lin\''},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'VAR','name' => 'Select dimensional vars.'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'mhd','name' => 'MHD vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'ful','name' => 'All vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'raw','name' => 'Raw vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'ray','name' => 'Ray tracing vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'flx','name' => 'Flux vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'sol','name' => 'Solar vars. scaled'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'pos','name' => 'Position vars. scaled','if' => '$plotarea eq \'lin\''},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'var','name' => 'Select scaled vars.'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DnSavePlot','min' => '-1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DtSavePlot','min' => '-1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$plotarea =~ /\\bdpl|cut|slc\\b/'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xMinCut','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xMaxCut','min' => '$xMinCut','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yMinCut','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yMaxCut','min' => '$yMinCut','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zMinCut','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zMaxCut','min' => '$zMinCut','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$plotarea =~ /\\bslc\\b/'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xPoint','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yPoint','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zPoint','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xNormal','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yNormal','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zNormal','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$plotarea =~ /\\bblk\\b/'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xPoint','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yPoint','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zPoint','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Radius','if' => '$plotarea =~ /\\bsph\\b/','min' => '0','default' => '10','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$plotarea =~ /\\blos\\b/'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'ObsPosX','default' => '-215','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ObsPosY','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ObsPosZ','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'OffsetAngle','min' => '-89','max' => '89','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rSizeImage','min' => '0','default' => '32','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xOffset','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yOffset','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rOccult','min' => '0','default' => '2','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MuLimbDarkening','min' => '0','max' => '1','default' => '0.5','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nPix','min' => '2','default' => '200','type' => 'integer'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$plotarea =~ /\\blin\\b/'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'NameLine','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'A','name' => 'Advected B'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'B','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'U'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'J'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'IsSingleLine','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nLine','min' => '1','max' => '20','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'for','attrib' => {'from' => '1','to' => '$nLine'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xStartLine','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yStartLine','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zStartLine','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'IsParallel','type' => 'logical'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DxSavePlot','if' => '($plotform=~/\\bidl\\b/ and $plotarea!~/\\b(sph|los|lin)\\b/)','min' => '-1.0','default' => '-1.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$plotvar =~ /\\bvar\\b/i'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameVars','type' => 'string'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NamePars','type' => 'string'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'content' => '
#SAVEPLOT
9			nPlotfile
3d  MHD tec		StringPlot ! 3d plot with MHD data
100			DnSavePlot
-1.			DtSavePlot
y=0 VAR idl		StringPlot ! y=0 plane plot with listed variables
-1			DnSavePlot
100.			DtSavePlot
2.			DxSavePlot ! resolution (for IDL plots)
jx jy jz		NameVars
g rbody			NamePars
cut ray idl		StringPlot ! 3D cut IDL (ONLY!) plot with raytrace info
1			DnSavePlot
-1.			DtSavePlot
-10.			xMinCut    
10.			xMaxCut    
-10.			yMinCut    
10.			yMaxCut    
-10.			zMinCut    
10.			zMaxCut    
1.			DxSavePlot 
sph flx idl		StringPlot ! spherical plot
-1			DnSavePlot
100.			DtSavePlot
4.			Radius     ! of spherical surface
los sol idl             StringPlot ! line of sight plot
-1			DnSavePlot
100.			DtSavePlot
-215.			ObsPosX
0.			ObsPosY
0.			ObsPosZ
0.                      OffsetAngle
32.			rSizeImage
0.			xOffset
0.			yOffset
3.			rOccult
0.5			MuLimbDarkening
300			nPix
lin mhd idl		StringPlot  ! field line plot
-1			DnSavePlot
10.			DtSavePlot
B			NameLine ! B - magnetic field line, U - stream line
F			IsSingleLine
2			nLine
-2.0			xStartLine
0.0			yStartLine
3.5			zStartLine
F			IsParallel
-1.0			xStartLine
1.0			yStartLine
-3.5			zStartLine
T			IsParallel
dpl MHD tec		StringPlot  ! dipole slice Tecplot (ONLY!) plot
-1			DnSavePlot
10.			DtSavePlot
-10.			xMinCut
 10.			xMaxCut
-10.			yMinCut
 10.			yMaxCut
-10.			zMinCut
 10.			zMaxCut
slc MHD tec		StringPlot  ! general slice Tecplot (ONLY!) plot
-1			DnSavePlot
10.			DtSavePlot
-10.			xMinCut
 10.			xMaxCut
-10.			yMinCut
 10.			yMaxCut
-10.			zMinCut
 10.			zMaxCut
 0.			xPoint
 0.			yPoint
 0.			zPoint
  0.			xNormal
  0.			yNormal
  1.			zNormal
blk MHD tec		StringPlot  ! general block Tecplot (ONLY!) plot
-1			DnSavePlot
10.			DtSavePlot
 5.			xPoint
 1.			yPoint
 1.			zPoint

Default is nPlotFile=0. \\\\

\\noindent
StringPlot must contain the following 3 parts in arbitrary order
\\begin{verbatim}
plotarea plotvar plotform

plotarea = \'3d\' , \'x=0\', \'y=0\', \'z=0\', \'cut\', \'dpl\', \'slc\', \'sph\', \'los\', \'lin\', \'blk\'
plotvar  = \'mhd\', \'ful\', \'raw\', \'ray\', \'flx\', \'sol\', \'pos\', \'var\' - normalized
plotvar  = \'MHD\', \'FUL\', \'RAW\', \'RAY\', \'FLX\', \'SOL\', \'pos\', \'VAR\' - dimensional
plotform = \'tec\', \'idl\'
\\end{verbatim}
NOTES: The plotvar option \'sol\' is only valid for plotarea \'los\' and
       the plotvar option \'pos\' is only valid for plotarea \'lin\'.\\\\

\\noindent
The plotarea string defines the 1, 2, or 3D volume of the plotting area:
\\begin{verbatim}
x=0   - full x=0 plane: average for symmetry plane
y=0   - full y=0 plane: average for symmetry plane
z=0   - full z=0 plane: average for symmetry plane
3d    - full 3D volume
cut   - 3D, 2D or 1D rectangular cut (IDL)/ a 2D rectangular cut (Tecplot)
dpl   - cut at dipole \'equator\', uses PLOTRANGE to clip plot
slc   - 2D slice defined with a point and normal, uses PLOTRANGE to clip plot
sph   - spherical surface cut at the given radius
los   - line of sight integrated plot
lin   - one dimensional plot along a field or stream line
blk   - 3D single block cell centered data, block specified point location
\\end{verbatim}
The plotvar string defines the plot variables and the equation parameters.
It also controls whether or not the variables will be plotted in dimensional
values or as non-dimensional values:
\\begin{verbatim}
 ALL CAPS  - dimensional
 all lower - dimensionless

 \'mhd\' - vars: rho Ux Uy Uz E Bx By Bz P Jx Jy Jz
         pars: g eta
 \'ful\' - vars: rho Ux Uy Uz E Bx By Bz B1x B1y B1z P Jx Jy Jz
         pars: g eta
 \'raw\' - vars: rho rhoUx rhoUy rhoUz E Bx By Bz P b1x b1y b1z divb
         pars: g eta
 \'ray\' - vars: bx by bz theta1 phi1 theta2 phi2 status blk
         pars: R_ray
 \'flx\' - vars: rho rhoUr Br jr pvecr
         pars: g eta
 \'var\' - vars: READ FROM PARAMETER FILE
         pars: READ FROM PARAMETER FILE
 \'sol\' - vars: wl pb
         pars: mu
\\end{verbatim}
The plot_string is always followed by the plotting frequencies
DnSavePlot and DtSavePlot.\\\\

\\noindent
Depending on StringPlot, further information is read from the parameter file
in this order:
\\begin{verbatim}
 PlotRange		if plotarea is \'cut\', \'dpl\', or \'slc\'
 Point			if plotarea is \'slc\', or \'blk\'
 Normal			if plotarea is \'slc\'
 DxSavePlot		if plotform is \'idl\' and plotarea is not sph, ion, los
 Radius                 if plotarea is \'sph\'
 NameVars		if plotform is \'var\'
 NamePars		if plotform is \'var\'
\\end{verbatim}
The PlotRange is described by 6 coordinates. 
For IDL plots, if the width in one or two 
dimensions is less than the smallest cell size within the plotarea, 
then the plot file will be 2 or 1 dimensional, respectively.
If the range is thin but symmetric about one of the x=0, y=0, or z=0 planes, 
data will be averaged in the postprocessing.\\\\

For Tecplot (tec) file and \'cut\', Plotrange is read but 
only 1 dimension is used.  
Cuts are entire x, y, or z = constant planes (2D only, 1D or 3D cuts are not
implemented.  For x=constant, for example, the y and z ranges 
do not matter as long at they are "wider" than the x range.  The slice will be 
located at the average of the two x ranges.  So, for example to save a plot in
a x=-5 constant plane cut in tec. The following would work for the plot range:
\\begin{verbatim}
 -5.01			xMinCut
 -4.99			xMaxCut
 -10.			yMinCut
  10.			yMaxCut
 -10.			zMinCut
  10.			zMaxCut
\\end{verbatim}
The \'dpl\' and \'slc\' Tecplot plots use Plotrange like the IDL plots, and will
clip the cut plane when it exits the defined box.

\\noindent
Point is described by the coordinate of any point on the cut plane, often the origin,
or inside of a 3D block. Normal is the coordinate of a vector normal to the plane.  
If the normal in any given coordinate direction is less than 0.01, 
then no cuts are computed for cell edges parallel to that coordinate direction.
For example, the following would result in only computing cuts on cell 
edges parallel to the Z axis.
\\begin{verbatim}
  0.0			xNormal
  0.0			yNormal
  1.0			zNormal
\\end{verbatim}

\\noindent
Possible values for DxSavePlot (for IDL files):
\\begin{verbatim}
  0.5	- fixed resolution (any positive value)
  0.	- fixed resolution based on the smallest cell in the plotting area
 -1.	- unstructured grid will be produced by PostIDL.exe
\\end{verbatim}
Radius is the radius of the spherical cut for plotarea=\'sph\'

The line-of-sight (plotarea \'los\') plots calculate integrals along the
lines of sight of some quantity and create a 2D Cartesian square
shaped grid of the integrated values. Only the circle enclosed in the
square is actually calculated and the corners are filled in with
zeros.  The image plane always contains the origin of the
computational domain (usually the center of the Sun).  By default the
image plane is orthogonal to the observers position relative to the
origin. The image plane can be rotated around the Z axis with an
offset angle. By default the center of the image is the observer
projected onto the image plane, but the center of the image can be
offset.  Since the central object (the Sun) contains extremely large
values, an occultational disk is used to block the lines of sight
going through the Sun.  The variables which control the direction of
the lines of sight and the grid position and resolution are the
following:
\\begin{verbatim}
 ObsPosX,ObsPosY,ObsPosZ- the position of the observer
 OffsetAngle            - the angle between the image plane normal direction
                          and the Sun\'s direction from the observer position
 rSizeImage             - the radius of the LOS image
 xOffset, yOffset       - offset relative to the observer projected onto 
                          the image plane 
 rOccult                - the radius of the occulting disk
 MuLimbDarkening        - the limb darkening parameter for the \'wl\' 
                          (white light) and \'pb\' (polarization brightness) 
                          plot variables.
 nPix                   - the number of pixels in each direction
\\end{verbatim}

\\noindent
The possible values for NameVars with plotarea \'los\' 
are listed in subroutine set_plotvar_los in write_plot_los.f90. \\\\

\\noindent
The possible values for NameVars for other plot areas
are listed in subroutine set_plotvar in write_plot_common.f90.\\\\

\\noindent
The possible values for NamePars are listed in subroutine 
set_eqpar in write_plot_common.f90\\\\

A plot file is produced by each processor.  This file is ASCII in \'tec\'
format and can be either binary or ASCII in \'idl\' format as chosen under
the #SAVEBINARY flag.  The name of the files are
\\begin{verbatim}
 IO2/plotarea_plotvar_plotnumber_timeinfo_PEnumber.extension
\\end{verbatim}
where extension is \'tec\' for the TEC and \'idl\' for the IDL file formats.
The plotnumber goes from 1 to nplot in the order of the files in PARAM.in.
The \'timeinfo\' contains simulation time as hours-minutes-seconds
(for time accurate runs only), and time step number.
Spherical plot area \'sph\' creates two files per processor starting with
\'spN\' and \'spS\' for the northern and southern hemispheres, respectively.  

After all processors wrote their plot files, processor 0 writes a small 
ASCII header file named as
\\begin{verbatim}
 IO2/plotarea_plotvar_plotnumber_timestep.headextension
\\end{verbatim}
where headextension is:
\\begin{verbatim}
           \'T\' for TEC file format
           \'S\' for TEC and plot_area \'sph\' 
           \'h\' for IDL file format       
\\end{verbatim}

\\noindent
The line of sight integration produces TecPlot and IDL files directly:
\\begin{verbatim}
 IO2/los_plotvar_plotnumber_timestep.extension
\\end{verbatim}
where extension is \'dat\' for TecPlot and \'out\' for IDL file formats.
The IDL output from line of sight integration is always in ASCII format.

','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SAVEBINARY'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoSaveBinary','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#SAVEBINARY
T			DoSaveBinary   used only for \'idl\' plot file

! Default is .true. Saves unformatted IO2/*.idl files if true. 
! This is the recommended method, because it is fast and accurate.
! The only advantage of saving IO2/*.idl in formatted text files is
! that it can be processed on another machine or with a different 
! (lower) precision. For example PostIDL.exe may be compiled with 
! single precision to make IO2/*.out files smaller, while BATSRUS.exe is 
! compiled in double precision to make results more accurate.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SAVEPLOTSAMR'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoSavePlotsAmr','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#SAVEPLOTSAMR
F			DoSavePlotsAmr

! Save plots before each AMR. Default is DoSavePlotsAMR=.false.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'FLUSH'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoFlush','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#FLUSH
F			DoFlush

If the DoFlush variable is true, the output is flushed when
subroutine ModUtility::flush_unit is called. This is used in the 
log and satellite files. The flush is useful to see the output immediately, 
and to avoid truncated files when the code crashes,
but on some systems the flush may be very slow. 

The default is to flush the output, i.e. DoFlush=T.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'AMR PARAMETERS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!  AMR PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'AMRINIT','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'InitialRefineType','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'default','default' => '1'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'all'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'none'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => '3Dbodyfocus'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'spherefocus'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'magnetosphere'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'points'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'coupledhelio'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'helio_init'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'helio_z=4'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'all_then_focus'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'cme'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'points'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'mag_new'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'magnetosphere'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'magneto_fine'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'magneto12'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'magnetosaturn'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'magnetojupiter'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'paleo'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'comet'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'InitialRefineLevel','min' => '0','default' => '4','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#AMRINIT
default			TypeRefineInit
4			nRefineLevelInit

! This command defines the geometry based refinement type and
! the number of initial refinement levels. The exact meaning
! of the various refinement types can be figured out from the
! source code in specify_refinement.f90. It is probably preferable 
! to use the #GRIDRESOLUTION and #GRIDLEVEL commands.
!
! These are the default values for the initial refinement.\\\\
! Possible values for InitialRefineType:\\\\
! Default depends on problem_type. 
!\\begin{verbatim}
! \'none\'		- Refine no blocks
! \'all\' 		- Refine all blocks
! \'3Dbodyfocus\'		- Refinement focusing on body
! \'spherefocus\'		- Refinement focusing on the origin, does not require 
!                           a body
! \'points\'      	- Refine around given points
! \'magnetosphere\'	- Refine for generic magnetosphere
! *			- any other value will use default value by ProblemType
!\\end{verbatim}
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'AMRINITPHYSICS','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nRefineLevelIC','min' => '0','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#AMRINITPHYSICS
3			nRefineLevelIC

! Defines number of physics (initial condition) based AMR-s AFTER the 
! geometry based initial AMR-s defined by #AMRINIT were done.
! Only useful if the initial condition has a non-trivial analytic form.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'multiple' => 'T','alias' => 'GRIDLEVEL','name' => 'GRIDRESOLUTION'},'content' => [{'name' => 'set','attrib' => {'value' => '0','name' => 'RotateArea'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Resolution','if' => '$_command =~ /RESOLUTION/','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nLevel','if' => '$_command =~ /LEVEL/','min' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'StringArea','min' => '1','max' => '2','type' => 'strings'},'content' => [{'name' => 'part','attrib' => {'name' => 'NameArea','required' => 'T','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'init/initial','name' => 'initial','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'all'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'box'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'brick'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'brick0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'sphere'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'sphere0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'shell'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'shell0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'cylinderx'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'cylinderx0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'cylindery'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'cylindery0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'cylinderz'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'cylinderz0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ringx'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ringx0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ringy'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ringy0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ringz'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'ringz0'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'part','attrib' => {'name' => 'RotateArea','required' => 'F','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'rotated'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameArea !~ /box|all|init|0/'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xCenter','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yCenter','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zCenter','default' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameArea =~ /box/'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xMinBox','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yMinBox','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zMinBox','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xMaxBox','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yMaxBox','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zMaxBox','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameArea =~ /brick/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xSizeBrick','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ySizeBrick','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zSizeBrick','min' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameArea =~ /sphere/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'Radius','min' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameArea =~ /shell/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'Radius1','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Radius2','min' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameArea =~ /cylinder/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'LengthCylinder','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Radius','min' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameArea =~ /ring/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'HeightRing','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Radius1','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Radius2','min' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$RotateArea =~ /rotated/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xRotate','min' => '-360','max' => '360','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yRotate','min' => '-360','max' => '360','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zRotate','min' => '-360','max' => '360','default' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#GRIDRESOLUTION
2.0			Resolution
initial			NameArea

#GRIDLEVEL
3			nLevel
all			NameArea

#GRIDLEVEL
4			nLevel
box			NameArea
-64.0			xMinBox
-16.0			yMinBox
-16.0			zMinBox
-32.0			xMaxBox
 16.0			yMaxBox
  0.0			zMaxBox

#GRIDLEVEL
4			nLevel
brick			NameArea
-48.0			xCenter
  0.0			yCenter
 -8.0			zCenter
 32.0			xSizeBrick
 32.0			ySizeBrick
 16.0			zSizeBrick

#GRIDRESOLUTION
1/8			Resolution
shell0			NameArea
3.5			Radius1
4.5			Radius2

#GRIDRESOLUTION
0.5			Resolution
sphere			NameArea
-10.0			xCenterSphere
 10.0			yCenterSphere
  0.0			zCenterSphere
 20.0			rSphere

#GRIDRESOLUTION
1/8			Resolution
cylinderx		NameArea
-30.0			xCenter
  0.0			yCenter
  0.0			zCenter
 60.0			LengthCylinder
 20.0			rCylinder

#GRIDRESOLUTION
1/8			Resolution
ringz0 rotated		NameArea
  5.0			HeightRing
 20.0			Radius1
 25.0			Radius2
 10.0			xRotate
 10.0			yRotate
  0.0			zRotate

The #GRIDRESOLUTION and #GRIDLEVEL commands allow to set the grid resolution
or refinement level, respectively, in a given area. The Resolution parameter
refers to the size of the cell in the X direction (Dx).
The nLevel parameter is an integer with level 0 meaning no refinement relative
to the root block, while level N is a refinement by 2 to the power N.

If NameArea is set to \'initial\' or \'init\', the highest initial resolution
or level is set by the command. This is similar to the #AMRINIT command,
but there is no \'TypeRefineInit\' parameter, because all refinement areas 
are defined with the additional #GRIDLEVEL and #GRIDRESOLUTION commands.
Do not use #AMRINIT if the #GRIDLEVEL or #GRIDRESOLUTION command is used 
with the \'initial\' area! The #AMRINIT command may be combined with
the #GRIDLEVEL and #GRIDRESOLUTION commands (these add additional areas
of refinement to the areas defined by TypeRefineInit), but in general 
the use of #AMRINIT is not recommended, because the refinement definitions
are defined in the source code which is difficult to understand and may
change from version to version.

For other values of NameArea, the command specifies the shape of the area. 
where the blocks are to be refined. If the desired grid resolution is finer
than the initial resolution, then initially the grid will be refined
to the initial resolution only, but the area will be further refined 
in subsequent pre-specified adaptive mesh refinements (AMRs) during the run 
(see the #AMR command). Once the resolution reaches the
desired level, the AMR-s will not do further refinement. If a grid block
is covered by more than one areas, the area with the finest resolution
determines the desired grid resolution.

All computational blocks that intersect the area and have a coarser
resolution than the resolution set for the area are selected for refinement.
There are the following basic shapes: 
\'all\', \'box\', \'brick\', \'sphere\', \'shell\', \'cylinderx\', \'cylindery\', 
\'cylinderz\', \'ringx\', \'ringy\' and \'ringz\'.

The area \'all\' refers to the whole computational domain, and it can be
used to set the overall minimum resolution. The area \'box\' is a box
aligned with the X, Y and Z axes, and it is given with the coordinates
of two diagonally opposite corners. The area \'brick\' has the same shape
as \'box\', but it is defined with the center of the brick and the 
size of the brick. The area \'sphere\' is a sphere around an arbitrary point,
which is defined with the center point and the radius of the sphere.
The area \'shell\' consists of the volume between two concentric spherical
surfaces, which is given with the center point and the two radii.
The area \'cylinderx\' is a cylinder with an axis parallel with the X axis,
and it is given with the center, the length of the axis and the radius,
The areas \'cylindery\' and \'cylinderz\' are cylinders parallel with the 
Y and Z axes, respectively, and are defined analogously as \'cylinderx\'.
The area \'ringx\', \'ringy\' and \'ringz\' are the volumes between 
two cylindrical surfaces parallel with the X, Y and Z axes, respectively.
The ring area is given with the center, the height and the two radii.

If the area name contains the number \'0\', the center is taken to be at the 
origin. If the word \'rotated\' is added, the area can be rotated by 3 angles 
around the X, Y and Z axes in this order.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'AMRLEVELS'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'MinBlockLevel','min' => '-1','default' => '0','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MaxBlockLevel','min' => '-1','default' => '99','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoFixBodyLevel','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#AMRLEVELS
0			MinBlockLevel
99			MaxBlockLevel
F			DoFixBodyLevel

! Set the minimum/maximum levels that can be affected by AMR.  The usage is as
! follows:
!\\begin{verbatim}
! MinBlockLevel .ge.0 Cells can be coarsened up to the listed level but not
!                       further.
! MinBlockLevel .lt.0 The current grid is ``frozen\'\' for coarsening such that
!                       blocks are not allowed to be coarsened to a size
!                       larger than their current one.
! MaxBlockLevel .ge.0 Any cell at a level greater than or equal to
!                       MaxBlockLevel is unaffected by AMR (cannot be coarsened
!                       or refined).
! MaxBlockLevel .lt.0 The current grid is ``frozen\'\' for refinement such that
!                       blocks are not allowed to be refined to a size
!                       smaller than their current one.
! DoFixBodyLevel = T  Blocks touching the body cannot be coarsened or refined.
!\\end{verbatim}
! This command has no effect when DoAutoRefine is .false. in the #AMR command.
!
! Note that the user can set either #AMRLEVELS or #AMRRESOLUTION but not
! both.  If both are set, the final one in the session will set the values
! for AMR.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'AMRRESOLUTION'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DxCellMin','min' => '-1','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DxCellMax','min' => '-1','default' => '99999','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoFixBodyLevel','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#AMRRESOLUTION
0.			DxCellMin
99999.			DxCellMax
F			DoFixBodyLevel

! Serves the same function as AMRLEVELS. The DxCellMin and DxCellMmax
! parameters are converted into MinBlockLevel and MaxBlockLevel 
! when they are read.
! Note that MinBlockLevel corresponds to DxCellMax and MaxBlockLevel
! corresponds to DxCellMin.  See details above.
!
! This command has no effect when DoAutoRefine is .false. in the #AMR command.
!
! Note that the user can set either #AMRLEVELS or #AMRRESOLUTION but not
! both.  If both are set, the final one in the session will set the values
! for AMR.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'AMR'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DnRefine','min' => '-1','default' => '-1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$DnRefine>0'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoAutoRefine','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$DoAutoRefine'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'PercentCoarsen','min' => '0','max' => '100','default' => '20','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'PercentRefine','min' => '0','max' => '100','default' => '20','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MaxTotalBlocks','min' => '1','default' => '99999','type' => 'integer'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'content' => '
#AMR
2001			DnRefine
T			DoAutoRefine   ! read if DnRefine is positive
0.			PercentCoarsen ! read if DoAutoRefine is true
0.			PercentRefine  ! read if DoAutoRefine is true
99999			MaxTotalBlocks ! read if DoAutoRefine is true

! The DnRefine parameter determines the frequency of adaptive mesh refinements
! in terms of total steps nStep.
!
! When DoAutoRefine is false, the grid is refined by one more level
! based on the TypeRefineInit parameter given in the #AMRINIT command
! and/or the areas and resolutions defined by the 
! #GRIDLEVEL and #GRIDRESOLUTION commands.
! If the number of blocks is not sufficient for this pre-specified refinement, 
! the code stops with an error.
!
! When DoAutoRefine is true, the grid is refined or coarsened 
! based on the criteria given in the #AMRCRITERIA command.
! The number of blocks to be refined or coarsened are determined by
! the PercentRefine and PercentCoarsen parameters. These percentages
! are approximate only, because the constraints of the block adaptive
! grid may result in more or fewer blocks than prescribed.
! The total number of blocks will not exceed the smaller of the 
! MaxTotalBlocks parameter and the total number of blocks available on all 
! the PE-s (which is determined by the number of PE-s and 
! the MaxBlocks parameter in ModSize.f90).
! 
! Default for DnRefine is -1, i.e. no run time refinement.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'AMRCRITERIA'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nRefineCrit','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'name' => '0'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => '1'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => '2'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => '3','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'for','attrib' => {'from' => '1','to' => '$nRefineCrit'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeRefine','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'gradt/gradT','name' => 'grad T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'gradp/gradP','name' => 'grad P'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'gradlogrho','name' => 'grad log(Rho)'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'gradlogP/gradlogp','name' => 'grad log(p)'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'gradE','name' => 'grad E'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'curlV/curlv/curlU/curlu','name' => 'curl U'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'curlB/curlb','name' => 'curl B'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'divU/divu/divV/divv','name' => 'div U'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'divb/divB','name' => 'divB'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Valfven/vAlfven/valfven','name' => 'vAlfven'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'heliobeta','name' => 'heliospheric beta'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'flux'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'heliocurrentsheet','name' => 'heliospheric current sheet'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'rcurrents/Rcurrents','name' => 'rCurrents'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'transient/Transient','name' => 'Transient'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$TypeRefine =~ /transient/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeTransient','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'p_dot/P_dot','name' => 'P_dot'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 't_dot/T_dot','name' => 'T_dot'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'rho_dot/Rho_dot','name' => 'Rho_dot','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'RhoU_dot/rhou_dot','name' => 'RhoU_dot'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Rho_2nd_1/rho_2nd_1','name' => 'Rho_2nd_1'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Rho_2nd_2/rho_2nd_2','name' => 'Rho_2nd_2'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseSunEarth','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseSunEarth'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'xEarth','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yEarth','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zEarth','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'InvD2Ray','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'content' => '
#AMRCRITERIA
3			nRefineCrit (number of refinement criteria: 1,2 or 3)
gradlogP		TypeRefine
divB			TypeRefine
Transient		TypeRefine
Rho_dot			TypeTransient ! Only if \'Transient\' or \'transient\'
T			UseSunEarth   ! Only if \'Transient\'
0.00E+00		xEarth        ! Only if UseSunEarth
2.56E+02 		yEarth        ! Only if UseSunEarth
0.00E+00		zEarth        ! Only if UseSunEarth
5.00E-01		InvD2Ray      ! Only if UseSunEarth

The default values depend on problem_type.

At most three criteria can be given. If nRefineCrit is set to zero,
the blocks are not ordered. This can be used to refine or coarsen
all the blocks limited by the minimum and maximum levels only
(see commands #AMRLEVELS and #AMRRESOLUTION). If nRefineCrit is 1, 2, or 3
then the criteria can be chosen from the following list:
\\begin{verbatim}
  \'gradT\'		- gradient of temperature
  \'gradP\'		- gradient of pressure
  \'gradlogrho\'		- gradient of log(rho)
  \'gradlogP\'		- gradient of log(P)
  \'gradE\'		- gradient of electric field magnitude
  \'curlV\',\'curlU\' 	- magnitude of curl of velocity
  \'curlB\'		- magnitude of current
  \'divU\', \'divV\'	- divergence of velocity
  \'divB\'		- div B
  \'vAlfven\',\'Valfven\'	- Alfven speed
  \'heliobeta\' 		- special function for heliosphere $R^2 B^2/rho$
  \'flux\'		- radial mass flux
  \'heliocurrentsheet\'	- refinement in the currentsheet of the heliosphere
  \'Rcurrents\'		- refinement near Rcurrents value
\\end{verbatim}
All the names can also be spelled with all small case letters.\\\\

\\noindent
The possible choices for TypeTransient:
\\begin{verbatim}
  \'P_dot\' (same as \'p_dot\')
  \'T_dot\' (same as \'t_dot\')
  \'Rho_dot\' (same as \'rho_dot\')
  \'RhoU_dot\' (same as \'rhou_dot\')
  \'B_dot\' (same as \'b_dot\')
  \'Rho_2nd_1\' (same as \'rho_2nd_1\')
  \'Rho_2nd_2\' (same as \'rho_2nd_2\')
\\end{verbatim}

Also, (xEarth,yEarth,zEarth) are the coordinates of the Earth. InvD2Ray is
a factor that defines how close to the ray Sun-Earth to refine the grid.
Note that the AMR occurs in a cylinder around the ray.
Example for InvD2Ray =
\\begin{verbatim}
   1 - refine_profile = 0.3679 at distance Rsun/10 from the ray
   2 - refine_profile = 0.0183 at distance Rsun/10 from the ray
   3 - refine_profile = 0.0001 at distance Rsun/10 from the ray
\\end{verbatim}
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'SCHEME PARAMETERS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!  SCHEME PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'SCHEME'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nOrder','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'name' => '1'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => '2','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypeFlux','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'Roe/roe/1','name' => 'Roe'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Rusanov/rusanov/2/TVDLF','name' => 'Rusanov','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Linde/linde/3/HLLEL','name' => 'Linde'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Sokolov/sokolov/4/AW','name' => 'Sokolov'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$nOrder == 2'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeLimiter','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'minmod','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'mc'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'mc3'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'beta'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'LimiterBeta','if' => '$TypeLimiter ne \'minmod\'','min' => '1','max' => '2','default' => '1.2','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#SCHEME
2			nOrder (1 or 2)
Rusanov			TypeFlux
mc3			TypeLimiter ! Only for nOrder=2
1.2			LimiterBeta ! Only if TypeLimiter is NOT \'minmod\'

The nOrder parameter determines the spatial and temporal accuracy of
the scheme. The spatially first order scheme uses a one-stage time integration,
while the spatially second order scheme either uses a two-stage Runge-Kutta 
explicit or a BDF2 three-level implicit time discretization. 

\\noindent
Possible values for TypeFlux:
\\begin{verbatim}
 \'Rusanov\'     - Rusanov or Lax-Friedrichs flux     
 \'Linde        - Linde\'s HLLEL flux                   
 \'Sokolov\'     - Sokolov\'s Local Artificial Wind flux 
 \'Roe\'         - Roe\'s approximate Riemann flux       
\\end{verbatim}
Possible values for TypeLimiter for spatially second order schemes:
\\begin{verbatim}
 \'minmod\'      - minmod limiter is the most robust and diffusive limiter
 \'mc\'          - monotonized central limiter with a beta parameter
 \'mc3\'         - third order (in the linear sense) limiter with beta parameter
 \'beta\'        - beta limiter is less robust than the mc limiter for 
                 the same beta value
\\end{verbatim}
Possible values for LimiterBeta (for limiters othen than minmod)
are between 1.0 and 2.0 : 
\\begin{verbatim}
  LimiterBeta = 1.0 is the same as the minmod limiter
  LimiterBeta = 2.0 for the beta limiter is the same as the superbee limiter
  LimiterBeta = 1.5 is a typical value for the mc/mc3 limiters
  LimiterBeta = 1.2 is the recommended value for the beta limiter
\\end{verbatim}
The default is the second order Rusanov scheme with the minmod limiter.

','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'NONCONSERVATIVE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseNonConservative','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#NONCONSERVATIVE
T		UseNonConservative

! For Earth the default is using non-conservative equations 
! (close to the body).
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'CONSERVATIVECRITERIA'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nConservCrit','min' => '0','max' => '3','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'for','attrib' => {'from' => '1','to' => '$nConservCrit'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeConservCrit','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'r/R/radius/Radius','name' => 'radius','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'parabola/paraboloid','name' => 'parabola'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'p/P','name' => 'p'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'gradp/GradP','name' => 'grad P'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rConserv','if' => '$TypeConservCrit =~ /^r|radius$/i','min' => '$rBody','default' => '6','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xParabolaConserv','if' => '$TypeConservCrit =~ /^parabol/i','min' => '0','default' => '6','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yParabolaConserv','if' => '$TypeConservCrit =~ /^parabol/i','min' => '0','default' => '36','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'pCoeffConserv','if' => '$TypeConservCrit =~ /^p$/i','min' => '0','default' => '0.05','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'GradPCoeffConserv','if' => '$TypeConservCrit =~ /gradp/i','min' => '0','default' => '0.1','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#CONSERVATIVECRITERIA
3		nConservCrit
r		TypeConservCrit
6.		rConserv             ! read if TypeConservCrit is \'r\'
parabola        TypeConservCrit
6.		xParabolaConserv     ! read if TypeConservCrit is \'parabola\'
36.		yParabolaConserv     ! read if TypeConservCrit is \'parabola\'
p		TypeConservCrit
0.05		pCoeffConserv	     ! read if TypeConservCrit is \'p\'
GradP		TypeConservCrit
0.1		GradPCoeffConserv    ! read if TypeConservCrit is \'GradP\'

! Select the parts of the grid where the conservative vs. non-conservative
! schemes are applied. The number of criteria is arbitrary, although 
! there is no point applying the same criterion more than once.
!
! If no criteria is used, the whole domain will use conservative or
! non-conservative equations depending on UseNonConservative set in
! command #NONCONSERVATIVE.
!
! The physics based conservative criteria (\'p\' and \'GradP\')
! select cells which use the non-conservative scheme if ALL of them are true:
!\\begin{verbatim}
! \'p\'      - the pressure is smaller than fraction pCoeffConserv of the energy
! \'GradP\'  - the relative gradient of pressure is less than GradPCoeffConserv
!\\end{verbatim}
! The geometry based criteria are applied after the physics based criteria 
! (if any) and they select the non-conservative scheme if ANY of them is true:
!\\begin{verbatim}
! \'r\'        - radial distance of the cell is less than rConserv
! \'parabola\' - x less than xParabolaConserv - (y**2+z**2)/yParabolaConserv
!\\end{verbatim}
! Default values are nConservCrit = 1 with TypeConservCrit = \'r\'
! and rConserv=2*rBody, where rBody has a problem dependent default.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'UPDATECHECK'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseUpdateCheck','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseUpdateCheck'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'RhoMinPercent','min' => '0','max' => '100','default' => '40','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RhoMaxPercent','min' => '100','default' => '400','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'pMinPercent','min' => '0','max' => '100','default' => '40','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'pMaxPercent','min' => '100','default' => '400','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#UPDATECHECK
T			UseUpdateCheck
40.			RhoMinPercent
400.			RhoMaxPercent
40.			pMinPercent
400.			pMaxPercent

! Default values are shown.  This will adjust the timestep so that
! density and pressure cannot change by more than the given percentages
! in a single timestep.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PROLONGATION'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'nOrderProlong','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'name' => '1','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => '2'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypeProlong','if' => '$nOrderProlong==2','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'lr','name' => 'left-right','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'central'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'minmod'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'lr2','name' => 'left-right extrapolate'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'central2','name' => 'central    extrapolate'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'minmod2','name' => 'minmod     extrapolate'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#PROLONGATION
2			nOrderProlong (1 or 2 for ghost cells)
lr			TypeProlong  ! Only for nOrderProlong=2

! Default is prolong_order=1. \\\\
! Possible values for prolong_type:\\\\
!
!\\noindent
! 1. in message_pass_dir (used if limiter_type is not \'LSG\')
!\\begin{verbatim}
!    \'lr\'          - interpolate only with left and right slopes 
!    \'central\'	   - interpolate only with central difference slope
!    \'minmod\' 	   - interpolate only with minmod limited slope
!    \'lr2\'	   -  like \'lr\' but extrapolate when necessary
!    \'central2\'	   - like \'central\' but extrapolate when necessary
!    \'minmod2\'	   - like \'minmod\' but extrapolate when necessary
!    \'lr3\'         - only experimental
!\\end{verbatim}
!
!\\noindent
! 2. in messagepass_all (used if limiter_type is \'LSG\')
\\begin{verbatim}
!    \'lr\',\'lr2\'		    - left and right slopes (all interpolation)
!    \'central\',\'central2\'   - central differences (all interpolation)
!    \'minmod\',\'minmod2\'	    - to be implemented
!\\end{verbatim}
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'OPTIMIZE','name' => 'MESSAGEPASS'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeMessagePass','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'allopt','name' => 'm_p_cell FACES ONLY','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'all','name' => 'm_p_cell'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'opt','name' => 'm_p_dir FACES ONLY'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'dir','name' => 'm_p_dir group by directions'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'face','name' => 'm_p_dir group by faces     '},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'min','name' => 'm_p_dir group by kind and face'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#MESSAGEPASS
allopt			TypeMessagePass

! Default value is shown above.\\\\
! Possible values for optimize_message_pass:
!\\begin{verbatim}
! \'dir\'		- message_pass_dir: group messages direction by direction
! \'face\'	- message_pass_dir: group messages face by face
! \'min\'		- message_pass_dir: send equal, restricted and prolonged 
!				    messages face by face
!
! \'opt\'		- message_pass_dir: do not send corners, send one layer for
!				    first order, send direction by direction
!
! \'all\'		- message_pass_cell: corners, edges and faces in single message
!
! \'allopt\'      - message_pass_cell:  faces only in a single message
!\\end{verbatim}
! Constrained transport requires corners, default is \'all\'!\\\\ 
! Diffusive control requires corners, default is \'all\'!\\\\
! Projection uses message_pass_dir for efficiency!\\\\
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'RESOLUTIONCHANGE','name' => 'RESCHANGE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseAccurateReschange','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#RESCHANGE
T		UseAccurateResChange

! For UseAccurateResChange=T a second order accurate, upwind and oscillation 
! free scheme is used at the resolution changes. 
!
! Default value is false, which results in first order 
! prolongation and restriction operators at the resolution changes.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TVDRESCHANGE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseTvdReschange','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#TVDRESCHANGE
T		UseTvdResChange

! For UseTvdResChange=T an almost second order and partially downwinded 
! TVD limited scheme is used at the resolution changes. 
!
! Default value is false, which results in first order 
! prolongation and restriction operators at the resolution changes.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'BORIS'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseBorisCorrection','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BorisClightFactor','if' => '$UseBorisCorrection','min' => '0','max' => '1','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#BORIS
T			UseBorisCorrection
1.0			BorisClightFactor !Only if UseBorisCorrection is true

! Default is boris_correction=.false.
! Use semi-relativistic MHD equations with speed of light reduced by
! the BorisClightFactor. Set BorisClightFactor=1.0 for true semi-relativistic
! MHD. Gives the same steady state as normal MHD analytically, but there
! can be differences due to discretization errors. 
! You can use either Boris or BorisSimple but not both. 
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'BORISSIMPLE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseBorisSimple','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BorisClightFactor','if' => '$UseBorisSimple','min' => '0','max' => '1','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#BORISSIMPLE
T			UseBorisSimple
0.05			BorisClightFactor !Only if UseBorisSimple is true

! Default is UseBorisSimple=.false. 
! Use simplified semi-relativistic MHD with speed of light reduced by the
! BorisClightFactor. This is only useful with BorisClightFactor less than 1.
! Should give the same steady state as normal MHD, but there can be a
! difference due to discretization errors.
! You can use either Boris or BorisSimple but not both. 
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'DIVB'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseDivbSource','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseDivbDiffusion','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseProjection','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseConstrainB','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '$UseDivbSource or $UseDivbDiffusion or $UseProjection or $UseConstrainB'},'content' => [{'content' => '
		At least one of the options should be true.
	','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => 'not($UseProjection and ($UseDivbSource or $UseDivbDiffusion or $UseConstrainB))'},'content' => [{'content' => '
		If UseProjection is true, all others should be false.
	','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => 'not($UseConstrainB and ($UseDivbSource or $UseDivbDiffusion or $UseProjection))'},'content' => [{'content' => '
		If UseConstrainB is true, all others should be false.
	','type' => 't'}],'type' => 'e'},{'content' => '
	
#DIVB
T			UseDivbSource
F			UseDivbDiffusion	
F			UseProjection           
F			UseConstrainB           

! Default values are shown above.
! If UseProjection is true, all others should be false.
! If UseConstrainB is true, all others should be false.
! At least one of the options should be true.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'DIVBSOURCE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseB0Source','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#DIVBSOURCE
T			UseB0Source

! Add extra source terms related to the non-zero divergence and curl of B0.
! Default is true.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PROJECTION'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeProjectIter','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'cg','name' => 'Conjugate Gradients','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'bicgstab','name' => 'BiCGSTAB'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TypeProjectStop','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'rel','name' => 'Relative norm','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'max','name' => 'Maximum error'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RelativeLimit','min' => '0','max' => '1','default' => '0.1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'AbsoluteLimit','min' => '0','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MaxMatvec','min' => '1','default' => '50','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#PROJECTION
cg			TypeProjectIter:\'cg\' or \'bicgstab\' for iterative scheme
rel			TypeProjectStop:\'rel\' or \'max\' error for stop condition
0.1			RelativeLimit
0.0			AbsoluteLimit 
50			MaxMatvec (upper limit on matrix.vector multipl.)

! Default values are shown above.\\\\
!
!\\noindent
! For symmetric Laplacian matrix TypeProjectIter=\'cg\' (Conjugate Gradients)
! should be used, as it is faster than BiCGSTAB. In current applications
! the Laplacian matrix is always symmetric.\\\\
!
!\\noindent 
! The iterative scheme stops when the stopping condition is fulfilled:
!\\begin{verbatim}
!   TypeProjectStop = \'rel\': 
!        stop if ||div B||    < RelativeLimit*||div B0||
!   TypeProjectStop = \'max\' and RelativeLimit is positive:
!        stop if max(|div B|) < RelativeLimit*max(|div B0|)
!   TypeProjectStop = \'max\' and RelativeLimit is negative: 
!        stop if max(|div B|) < AbsoluteLimit
!\\end{verbatim}
!   where {\\tt ||.||} is the second norm, and B0 is the magnetic
!   field before projection. In words \'rel\' means that the norm of the error
!   should be decreased by a factor of RelativeLimit, while 
!   \'max\' means that the maximum error should be less than either
!   a fraction of the maximum error in div B0, or less than the constant 
!   AbsoluteLimit.
! 
!   Finally the iterations stop if the number of matrix vector
!   multiplications exceed MaxMatvec. For the CG iterative scheme
!   there is 1 matvec per iteration, while for BiCGSTAB there are 2/iteration.
!
!  In practice reducing the norm of the error by a factor of 10 to 100 in 
!  every iteration works well.
!

!
!  Projection is also used when the scheme switches to constrained transport.
!  It is probably a good idea to allow many iterations and require an
!  accurate projection, because it is only done once, and the constrained
!  transport will carry along the remaining errors in div B. An example is
!
#PROJECTION
cg			TypeProjIter
rel			TypeProjStop
0.0001			RelativeLimit
0.0			AbsoluteLimit 
500			MaxMatvec


','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'CORRECTP'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'pRatioLow','min' => '0','max' => '1','default' => '0.01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'pRatioHigh','min' => '$pRatioLow','max' => '1','default' => '0.1','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#CORRECTP
0.01			pRatioLow
0.1			pRatioHigh

Default values are shown. 

The purpose of the correctP subroutine is to remove any discrepancies between
pressure stored as the primitive variable P and the pressure calculated 
from the total energy E. Such discrepancies can be caused by the 
constrained transport scheme and by the projection scheme which modify 
the magnetic energy. The algorithm is the following:
\\begin{verbatim}
Define the rato of thermal and total energies q = eThermal/e and

If              q < pRatioLow   then E is recalculated from P
If pRatioLow  < q < pRatioHigh  then both P and E are modified depending on q
If pratioHigh < q               then P is recalculated from E
\\end{verbatim}
The second case is a linear interpolation between the first and third cases.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'RAYTRACE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseAccurateIntegral','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseAccurateTrace','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DtExchangeRay','min' => '0.01','max' => '60','default' => '0.1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DnRaytrace','min' => '1','default' => '1','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '

#RAYTRACE
T			UseAccurateIntegral
T			UseAccurateTrace
0.1			DtExchangeRay [sec]
1			DnRaytrace

Raytracing (field-line tracing) is needed to couple the GM with the IM or RB 
components. It can also be used to create plot files with open-closed 
field line information. There are two algorithms implemented for integrating 
rays and for tracing rays.

The UseAccurateIntegral parameter is kept for backwards compatibility
only, it is ignored. The field line integrals are always calculated with 
the accurate algorithm, which follows the lines all the way. 

If UseAccurateTrace is false (default), the block-wise algorithm is used,
which interpolates at block faces. This algorithm is fast, but less 
accurate than the other algorithm. If UseAccurateTrace is true, 
the field lines are followed all the way. It is more accurate but 
potentially slower than the other algorithm.

In the accurate tracing algorithms, when the ray exits the domain that belongs 
to the PE, its information is sent to the other PE where the ray continues. 
The information is buffered for sake of efficiency and to synchronize
communication. The frequency of the information exchanges 
(in terms of CPU seconds) is given by the DtExchangeRay parameter. 
This is an optimization parameter for speed. Very small values of DtExchangeRay
result in many exchanges with few rays, while very large values result
in infrequent exchanges thus some PE-s may become idle (no more work to do).
The optimal value is problem dependent. A typically acceptable value is 
DtExchangeRay = 0.1 seconds (default).

The DnRaytrace parameter contains the minimum number of iterations between
two ray tracings. The default value 1 means that every new step requires
a new trace (since the magnetic field is changing). A larger value implies
that the field does not change significantly in that many time steps.
The ray tracing is always redone if the grid changes due to an AMR.

Default values are UseAccurateIntegral = .true., UseAccurateTrace = .false.,
DtExchangeRay = 0.1 and DnRaytrace=1.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'IM'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TauCoupleIm','min' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#IM
20.0			TauCoupleIm

Same as command IMCOUPLING, except it does not read the two logicals.
See description for command IMCOUPLING.

The default value is TauCoupleIm=20.0, which corresponds to typical nudging.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'IMCOUPLING'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TauCoupleIm','min' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoCoupleImPressure','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoCoupleImDensity','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#IMCOUPLING
20.0			TauCoupleIm
T			DoCoupleImPressure
F			DoCoupleImDensity

TauCoupleIm:

Determine how fast the GM pressure p (and possibly density rho) 
should be nudged towards the IM pressure pIm (and density dIM). 
The RCM prssure and denstiy are updated every time IM->GM coupling occurs,
but the nudging towards these values is done in every GM time step.

If not time accurate, a weighted average is taken: 

p\' = (p*TauCoupleIm + pIm)/(TauCoupleIm+1)

Therefore the larger TauCoupleIm is the slower the adjustment will be.
It takes approximately 2*TauCoupleIm time steps to get p close to pIm.

If time accurate, the nudging is based on physical time:

p\' = p + max(1.0, dt/TauCoupleIm)*(pIm - p)

where dt is the time step. It takes about 2*TauCoupleIm seconds
to get p close to pIm. If the time step dt exceeds TauCoupleIm, 
p\' = pIm is set in a single step.

The default value is TauCoupleIm=20.0, which corresponds to typical nudging.

DoCoupleImPressure:

Logical which sets whether GM pressure is driven by IM pressure, default 
is true, and it should always be true, because pressure is the dominant
variable in the IM to GM coupling.

DoCoupleImDensity:

Logical which sets whether GM density is driven by IM density, default is
false. This is a new feature in the IM-GM coupling, which is not fully
tested.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'PHYSICS PARAMETERS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!  PHYSICS PARAMETERS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'GAMMA','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'Gamma','min' => '1','default' => '1.6666666667','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#GAMMA
1.6666666667		Gamma

The adiabatic index (ratio of the specific heats for fixed pressure
and volume. The default value is 5.0/3.0, which is valid for
monoatomic gas or plasma.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'PLASMA'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'AverageIonMass','min' => '0','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'AverageIonCharge','min' => '0','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ElectronTemperatureRatio','min' => '0','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#PLASMA
1.0		AverageIonMass [amu]
1.0		AverageIonCharge [e]
0.0		ElectronTemperatureRatio

The AverageIonMass determines the average mass of ions (and strongly
coupled neutrals) in atomic mass units (amu).
This parameter is only used if there are no species (UseMultiSpecies=.false.
in ModEquation). The number density is n=rho/AverageIonMass.
For a pure hydrogene plasma AverageIonMass=1.0, while
for a mix of 90 per cent hydrogene and 10 per cent helium AverageIonMass=1.4.

The AverageIonCharge determines the average charge of ions (and strongly
coupled neutrals) in electron charge units.
The electron density is ne=n*AverageIonCharge. 
For a fully ionized hydrogene plasma AverageIonCharge=1.0,
for a fully ionized helium plasma AverageIonCharge=2.0, while
for a 10 per cent ionized hydrogene plasma AverageIonCharge=0.1.

The ElectronTemperatureRatio determines the ratio of electron
and ion temperatures. The ion temperature Te = T * ElectronTemperatureRatio
where T is the ion temperature. The total pressure p = n*k*T + ne*k*Te,
so T = p/(n*k+ne*k*ElectronTemperatureRatio). If the electrons and ions are
in temperature equilibrium, ElectronTemperatureRatio=1.0.

In a real plasma all these values can vary in space and time,
but in a single fluid/species MHD description using these constants is
the best one can do. In multispecies MHD the number density can
be determined accurately as n = sum(RhoSpecies_V/(ProtonMass*MassSpecies_V)).

The default values are shown above, which corresponds to
a fully ionized hydrogen plasma where the electron temperature is
negligible relative to the ion temperature. This default is 
backwards compatible with previous versions of the code.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SHOCKTUBE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'RhoLeft','min' => '0','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UnLeft','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Ut1Left','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Ut2Left','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BnLeft','default' => '0.75','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Bt1Left','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Bt2Left','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'pRight','min' => '0','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RhoRight','min' => '0','default' => '0.125','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UnRight','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Ut1Right','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Ut2Right','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BnRight','default' => '0.75','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Bt1Right','default' => '-1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Bt2Right','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'pRight','min' => '0','default' => '0.1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ShockSlope','input' => 'select','type' => 'real'},'content' => [{'name' => 'option','attrib' => {'value' => '0','name' => 'no rotation','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '0.25'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '0.3333333333333'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '0.5'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '1'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '2'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '3'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '4'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#SHOCKTUBE
1.		rho (left state)
0.		Ux (Un)
0.		Uy (Ut1)
0.		Uz (Ut2)
0.75		Bx (Bn)
1.		By (Bt1)
0.		Bz (Bt2)
1.		P
0.125		rho (right state)
0.		Ux (Un)
0.		Uy (Ut1)
0.		Uz (Ut2)
0.75		Bx (Bn)
-1.		By (Bt1)
0.		Bz (Bt2)
0.1		P
0.0		ShockSlope

! Default values are shown (Brio-Wu problem).
! The shock is rotated if ShockSlope is not 0, and the tangent of 
! the rotation angle is ShockSlope. 
! When the shock is rotated, it is best used in combination
! with sheared outer boundaries, but then only
!\\begin{verbatim}
! ShockSlope = 1., 2., 3., 4., 5.      .....
! ShockSlope = 0.5, 0.33333333, 0.25, 0.2, .....
!\\end{verbatim}
! can be used, because these angles can be accurately represented
! on the grid.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SOLARWIND','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'SwRhoDim','min' => '-1','default' => '5','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SwTDim','min' => '-1','default' => '181712.175','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SwUxDim','max' => '0','default' => '-400','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SwUyDim','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SwUzDim','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SwBxDim','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SwByDim','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SwBzDim','default' => '5','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#SOLARWIND
5.0			SwRhoDim [n/cc]
181712.175		SwTDim [K]
-400.0			SwUxDim [km/s]
0.0			SwUyDim [km/s]
0.0			SwUzDim [km/s]
0.0			SwBxDim [nT]
0.0			SwByDim [nT]
5.0			SwBzDim [nT]

! This command defines the solar wind parameters for the GM component.
! It also defines the normalization for all the variables therefore
! it is saved into the restart header file.
! One of the #SOLARWIND command and the #SOLARWINDFILE command
! (with UseSolarWindFile = .true.) is required by the GM component.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'UPSTREAM_INPUT_FILE','name' => 'SOLARWINDFILE'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseSolarWindFile','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseSolarWindFile'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameSolarWindFile','type' => 'string'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '-f $NameSolarWindFile'},'content' => [{'content' => '
		Solar wind file $NameSolarWindFile must exist
	','type' => 't'}],'type' => 'e'},{'content' => '
#SOLARWINDFILE
T			UseSolarWindFile (rest of parameters read if true)
IMF.dat                 NameSolarWindFile

! Default is UseSolarWindFile = .false.
!
! Read IMF data from file NameSolarWindFile if UseSolarWindFile is true.
! The data file contains all information required for setting the upstream
! boundary conditions. Parameter TypeBcEast should be set to \'vary\' for
! the time dependent boundary condition.
!
! If the #SOLARWIND command is not provided then the first time read from
! the solar wind file will set the normalization of all variables
! in the GM component. Consequently either the #SOLARWIND command or
! the #SOLARWINDFILE command with UseSolarWindFile=.true.
! is required by the GM component.
!
! The input files are strutured similar to the PARAM.in file.  There are 
! {\\tt #commands} that can be  inserted as well as the data.
! The file containing the upstream conditions should include data in the 
! following order:
! \\begin{verbatim}
! yr mn dy hr min sec msec bx by bz vx vy vz dens temp
! \\end{verbatim}
! The units of the variables should be:
! \\begin{verbatim}
! Magnetic field (b)     nT
! Velocity (v)           km/s
! Number Density (dens)  cm^-3
! Temperature (Temp)     K
! \\end{verbatim}
!
! The input files  can have the following optional commands at the beginning
! \\begin{verbatim}
! #COOR
! GSM          The coordinate system of the data (GSM or GSE)
!
! #PLANE       The input data represents values on a tilted plane
! 30.0         Angle to rotate in the XY plane
! 30.0         Angle to rotate in the XZ plane
!
! #POSITION    Origin for the plane rotation (see #PLANE)
! 30.0         Y location
! 30.0         Z location
!
! #ZEROBX
! T            T means Bx is ignored and set to zero
!
! #TIMEDELAY
! 3600.0       A real number in seconds by which to delay the input
! \\end{verbatim}
!
! Finally, the data should be preceded by a {\\tt #START}.  The beginning of 
! a typical solar wind input file might look like:
! \\begin{verbatim}
! #COOR
! GSM
! 
! #ZEROBX
! T
!
! #START
!  2004  6  24   0   0  58   0  2.9  -3.1 - 3.7  -300.0  0.0  0.0  5.3  2.00E+04
!  2004  6  24   0   1  58   0  3.0  -3.2 - 3.6  -305.0  0.0  0.0  5.4  2.01E+04
! \\end{verbatim}
!
! The maximum number of lines of data allowed in the input file is 50,000.  
! However, this can be modified by changing the variable Max_Upstream_Npts 
! in the file GM/BATSRUS/get_solar_wind_point.f90.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'alias' => 'MAGNETOSPHERE','name' => 'BODY','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseBody','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseBody'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'rBody','min' => '0','default' => '3','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rCurrents','if' => '$_NameComp eq \'GM\'','min' => '-1','default' => '4','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BodyRhoDim','min' => '0','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BodyTDim','min' => '0','default' => '1000','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#BODY
T			UseBody (rest of parameters read if true)
3.0			rBody (user units)
4.0			rCurrents (only read for GM component)
1.0			BodyRhoDim (/ccm) density for fixed BC for rho_BLK
10000.0			BodyTDim (K) temperature for fixed BC for P_BLK

! If UseBody is true, the inner boundary is a spherical surface
! with radius rBody. The rBody is defined in units of the planet/solar
! radius. It can be 1.0, in which case the simulation extends all the
! way to the surface of the central body. In many cases it is more
! economic to use an rBody larger than 1.0. 
!
! The rCurrents parameter defines where the currents are calculated for
! the GM-IE coupling. This only matters if BATSRUS is running as GM
! and it is coupled to IE.
!
! The BodyRhoDim and BodyTDim parameters define the density and temperature
! at the inner boundary. The exact effect of these parameters depends 
! on the settings in the #INNERBOUNDARY command.
! 
! The default values depend on the component: 
! For GM rBody=3, rCurrents=4, BodyRhoDim = 5amu/cc and BodyTDim = 25000 K. 
! For SC/IH: rBody=1, BodyRhoDim = 1.5e8 amu/cc, BodyTDim = 2.8e6 K.
! The rBody and rCurrents are given in planetary/solar radii units.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'GRAVITY','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseGravity','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'iDirGravity','if' => '$UseGravity','input' => 'select','type' => 'integer'},'content' => [{'name' => 'option','attrib' => {'value' => '0','name' => 'central mass','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '1','name' => 'X direction'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '2','name' => 'Y direction'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => '3','name' => 'Z direction'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#GRAVITY
T			UseGravity (rest of parameters read if true)
0			iDirGravity(0 - central, 1 - X, 2 - Y, 3 - Z direction)

! If UseGravity is false, the gravitational force of the central body
! is neglected. If UseGravity is true and iDirGravity is 0, the
! gravity points towards the origin. If iDirGravity is 1, 2 or 3,
! the gravitational force is parallel with the X, Y or Z axes, respectively.
!
! Default values depend on problem_type.

! When a second body is used the gravity direction for the second body
! is independent of the GravityDir value.  Gravity due to the second body
! is radially inward toward the second body.

','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'HALLRESISTIVITY'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseHallResist','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseHallResist'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'HallFactor','min' => '0','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'HallCmaxFactor','min' => '0','max' => '1','default' => '1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'HallHyperFactor','min' => '0','max' => '1','default' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#HALLRESISTIVITY
T		UseHallResist (rest of parameters read only if true)
3e12		HallFactor
0.5		HallCmaxFactor
0.2		HallHyperFactor

If UseHallResist is true the Hall resistivity is used.
The off-diagonal Hall elements of the resistivity tensor
are multiplied by HallFactor. If HallFactor is 1 then the 
physical Hall resistivity is used.

If HallCmaxFactor is 1.0 the maximum propagation speed takes into
account the full whistler wave speed. If it is 0, the wave speed
is not midified. For values betwen 1 and 0 a fraction of the whistler
wave speed is added. The full speed is needed for the stability
of the explicit scheme (unless the whistler speed is very small
and/or the diagonal part of the resistivity tensor is dominant).
For the implicit scheme it is better to have HallCmaxFactor=dtexpl/dt,
otherwise there is a significant phase error.

If HallHyperFactor is larger than zero, a 2nd order hyper resistivity
is added: proportional to Delta $x^2 d^4 B/\\Delta x^4$. The 0.1 to 0.2
is a good range to suppress the island formation in the GEM challenge.

Default is UseHallResist false.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'HALLREGION'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'NameHallRegion','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'all','default' => 'T'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'name' => 'shell'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$NameHallRegion eq \'shell\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'R1Hall','min' => '0','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'R2Hall','min' => '$R1Hall','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'HallWidth','min' => '0','default' => '0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#HALLREGION
shell			NameHallRegion
 3.5			R1Hall
20.0			R2Hall
 2.0			HallWidth

The NameHallRegion parameter determines the region where the Hall effect
is taken into account. For value "all" the Hall effect is used everywhere
in the computational domain. For "shell" the region is between radii
R1Hall and R2Hall. The edge of the shell is smoothed to avoid a sharp
discontinuity. The width of the smoothing is given by HallWidth.

','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'MASSLOADING'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseMassLoading','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoAccelerateMassLoading','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '
#MASSLOADING
F			UseMassLoading
F			DoAccelerateMassLoading
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'HEATFLUX'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseHeatFlux','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseSpitzerForm','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => 'not $UseSpitzerForm'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'Kappa0Heat','default' => '1.23E-11','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Kappa0Heat','default' => '2.5','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#HEATFLUX
T		UseHeatFlux
F		UseSpitzerForm
1.23E-11	Kappa0Heat [W/m/K]	! Only if not UseSpitzerForm
2.50E+00	ExponentHeat [-]	! Only if not UseSpitzerForm
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'RESISTIVEFLUX'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseResistFlux','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseSpitzerForm','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => 'not $UseSpitzerForm'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeResist','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'value' => 'Localized/localized','name' => 'localized'},'content' => [],'type' => 'e'},{'name' => 'option','attrib' => {'value' => 'Constant/constant','name' => 'constant','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Eta0Resist','default' => '9.69953E+8','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$TypeResist =~ /localized/i'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'Alpha0Resist','default' => '150','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yShiftResist','default' => '0.5','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TimeInitRise','default' => '0.05','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'TimeConstLev','default' => '1','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UseAnomResist','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseAnomResist'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'Eta0AnomResist','default' => '1.93991E+09','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'EtaAnomMaxResist','default' => '1.93991E+10','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'jCritResist','min' => '0','default' => '1.0E-9','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '
#RESISTIVEFLUX
T		UseResistFlux
F		UseSpitzerForm
Localized	TypeResist		! Only if not UseSpitzerForm
9.69953E+08	Eta0Resist [m^2/s]	! Only if not UseSpitzerForm
1.50000E+02	Alpha0Resist [-]	! Only if TypeResist==\'Localized\'
5.00000E-01	yShiftResist [-]	! Only if TypeResist==\'Localized\'
5.00000E-02	TimeInitRise [-]	! Only if TypeResist==\'Localized\'
1.00000E+00	TimeConstLev [-]	! Only if TypeResist==\'Localized\'
T		UseAnomResist
1.93991E+09	Eta0AnomResist [m^2/s]	! Only if UseAnomResist
1.93991E+10	EtaAnomMaxResist [m^2/s]! Only if UseAnomResist
1.00000E-09	jCritResist [A/m^2]	! Only if UseAnomResist

If UseResistFlux is false, no resistivity is included.
If UseResistFlux is true, then one can select the Spitzer resistivity with
UseSpitzerForm=.true., which results in very low resistivity in space plasma.
If UseSpitzerForm=.false., the resistivity can be set by hand.
For TypeResist=\'constant\' the resistivity is uniformly set to Eta0Resist.
For TypeResist=\'localized\' the resistivity has a peak value Eta0Resist
The enhanced resistivity has a Gaussian shape with a half width of 
1/sqrt(Alpha0Resist), and the position is shifted along the y-axis 
to -yShistResist*y2. 

A current dependent anomalous resistivity can be added both to
the constant and localized resistivities. 
If UseAnomResist is true, the anomalous resistivity is 
Eta0AnomResist*(j/jCritResist-1) limited by 0 and EtaAnomMaxResist.

The default is UseResistFlux=F, i.e. ideal MHD.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'TESTDISSMHD','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseDefaultUnits','default' => 'T','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Grav0Diss','default' => '2.635620E-02','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Beta0Diss','default' => '1.640000E-01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Length0Diss','default' => '1.500000E+06','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Time0Diss','default' => '1.159850E+01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Rho0Diss','default' => '5.019000E-11','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Tem0Diss','default' => '1.000000E+05','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Theta0Diss','default' => '6.000000E-01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Delta0Diss','default' => '2.500000E+01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'EpsilonDiss','default' => '7.000000E+00','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RhoDifDiss','default' => '4.500000E+00','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yShiftDiss','default' => '4.000000E-01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ScaleHeightDiss','default' => '5.000000E-01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ScaleFactorDiss','default' => '1.159850E+01','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BZ0iss','default' => '5.000000E-01','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#TESTDISSMHD
F                       UseDefaultUnits
2.635620E-02            Grav0Diss
1.640000E-01            Beta0Diss
1.500000E+06            Length0Diss
1.159850E+01            Time0Diss
5.019000E-11            Rho0Diss
1.000000E+05            Tem0Diss
6.000000E-01            ThetaDiss
2.500000E+01            DeltaDiss
7.000000E+00            EpsilonDiss
4.500000E+00            RhoDifDiss
4.000000E-01            yShiftDiss
5.000000E-01            scaleHeightDiss
1.000000E+00            scaleFactorDiss
0.000000E-01            BZ0Diss

! Default values are shown. Parameters for problem_dissipation
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'SECONDBODY','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'UseBody2','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$UseBody2'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'rBody2','min' => '0','default' => '0.1','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'xBody2','min' => '$xMin','max' => '$xMax','default' => '-40','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'yBody2','min' => '$yMin','max' => '$yMax','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'zBody2','min' => '$zMin','max' => '$zMax','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rCurrents2','min' => '$rBody2','default' => '1.3*$rBody2','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RhoDimBody2','min' => '0','default' => '5','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'tDimBody2','min' => '0','default' => '25000','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#SECONDBODY
T			UseBody2   ! Rest of the parameters read if .true.
0.01			rBody2 
-40.			xBody2
0.			yBody2
0.			zBody2
0.011                   rCurrents2  !This is unused currently 
5.0			RhoDimBody2 (/ccm) density for fixed BC for rho_BLK
25000.0			TDimBody2 (K) temperature for fixed BC for P_BLK

! Default for UseBody2=.false.   -   All others have no defaults!
! This command should appear before the #INNERBOUNDARY command when using
! a second body.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'DIPOLEBODY2','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'BdpDimBody2x','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BdpDimBody2y','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BdpDimBody2z','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#DIPOLEBODY2
0.0			BdpDimBody2x [nT]
0.0			BdpDimBody2y [nT]
-1000.0			BdpDimBody2z [nT]

! The BdpDimBody2x, BdpDimBody2y and BdpDimBody2z variables contain
! the 3 components of the dipole vector in the GSE frame.
! The absolute value of the dipole vector is the equatorial field strength
! in nano Tesla.
!
! Default is no dipole field.

! For now the dipole of the second body can only be aligned with the z-axis
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'SOLAR PROBLEM TYPES'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!! SOLAR PROBLEM TYPES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'HELIOSPHERE','if' => '$_IsFirstSession and $_NameComp ne \'GM\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'BodyTDim','min' => '0','default' => '2.85E06','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'BodyRhoDim','min' => '0','default' => '1.50E8','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'qSun','min' => '0','default' => '25.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'tHeat','min' => '0','default' => '1.75','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rHeat','min' => '0','default' => '1.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'SigmaHeat','min' => '0','default' => '4.5','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'DoInitRope','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'name' => 'if','attrib' => {'expr' => '$DoInitRope'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'CmeA','min' => '0','default' => '0.7','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeR1','min' => '0','default' => '1.2','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeR0','min' => '0','default' => '1.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeA1','default' => '0.23','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeAlpha','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeRho1','min' => '0','default' => '2.5E-12','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeRho2','min' => '0','default' => '2.0E-13','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ModulationRho','min' => '0','max' => '10','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ModulationP','min' => '0','max' => '10','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'OrientationGL98','min' => '-360','max' => '360','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'LatitudeGL98','min' => '-90','max' => '90','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'LongitudeGL98','min' => '-360','max' => '360','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'}],'type' => 'e'},{'content' => '

#HELIOSPHERE
2.85E06			BodyTDim	[K]
1.50E8			BodyRhoDim	[N/ccm]
25.00			qSun		
1.75			tHeat
1.00			rHeat
4.50			SIGMAheat
F			InitRope
0.7     		CmeA    [scaled] contraction distance
1.2     		CmeR1   [scaled] distance of spheromac from sun center
1.0     		CmeR0   [scaled] diameter of spheromac
0.23    		CmeA1   [Gauss]  spheromac B field strength
0.0     		CmeAlpha[scaled] cme acceleration rate
2.5E-12 		CmeRho1 [kg/m^3] density of background corona before contract
2.0E-13 		CmeRho2 [kg/m^3] density of background corona after contract 
0.0                     ModulationRho
0.0                     ModulationP
0.0			OrientationGL98 [deg]
0.0			LatitudeGL98 [deg]
0.0			LongitudeGL98 [deg]

This command defines the heliosphere parameters with a CME model.
The coronal eruptive event generator is based on the
Gibson and Low (GL) analytical solution prescribing a
three-dimensional twisted magnetic flux rope in
hydrostatic equilibrium in the presence of gravity.
The GL solution is described in the Astrophysical
Journal, volume 493, page 460.
This flux rope is formed by applying a mathematical
stretching operation to axisymmetric  flux
rope.  The flux rope is of radius Cme_R0 and is
placed Cme_R1 from the origin (solar center).  The
stretching transformation draws space radially inward
toward the origin by a distance of Cme_A, which
distorts the flux rope to have a tear-drop shape.
The parameter Cme_A1 modulates the magnetic field strength
and negative values of Cme_A1 reverse the overall field
direction.  For the GL flux rope to be in equilibrium, requires
both dense plasma in the form of a filament inside the rope,
(prescribed by the GL solution) as well as plasma pressure
outside the flux rope which tends to be large than the
solar corona can provide.  To initiate an eruption (the CME)
we linearly superimpose the GL flux rope in the solar
corona within the streamer belt.  The location of the flux
rope is determined by the parameters cRotxGl98, cRotYGl98
and cRotZGl98.  The flux rope is line-tied with both ends
attached to the inner boundary.  The eruption follows from
the flux rope being out of equilibrium, owing to a reduction
in filament mass (set with ModulationRho) and from pressure
of the corona being unable to balance the magnetic pressure
of the flux rope.  The eruption takes the form of the flux
rope being bodily expelled from the corona.  Eruption energy
increases with flux rope size, field strength, stretching
deformation and the buoyancy of the flux rope.

The flux rope can be rotated to an arbitrary position.
The LatitudeGM98 and LongitudeGL98 parameters define the position
of the center of the fluxrope in the coordinate system of the Solar
Corona component. The OrientationGL98 parameter determines the 
orientation of the fluxrope relative to the East-West direction
(clock-wise).
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'HELIOUPDATEB0','if' => '$_NameComp ne \'GM\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DtUpdateB0','min' => '-1','default' => '0.0001','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#HELIOUPDATEB0
-1.0			DtUpdateB0 [s]

Set the frequency of updating the B0 field for the solar corona.
A negative value means that the B0 field is not updated.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'HELIODIPOLE','if' => '$_NameComp ne \'GM\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'HelioDipoleStrength','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'HelioDipoleTilt','min' => '-90','max' => '90','default' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '

#HELIODIPOLE
-3.0                    HelioDipoleStrength [G]
 0.0                    HelioDipoleTilt     [deg]

! Variable HelioDipoleStrength defines the equatorial field strength in Gauss,
! while HelioDipoleTilt is the tilt relative to the ecliptic North 
! (negative sign means towards the planet) in degrees.
!
! Default value is HelioDipoleStrength = 0.0.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'HELIOTEST','if' => '$_NameComp ne \'GM\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'DoSendMHD','default' => 'F','type' => 'logical'},'content' => [],'type' => 'e'},{'content' => '

#HELIOTEST
F			DoSendMHD

! If DoSendMHD is true, IH sends the real MHD solution to GM in the coupling.
! If DoSendMHD is false then the values read from the IMF file are sent,
! so there is no real coupling. Mostly used for testing the framework.
!
! Default value is true, i.e. real coupling.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'HELIOBUFFERGRID','if' => '$_IsFirstSession and $_NameComp eq \'IH\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'rBuffMin','min' => '1','default' => '19','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'rBuffMax','min' => '1','default' => '21','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nThetaBuff','min' => '18','default' => '45','type' => 'integer'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'nPhiBuff','min' => '36','default' => '90','type' => 'integer'},'content' => [],'type' => 'e'},{'content' => '
#HELIOBUFFERGRID
19.0		rBuffMin
21.0		rBuffMax
45		nThetaBuff
90		nPhiBuff

Define the radius and the grid resolution for the uniform 
spherical buffer grid which passes information 
from the SC component to the IH component. The resolution should
be similar to the grid resolution of the coarser of the SC and IH grids.
This command can only be used in the first session by the IH component. 
Default values are shown above.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'CME','if' => '$_IsFirstSession and $_NameComp ne \'GM\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'TypeCme','input' => 'select','type' => 'string'},'content' => [{'name' => 'option','attrib' => {'name' => 'Low','default' => 'T'},'content' => [],'type' => 'e'}],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeA','min' => '0','default' => '0.7','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeR1','min' => '0','default' => '1.2','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeR0','min' => '0','default' => '1.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeA1','default' => '0.23','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeAlpha','default' => '0.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeRho1','min' => '0','default' => '2.5E-12','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeRho2','min' => '0','default' => '2.0E-13','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeB1Dim','default' => '1.0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'CmeUErupt','min' => '0','default' => '4.0E5','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#CME
Low		TypeCme   model type (\'Low\')
0.7		CmeA    [scaled] contraction distance
1.2             CmeR1   [scaled] distance of spheromac from sun center
1.0             CmeR0   [scaled] diameter of spheromac
0.23		CmeA1   [Gauss]  sets spheromac B strength which can be negative
0.0		Cmealpha   [scaled] cme acceleration rate
2.5E-12		CmeRho1 [kg/m^3] density of background corona before contract
2.0E-13		CmeRho2 [kg/m^3] density of background corona after contract 
1.0             CmeB1Dim [Gauss] field strength of dipole-type B field
4.0E5           CmeUErupt  [m/s] cme velocity

The coronal eruptive event generator (TypeCme Low) is based on the
Gibson and Low (GL) analytical solution prescribing a
three-dimensional twisted magnetic flux rope in
hydrostatic equilibrium in the presence of gravity.
The GL solution is described in the Astrophysical
Journal, volume 493, page 460.
This flux rope is formed by applying a mathematical
stretching operation to axisymmetric spheromak flux
rope.  The flux rope is of radius Cme_R0 and is
placed Cme_R1 from the origin (solar center).  The
stretching transformation draws space radially inward
toward the origin by a distance of Cme_A, which
distorts the flux rope to have a tear-drop shape.
The parameter Cme_A1 modulates the magnetic field strength
and negative values of Cme_A1 reverse the overall field
direction.  For the GL flux rope to be in equilibrium, requires
both dense plasma in the form of a filament inside the rope,
(prescribed by the GL solution) as well as plasma pressure
outside the flux rope which tends to be large than the
solar corona can provide.  To initiate an eruption (the CME)
we linearly superimpose the GL flux rope in the solar
corona within the streamer belt.  The location of the flux
rope is determined by the parameters cRotxGl98, cRotYGl98
and cRotZGl98.  The flux rope is line-tied with both ends
attached to the inner boundary.  The eruption follows from
the flux rope being out of equilibrium, owing to a reduction
in filament mass (set with ModulationRho) and from pressure
of the corona being unable to balance the magnetic pressure
of the flux rope.  The eruption takes the form of the flux
rope being bodily expelled from the corona.  Eruption energy
increases with flux rope size, field strength, stretching
deformation and the buoyancy of the flux rope.
Default values are shown above for the GL flux rope CME model.
','type' => 't'}],'type' => 'e'},{'name' => 'command','attrib' => {'name' => 'ARCADE','if' => '$_IsFirstSession and $_NameComp ne \'GM\''},'content' => [{'name' => 'parameter','attrib' => {'name' => 'tArcDim','min' => '0','default' => '1.0E6','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'RhoArcDim','min' => '0','default' => '1.0E-12','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'bArcDim','min' => '0','default' => '0.718144','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ByArcDim','default' => '1.0E6','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UzArcDim','default' => '5.0E3','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'Phi0Arc','default' => '0.5','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'MuArc','default' => '1.3','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'ExpArc','min' => '0','default' => '3','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'WidthArc','min' => '0','default' => '0.5','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#ARCADE
1.0E6                   tArcDim   [K]      1.0E6
1.0E-12                 RhoArcDim [kg/m^3] 1.0E-12
0.71814                 bArcDim   [Gauss]  0.718144
0.0                     ByArcDim  [Gauss]
5.0E3                   UzArcDim  [5.0E3 m/s]
0.5                     Phi0Arc
1.3                     MuArc
3                       ExpArc
0.5                     WidthArc

! Default values are shown. Parameters for problem_arcade
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'COMET PROBLEM TYPE'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!! COMET PROBLEM TYPE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'COMET','if' => '$_IsFirstSession'},'content' => [{'name' => 'parameter','attrib' => {'name' => 'ProdRate','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'UrNeutral','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'AverageMass','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'IonizationRate','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'name' => 'parameter','attrib' => {'name' => 'kFriction','min' => '0','type' => 'real'},'content' => [],'type' => 'e'},{'content' => '
#COMET
1.0E28		ProdRate    - Production rate (#/s)
1.0		UrNeutral   - neutral radial outflow velocity (km/s)
17.0		AverageMass - average particle mass (amu)
1.0E-6		IonizationRate (1/s)
1.7E-9		kFriction - ion-neutral friction rate coefficient (cm^3/s)

! Only used by problem_comet.  Defaults are as shown.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'commandgroup','attrib' => {'name' => 'SCRIPT COMMANDS'},'content' => [{'content' => '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!! SCRIPT COMMANDS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
','type' => 't'},{'name' => 'command','attrib' => {'name' => 'INCLUDE'},'content' => [{'name' => 'parameter','attrib' => {'length' => '100','name' => 'NameIncludeFile','default' => 'Param/','type' => 'string'},'content' => [],'type' => 'e'},{'content' => '

#INCLUDE
Param/SSS_3000		NameIncludeFile

! Include a library file from Param/ or any file from anywhere else.
','type' => 't'}],'type' => 'e'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '($SwRhoDim > 0) or $UseSolarWindFile or $_NameComp ne \'GM\''},'content' => [{'content' => '
	Either command #SOLARWIND or #SOLARWINDFILE must be used!
','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '$MaxImplBlock>1 or not $UsePartImplicit or not $MaxImplBlock'},'content' => [{'content' => '
	Part implicit scheme requires more than 1 implicit block!
','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '$MaxImplBlock==$MaxBlock or not $UseFullImplicit'},'content' => [{'content' => '
	Full implicit scheme should be used with equal number of 
	explicit and implicit blocks!
','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '-d $NameRestartOutDir or not $_IsFirstSession'},'content' => [{'content' => '
	Output restart directory $NameRestartOutDir should exist!
','type' => 't'}],'type' => 'e'},{'name' => 'rule','attrib' => {'expr' => '-d $NamePlotDir or not $_IsFirstSession'},'content' => [{'content' => '
	Plot directory $NamePlotDir should exist!
','type' => 't'}],'type' => 'e'}],'type' => 'e'}];