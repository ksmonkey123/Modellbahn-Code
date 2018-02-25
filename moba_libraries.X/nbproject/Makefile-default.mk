#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=lib
DEBUGGABLE_SUFFIX=
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/moba_libraries.X.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=lib
DEBUGGABLE_SUFFIX=
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/moba_libraries.X.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=specials.asm led.asm global_ram.asm delay.asm portb_manager.asm serial.in.asm serial.out.asm expansion.in.asm expansion.out.asm switch_controlling.asm serial.in_RA1.asm calibration.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/specials.o ${OBJECTDIR}/led.o ${OBJECTDIR}/global_ram.o ${OBJECTDIR}/delay.o ${OBJECTDIR}/portb_manager.o ${OBJECTDIR}/serial.in.o ${OBJECTDIR}/serial.out.o ${OBJECTDIR}/expansion.in.o ${OBJECTDIR}/expansion.out.o ${OBJECTDIR}/switch_controlling.o ${OBJECTDIR}/serial.in_RA1.o ${OBJECTDIR}/calibration.o
POSSIBLE_DEPFILES=${OBJECTDIR}/specials.o.d ${OBJECTDIR}/led.o.d ${OBJECTDIR}/global_ram.o.d ${OBJECTDIR}/delay.o.d ${OBJECTDIR}/portb_manager.o.d ${OBJECTDIR}/serial.in.o.d ${OBJECTDIR}/serial.out.o.d ${OBJECTDIR}/expansion.in.o.d ${OBJECTDIR}/expansion.out.o.d ${OBJECTDIR}/switch_controlling.o.d ${OBJECTDIR}/serial.in_RA1.o.d ${OBJECTDIR}/calibration.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/specials.o ${OBJECTDIR}/led.o ${OBJECTDIR}/global_ram.o ${OBJECTDIR}/delay.o ${OBJECTDIR}/portb_manager.o ${OBJECTDIR}/serial.in.o ${OBJECTDIR}/serial.out.o ${OBJECTDIR}/expansion.in.o ${OBJECTDIR}/expansion.out.o ${OBJECTDIR}/switch_controlling.o ${OBJECTDIR}/serial.in_RA1.o ${OBJECTDIR}/calibration.o

