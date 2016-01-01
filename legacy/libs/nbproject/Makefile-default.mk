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
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/libs.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=lib
DEBUGGABLE_SUFFIX=
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/libs.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=expansion_API.asm globals.asm network.asm default_inits.asm led.asm bitCount.asm bitNumber.asm autocal.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/expansion_API.o ${OBJECTDIR}/globals.o ${OBJECTDIR}/network.o ${OBJECTDIR}/default_inits.o ${OBJECTDIR}/led.o ${OBJECTDIR}/bitCount.o ${OBJECTDIR}/bitNumber.o ${OBJECTDIR}/autocal.o
POSSIBLE_DEPFILES=${OBJECTDIR}/expansion_API.o.d ${OBJECTDIR}/globals.o.d ${OBJECTDIR}/network.o.d ${OBJECTDIR}/default_inits.o.d ${OBJECTDIR}/led.o.d ${OBJECTDIR}/bitCount.o.d ${OBJECTDIR}/bitNumber.o.d ${OBJECTDIR}/autocal.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/expansion_API.o ${OBJECTDIR}/globals.o ${OBJECTDIR}/network.o ${OBJECTDIR}/default_inits.o ${OBJECTDIR}/led.o ${OBJECTDIR}/bitCount.o ${OBJECTDIR}/bitNumber.o ${OBJECTDIR}/autocal.o

# Source Files
SOURCEFILES=expansion_API.asm globals.asm network.asm default_inits.asm led.asm bitCount.asm bitNumber.asm autocal.asm


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
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/libs.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f527
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/expansion_API.o: expansion_API.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion_API.o.d 
	@${RM} ${OBJECTDIR}/expansion_API.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion_API.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion_API.lst\\\" -e\\\"${OBJECTDIR}/expansion_API.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion_API.o\\\" \\\"expansion_API.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion_API.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion_API.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/globals.o: globals.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/globals.o.d 
	@${RM} ${OBJECTDIR}/globals.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/globals.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/globals.lst\\\" -e\\\"${OBJECTDIR}/globals.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/globals.o\\\" \\\"globals.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/globals.o"
	@${FIXDEPS} "${OBJECTDIR}/globals.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/network.o: network.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/network.o.d 
	@${RM} ${OBJECTDIR}/network.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/network.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/network.lst\\\" -e\\\"${OBJECTDIR}/network.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/network.o\\\" \\\"network.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/network.o"
	@${FIXDEPS} "${OBJECTDIR}/network.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/default_inits.o: default_inits.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/default_inits.o.d 
	@${RM} ${OBJECTDIR}/default_inits.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/default_inits.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/default_inits.lst\\\" -e\\\"${OBJECTDIR}/default_inits.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/default_inits.o\\\" \\\"default_inits.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/default_inits.o"
	@${FIXDEPS} "${OBJECTDIR}/default_inits.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/led.o: led.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/led.o.d 
	@${RM} ${OBJECTDIR}/led.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/led.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/led.lst\\\" -e\\\"${OBJECTDIR}/led.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/led.o\\\" \\\"led.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/led.o"
	@${FIXDEPS} "${OBJECTDIR}/led.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/bitCount.o: bitCount.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/bitCount.o.d 
	@${RM} ${OBJECTDIR}/bitCount.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/bitCount.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/bitCount.lst\\\" -e\\\"${OBJECTDIR}/bitCount.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/bitCount.o\\\" \\\"bitCount.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/bitCount.o"
	@${FIXDEPS} "${OBJECTDIR}/bitCount.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/bitNumber.o: bitNumber.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/bitNumber.o.d 
	@${RM} ${OBJECTDIR}/bitNumber.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/bitNumber.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/bitNumber.lst\\\" -e\\\"${OBJECTDIR}/bitNumber.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/bitNumber.o\\\" \\\"bitNumber.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/bitNumber.o"
	@${FIXDEPS} "${OBJECTDIR}/bitNumber.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/autocal.o: autocal.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/autocal.o.d 
	@${RM} ${OBJECTDIR}/autocal.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/autocal.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/autocal.lst\\\" -e\\\"${OBJECTDIR}/autocal.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/autocal.o\\\" \\\"autocal.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/autocal.o"
	@${FIXDEPS} "${OBJECTDIR}/autocal.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/expansion_API.o: expansion_API.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion_API.o.d 
	@${RM} ${OBJECTDIR}/expansion_API.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion_API.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion_API.lst\\\" -e\\\"${OBJECTDIR}/expansion_API.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion_API.o\\\" \\\"expansion_API.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion_API.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion_API.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/globals.o: globals.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/globals.o.d 
	@${RM} ${OBJECTDIR}/globals.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/globals.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/globals.lst\\\" -e\\\"${OBJECTDIR}/globals.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/globals.o\\\" \\\"globals.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/globals.o"
	@${FIXDEPS} "${OBJECTDIR}/globals.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/network.o: network.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/network.o.d 
	@${RM} ${OBJECTDIR}/network.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/network.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/network.lst\\\" -e\\\"${OBJECTDIR}/network.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/network.o\\\" \\\"network.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/network.o"
	@${FIXDEPS} "${OBJECTDIR}/network.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/default_inits.o: default_inits.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/default_inits.o.d 
	@${RM} ${OBJECTDIR}/default_inits.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/default_inits.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/default_inits.lst\\\" -e\\\"${OBJECTDIR}/default_inits.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/default_inits.o\\\" \\\"default_inits.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/default_inits.o"
	@${FIXDEPS} "${OBJECTDIR}/default_inits.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/led.o: led.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/led.o.d 
	@${RM} ${OBJECTDIR}/led.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/led.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/led.lst\\\" -e\\\"${OBJECTDIR}/led.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/led.o\\\" \\\"led.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/led.o"
	@${FIXDEPS} "${OBJECTDIR}/led.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/bitCount.o: bitCount.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/bitCount.o.d 
	@${RM} ${OBJECTDIR}/bitCount.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/bitCount.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/bitCount.lst\\\" -e\\\"${OBJECTDIR}/bitCount.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/bitCount.o\\\" \\\"bitCount.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/bitCount.o"
	@${FIXDEPS} "${OBJECTDIR}/bitCount.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/bitNumber.o: bitNumber.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/bitNumber.o.d 
	@${RM} ${OBJECTDIR}/bitNumber.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/bitNumber.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/bitNumber.lst\\\" -e\\\"${OBJECTDIR}/bitNumber.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/bitNumber.o\\\" \\\"bitNumber.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/bitNumber.o"
	@${FIXDEPS} "${OBJECTDIR}/bitNumber.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/autocal.o: autocal.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/autocal.o.d 
	@${RM} ${OBJECTDIR}/autocal.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/autocal.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/autocal.lst\\\" -e\\\"${OBJECTDIR}/autocal.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/autocal.o\\\" \\\"autocal.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/autocal.o"
	@${FIXDEPS} "${OBJECTDIR}/autocal.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: archive
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/libs.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_AR} $(MP_EXTRA_AR_PRE) -c dist/${CND_CONF}/${IMAGE_TYPE}/libs.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/libs.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_AR} $(MP_EXTRA_AR_PRE) -c dist/${CND_CONF}/${IMAGE_TYPE}/libs.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}     
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
