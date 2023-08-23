* @ValidationCode : MjotMjAzMjk2MzE1MzpDcDEyNTI6MTY4MjU5ODAxMjcwNDpzYW1hcjotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACH.INW.OMSG(Y.OUT.MESSAGE)
***********************************************************
*-----------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.ACH.INW.OMSG
*------------------------------------------------------------------------------


* DESCRIPTION : Out Msg Routine responsible for analyzing the result of processing of a OFS message,
*               for INWARD transactions and rejection of OUTWARD transactions
*-----------------------------------------------------------------------------

*    LINKED WITH :
*    IN PARAMETER:
*    OUT PARAMETER: Y.OUT.MESSAGE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.08.2010      GANESH R               ODR-2009-12-0290   INITIAL CREATION
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION            C$T24.SESSION.NO ADDED
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*----------------------------------------------------------------------


*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.USER
    $USING APAP.REDOCHNLS


    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*-------------------------------------------------------------
INIT:
*Initialising
*-------------------------------------------------------------

RETURN

*-------------------------------------------------------------
OPENFILES:
*Opening File

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'
    F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

    FN.REDO.ACH.PROCESS = 'F.REDO.ACH.PROCESS'
    F.REDO.ACH.PROCESS = ''
    CALL OPF(FN.REDO.ACH.PROCESS,F.REDO.ACH.PROCESS)

RETURN
*-------------------------------------------------------------
PROCESS:
*Extracting the values of FT id and Message

    Y.PART.1 = FIELD (Y.OUT.MESSAGE,',',1)
    Y.FT.ID = FIELD(Y.PART.1,'/',1)
    Y.MSG.ID = FIELD (Y.PART.1,'/',2)
    Y.RESULT = FIELD(Y.PART.1,'/',3)
    GOSUB FIND.RESULT
    CALL F.READ(FN.REDO.ACH.PROCESS.DET,Y.MSG.ID,R.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET,ACH.PROC.ERR)
    CHANGE "<requests><request>" TO "" IN Y.FT.ID
    IF R.REDO.ACH.PROCESS.DET THEN
        GOSUB PROCESS.RESULT
    END

RETURN
*--------------
FIND.RESULT:
*--------------
    Y.OP.REQ.TOT=DCOUNT(Y.OUT.MESSAGE,'<request>')
    Y.OP.REQ.CNT=2
    LOOP
    WHILE Y.OP.REQ.CNT LE Y.OP.REQ.TOT
        Y.SUB.MESSAGE=FIELD(Y.OUT.MESSAGE,'<request>',Y.OP.REQ.CNT)
        Y.SUBPART.1 = FIELD (Y.SUB.MESSAGE,',',1)
        Y.SUBRESULT = FIELD(Y.SUBPART.1,'/',3)
        Y.RESULT=Y.SUBRESULT
        IF Y.RESULT NE '1' THEN
            Y.OP.REQ.CNT=Y.OP.REQ.TOT
        END
        Y.OP.REQ.CNT += 1
    REPEAT
RETURN
*--------------------
PROCESS.RESULT:

    IF Y.RESULT EQ 1 THEN
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '02'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.T24.TXN.ID> = Y.FT.ID
    END ELSE
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'

        IF PGM.VERSION EQ ',CARD.IN' THEN
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R04'          ;* Fix for ACH Rejection
        END ELSE
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R31'
        END
        Y.REC.CON.ID = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.ID>
        Y.EXEC = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.EXEC.ID>
        CALL F.READ(FN.REDO.ACH.PROCESS,Y.EXEC,R.REDO.ACH.PROCESS,F.REDO.ACH.PROCESS,Y.ERR.PROC)
        Y.PROCESS.TYPE = R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.PROCESS.TYPE>
        IF Y.PROCESS.TYPE EQ 'REDO.ACH.INWARD' THEN
            Y.INTERF.ID = 'ACH003'
        END
        IF Y.PROCESS.TYPE EQ 'REDO.ACH.REJ.OUTWARD' THEN
            Y.INTERF.ID = 'ACH002'
        END

        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'ONLINE'
        BAT.NO = ''
        BAT.TOT = ''
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.MSG.ID
        MON.TP = '08'
        DESC = 'Transaction could not be processed at T24'
        REC.CON = Y.REC.CON.ID
        EX.USER = OPERATOR
        EX.PC = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*APAP.REDOCHSNL.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
=======
*CALL APAP.REDOCHSNL.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
=======
*CALL APAP.REDOCHSNL.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);* MANUAL R22 CODE CONVERSION
    END

    Y.CURR.NO = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CURR.NO>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CURR.NO> = Y.CURR.NO + 1
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;* AUTO R22 CODE CONVERSION
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;* AUTO R22 CODE CONVERSION

    DATE.TIME = OCONV(DATE(), 'D2:YMD') : OCONV(TIME(), 'MT')
    CHANGE ':' TO '' IN DATE.TIME


    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DATE.TIME> = DATE.TIME
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CO.CODE> = ID.COMPANY
    WRITE R.REDO.ACH.PROCESS.DET TO F.REDO.ACH.PROCESS.DET,Y.MSG.ID ON ERROR

        RETURN
    END

RETURN
END
