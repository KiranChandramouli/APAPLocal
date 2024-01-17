* @ValidationCode : MjotMzQ3MzM4Mzc0OkNwMTI1MjoxNzAzNjczMDMxNjM4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 16:00:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.GEN.ACH.REJINW.FILE(PROCESS.ID)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*            Multithreading routine responsible for generating rejections files corresponding to transactions performed
* in other banks, which had problems when trying to be applied in T24. For the generation uses the information of the
* file REDO.ACH.PROCESS and REDO.ACH.PROCESS.DET
* Flat files are generated for every load performed in T24 during the day
*-----------------------------------------------------------------------------
* Input/Output:
*-----------------------------------------------------------------------------
* IN  : -NA-
* OUT : -NA-
*------------------------------------------------------------------------------
* Dependencies:
*-------------------------------------------------------------------------------
* CALLS : -NA-
* CALLED BY : -NA-
*--------------------------------------------------------------------------------
* Revision History:
*---------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-Oct-2010        Harish.Y       ODR-2009-12-0290       Initial Creation
* 10-APR-2013        Shesharaj      PERF-CHANGE            Performance Changes
* Date                   who                   Reference
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND ++ TO += 1 AND TNO TO C$T24.SESSION.NO AND = TO EQ
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion   Change F.READ to F.READU
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_TSA.COMMON
    $INSERT I_F.USER
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_REDO.B.GEN.ACH.REJINW.FILE.COMMON
    $USING APAP.REDOCHNLS

    GOSUB PROCESS


RETURN
**********
PROCESS:
**********
    R.FILE = ''
    R.REC = ''

    Y.COUNT=1
*    CALL F.READ(FN.REDO.ACH.PROCESS,PROCESS.ID,R.ACH.PROCESS,F.REDO.ACH.PROCESS,ACH.PROCESS.ERR)
    CALL F.READU(FN.REDO.ACH.PROCESS,PROCESS.ID,R.ACH.PROCESS,F.REDO.ACH.PROCESS,ACH.PROCESS.ERR,"") ;*R22 Manual Conversion
    
    IF R.ACH.PROCESS THEN
        Y.ORIG.FILE =R.ACH.PROCESS<REDO.ACH.PROCESS.FILE.NAME>
        Y.PROCESS.TYPE =R.ACH.PROCESS<REDO.ACH.PROCESS.PROCESS.TYPE>
    END
*!*PERF-CHANGE - Start
    IF (Y.PROCESS.TYPE EQ "REDO.ACH.INWARD" OR Y.PROCESS.TYPE EQ "REDO.ACH.REJ.OUTWARD") THEN
*!*PERF-CHANGE - End

        SELECT.CMD = "SELECT ":FN.REDO.ACH.PROCESS.DET:" WITH EXEC.ID EQ ":PROCESS.ID:" AND STATUS EQ 03"
        CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NOR,ERR)
        Y.TOTAL = NOR

        IF NOT(Y.TOTAL) THEN
            INT.CODE = Y.INTERF.ID
            INT.TYPE = 'BATCH'
            BAT.NO = '1'
            BAT.TOT = '1'
            INFO.OR = 'T24'
            INFO.DE = 'T24'
            ID.PROC = PROCESS.ID
            MON.TP = '01'
            DESC = 'There are no rejected records'
            REC.CON = Y.ORIG.FILE
            EX.USER = OPERATOR
            EX.PC = ''
*           CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
        END ELSE
            GOSUB UPDATE.ACH.PROCESS
            GOSUB START.PROCESS.DET
            GOSUB WRITE.TO.FILE
        END
    END
RETURN
*******************
UPDATE.ACH.PROCESS:
*******************
* Y.FILE.NAME = Y.FILE.PREFIX:PROCESS.ID:'.txt'

    Y.FILE.NAME = 'Reject.File':AGENT.NUMBER:'.txt'
    BEGIN CASE
        CASE Y.PROCESS.TYPE EQ 'REDO.ACH.INWARD'
            Y.PATH.HIST = Y.IN.PATH.HIS
        CASE Y.PROCESS.TYPE EQ 'REDO.ACH.REJ.OUTWARD'
            Y.PATH.HIST = Y.OUT.PATH.HIS
    END CASE

    Y.ID.MASTER =TODAY:'.':TIME()

    R.RECORD<REDO.ACH.PROCESS.EXEC.DATE>=TODAY
*R.RECORD<REDO.ACH.PROCESS.FILE.NAME>=Y.FILE.NAME
    R.RECORD<REDO.ACH.PROCESS.EXEC.TIME>=TIME()
    R.RECORD<REDO.ACH.PROCESS.PROCESS.TYPE>='REDO.ACH.REJECTION'
    R.RECORD<REDO.ACH.PROCESS.TOTAL.REC>=Y.TOTAL
    Y.CURR.NO = 1
    R.RECORD<REDO.ACH.PROCESS.CURR.NO> = Y.CURR.NO
    R.RECORD<REDO.ACH.PROCESS.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.RECORD<REDO.ACH.PROCESS.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    R.RECORD<REDO.ACH.PROCESS.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME1 = TEMPTIME[1,5]
    R.RECORD<REDO.ACH.PROCESS.DATE.TIME> = OCONV(DATE(),"D2"):' ':TEMPTIME1
    R.RECORD<REDO.ACH.PROCESS.CO.CODE> = ID.COMPANY

    CALL F.WRITE(FN.REDO.ACH.PROCESS,Y.ID.MASTER,R.RECORD)
    R.ACH.PROCESS<REDO.ACH.PROCESS.REJ.GEN>='YES'
    CALL F.WRITE(FN.REDO.ACH.PROCESS,PROCESS.ID,R.ACH.PROCESS)
    R.REDO.ACH.PROC.IDS = ''
    CALL F.READ(FN.REDO.ACH.PROC.IDS,TODAY,R.REDO.ACH.PROC.IDS,F.REDO.ACH.PROC.IDS,ID.ERR)
    R.REDO.ACH.PROC.IDS<-1> = Y.ID.MASTER
    CALL F.WRITE(FN.REDO.ACH.PROC.IDS,TODAY,R.REDO.ACH.PROC.IDS)
