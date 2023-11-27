* @ValidationCode : MjotNjUzMTM1Njk6Q3AxMjUyOjE2OTMzMTQyMjIxNjk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Aug 2023 18:33:42
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
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACH.INW.INDIR
********************************************************

* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.ACH.INW.INDIR
*------------------------------------------------------------------------------
*DESCRIPTION:In dir Routine associated to the OFS.SOURCE to process INWARD transactions and perform rejection of OUTWARD transactions
*-------------------------------------------------------------------------------
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*07-SEP-2010    Swaminathan.S.R        ODR-2009-12-0290     INITIAL CREATION
*21-APR-2015    Vignesh Kumaar R       PACS00452811         ACH special character
*  DATE             WHO                   REFERENCE
* 06-JUNE-2023      Conversion Tool       R22 Auto Conversion - FM to @FM , TNO to C$T24.SESSION.NO
* 06-JUNE-2023      Harsha                R22 Manual Conversion - Added Package
* 24-AUG-2023       VIGNESHWARI           R22 Manual Conversion - PATH IS MODIFIED
*27/11/2023         Suresh                R22 Manual Conversion - OFS.BUILD.RECORED changed
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ACH.DATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $USING APAP.REDOCHNLS
*-------------------------------------------------------------------------------------

    GOSUB OPEN.FILES
    GOSUB ASSIGN.VAL
    GOSUB SEL.OFS.SOURCE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------
************
OPEN.FILES:
************
    FN.REDO.ACH.DATE = 'F.REDO.ACH.DATE'
    F.REDO.ACH.DATE = ''
    CALL OPF(FN.REDO.ACH.DATE,F.REDO.ACH.DATE)

    FLAG.PATH = ''
    INVALID.ACCT = ''

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM = ''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

    FN.REDO.ACH.PARAM = 'F.REDO.ACH.PARAM'
    F.REDO.ACH.PARAM = ''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    FN.REDO.ACH.PROCESS = 'F.REDO.ACH.PROCESS'
    F.REDO.ACH.PROCESS = ''
    CALL OPF(FN.REDO.ACH.PROCESS,F.REDO.ACH.PROCESS)

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'
    F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    REVERSE.FLAG = ''

    R.REDO.ACH.PROCESS = ''
    INVALID.ERR.FLAG = ''
    INVALID.PROC.DET.ERR.FLAG = ''
    R.REDO.ACH.PROCESS.DET = ''

    OFS.RAD.ERR.FLAG = ''
    OFS.RAD.PROC.ERR.FLAG = ''
    OFS.ERR.FLAG = ''
    Y.ARR.OFS.MSG = ''
    INVALID.ACCT.ERR.FLAG = ''

RETURN
*------------------------------------------------------------------------------------------
**************
ASSIGN.VAL:
**************
    CALL CACHE.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,Y.ERR.ACH.PAR)

    Y.PARAM.TXN.PURPOSE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.PURPOSE>
    Y.PARAM.TXN.CODE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.CODE>
    Y.PARAM.TXN.VERSION = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.VERSION>
    Y.PARAM.OFS.RAD.ID = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OFS.RAD.ID>
    Y.SPL.CHAR = R.REDO.ACH.PARAM<REDO.ACH.PARAM.ACH.SPL.CHAR>

    Y.OFS.SOURCE.ID = OFS$SOURCE.ID
    R.OFS.SOURCE = OFS$SOURCE.REC
    IN.QUEUE.PATH = R.OFS.SOURCE<OFS.SRC.IN.QUEUE.DIR>

RETURN
*---------------------------------------------------------------------------------------------
******************
SEL.OFS.SOURCE:
******************

    BEGIN CASE
        CASE Y.OFS.SOURCE.ID EQ "REDO.ACH.INWARD"
            Y.INTERF.ID = 'ACH003'
            CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,Y.INTERF.ID,R.REDO.INTERFACE.PARAM,Y.ERR.INT.PARAM)
            IN.DIR.PATH = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
            HIST.PATH = R.REDO.ACH.PARAM<REDO.ACH.PARAM.INW.HIST.PATH>

        CASE Y.OFS.SOURCE.ID EQ "REDO.ACH.REJ.OUTWARD"
            Y.INTERF.ID = 'ACH002'
            CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,Y.INTERF.ID,R.REDO.INTERFACE.PARAM,Y.ERR.INT.PARAM)
            IN.DIR.PATH = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
            HIST.PATH = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OUT.RJ.HIS.PATH>

    END CASE
