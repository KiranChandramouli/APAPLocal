* @ValidationCode : MjotMTMxNzE2OTM0MjpDcDEyNTI6MTcwMTA4OTMzNTY4Mzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Nov 2023 18:18:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH

SUBROUTINE REDO.B.INW.PREPROCESS.POST
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ganesh r
* PROGRAM NAME : REDO.B.INW.PREPROCESS.POST
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r           ODR-2010-09-0148   INITIAL CREATION
* Date                  who                   Reference              
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*27-11-2023	      VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES-SQA-11797 – By Santiago
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.REDO.CLEARING.PROCESS	;*Fix SQA-11797 – By Santiago-new insert file added
    $INSERT I_REDO.B.INW.PREPROCESS.COMMON
*------------------------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

PROCESS:
*------------------------------------------------------------------------------------------
    FN.REDO.CLEARING.PROCESS.ID = 'INW.PROCESS'		;*Fix SQA-11797 – By Santiago-new lines added-start

    FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.REDO.CLEARING.PROCESS  = ''
    CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

*    CALL F.READ(FN.REDO.CLEARING.PROCESS,FN.REDO.CLEARING.PROCESS.ID,R.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS,PROC.CLEAR.ERR)
	CALL CACHE.READ(FN.REDO.CLEARING.PROCESS,FN.REDO.CLEARING.PROCESS.ID,R.REDO.CLEARING.PROCESS,Y.ERR)
    VAR.FILE.PATH = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.PROCESS.PATH>
    SEL.CMD = "SELECT ":VAR.FILE.PATH
    CALL EB.READLIST(SEL.CMD,FILE.LIST,'',NO.OF.REC,RET.ERR)

    LOOP
        REMOVE VAR.APERTA.ID FROM FILE.LIST SETTING FILE.POS
    WHILE VAR.APERTA.ID:FILE.POS
        DAEMON.CMD = "DELETE ":VAR.FILE.PATH:" ":VAR.APERTA.ID	;*Fix SQA-11797 – By Santiago-end
        EXECUTE DAEMON.CMD
    
	REPEAT	;*Fix SQA-11797 – By Santiago-new lines added
RETURN

END