# Source Files
SOURCEFILES=specials.asm led.asm global_ram.asm delay.asm portb_manager.asm serial.in.asm serial.out.asm expansion.in.asm expansion.out.asm switch_controlling.asm serial.in_RA1.asm calibration.asm


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/moba_libraries.X.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f527
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/specials.o: specials.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/specials.o.d 
	@${RM} ${OBJECTDIR}/specials.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/specials.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/specials.lst\\\" -e\\\"${OBJECTDIR}/specials.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/specials.o\\\" \\\"specials.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/specials.o"
	@${FIXDEPS} "${OBJECTDIR}/specials.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/led.o: led.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/led.o.d 
	@${RM} ${OBJECTDIR}/led.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/led.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/led.lst\\\" -e\\\"${OBJECTDIR}/led.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/led.o\\\" \\\"led.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/led.o"
	@${FIXDEPS} "${OBJECTDIR}/led.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/global_ram.o: global_ram.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/global_ram.o.d 
	@${RM} ${OBJECTDIR}/global_ram.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/global_ram.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/global_ram.lst\\\" -e\\\"${OBJECTDIR}/global_ram.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/global_ram.o\\\" \\\"global_ram.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/global_ram.o"
	@${FIXDEPS} "${OBJECTDIR}/global_ram.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/delay.o: delay.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/delay.o.d 
	@${RM} ${OBJECTDIR}/delay.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/delay.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/delay.lst\\\" -e\\\"${OBJECTDIR}/delay.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/delay.o\\\" \\\"delay.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/delay.o"
	@${FIXDEPS} "${OBJECTDIR}/delay.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/portb_manager.o: portb_manager.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/portb_manager.o.d 
	@${RM} ${OBJECTDIR}/portb_manager.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/portb_manager.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/portb_manager.lst\\\" -e\\\"${OBJECTDIR}/portb_manager.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/portb_manager.o\\\" \\\"portb_manager.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/portb_manager.o"
	@${FIXDEPS} "${OBJECTDIR}/portb_manager.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/serial.in.o: serial.in.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/serial.in.o.d 
	@${RM} ${OBJECTDIR}/serial.in.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/serial.in.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/serial.in.lst\\\" -e\\\"${OBJECTDIR}/serial.in.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/serial.in.o\\\" \\\"serial.in.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/serial.in.o"
	@${FIXDEPS} "${OBJECTDIR}/serial.in.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/serial.out.o: serial.out.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/serial.out.o.d 
	@${RM} ${OBJECTDIR}/serial.out.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/serial.out.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/serial.out.lst\\\" -e\\\"${OBJECTDIR}/serial.out.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/serial.out.o\\\" \\\"serial.out.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/serial.out.o"
	@${FIXDEPS} "${OBJECTDIR}/serial.out.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion.in.o: expansion.in.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion.in.o.d 
	@${RM} ${OBJECTDIR}/expansion.in.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion.in.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion.in.lst\\\" -e\\\"${OBJECTDIR}/expansion.in.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion.in.o\\\" \\\"expansion.in.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion.in.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion.in.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion.out.o: expansion.out.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion.out.o.d 
	@${RM} ${OBJECTDIR}/expansion.out.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion.out.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion.out.lst\\\" -e\\\"${OBJECTDIR}/expansion.out.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion.out.o\\\" \\\"expansion.out.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion.out.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion.out.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/switch_controlling.o: switch_controlling.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/switch_controlling.o.d 
	@${RM} ${OBJECTDIR}/switch_controlling.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/switch_controlling.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/switch_controlling.lst\\\" -e\\\"${OBJECTDIR}/switch_controlling.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/switch_controlling.o\\\" \\\"switch_controlling.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/switch_controlling.o"
	@${FIXDEPS} "${OBJECTDIR}/switch_controlling.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/serial.in_RA1.o: serial.in_RA1.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/serial.in_RA1.o.d 
	@${RM} ${OBJECTDIR}/serial.in_RA1.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/serial.in_RA1.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/serial.in_RA1.lst\\\" -e\\\"${OBJECTDIR}/serial.in_RA1.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/serial.in_RA1.o\\\" \\\"serial.in_RA1.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/serial.in_RA1.o"
	@${FIXDEPS} "${OBJECTDIR}/serial.in_RA1.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/calibration.o: calibration.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/calibration.o.d 
	@${RM} ${OBJECTDIR}/calibration.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/calibration.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/calibration.lst\\\" -e\\\"${OBJECTDIR}/calibration.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/calibration.o\\\" \\\"calibration.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/calibration.o"
	@${FIXDEPS} "${OBJECTDIR}/calibration.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/specials.o: specials.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/specials.o.d 
	@${RM} ${OBJECTDIR}/specials.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/specials.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/specials.lst\\\" -e\\\"${OBJECTDIR}/specials.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/specials.o\\\" \\\"specials.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/specials.o"
	@${FIXDEPS} "${OBJECTDIR}/specials.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/led.o: led.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/led.o.d 
	@${RM} ${OBJECTDIR}/led.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/led.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/led.lst\\\" -e\\\"${OBJECTDIR}/led.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/led.o\\\" \\\"led.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/led.o"
	@${FIXDEPS} "${OBJECTDIR}/led.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/global_ram.o: global_ram.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/global_ram.o.d 
	@${RM} ${OBJECTDIR}/global_ram.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/global_ram.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/global_ram.lst\\\" -e\\\"${OBJECTDIR}/global_ram.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/global_ram.o\\\" \\\"global_ram.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/global_ram.o"
	@${FIXDEPS} "${OBJECTDIR}/global_ram.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/delay.o: delay.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/delay.o.d 
	@${RM} ${OBJECTDIR}/delay.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/delay.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/delay.lst\\\" -e\\\"${OBJECTDIR}/delay.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/delay.o\\\" \\\"delay.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/delay.o"
	@${FIXDEPS} "${OBJECTDIR}/delay.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/portb_manager.o: portb_manager.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/portb_manager.o.d 
	@${RM} ${OBJECTDIR}/portb_manager.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/portb_manager.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/portb_manager.lst\\\" -e\\\"${OBJECTDIR}/portb_manager.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/portb_manager.o\\\" \\\"portb_manager.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/portb_manager.o"
	@${FIXDEPS} "${OBJECTDIR}/portb_manager.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/serial.in.o: serial.in.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/serial.in.o.d 
	@${RM} ${OBJECTDIR}/serial.in.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/serial.in.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/serial.in.lst\\\" -e\\\"${OBJECTDIR}/serial.in.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/serial.in.o\\\" \\\"serial.in.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/serial.in.o"
	@${FIXDEPS} "${OBJECTDIR}/serial.in.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/serial.out.o: serial.out.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/serial.out.o.d 
	@${RM} ${OBJECTDIR}/serial.out.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/serial.out.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/serial.out.lst\\\" -e\\\"${OBJECTDIR}/serial.out.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/serial.out.o\\\" \\\"serial.out.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/serial.out.o"
	@${FIXDEPS} "${OBJECTDIR}/serial.out.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion.in.o: expansion.in.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion.in.o.d 
	@${RM} ${OBJECTDIR}/expansion.in.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion.in.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion.in.lst\\\" -e\\\"${OBJECTDIR}/expansion.in.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion.in.o\\\" \\\"expansion.in.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion.in.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion.in.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion.out.o: expansion.out.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion.out.o.d 
	@${RM} ${OBJECTDIR}/expansion.out.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion.out.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion.out.lst\\\" -e\\\"${OBJECTDIR}/expansion.out.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion.out.o\\\" \\\"expansion.out.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion.out.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion.out.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/switch_controlling.o: switch_controlling.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/switch_controlling.o.d 
	@${RM} ${OBJECTDIR}/switch_controlling.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/switch_controlling.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/switch_controlling.lst\\\" -e\\\"${OBJECTDIR}/switch_controlling.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/switch_controlling.o\\\" \\\"switch_controlling.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/switch_controlling.o"
	@${FIXDEPS} "${OBJECTDIR}/switch_controlling.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/serial.in_RA1.o: serial.in_RA1.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/serial.in_RA1.o.d 
	@${RM} ${OBJECTDIR}/serial.in_RA1.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/serial.in_RA1.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/serial.in_RA1.lst\\\" -e\\\"${OBJECTDIR}/serial.in_RA1.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/serial.in_RA1.o\\\" \\\"serial.in_RA1.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/serial.in_RA1.o"
	@${FIXDEPS} "${OBJECTDIR}/serial.in_RA1.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/calibration.o: calibration.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/calibration.o.d 
	@${RM} ${OBJECTDIR}/calibration.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/calibration.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/calibration.lst\\\" -e\\\"${OBJECTDIR}/calibration.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/calibration.o\\\" \\\"calibration.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/calibration.o"
	@${FIXDEPS} "${OBJECTDIR}/calibration.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: archive
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/moba_libraries.X.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_AR} $(MP_EXTRA_AR_PRE) -c dist/${CND_CONF}/${IMAGE_TYPE}/moba_libraries.X.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/moba_libraries.X.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_AR} $(MP_EXTRA_AR_PRE) -c dist/${CND_CONF}/${IMAGE_TYPE}/moba_libraries.X.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "${PATH_TO_IDE_BIN}"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
