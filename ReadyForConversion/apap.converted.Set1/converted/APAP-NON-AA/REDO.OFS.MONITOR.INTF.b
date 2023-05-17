SUBROUTINE REDO.OFS.MONITOR.INTF(Y.IN.MESSAGE)

*------------------------------------------------
* Description:
*
* Author: Cesar Yepez
* Date  : 08-Sept-2010
*------------------------------------------------
* Modification History:
*
*------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BROWSER.TAGS
    $INSERT I_F.REDO.MONITOR.PARAMETER
    $INSERT I_TSS.COMMON


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

*-----------------------------------------------------------------------------------
PROCESS:

    BEGIN CASE
        CASE Y.OFS.TYPE EQ 'OFSML'
            GOSUB PROCESS.OFSML
    END CASE

RETURN
*-----------------------------------------------------------------------------------

PROCESS.OFSML:
*DEBUG
    CALL OS.GET.TAG.VALUE(THE.REQUEST, C$REQUEST.TYPE.TAG, OFS$REQUEST.TYPE)
    Y.OFS.REQUEST.TYPE = OFS$REQUEST.TYPE

    BEGIN CASE
        CASE Y.OFS.REQUEST.TYPE EQ 'OFS.ENQUIRY'
            Y.FLAG.ENQUIRY = '1'
            Y.ENQ.NAME.TAG = C$ENQ.NAME.TAG
            Y.ENQ.ACTION.TAG = C$ENQ.ACTION.TAG
            Y.INPUTTER = FIELD(THE.REQUEST,'<windowName>',2)
            Y.INPUTTER = FIELD(Y.INPUTTER,'_ENQ',1)
            CHANGE "_" TO "." IN Y.INPUTTER

            CALL OS.GET.TAG.VALUE( THE.REQUEST, C$ENQ.ACTION.TAG, Y.ENQ.ACTION)

            IF Y.ENQ.ACTION EQ 'RUN' THEN
*DEBUG
                CALL OS.GET.TAG.VALUE( THE.REQUEST, C$ENQ.NAME.TAG, Y.ENQ.NAME)
                Y.SEL.CRITERIA = THE.REQUEST
                CALL OS.PREP.ENQUIRY("", Y.SEL.CRITERIA, "XML")
                GOSUB PROCESS.ENQUIRY
            END
        CASE Y.OFS.REQUEST.TYPE EQ 'UTILITY.ROUTINE'
*DEBUG
            Y.FLAG.APPLICATION = '1'
            GOSUB GET.CUS.ACC.MAP

            IF Y.MAP.REF EQ '' THEN
                RETURN
            END

            CALL OS.GET.TAG.VALUE(THE.REQUEST, C$ROUTINE.ARGS.TAG, Y.CMD.ARGS)

            IF Y.CMD.ARGS EQ '' THEN
                RETURN
            END
            Y.INPUTTER = FIELD(THE.REQUEST,'<compScreen>',2)
            Y.INPUTTER = FIELD(Y.INPUTTER,'_',2)



            Y.SEE.CMD = ' S '
            Y.INDEX.SEE = INDEX(Y.CMD.ARGS,Y.SEE.CMD,1)
            IF Y.INDEX.SEE NE '0' THEN

                BEGIN CASE
                    CASE (Y.CMD.ARGS[1,9] EQ 'CUSTOMER ') OR  (Y.CMD.ARGS[1,4] EQ 'CUS ') OR (Y.CMD.ARGS[1,3] EQ 'CU ')
                        Y.OBJECT = 'CUSTOMER'
                        Y.REC.CON = Y.CMD.ARGS[Y.INDEX.SEE + 3,99]
                        Y.APP = 'CUSTOMER'
                    CASE (Y.CMD.ARGS[1,9] EQ 'CUSTOMER,') OR (Y.CMD.ARGS[1,4] EQ 'CUS,') OR (Y.CMD.ARGS[1,3] EQ 'CU,')
                        Y.INDEX.COMMA = INDEX(Y.CMD.ARGS,',',1)
                        Y.OBJECT = 'CUSTOMER' : Y.CMD.ARGS[Y.INDEX.COMMA,Y.INDEX.SEE - Y.INDEX.COMMA]
                        Y.REC.CON = Y.CMD.ARGS[Y.INDEX.SEE + 3,99]
                        Y.APP = 'CUSTOMER'
                    CASE (Y.CMD.ARGS[1,8] EQ 'ACCOUNT ') OR (Y.CMD.ARGS[1,4] EQ 'ACC ') OR (Y.CMD.ARGS[1,3] EQ 'AC ')
                        Y.OBJECT = 'ACCOUNT'
                        Y.REC.CON = Y.CMD.ARGS[Y.INDEX.SEE + 3,99]
                        Y.APP = 'ACCOUNT'
                    CASE (Y.CMD.ARGS[1,9] EQ 'ACCOUNT,') OR (Y.CMD.ARGS[1,4] EQ 'ACC,') OR (Y.CMD.ARGS[1,3] EQ 'AC,')
                        Y.INDEX.COMMA = INDEX(Y.CMD.ARGS,',',1)
                        Y.OBJECT = 'ACCOUNT' : Y.CMD.ARGS[Y.INDEX.COMMA,Y.INDEX.SEE - Y.INDEX.COMMA]
                        Y.REC.CON = Y.CMD.ARGS[Y.INDEX.SEE + 3,99]
                        Y.APP = 'ACCOUNT'
                END CASE

                IF Y.APP THEN
                    Y.REC.ID = Y.REC.CON
                    Y.FUNCT = 'S'
                    Y.OBJ = Y.OBJECT
                    GOSUB SEND.QUEUE
                END


            END

        CASE Y.OFS.REQUEST.TYPE EQ 'OFS.APPLICATION'
