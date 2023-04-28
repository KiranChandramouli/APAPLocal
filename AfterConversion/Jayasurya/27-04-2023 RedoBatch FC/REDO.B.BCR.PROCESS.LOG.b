* @ValidationCode : MjotMTI1Mzk4NTUwODpDcDEyNTI6MTY4MjUxMDU1MzE5NTpJVFNTQk5HOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 17:32:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSSBNG
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.BCR.PROCESS.LOG
*-----------------------------------------------------------------------------
* Simple Routine to wrap REDO.INTERFACE.REC.ACT
* SingleThread JOB, for recording REDO.INTERFACE.REC.ACT trace
*-----------------------------------------------------------------------------
* Modification History:
* Revision History:
* -----------------
* Date       Name              Reference                     Version
* --------   ----              ----------                    --------
* 17.04.12   hpasquel           PACS00191153                1.0
* Date                  who                   Reference
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION  CALL RTN METHOD ADDED
*------------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING APAP.REDOCHNLS  ;* MANUAL R22 CODE CONVERSION
*
    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------------------
    CALL EB.READLIST(Y.SEL.CMD,Y.LIST.PROCESS,"",NO.OF.REC,Y.SYSTEM.RETURN.CODE)

    LOOP
        REMOVE Y.REDO.LOG.ID FROM Y.LIST.PROCESS SETTING Y.MARK
    WHILE Y.REDO.LOG.ID : Y.MARK
        R.REDO.LOG = ''
*
        CALL F.READ(FN.REDO.BCR.PROCESS.LOG, Y.REDO.LOG.ID, R.REDO.LOG, F.REDO.BCR.PROCESS.LOG, Y.ERR)
*
        INT.CODE = R.REDO.LOG<1>
        BAT.NO   = R.REDO.LOG<2>
        BAT.TOT  = R.REDO.LOG<3>
        INFO.OR  = R.REDO.LOG<4>
        INFO.DE  = R.REDO.LOG<5>
        ID.PROC  = R.REDO.LOG<6>
        MON.TP   = R.REDO.LOG<7>
        DESC     = R.REDO.LOG<8>
        REC.CON  = R.REDO.LOG<9>
        EX.USER  = R.REDO.LOG<10>
        EX.PC    = R.REDO.LOG<11>
        INT.TYPE = R.REDO.LOG<12>
*
        
*CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;* MANUAL R22 CODE CONVERSION
        CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;* MANUAL R22 CODE CONVERSION
        CALL F.DELETE (FN.REDO.BCR.PROCESS.LOG, Y.REDO.LOG.ID)
*
    REPEAT

RETURN
*------------------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------------------
    F.REDO.BCR.PROCESS.LOG = ''
    FN.REDO.BCR.PROCESS.LOG = "F.REDO.BCR.PROCESS.LOG"
    CALL OPF(FN.REDO.BCR.PROCESS.LOG, F.REDO.BCR.PROCESS.LOG)
    R.REDO.LOG = ''
    Y.SEL.CMD = "SELECT " : FN.REDO.BCR.PROCESS.LOG
RETURN

*------------------------------------------------------------------------------------------------------------------
END
