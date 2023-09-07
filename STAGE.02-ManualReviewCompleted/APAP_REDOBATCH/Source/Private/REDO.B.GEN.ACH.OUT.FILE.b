* @ValidationCode : MjotNjkyMzczMTAwOkNwMTI1MjoxNjkzOTc2NjkzNzQzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Sep 2023 10:34:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.GEN.ACH.OUT.FILE(Y.ACH.SEL.LIST)
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.GEN.ACH.OUT.FILE
*------------------------------------------------------------------------------
*DESCRIPTION:Multithreading routine responsible for generating the files corresponding to transactions performed in APAP
*            For the generation uses the information of the file concat REDO.ACH.DATE and using the tool RAD.CONDUIT.LINEAR,
*            flat files are generated for each ACH transaction
*-------------------------------------------------------------------------------
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*02-SEP-2010    Swaminathan.S.R        ODR-2009-12-0290     INITIAL CREATION
*12-APR-2013 Karthik Sundararajan   PERF-CHANGE
*12-Oct-2017 Saran.S
* Date                   who                   Reference
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - TNO TO C$T24.SESSION.NO AND ADDING END
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.GEN.ACH.OUT.FILE.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ACH.DATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.USER
    $INSERT I_F.LOCKING
    $USING APAP.REDOCHNLS
    $USING APAP.LAPAP
*---------------------------------------------------------------------------------

    GOSUB SEL.ID
* 20171012 /S
    IF R.FUNDS.TRANSFER THEN
* 20171012 /E
        GOSUB RAD.TRAN
        GOSUB ID.FORMAT
        GOSUB WRITE.TRAN
* 20171012 /S
    END
* 20171012 /E
RETURN
*----------------------------------------------------------------------------------
**********
SEL.ID:
**********
    
    Y.LINE.1 = ''; Y.LINE.2 = ''
    Y.LINE.3 = ''; R.RETURN.MSG = ''
    TEMPTIME = ''
    Y.COUNT = '1'
    R.REDO.ACH.PROCESS.DET = ''
    R.APP = ''
    E = ''
    Y.OUTPUT.ARRAY = ''
*!* PERF-CHANGE-Start
*    Y.TXN.TYPE =  FIELD(Y.ACH.SEL.LIST,'-',1,1)
*    Y.TXN.ID = FIELD(Y.ACH.SEL.LIST,'-',2,1)

    Y.TXN.ID = TRIM(Y.ACH.SEL.LIST)

    IF Y.TXN.ID  AND Y.TXN.ID[1,2] EQ 'FT' THEN
        GOSUB READ.FT
    END
    PRINT "Y.TXN.ID :" :Y.TXN.ID
    Y.ACH.SEL.LIST = Y.TXN.TYPE:"-":Y.TXN.ID      ;* ReCompensating the change

*!* PERF-CHANGE-End

    LOCATE Y.TXN.TYPE IN Y.ACH.PARAM.TXN.TYPE<1,1> SETTING ACH.TXN.POS THEN
        Y.RAD.ID = Y.ACH.PARAM.RAD.COND<1,ACH.TXN.POS>
    END
RETURN
*--------------------------------------------------------------------------------------
************
RAD.TRAN:
************
    MAP.FMT = 'O'
    ID.RCON.L = Y.RAD.ID
    Y.FT.HIS.APP = FIELD(Y.TXN.ID,';',2,1)
    IF Y.FT.HIS.APP NE '' THEN
        APP = 'F.FUNDS.TRANSFER$HIS'
    END ELSE
        APP = 'F.FUNDS.TRANSFER'
    END
    ID.APP = Y.TXN.ID

    IF Y.TXN.ID[1,2] EQ 'FT' THEN
        R.APP = R.FUNDS.TRANSFER