RETURN
*-----------------------------------------------------------------------------------------------
************
PROCESS:
************

    ACH.PROC.FLAG = ''
    Y.DELIMITER =  R.REDO.ACH.PARAM<REDO.ACH.PARAM.INW.DELIMITER>
    Y.NO.OF.ELEMENTS = R.REDO.ACH.PARAM<REDO.ACH.PARAM.INW.NO.OF.ELMNT>
    INW.PATH.OUTPUT = ''

    OPEN IN.DIR.PATH TO F.FILE.PATH ELSE
        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.FILE.NAME
        MON.TP = '03'
        DESC = 'Unable to Open ':IN.DIR.PATH
        REC.CON = Y.MSG
        EX.USER = OPERATOR ;
        EX.PC = ''
        GOSUB INTERFACE.REC
        FLAG.PATH = 1
    END

    IF FLAG.PATH NE '1' THEN
        SEL.CMD.INW = "SELECT ":IN.DIR.PATH
        CALL EB.READLIST(SEL.CMD.INW,SEL.LIST.INW,'',NO.OF.INW.REC,SEL.ERR.INW)

        LOOP
            REMOVE Y.INW.ID FROM SEL.LIST.INW SETTING INW.POS
        WHILE Y.INW.ID : INW.POS
            Y.FILE.NAME = Y.INW.ID
            * Y.COMMAND = 'COPY FROM ':IN.DIR.PATH: ' TO ':HIST.PATH:' ':Y.INW.ID
            Y.COMMAND = 'SH -c cp ':IN.DIR.PATH: '/':Y.INW.ID:' ':HIST.PATH:'/':Y.INW.ID ;*R22 Manual Conversion - PATH IS MODIFIED 
            EXECUTE Y.COMMAND
            GOSUB INW.INDIR.PROC
            ACH.PROC.FLAG = ''

        REPEAT
    END
RETURN
*-------------------------------------------------------------------------------------------------
************
INW.INDIR.PROC:
************

    READ Y.FILE.MSG FROM F.FILE.PATH,Y.FILE.NAME THEN

* Fix for PACS00452811 [ACH special character]

        LOOP
            REMOVE Y.SPL FROM Y.SPL.CHAR SETTING Y.SPL.POS
        WHILE Y.SPL:Y.SPL.POS

            Y.FILE.MSG = CHANGE(Y.FILE.MSG,CHARX(Y.SPL),'***')

        REPEAT

* End of Fix

        Y.TOTAL.REC = DCOUNT(Y.FILE.MSG,@FM)

        FILE.LOOP = 1
        LOOP
            REMOVE Y.INW.LINE FROM Y.FILE.MSG SETTING Y.REC.POS
        WHILE Y.INW.LINE : Y.REC.POS
            IF ACH.PROC.FLAG NE '1' THEN
                GOSUB ACH.PROC.PROCESS
            END
            IF INVALID.ERR.FLAG NE '1' THEN

                GOSUB ACH.PROC.DET
                IF INVALID.ACCT.ERR.FLAG NE '1' AND INVALID.PROC.DET.ERR.FLAG NE '1' THEN
                    GOSUB OFS.RAD.PROC
                END

            END

            IF Y.LOAN.FLAG EQ '' THEN
                GOSUB ACH.PROC.DET.AUDIT
            END

            R.REDO.ACH.PROCESS.DET = ''
            INVALID.ERR.FLAG = ''
            INVALID.PROC.DET.ERR.FLAG = ''
            INVALID.ACCT.ERR.FLAG = ''
            OFS.RAD.ERR.FLAG = ''
            OFS.RAD.PROC.ERR.FLAG = ''
            OFS.ERR.FLAG = ''
            Y.OFS.RAD.ID = ''
            Y.OFS.RAD.VERSION = ''
            FILE.LOOP += 1

        REPEAT

        GOSUB WRITE.QUEUE.PATH

    END ELSE
        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.FILE.NAME
        MON.TP = '03'
        DESC = 'Unable to Read from ':F.FILE.PATH
        REC.CON = Y.MSG
        EX.USER = OPERATOR
        EX.PC = ''
        GOSUB INTERFACE.REC
    END
