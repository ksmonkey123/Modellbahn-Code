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
SOURCEFILES_QUOTED_IF_SPACED=specials.asm random.asm led.asm expansion_read.asm expansion_write.asm global_ram.asm delay.asm count_ones.asm binary_logarithm.asm pow2.asm fastnet_sender.asm fastnet_receiver.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/specials.o ${OBJECTDIR}/random.o ${OBJECTDIR}/led.o ${OBJECTDIR}/expansion_read.o ${OBJECTDIR}/expansion_write.o ${OBJECTDIR}/global_ram.o ${OBJECTDIR}/delay.o ${OBJECTDIR}/count_ones.o ${OBJECTDIR}/binary_logarithm.o ${OBJECTDIR}/pow2.o ${OBJECTDIR}/fastnet_sender.o ${OBJECTDIR}/fastnet_receiver.o
POSSIBLE_DEPFILES=${OBJECTDIR}/specials.o.d ${OBJECTDIR}/random.o.d ${OBJECTDIR}/led.o.d ${OBJECTDIR}/expansion_read.o.d ${OBJECTDIR}/expansion_write.o.d ${OBJECTDIR}/global_ram.o.d ${OBJECTDIR}/delay.o.d ${OBJECTDIR}/count_ones.o.d ${OBJECTDIR}/binary_logarithm.o.d ${OBJECTDIR}/pow2.o.d ${OBJECTDIR}/fastnet_sender.o.d ${OBJECTDIR}/fastnet_receiver.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/specials.o ${OBJECTDIR}/random.o ${OBJECTDIR}/led.o ${OBJECTDIR}/expansion_read.o ${OBJECTDIR}/expansion_write.o ${OBJECTDIR}/global_ram.o ${OBJECTDIR}/delay.o ${OBJECTDIR}/count_ones.o ${OBJECTDIR}/binary_logarithm.o ${OBJECTDIR}/pow2.o ${OBJECTDIR}/fastnet_sender.o ${OBJECTDIR}/fastnet_receiver.o

# Source Files
SOURCEFILES=specials.asm random.asm led.asm expansion_read.asm expansion_write.asm global_ram.asm delay.asm count_ones.asm binary_logarithm.asm pow2.asm fastnet_sender.asm fastnet_receiver.asm


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
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/specials.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/specials.lst\\\" -e\\\"${OBJECTDIR}/specials.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/specials.o\\\" \\\"specials.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/specials.o"
	@${FIXDEPS} "${OBJECTDIR}/specials.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/random.o: random.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/random.o.d 
	@${RM} ${OBJECTDIR}/random.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/random.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/random.lst\\\" -e\\\"${OBJECTDIR}/random.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/random.o\\\" \\\"random.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/random.o"
	@${FIXDEPS} "${OBJECTDIR}/random.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/led.o: led.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/led.o.d 
	@${RM} ${OBJECTDIR}/led.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/led.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/led.lst\\\" -e\\\"${OBJECTDIR}/led.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/led.o\\\" \\\"led.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/led.o"
	@${FIXDEPS} "${OBJECTDIR}/led.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion_read.o: expansion_read.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion_read.o.d 
	@${RM} ${OBJECTDIR}/expansion_read.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion_read.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion_read.lst\\\" -e\\\"${OBJECTDIR}/expansion_read.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion_read.o\\\" \\\"expansion_read.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion_read.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion_read.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion_write.o: expansion_write.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion_write.o.d 
	@${RM} ${OBJECTDIR}/expansion_write.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion_write.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion_write.lst\\\" -e\\\"${OBJECTDIR}/expansion_write.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion_write.o\\\" \\\"expansion_write.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion_write.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion_write.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/global_ram.o: global_ram.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/global_ram.o.d 
	@${RM} ${OBJECTDIR}/global_ram.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/global_ram.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/global_ram.lst\\\" -e\\\"${OBJECTDIR}/global_ram.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/global_ram.o\\\" \\\"global_ram.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/global_ram.o"
	@${FIXDEPS} "${OBJECTDIR}/global_ram.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/delay.o: delay.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/delay.o.d 
	@${RM} ${OBJECTDIR}/delay.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/delay.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/delay.lst\\\" -e\\\"${OBJECTDIR}/delay.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/delay.o\\\" \\\"delay.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/delay.o"
	@${FIXDEPS} "${OBJECTDIR}/delay.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/count_ones.o: count_ones.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/count_ones.o.d 
	@${RM} ${OBJECTDIR}/count_ones.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/count_ones.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/count_ones.lst\\\" -e\\\"${OBJECTDIR}/count_ones.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/count_ones.o\\\" \\\"count_ones.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/count_ones.o"
	@${FIXDEPS} "${OBJECTDIR}/count_ones.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/binary_logarithm.o: binary_logarithm.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/binary_logarithm.o.d 
	@${RM} ${OBJECTDIR}/binary_logarithm.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/binary_logarithm.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/binary_logarithm.lst\\\" -e\\\"${OBJECTDIR}/binary_logarithm.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/binary_logarithm.o\\\" \\\"binary_logarithm.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/binary_logarithm.o"
	@${FIXDEPS} "${OBJECTDIR}/binary_logarithm.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/pow2.o: pow2.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pow2.o.d 
	@${RM} ${OBJECTDIR}/pow2.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/pow2.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/pow2.lst\\\" -e\\\"${OBJECTDIR}/pow2.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/pow2.o\\\" \\\"pow2.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/pow2.o"
	@${FIXDEPS} "${OBJECTDIR}/pow2.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/fastnet_sender.o: fastnet_sender.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/fastnet_sender.o.d 
	@${RM} ${OBJECTDIR}/fastnet_sender.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/fastnet_sender.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/fastnet_sender.lst\\\" -e\\\"${OBJECTDIR}/fastnet_sender.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/fastnet_sender.o\\\" \\\"fastnet_sender.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/fastnet_sender.o"
	@${FIXDEPS} "${OBJECTDIR}/fastnet_sender.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/fastnet_receiver.o: fastnet_receiver.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/fastnet_receiver.o.d 
	@${RM} ${OBJECTDIR}/fastnet_receiver.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/fastnet_receiver.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/fastnet_receiver.lst\\\" -e\\\"${OBJECTDIR}/fastnet_receiver.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/fastnet_receiver.o\\\" \\\"fastnet_receiver.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/fastnet_receiver.o"
	@${FIXDEPS} "${OBJECTDIR}/fastnet_receiver.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/specials.o: specials.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/specials.o.d 
	@${RM} ${OBJECTDIR}/specials.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/specials.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/specials.lst\\\" -e\\\"${OBJECTDIR}/specials.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/specials.o\\\" \\\"specials.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/specials.o"
	@${FIXDEPS} "${OBJECTDIR}/specials.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/random.o: random.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/random.o.d 
	@${RM} ${OBJECTDIR}/random.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/random.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/random.lst\\\" -e\\\"${OBJECTDIR}/random.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/random.o\\\" \\\"random.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/random.o"
	@${FIXDEPS} "${OBJECTDIR}/random.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/led.o: led.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/led.o.d 
	@${RM} ${OBJECTDIR}/led.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/led.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/led.lst\\\" -e\\\"${OBJECTDIR}/led.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/led.o\\\" \\\"led.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/led.o"
	@${FIXDEPS} "${OBJECTDIR}/led.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion_read.o: expansion_read.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion_read.o.d 
	@${RM} ${OBJECTDIR}/expansion_read.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion_read.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion_read.lst\\\" -e\\\"${OBJECTDIR}/expansion_read.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion_read.o\\\" \\\"expansion_read.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion_read.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion_read.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/expansion_write.o: expansion_write.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/expansion_write.o.d 
	@${RM} ${OBJECTDIR}/expansion_write.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/expansion_write.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/expansion_write.lst\\\" -e\\\"${OBJECTDIR}/expansion_write.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/expansion_write.o\\\" \\\"expansion_write.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/expansion_write.o"
	@${FIXDEPS} "${OBJECTDIR}/expansion_write.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
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
	