*        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) SJ commented for test
*CALL REDO.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
        APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG);* R22 Manual conversion
        PRINT "R.RETURN.MSG :" :R.RETURN.MSG
        Y.LINE.1 = R.RETURN.MSG[1,Y.LENG.LINE]
        Y.LINE.2 = R.RETURN.MSG[1+Y.LENG.LINE,Y.LENG.LINE]
        Y.LINE.3 = R.RETURN.MSG[1+Y.LENG.LINE+Y.LENG.LINE,Y.LENG.LINE]
        
        IF Y.LINE.1 OR Y.LINE.2 OR Y.LINE.3 THEN
            Y.OUTPUT.ARRAY<-1> = Y.LINE.1
            Y.OUTPUT.ARRAY<-1> = Y.LINE.2
            Y.OUTPUT.ARRAY<-1> = Y.LINE.3
        END
        PRINT "Y.OUTPUT.ARRAY :" :Y.OUTPUT.ARRAY
    END

RETURN
*-------------------------------------------------------------------------------------------
************
ID.FORMAT:
************

    Y.FILE.NAME = 'APAP.ACHOUT.':Y.ACH.SEL.LIST
RETURN
*--------------------------------------------------------------------------------------------
************
WRITE.TRAN:
************
*WRITE THE TRANSACTION TO FILE NAME IN OUT.PATH AND OUT.PATH.HIS

*  IF TRIM(Y.OUTPUT.ARRAY,"","A") NE '' THEN
*      RETURN
*  END

    PRINT "Y.OUTPUT.ARRAY :" :Y.OUTPUT.ARRAY
    OPEN.ERR = ''
    WRITE.ERR = ''
    GOSUB OPEN.FILE
    IF OPEN.ERR NE '1' THEN
        GOSUB WRITE.FILE
        IF WRITE.ERR NE '1' THEN

            GOSUB ACH.PROC
            GOSUB ACH.PROC.DET
*            GOSUB SUCCESS.MSG -commented for performance fix. No need to update for successful transactions
        END
    END
RETURN
*--------------------------------------------------------------------------------------------
OPEN.FILE:
*************
    OPENSEQ Y.OUT.PATH,Y.FILE.NAME TO PATH.OUTPUT ELSE
        CREATE PATH.OUTPUT THEN
        END ELSE
*call C.22  FILE.OPEN.ERR
            INT.CODE = Y.INTERF.ID ; INT.TYPE = 'BATCH' ; BAT.NO = Y.COUNT ; BAT.TOT = Y.TOTAL ; INFO.OR = 'T24' ; INFO.DE = 'PAYBANK' ; ID.PROC = Y.TXN.ID
            MON.TP = '03' ; DESC = 'Unable to Open / Create ':Y.OUT.PATH ; REC.CON = Y.ACH.SEL.LIST ; EX.USER = OPERATOR ; EX.PC = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CONVERSION
            OPEN.ERR = '1'
        END
    END
    
    IF OPEN.ERR NE '1' THEN
        OPENSEQ Y.OUT.PATH.HIS,Y.FILE.NAME TO PATH.HIS.OUTPUT ELSE
            CREATE PATH.HIS.OUTPUT THEN
            END ELSE
*call C.22  HIS.OPEN.ERR
                INT.CODE = Y.INTERF.ID ; INT.TYPE = 'BATCH' ; BAT.NO = Y.COUNT ; BAT.TOT = Y.TOTAL ; INFO.OR = 'T24' ; INFO.DE = 'PAYBANK' ; ID.PROC = Y.TXN.ID
                MON.TP = '03' ; DESC = 'Unable to Open / Create ':Y.OUT.PATH.HIS ; REC.CON = Y.ACH.SEL.LIST ; EX.USER = OPERATOR ; EX.PC = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
                APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CONVERSION
                OPEN.ERR = '1'
            END
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------
WRITE.FILE:
*************

    LOOP
        REMOVE Y.REC FROM Y.OUTPUT.ARRAY SETTING Y.REC.POS
    WHILE Y.REC:Y.REC.POS
* 20171012 /S
        IF Y.REC EQ '' THEN
            CONTINUE
        END   ;*R22 AUTO CONVERSTION ADDING THE END
        PRINT "Y.REC :" :Y.REC
* 20171012 /E
        WRITESEQ Y.REC APPEND TO PATH.OUTPUT ELSE