RETURN
*---------------------------------------------------------------------------------------------------
******************
ACH.PROC.PROCESS:
******************

    Y.EXP.FMT = DCOUNT(Y.INW.LINE,Y.DELIMITER)
    IF Y.EXP.FMT NE Y.NO.OF.ELEMENTS THEN

        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.FILE.NAME
        MON.TP = '04'
        DESC = 'Invalid file'
        REC.CON = Y.FILE.NAME
        EX.USER = OPERATOR
        EX.PC = ''

        GOSUB INTERFACE.REC
        INVALID.ERR.FLAG = '1'

    END  ELSE
        GOSUB ACH.PROC
    END
    ACH.PROC.FLAG = '1'
RETURN
*----------------------------------------------------------------------------------------------------
*********
ACH.PROC:
*********

    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.EXEC.DATE> = TODAY
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.FILE.NAME> = Y.FILE.NAME
    TEMPTIME = OCONV(TIME(),"MTS")
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.EXEC.TIME> = TEMPTIME
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.PROCESS.TYPE> = Y.OFS.SOURCE.ID
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.TOTAL.REC> = Y.TOTAL.REC
*AUDIT FIELDS
    Y.CURR.NO = 1
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.CURR.NO> = Y.CURR.NO
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR	;*R22 Auto Conversion  - TNO to C$T24.SESSION.NO
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR


    DATE.TIME = OCONV(DATE(), 'D2:YMD') : OCONV(TIME(), 'MT')
    CHANGE ':' TO '' IN DATE.TIME


    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.DATE.TIME> = DATE.TIME
    R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.CO.CODE> = ID.COMPANY
    Y.ID.MASTER = TODAY:".":TIME()

    WRITE R.REDO.ACH.PROCESS TO F.REDO.ACH.PROCESS,Y.ID.MASTER ON ERROR
        RETURN
    END


RETURN
*--------------------------------------------------------------------------------------------------------
***********
ACH.PROC.DET:
************

    Y.MSG = Y.INW.LINE
    Y.COUNT = '1'

    Y.SEQUENCE = FILE.LOOP
    Y.SEQUENCE=FMT(Y.SEQUENCE,'4"0"R')

    Y.ID.DETAIL = Y.ID.MASTER:".":Y.SEQUENCE

    MAP.FMT = 'MAP'
    ID.RCON.L = 'REDO.ACH.INWARD'
    ID.APP = ''
    R.APP = ''
    APP = ""
    R.RETURN.MSG= ''
    ERR.MSG= ''
    R.APP = Y.INW.LINE

    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    Y.REPLACE = R.RETURN.MSG<12>
    IF ERR.MSG EQ '' THEN

        Y.TXN.CODE = R.RETURN.MSG<1>

        GOSUB SUCCESS.PROCESS

    END ELSE

        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.FILE.NAME
        MON.TP = '04'
        DESC = 'Invalid message'
        REC.CON = Y.MSG
        EX.USER = OPERATOR
        EX.PC = ''
        GOSUB INTERFACE.REC
        INVALID.PROC.DET.ERR.FLAG = '1'

    END

RETURN
*-----------------------------------------------------------------------------
SUCCESS.PROCESS:

    Y.ACCOUNT.NO = R.RETURN.MSG<3>
    R.RETURN.MSG<3>=TRIM(R.RETURN.MSG<3>)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,Y.ERR.AC)
    Y.LOAN.FLAG=''
    Y.CARD.FLAG=''
    Y.ERR.FLAG=''   ;* PACS00539602
    IF R.ACCOUNT<AC.ARRANGEMENT.ID> NE '' AND (R.RETURN.MSG<1> EQ "22" OR R.RETURN.MSG<1> EQ "32" OR R.RETURN.MSG<1> EQ "52") THEN
        Y.ERR.FLAG= 1         ;* PACS00539602
    END

    IF R.RETURN.MSG<1> EQ "52"  AND R.RETURN.MSG<7> EQ "04" THEN