${OBJECTDIR}/count_ones.o: count_ones.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/count_ones.o.d 
	@${RM} ${OBJECTDIR}/count_ones.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/count_ones.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/count_ones.lst\\\" -e\\\"${OBJECTDIR}/count_ones.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/count_ones.o\\\" \\\"count_ones.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/count_ones.o"
	@${FIXDEPS} "${OBJECTDIR}/count_ones.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/binary_logarithm.o: binary_logarithm.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/binary_logarithm.o.d 
	@${RM} ${OBJECTDIR}/binary_logarithm.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/binary_logarithm.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/binary_logarithm.lst\\\" -e\\\"${OBJECTDIR}/binary_logarithm.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/binary_logarithm.o\\\" \\\"binary_logarithm.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/binary_logarithm.o"
	@${FIXDEPS} "${OBJECTDIR}/binary_logarithm.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/pow2.o: pow2.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pow2.o.d 
	@${RM} ${OBJECTDIR}/pow2.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/pow2.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/pow2.lst\\\" -e\\\"${OBJECTDIR}/pow2.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/pow2.o\\\" \\\"pow2.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/pow2.o"
	@${FIXDEPS} "${OBJECTDIR}/pow2.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/fastnet_sender.o: fastnet_sender.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/fastnet_sender.o.d 
	@${RM} ${OBJECTDIR}/fastnet_sender.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/fastnet_sender.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/fastnet_sender.lst\\\" -e\\\"${OBJECTDIR}/fastnet_sender.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/fastnet_sender.o\\\" \\\"fastnet_sender.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/fastnet_sender.o"
	@${FIXDEPS} "${OBJECTDIR}/fastnet_sender.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/fastnet_receiver.o: fastnet_receiver.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/fastnet_receiver.o.d 
	@${RM} ${OBJECTDIR}/fastnet_receiver.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/fastnet_receiver.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/fastnet_receiver.lst\\\" -e\\\"${OBJECTDIR}/fastnet_receiver.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/fastnet_receiver.o\\\" \\\"fastnet_receiver.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/fastnet_receiver.o"
	@${FIXDEPS} "${OBJECTDIR}/fastnet_receiver.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
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