*DEBUG
            Y.FLAG.APPLICATION = '1'
            GOSUB GET.CUS.ACC.MAP

            IF Y.MAP.REF EQ '' THEN
                RETURN
            END

            CALL OS.GET.TAG.VALUE(THE.REQUEST, C$APPLICATION.TAG, Y.CMD.APP)
            CALL OS.GET.TAG.VALUE(THE.REQUEST, C$OFS.FUNCTION.TAG, Y.CMD.FUNCTION)

            Y.INPUTTER = FIELD(THE.REQUEST,'<compScreen>',2)
            Y.INPUTTER = FIELD(Y.INPUTTER,'_',2)


            IF Y.CMD.APP MATCHES 'ACCOUNT' :@VM: 'CUSTOMER' THEN
                IF Y.CMD.FUNCTION EQ 'S' THEN
                    CALL OS.GET.TAG.VALUE(THE.REQUEST, C$TRANSACTION.ID.TAG, Y.CMD.TXN.ID)
                    CALL OS.GET.TAG.VALUE(THE.REQUEST, C$VERSION.TAG, Y.CMD.VERSION)

                    Y.REC.ID = Y.CMD.TXN.ID
                    Y.FUNCT = Y.CMD.FUNCTION
                    Y.REC.CON = Y.CMD.TXN.ID
                    Y.APP = Y.CMD.APP
                    Y.OBJ = Y.CMD.APP : Y.CMD.VERSION

                    GOSUB SEND.QUEUE

                END
            END

    END CASE


RETURN
*-----------------------------------------------------------------------------------
PROCESS.ENQUIRY:
*DEBUG
    CALL CACHE.READ("F.REDO.MONITOR.PARAMETER",Y.APPLICATION,R.RECORD.PARAM,Y.ERR.PARAM)
*CALL F.READ(FN.MONITOR.PARAMETER,Y.APPLICATION, R.RECORD.PARAM,F.MONITOR.PARAMETER,Y.ERR.PARAM)
    IF Y.ERR.PARAM THEN
        RETURN
    END

    LOCATE Y.ENQ.NAME IN R.RECORD.PARAM<REDO.MON.PARAM.ENQUIRY.NAME,1> SETTING Y.POS.MV THEN
        Y.GEN.MAP.ENQ =  R.RECORD.PARAM<REDO.MON.PARAM.GEN.MAP.ENQ>
        Y.FLD.CUSTOMER = R.RECORD.PARAM<REDO.MON.PARAM.ENQ.CUSTOMER,Y.POS.MV>
        Y.FLD.ACCOUNT = R.RECORD.PARAM<REDO.MON.PARAM.ENQ.ACCOUNT,Y.POS.MV>
        Y.ENQ.MAP.REF = R.RECORD.PARAM<REDO.MON.PARAM.ENQ.MAP.REF,Y.POS.MV>

        IF Y.ENQ.MAP.REF EQ '' THEN
            Y.MAP.REF = Y.GEN.MAP.ENQ
        END ELSE
            Y.MAP.REF = Y.ENQ.MAP.REF
        END

        Y.REC.ID = Y.SEL.CRITERIA
        CHANGE @FM TO Y.PIPE IN Y.REC.ID
        Y.FUNCT = Y.ENQ.ACTION
        Y.REC.CON = Y.SEL.CRITERIA
        Y.APP = 'ENQUIRY'
        Y.OBJ = Y.ENQ.NAME

        GOSUB SEND.QUEUE

    END