*Loan
        Y.LOAN.FLAG=1
        Y.ERR.FLAG = ''       ;* PACS00539602
    END

    IF R.RETURN.MSG<1> EQ "52" AND R.RETURN.MSG<7> EQ "05" THEN

        Y.CARD.FLAG=1
*card

    END

* IF R.ACCOUNT EQ '' AND Y.CARD.FLAG EQ '' THEN
    IF (R.ACCOUNT EQ '' AND Y.CARD.FLAG EQ '') OR Y.ERR.FLAG THEN     ;*PACS00539602
        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.FILE.NAME
        MON.TP = '04'
        DESC = 'Invalid account'
        REC.CON = Y.MSG
        EX.USER = OPERATOR
        EX.PC = ''

        GOSUB INTERFACE.REC
        INVALID.ACCT.ERR.FLAG = '1'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R04'

        GOSUB UPDATE.PROCESS.DET
        IF Y.LOAN.FLAG THEN
            GOSUB ACH.PROC.DET.AUDIT
        END
    END ELSE
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '01'
        GOSUB UPDATE.PROCESS.DET

    END

RETURN
*---------------------------------------------------------------------------------
UPDATE.PROCESS.DET:
    Y.TXN.AMT.LEN=LEN(R.RETURN.MSG<2>)
    Y.TXN.AMT=R.RETURN.MSG<2>[ 1,Y.TXN.AMT.LEN-2] : "." : R.RETURN.MSG<2>[Y.TXN.AMT.LEN-1,2]

    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.EXEC.ID> = Y.ID.MASTER
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.CODE> = R.RETURN.MSG<1>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.AMOUNT> = Y.TXN.AMT
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


RETURN
*--------------------------------------------------------------------------------------------------------------
OFS.RAD.PROC:

    Y.TXN.PURPOSE = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.DESCRIPTION>
    LOCATE Y.TXN.PURPOSE IN Y.PARAM.TXN.PURPOSE<1,1> SETTING TXN.PUR.POS THEN
        LOCATE Y.TXN.CODE IN Y.PARAM.TXN.CODE<1,TXN.PUR.POS,1> SETTING TXN.CODE.POS THEN
            Y.OFS.RAD.ID = Y.PARAM.OFS.RAD.ID<1,TXN.PUR.POS,TXN.CODE.POS>
            Y.OFS.RAD.VERSION = Y.PARAM.TXN.VERSION<1,TXN.PUR.POS,TXN.CODE.POS>
        END
    END
    IF Y.OFS.RAD.ID EQ '' OR Y.OFS.RAD.VERSION EQ '' THEN

        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.FILE.NAME
        MON.TP = '09'
        DESC = 'There is no Version o Rad for the purpose or code of the transaction'
        REC.CON = Y.MSG
        EX.USER = OPERATOR
        EX.PC = ''
        GOSUB INTERFACE.REC
        OFS.RAD.ERR.FLAG = 1
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R31'
    END ELSE
        MAP.FMT = 'MAP'
        ID.RCON.L = Y.OFS.RAD.ID
        APP = ''
        ID.APP = ''
        R.APP = Y.MSG
        R.RETURN.MSG= ''
        ERR.MSG= ''
        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
        Y.NEW.VAL = Y.REPLACE:'.':Y.FILE.NAME:'.':FILE.LOOP
        Y.ALT.KEY = Y.NEW.VAL
        R.RETURN.MSG = EREPLACE(R.RETURN.MSG,Y.REPLACE,Y.NEW.VAL)
        Y.REPLACE = ''
        Y.NEW.VAL = ''
        IF ERR.MSG NE '' THEN

            INT.CODE = Y.INTERF.ID
            INT.TYPE = 'BATCH'
            BAT.NO = '1'
            BAT.TOT = '1'
            INFO.OR = 'T24'
            INFO.DE = 'T24'
            ID.PROC = Y.FILE.NAME
            MON.TP = '08'
            DESC = 'OFS creating error ' : ERR.MSG
            REC.CON = Y.MSG
            EX.USER = OPERATOR
            EX.PC = ''
            GOSUB INTERFACE.REC
            OFS.RAD.PROC.ERR.FLAG = 1
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '05'

        END
    END

    ALT.KEY.FLD.NAME = 'L.UNIQ.REF'
    FN.ALT.KEY.CONCAT = 'F.FUNDS.TRANSFER':'.':ALT.KEY.FLD.NAME
    F.ALT.KEY.CONCAT = ''
    CALL OPF(FN.ALT.KEY.CONCAT,F.ALT.KEY.CONCAT)  ;* open ALT KEY concat file

    CONCAT.REC = ''
    CALL F.READ(FN.ALT.KEY.CONCAT,Y.ALT.KEY,CONCAT.REC,F.ALT.KEY.CONCAT,ER2)
    Y.ALT.KEY = ''
    IF CONCAT.REC EQ '' THEN

        IF OFS.RAD.ERR.FLAG NE '1' AND OFS.RAD.PROC.ERR.FLAG NE '1' THEN
            GOSUB OFS.PROC
        END
    END
