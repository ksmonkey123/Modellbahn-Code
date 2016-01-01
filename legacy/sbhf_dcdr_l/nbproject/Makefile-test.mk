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
ifeq "$(wildcard nbproject/Makefile-local-test.mk)" "nbproject/Makefile-local-test.mk"
include nbproject/Makefile-local-test.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=test
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/sbhf_dcdr_l.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/sbhf_dcdr_l.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=sbhf_dcdr_l.asm switch-driver.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/sbhf_dcdr_l.o ${OBJECTDIR}/switch-driver.o
POSSIBLE_DEPFILES=${OBJECTDIR}/sbhf_dcdr_l.o.d ${OBJECTDIR}/switch-driver.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/sbhf_dcdr_l.o ${OBJECTDIR}/switch-driver.o

# Source Files
SOURCEFILES=sbhf_dcdr_l.asm switch-driver.asm


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
	${MAKE}  -f nbproject/Makefile-test.mk dist/${CND_CONF}/${IMAGE_TYPE}/sbhf_dcdr_l.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f527
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/sbhf_dcdr_l.o: sbhf_dcdr_l.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/sbhf_dcdr_l.o.d 
	@${RM} ${OBJECTDIR}/sbhf_dcdr_l.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/sbhf_dcdr_l.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/sbhf_dcdr_l.lst\\\" -e\\\"${OBJECTDIR}/sbhf_dcdr_l.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/sbhf_dcdr_l.o\\\" \\\"sbhf_dcdr_l.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/sbhf_dcdr_l.o"
	@${FIXDEPS} "${OBJECTDIR}/sbhf_dcdr_l.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/switch-driver.o: switch-driver.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/switch-driver.o.d 
	@${RM} ${OBJECTDIR}/switch-driver.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/switch-driver.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/switch-driver.lst\\\" -e\\\"${OBJECTDIR}/switch-driver.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/switch-driver.o\\\" \\\"switch-driver.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/switch-driver.o"
	@${FIXDEPS} "${OBJECTDIR}/switch-driver.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/sbhf_dcdr_l.o: sbhf_dcdr_l.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/sbhf_dcdr_l.o.d 
	@${RM} ${OBJECTDIR}/sbhf_dcdr_l.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/sbhf_dcdr_l.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/sbhf_dcdr_l.lst\\\" -e\\\"${OBJECTDIR}/sbhf_dcdr_l.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/sbhf_dcdr_l.o\\\" \\\"sbhf_dcdr_l.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/sbhf_dcdr_l.o"
	@${FIXDEPS} "${OBJECTDIR}/sbhf_dcdr_l.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/switch-driver.o: switch-driver.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/switch-driver.o.d 
	@${RM} ${OBJECTDIR}/switch-driver.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/switch-driver.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/switch-driver.lst\\\" -e\\\"${OBJECTDIR}/switch-driver.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/switch-driver.o\\\" \\\"switch-driver.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/switch-driver.o"
	@${FIXDEPS} "${OBJECTDIR}/switch-driver.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/sbhf_dcdr_l.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk  ../utilities.X/dist/test/debug/utilities.X.lib ../utilities.X/switch-driver.asm  
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1 -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_SIMULATOR=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/sbhf_dcdr_l.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}   ../utilities.X/dist/test/debug/utilities.X.lib ../utilities.X/switch-driver.asm  
else
dist/${CND_CONF}/${IMAGE_TYPE}/sbhf_dcdr_l.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk  ../utilities.X/dist/test/production/utilities.X.lib ../utilities.X/switch-driver.asm 
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w  -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/sbhf_dcdr_l.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}   ../utilities.X/dist/test/production/utilities.X.lib ../utilities.X/switch-driver.asm  
endif


# Subprojects
.build-subprojects:
	cd ../utilities.X && ${MAKE}  -f Makefile CONF=test


# Subprojects
.clean-subprojects:
	cd ../utilities.X && rm -rf "build/test" "dist/test"

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/test
	${RM} -r dist/test

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "${PATH_TO_IDE_BIN}"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