RETURN
******************
START.PROCESS.DET:
******************
    LOOP
    WHILE Y.COUNT LE NOR
*        CALL F.READ(FN.REDO.ACH.PROCESS.DET,SEL.LIST<Y.COUNT>,R.DET,F.REDO.ACH.PROCESS.DET,DET.ERR)
        CALL F.READU(FN.REDO.ACH.PROCESS.DET,SEL.LIST<Y.COUNT>,R.DET,F.REDO.ACH.PROCESS.DET,DET.ERR,"") ;*R22 Manual Conversion
        Y.TXN.ID = R.DET<REDO.ACH.PROCESS.DET.TXN.ID>
        Y.TXN.CODE = R.DET<REDO.ACH.PROCESS.DET.TXN.CODE>
        Y.TXN.ID = FMT(Y.TXN.ID,'R%7')
        Y.REJ.CODE = R.DET<REDO.ACH.PROCESS.DET.REJECT.CODE>
        IF Y.TXN.CODE EQ '21' OR Y.TXN.CODE EQ '31' OR Y.TXN.CODE EQ '51' ELSE
            Y.VALUE = Y.TXN.ID:Y.REJ.CODE
            R.FILE<-1> = Y.VALUE
        END

        LEN.CNT=FMT(Y.COUNT,'4"0"R')

        Y.ID.DETAIL =Y.ID.MASTER:'.':LEN.CNT

        R.REC<REDO.ACH.PROCESS.DET.TXN.ID> = Y.TXN.ID
        R.REC<REDO.ACH.PROCESS.DET.REJECT.CODE> = Y.REJ.CODE
        Y.CURR.NO = 1
        R.REC<REDO.ACH.PROCESS.DET.CURR.NO> = Y.CURR.NO
        R.REC<REDO.ACH.PROCESS.DET.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
        R.REC<REDO.ACH.PROCESS.DET.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
        R.REC<REDO.ACH.PROCESS.DET.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
        TEMPTIME = OCONV(TIME(),"MTS")
        TEMPTIME1 = TEMPTIME[1,5]
        R.REC<REDO.ACH.PROCESS.DET.DATE.TIME> = OCONV(DATE(),"D2"):' ':TEMPTIME1
        R.REC<REDO.ACH.PROCESS.DET.CO.CODE> = ID.COMPANY

        CALL F.WRITE(FN.REDO.ACH.PROCESS.DET,Y.ID.DETAIL,R.REC)
        Y.COUNT += 1
    REPEAT
RETURN
*************
WRITE.TO.FILE:
*************
*-------------WRITING INTO FLAT FILE------------------------*

    OPEN.ERR = ''
    OPENSEQ Y.OUT.PATH,Y.FILE.NAME TO FILE.PTR ELSE
        CREATE FILE.PTR ELSE
            INT.CODE = Y.INTERF.ID
            INT.TYPE = 'BATCH'
            BAT.NO = '1'
            BAT.TOT = '1'
            INFO.OR = 'T24'
            INFO.DE = 'T24'
            ID.PROC = PROCESS.ID
            MON.TP = '03'
            DESC = 'Unable to Open / Create ':Y.OUT.PATH
            REC.CON = Y.ORIG.FILE
            EX.USER = OPERATOR
            EX.PC = ''
*           CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 Manual Code Conversion
            OPEN.ERR = '1'
        END
    END
    IF OPEN.ERR NE '1' THEN

        Y.REJ.REC.CNT=1
        Y.REJ.REC.TOT=DCOUNT(R.FILE,@FM)
        LOOP
        WHILE Y.REJ.REC.CNT LE Y.REJ.REC.TOT
            WRITESEQ R.FILE<Y.REJ.REC.CNT> APPEND TO FILE.PTR ELSE
                INT.CODE = Y.INTERF.ID
                INT.TYPE = 'BATCH'
                BAT.NO = '1'
                BAT.TOT = '1'
                INFO.OR = 'T24'
                INFO.DE = 'T24'
                ID.PROC = PROCESS.ID
                MON.TP = '03'
                DESC = 'Unable to Write ':Y.OUT.PATH:' ':Y.FILE.NAME
                REC.CON = Y.ORIG.FILE
                EX.USER = OPERATOR
                EX.PC = ''
*              CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
                APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
                Y.REJ.REC.CNT=Y.REJ.REC.TOT
            END
            Y.REJ.REC.CNT += 1
        REPEAT
    END
RETURN
*--------------------------------------------------------------
END