RETURN
*---------------------------------------------------------------------------------------------------------------------
***********
OFS.PROC:
***********

    OFS.SRC.ID = "ACH"
    OFS.MSG.ID = ''
    ERR.OFS = ''
    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.VERSION = FUNDS.TRANSFER:',':Y.OFS.RAD.VERSION ;*R22 Manual Conversion
    GTS.MODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = "/" : Y.ID.DETAIL
    R.ACC = R.RETURN.MSG
    OFSRECORD = ''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFS.VERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.ACC,OFSRECORD)

    IF OFSRECORD EQ '' THEN

        INT.CODE = Y.INTERF.ID
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = Y.FILE.NAME
        MON.TP = '08'
        DESC = 'OFS creating error '
        REC.CON = Y.MSG
        EX.USER = OPERATOR
        EX.PC = ''
        GOSUB INTERFACE.REC
        OFS.ERR.FLAG = 1
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '05'

    END

    IF OFS.ERR.FLAG NE '1' AND Y.LOAN.FLAG EQ '' THEN
        Y.ARR.OFS.MSG<-1> = OFSRECORD
    END ELSE



        GOSUB ACH.PROC.DET.AUDIT
        Y1.SOURCE.ID='REDO.ACH.INWARD.LOAN'
        CALL OFS.CALL.BULK.MANAGER(Y1.SOURCE.ID,OFSRECORD,Y.theResponse, Y.txnCommitted)

    END
    OFS$SOURCE.ID=Y.OFS.SOURCE.ID
    OFS$SOURCE.REC=R.OFS.SOURCE

RETURN
*-----------------------------------------------------------------------------------------------------------------------------
********************
WRITE.QUEUE.PATH:
********************

    OPEN IN.QUEUE.PATH TO QUEUE.PATH.OUTPUT THEN
        WRITE Y.ARR.OFS.MSG TO QUEUE.PATH.OUTPUT,Y.FILE.NAME
        DEL.CMD = "DELETE ":IN.DIR.PATH:" ":Y.FILE.NAME
        EXECUTE DEL.CMD
    END

RETURN
*---------------------------------------------------------------------------------------------------------------------------------
***************
INTERFACE.REC:
***************
*C.22 RTN
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)      ;*R22 Manual Conversion - Added Package

RETURN
*------------------------------------------------------------------------------------------------------------------------------------
*****************
ACH.PROC.DET.AUDIT:
******************
*AUDIT FIELDS

    Y.CURR.NO = 1
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CURR.NO> = Y.CURR.NO
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR	;*R22 Auto Conversion  - TNO to C$T24.SESSION.NO
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR


    DATE.TIME = OCONV(DATE(), 'D2:YMD') : OCONV(TIME(), 'MT')
    CHANGE ':' TO '' IN DATE.TIME

    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DATE.TIME> = DATE.TIME
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CO.CODE> = ID.COMPANY
    WRITE R.REDO.ACH.PROCESS.DET TO F.REDO.ACH.PROCESS.DET,Y.ID.DETAIL ON ERROR
        RETURN
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------------------------
END