* call C.22  WRITE.ERR
            INT.CODE = Y.INTERF.ID ; INT.TYPE = 'BATCH' ; BAT.NO = Y.COUNT ; BAT.TOT = Y.TOTAL ; INFO.OR = 'T24' ; INFO.DE = 'PAYBANK' ; ID.PROC = Y.TXN.ID
            MON.TP = '03' ; DESC = 'Unable to Write ':PATH.OUTPUT ; REC.CON = Y.ACH.SEL.LIST ; EX.USER = OPERATOR ; EX.PC = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CONVERSION
            WRITE.ERR = '1'
        END

        IF WRITE.ERR NE '1' THEN
            WRITESEQ Y.REC APPEND TO PATH.HIS.OUTPUT ELSE
* call C.22  WRITE.ERR
                INT.CODE = Y.INTERF.ID ; INT.TYPE = 'BATCH' ; BAT.NO = Y.COUNT ; BAT.TOT = Y.TOTAL ; INFO.OR = 'T24' ; INFO.DE = 'PAYBANK' ; ID.PROC = Y.TXN.ID
                MON.TP = '03' ; DESC = 'Unable to Write ':PATH.HIS.OUTPUT ; REC.CON = Y.ACH.SEL.LIST ; EX.USER = OPERATOR ; EX.PC = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
                APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CONVERSION
                WRITE.ERR = '1'
            END
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------------
**************
ACH.PROC:
**************

    Y.ID.MASTER = TODAY:'.':Y.TXN.ID:".TEMP"

    CALL F.READU(FN.REDO.ACH.PROCESS,Y.ID.MASTER,R.REDO.ACH.PROCESS,F.REDO.ACH.PROCESS,ACH.ERR,RETRY)
    IF R.REDO.ACH.PROCESS THEN
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.TOTAL.REC> = R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.TOTAL.REC> + 1
    END ELSE

        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.EXEC.DATE> = Y.DATE
        TEMPTIME = OCONV(TIME(),"MTS")
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.PROCESS.TYPE> = 'REDO.ACH.OUTWARD'
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.TOTAL.REC> = '1'
    END

    Y.CURR.NO = 1
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.CURR.NO> = Y.CURR.NO
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    TEMPTIME1 = TEMPTIME[1,5]
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.DATE.TIME> = OCONV(DATE(),"D2"):' ':TEMPTIME1
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.CO.CODE> = ID.COMPANY

    CALL F.WRITE(FN.REDO.ACH.PROCESS,Y.ID.MASTER,R.REDO.ACH.PROCESS)
RETURN
*---------------------------------------------------------------------------------------------------------------
**************
ACH.PROC.DET:
**************

    Y.LOCKING.ID = 'F.REDO.ACH.PROC.DET.FILE'
    CALL F.READU(FN.LOCK,Y.LOCKING.ID,R.LOCKING,F.LOCK,LOCKING.ERR,RETRY)

    IF R.LOCKING EQ '' THEN
        R.LOCKING<EB.LOK.REMARK> = TODAY
        R.LOCKING<EB.LOK.CONTENT> = '0001'
        Y.ID.DETAIL = TODAY:".":TIME():".":'0001'
    END ELSE
        REMARK.VAL=R.LOCKING<EB.LOK.REMARK>
        IF REMARK.VAL EQ TODAY THEN
            Y.SEQUENCE = R.LOCKING<EB.LOK.CONTENT> + 1
            Y.SEQUENCE=FMT(Y.SEQUENCE,'4"0"R')
            R.LOCKING<EB.LOK.CONTENT> = Y.SEQUENCE
            R.LOCKING<EB.LOK.REMARK> = TODAY
            Y.ID.DETAIL = TODAY:".":TIME():".":Y.SEQUENCE
        END ELSE
            R.LOCKING<EB.LOK.REMARK> = TODAY
            R.LOCKING<EB.LOK.CONTENT> = '0001'
            Y.ID.DETAIL = TODAY:".":TIME():".":'0001'

        END
    END
    CALL F.WRITE(FN.LOCK,Y.LOCKING.ID,R.LOCKING)

    MAP.FMT = 'O'
    ID.RCON.L = 'REDO.ACH.OUTWARD'
    ID.APP = Y.TXN.ID
    R.APP = R.FUNDS.TRANSFER  ;*'' SJ commeted for test
    R.RETURN.MSG= ''
    ERR.MSG= ''
    