RETURN


*-----------------------------------------------------------------------------------
SEND.QUEUE:
*DEBUG
    P.REC.ID = Y.REC.ID
    P.MAP.ID = Y.MAP.REF
    P.FUNCT = Y.FUNCT
    P.OPERATOR = Y.INPUTTER
    P.COMPANY = ID.COMPANY
    P.APP = Y.APP
    P.OBJ = Y.OBJ
    P.REC.NEW = ''
    P.REC.OLD = ''
    P.ACC.NEW = ''
    P.ACC.OLD = ''
    O.ERR = ''


    CALL REDO.MON.POST.MAP.QUEUE(P.REC.ID, P.MAP.ID, P.FUNCT, P.OPERATOR, P.COMPANY, P.APP, P.OBJ, P.REC.OLD, P.REC.NEW, P.ACC.OLD, P.ACC.NEW, O.ERR)

    IF O.ERR THEN
        ERR.MSG = 'ERROR SENDING MAPPING QUEUE. ENQ: ' : Y.REC.ID
        ERR.TYPE = 'ERROR'
        ERR.ID.PROC = Y.REC.ID
        ERR.REC.CON = Y.REC.CON
        GOSUB LOG.ERROR
    END

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
    ID.PROC = ERR.ID.PROC
    MON.TP = ''
    DESC = ERR.MSG
    REC.CON = ERR.REC.CON
    EX.USER = Y.INPUTTER
    EX.PC = IP.ADDRESS

    BEGIN CASE
        CASE ERR.TYPE EQ 'WARNING'
            MON.TP = 05
        CASE ERR.TYPE EQ 'ERROR'
            MON.TP = 08
    END CASE


    CALL REDO.INTERFACE.REC.ACT(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.PC)

RETURN

*-----------------------------------------------------------------------------------
GET.CUS.ACC.MAP:

    Y.MAP.REF = ''
    CALL CACHE.READ("F.REDO.MONITOR.PARAMETER",Y.APPLICATION,R.RECORD.PARAM,Y.ERR.PARAM)

    IF NOT(Y.ERR.PARAM) THEN

        Y.MAP.REF = R.RECORD.PARAM<REDO.MON.PARAM.CUS.ACC.MAP>

    END

RETURN

*-----------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
    PROCESS.GOAHEAD = 1
    Y.OFS.TYPE = ''
    TEST.STRING = '<?xml'
    THE.REQUEST = Y.IN.MESSAGE
    Y.OFS.REQUEST.TYPE = ''
    Y.FLAG.ENQUIRY = ''
    Y.FLAG.APPLICATION = ''
    Y.APPLICATION = 'ENQUIRY'
    IP.ADDRESS = TSS$CLIENTIP
    Y.INTERF.ID = 'MON001'
    Y.PIPE = '|'

*   Y.INPUTTER = FIELD(THE.REQUEST,'<windowName>',2)
*   Y.INPUTTER = FIELD(Y.INPUTTER,'_',1)
    Y.INPUTTER = ""
    BEGIN CASE
        CASE THE.REQUEST[1,LEN(TEST.STRING)] EQ TEST.STRING      ;* <?xml means browser
            Y.OFS.TYPE = 'OFSML'
        CASE THE.REQUEST[1,15]= 'BROWSER.XML,,,,'     ;* Old style with embedded browser - from Connector
            Y.OFS.TYPE = 'OFSML'
        CASE OTHERWISE
            Y.OFS.TYPE = 'OFS'
    END CASE

RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:

    FN.MONITOR.PARAMETER = 'F.REDO.MONITOR.PARAMETER'
    F.MONITOR.PARAMETER = ''
    CALL OPF(FN.MONITOR.PARAMETER,F.MONITOR.PARAMETER)

RETURN

*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

RETURN
*-----------------------------------------------------------------------------------

END
