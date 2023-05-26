* @ValidationCode : MjoxMzc5NjkyNzEwOkNwMTI1MjoxNjg0ODU0MzkyOTc4OklUU1M6LTE6LTE6ODAyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 802
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MONITOR.MAP(MSG.ID)
*
*--------------------------------------------------------------------------------------
* Modifications:
*
* 30/08/2010 - Created by Cesar Yepez
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND CONVERT TO CHANGE
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*-------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.MAP.COMMON
    $INSERT I_F.REDO.MONITOR.TABLE
    $INSERT I_TSS.COMMON
*
*----------------------------------------------------------------------------------------
*
* Main processing section

    GOSUB INITIALISE
    GOSUB MAIN.PROCESSING
*
RETURN
*
*---------------------------------------------------------------------------------------
*
INITIALISE:
*
    R.MSG = ''
    ERR.TYPE = ''
    ERR.MSG = ''
    ERR.MAPPING = ''
    Y.PIPE = '|'

    Y.MAPPING.ID =  FIELD(MSG.ID, '-', 2)
*   Y.MSG.ID = FIELD(MSG.ID, '-', 1)  ;* without the mapping id

    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'

RETURN
*
*---------------------------------------------------------------------------------------
*
MAIN.PROCESSING:
*

    CALL F.READ(FN.REDO.MON.MAP.QUEUE, MSG.ID, R.MSG, F.REDO.MON.MAP.QUEUE, ERR)
*
    IF ERR THEN
        ERR.MSG = "MISSING REDO.MON.MAP.QUEUE RECORD " : MSG.ID
        ERR.TYPE = 'ERROR'
        GOSUB LOG.ERROR
        RETURN
    END ELSE
*

        GOSUB GET.MAPPING.VALUES

        IF ERR.MAPPING THEN
            ERR.MSG = "ERROR GETTING VALUES MAPPING " : MSG.ID
            ERR.TYPE = 'ERROR'
            GOSUB LOG.ERROR
            RETURN
        END ELSE
            R.RESPONSE = R.RETURN.MSG
            CHANGE Y.PIPE TO @FM IN R.RESPONSE  ;*R22 AUTO CONVERSTION CONVERT TO CHANGE AND = TO EQ

            GOSUB PREPARE.MSG

            IF R.RESULT NE '' THEN
                CHANGE @VM TO '@vm' IN  R.RESULT<1>
                CHANGE @VM TO '@vm' IN  R.RESULT<2>
                CHANGE @VM TO '@vm' IN  R.RESULT<3>
                CALL F.WRITE(FN.REDO.MON.SEND.QUEUE, MSG.ID, R.RESULT)
                CALL F.DELETE(FN.REDO.MON.MAP.QUEUE, MSG.ID)
                RETURN
            END ELSE
                ERR.MSG = "MESSAGE NULL " : MSG.ID
                ERR.TYPE = 'ERROR'
                GOSUB LOG.ERROR
                RETURN
            END

        END

    END
*
RETURN
*
*-----------------------------------------------------------------------------------
GET.MAPPING.VALUES:

* Some of the following variables are used only for debug
    Y.RECORD.ID = R.MSG<1>
    Y.MAPPING.ID = R.MSG<2>
    Y.FUNCTION = R.MSG<3>
    Y.DAY = R.MSG<4>
    Y.HOUR = R.MSG<5>
    Y.OPERATOR = R.MSG<6>
    Y.COMPANY = R.MSG<7>
    Y.APPLICATION = R.MSG<8>
    Y.OBJ = R.MSG<9>
    Y.ID.SEQ = R.MSG<10>
    Y.POST.MSG = R.MSG<20>
    Y.PRE.MSG = R.MSG<21>
    Y.POST.ACC = R.MSG<30>
    Y.PRE.ACC = R.MSG<31>


    MAP.FMT = 'MAP'
    ID.RCON.L = Y.MAPPING.ID
    APP = ''
    ID.APP = ''
    R.APP = R.MSG
    R.RETURN.MSG = ''
    ERR.MAPPING = ''

    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, ID.RCON.L, APP, ID.APP, R.APP, R.RETURN.MSG, ERR.MAPPING)



RETURN
*-----------------------------------------------------------------------------------
PREPARE.MSG:

* Getting name of monitor table
    Y.MNEM.MON.TABLE = FIELD(Y.MAPPING.ID, '/', 2)

    SEL.CMD = 'SELECT ' : FN.REDO.MON.TABLE : ' WITH MNEMONIC EQ ' : Y.MNEM.MON.TABLE
    CALL EB.READLIST(SEL.CMD,Y.LIST,'',NO.OF.REG,RET.CODE)

    IF (NO.OF.REG EQ 0) OR (NO.OF.REG GT 1) THEN
        ERR.MSG = "INVALID DEFINITION OF MONITOR TABLE: " : Y.MNEM.MON.TABLE
        ERR.TYPE = 'ERROR'
        GOSUB LOG.ERROR
        RETURN
    END

    LOOP
        REMOVE Y.ID.TABLE FROM Y.LIST SETTING POS
    WHILE Y.ID.TABLE:POS

        CALL F.READ(FN.REDO.MON.TABLE,Y.ID.TABLE,R.MONITOR.TABLE,F.REDO.MON.TABLE,ERR.TABLE)
        IF ERR.TABLE THEN
            ERR.MSG = "MONITOR TABLE NO FOUND: " : Y.ID.TABLE
            ERR.TYPE = 'ERROR'
            GOSUB LOG.ERROR
            RETURN
        END

        Y.FIELD.NAME = R.MONITOR.TABLE<REDO.MON.TAB.FIELD.NAME>
        Y.COUNT = DCOUNT(Y.FIELD.NAME,@VM)
        R.RESULT = ''
        FOR Y.CNT = 1 TO Y.COUNT
            Y.FIELD.NAME = R.MONITOR.TABLE<REDO.MON.TAB.SQL.FIELD.NAME,Y.CNT>
            Y.DATA.TYPE = R.MONITOR.TABLE<REDO.MON.TAB.DATA.TYPE,Y.CNT>
            Y.VALUE = R.RESPONSE<Y.CNT>
            Y.REQUIRED = R.MONITOR.TABLE<REDO.MON.TAB.REQUIRED,Y.CNT>
            CHANGE @VM TO '@vm' IN Y.FIELD.NAME
            CHANGE @VM TO '@vm' IN Y.DATA.TYPE
            CHANGE @VM TO '@vm' IN Y.VALUE
            R.RESULT<1,Y.CNT> = Y.FIELD.NAME
            R.RESULT<2,Y.CNT> = Y.DATA.TYPE
            R.RESULT<3,Y.CNT> = Y.VALUE



            Y.VALUE.SQL = Y.VALUE

            BEGIN CASE
                CASE Y.VALUE EQ ''
                    Y.VALUE.SQL = 'NULL'
                CASE Y.DATA.TYPE EQ 'C'
                    IF Y.VALUE NE '' THEN
                        Y.VALUE.SQL = "'" : Y.VALUE : "'"
                    END
                CASE Y.DATA.TYPE EQ 'D'
                    IF Y.VALUE NE '' THEN
                        Y.VALUE.SQL = "'" : Y.VALUE : "'"
                    END
            END CASE

            IF Y.CNT EQ 1 THEN
                Y.FIELDS = Y.FIELD.NAME
                Y.VALUES = Y.VALUE.SQL
            END ELSE
                Y.FIELDS = Y.FIELDS : ',' : Y.FIELD.NAME
                Y.VALUES = Y.VALUES : ',' : Y.VALUE.SQL
            END
        NEXT Y.CNT

        IF R.RESULT NE '' THEN
            R.RESULT<4> = Y.ID.TABLE
            R.RESULT<10> = 'insert into ' : Y.ID.TABLE : '(' : Y.FIELDS : ') values (' : Y.VALUES : ');'
        END

    REPEAT

RETURN
*-----------------------------------------------------------------------------------
LOG.ERROR:
* Register error in the fault log

    INT.CODE = Y.INTERF.ID
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = 'T24'
    INFO.DE = 'T24'
    ID.PROC = MSG.ID
    MON.TP = ''
    DESC = ERR.MSG
    REC.CON = Y.APPLICATION : '/' : Y.RECORD.ID
    EX.USER = OPERATOR
    EX.PC = IP.ADDRESS

    BEGIN CASE
        CASE ERR.TYPE EQ 'WARNING'
            MON.TP = '05'
        CASE ERR.TYPE EQ 'ERROR'
            MON.TP = '08'
            CALL F.WRITE(FN.REDO.MON.MAP.QUEUE.ERR, MSG.ID, R.MSG)
            CALL F.DELETE(FN.REDO.MON.MAP.QUEUE, MSG.ID)
    END CASE


    CALL REDO.INTERFACE.REC.ACT(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC)

RETURN

*-----------------------------------------------------------------------------------

END