*    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)  SJ commented for test
*CALL REDO.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) ;*R22 MANUAL CONVERSION
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.CODE> = R.RETURN.MSG<1>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.AMOUNT> = R.RETURN.MSG<2>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ACCOUNT> = R.RETURN.MSG<3>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.PARTICIP.NAME> = R.RETURN.MSG<4>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.ID> = R.RETURN.MSG<5>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.PARTICIP.ID> = R.RETURN.MSG<6>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.DESCRIPTION> = R.RETURN.MSG<7>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ADDIT.INFO> = R.RETURN.MSG<8>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.NAME> = R.RETURN.MSG<9>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.ID> = R.RETURN.MSG<10>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.ACCT> = R.RETURN.MSG<11>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.B.ID> = R.RETURN.MSG<12>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.T24.TXN.ID> = R.RETURN.MSG<16>

    Y.CURR.NO = 1
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CURR.NO> = Y.CURR.NO
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME1 = TEMPTIME[1,5]
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DATE.TIME> = OCONV(DATE(),"D2"):' ':TEMPTIME1
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CO.CODE> = ID.COMPANY
    CALL F.WRITE(FN.REDO.ACH.PROCESS.DET,Y.ID.DETAIL,R.REDO.ACH.PROCESS.DET)

    R.REDO.ACH.DET.IDS = ''
    Y.TODAY = TODAY
*!* PERF-CHANGE - Bug, A write on FN.REDO.ACH.DET.IDS without locking
*    CALL F.READ(FN.REDO.ACH.DET.IDS,Y.TODAY,R.REDO.ACH.DET.IDS,F.REDO.ACH.DET.IDS,ID.ERR)
    CALL F.READU(FN.REDO.ACH.DET.IDS,Y.TODAY,R.REDO.ACH.DET.IDS,F.REDO.ACH.DET.IDS,ACH.DET.ID.ERR,RETRY)

    R.REDO.ACH.DET.IDS<-1> = Y.ID.DETAIL

    CALL F.WRITE(FN.REDO.ACH.DET.IDS,Y.TODAY,R.REDO.ACH.DET.IDS)

RETURN
*----------------------------------------------------------------------------------------------------------------
***************
SUCCESS.MSG:
***************
* call C.22 SUCCESS MSG

    INT.CODE = Y.INTERF.ID ; INT.TYPE = 'BATCH' ; BAT.NO = Y.COUNT ; BAT.TOT = Y.TOTAL ; INFO.OR = 'T24' ; INFO.DE = 'PAYBANK' ; ID.PROC = Y.TXN.ID
    MON.TP = '01' ; DESC = 'Record generated successfully' ; REC.CON = Y.ACH.SEL.LIST ; EX.USER = OPERATOR ; EX.PC = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);* R22 Manual conversion
RETURN
*-----------------------------------------------------------------------------------------------------------------
*******
READ.FT:
*******
    R.FUNDS.TRANSFER = ''
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,Y.ERR.FT)
    IF R.FUNDS.TRANSFER THEN
        Y.TXN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>  ;* Condition R.FUNDS.TRANSFER<FT.RECORD.STATUS> NE 'REVE' is hypothetical
    END ELSE
* 20171012 /S
        R.FUNDS.TRANSFER = ''
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.TXN.ID,R.FUNDS.TRANSFER,Y.ERR.FTHIS)
        IF R.FUNDS.TRANSFER THEN
            IF R.FUNDS.TRANSFER<FT.RECORD.STATUS> NE 'REVE' THEN      ;* This was orginally a check IF R.FUNDS.TRANSFER<FT.RECORD.STATUS> NE 'REVE' in .SELECT routine, Seems to be a bug & Corrected
                Y.TXN.TYPE =  R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>   ;* Transaction type for only MATURED FT
* 20171012 /E
            END
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
END
