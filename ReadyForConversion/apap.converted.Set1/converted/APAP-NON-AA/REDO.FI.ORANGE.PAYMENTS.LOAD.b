SUBROUTINE REDO.FI.ORANGE.PAYMENTS.LOAD

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_TSA.COMMON
*
    $INSERT I_REDO.FI.ORANGE.PYMT.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END ELSE
        CALL TXT(W.ERROR)
    END
*
RETURN
*
* =====
PROCESS:
* =====
*
*      Creates File to save Orange Movements
*
    W.LEN = LEN(FILE.PATH)
    IF FILE.PATH[W.LEN,1] EQ "\" THEN
        W.LEN -= 1
        FILE.PATH = FILE.PATH[1,W.LEN]
    END
    FILE.NAME  = PRE.FILE.NAME:".":AGENT.NUMBER:".agt"
    FULL.NAME  = FILE.PATH : "/" : FILE.NAME
    OPENSEQ FULL.NAME TO FILE.TEXT ELSE
        CREATE FILE.TEXT ELSE
            W.ERROR = 'NO SE PUDO CREAR ARCHIVO-':FULL.NAME
        END
    END

*
RETURN
*
* ==============
B100.GET.PARAMS:
* ==============
*
*    Gets Params information from param main record
*
*   Teller Transactions to be considered for process
*
    LOOP
    WHILE WPARAM.POS GT 0 DO
        LOCATE WPARAM.TYPE.TT IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
            NUM.TT.TRAN                += 1
            TT.TRAN.LIST<NUM.TT.TRAN>  = RIP.VALUE<1, PARAM.POS>
            WPARAM.POS                  = PARAM.POS + 1
        END ELSE
            WPARAM.POS              = 0
        END
    REPEAT
*
*   FUNDS.TRANSFER Transactions to be considered for process
*
    WPARAM.POS = 1
    LOOP
    WHILE WPARAM.POS GT 0 DO
        LOCATE WPARAM.TYPE.FT IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
            NUM.FT.TRAN                += 1
            FT.TRAN.LIST<NUM.FT.TRAN>  = RIP.VALUE<1, PARAM.POS>
            WPARAM.POS                  = PARAM.POS + 1
        END ELSE
            WPARAM.POS              = 0
        END
    REPEAT
*
    IF TT.TRAN.LIST EQ "" AND FT.TRAN.LIST EQ "" THEN
        W.ERROR   = "MISSING.PARAMETER.TYPE.&.AND.&.IN.&.RECORD":@FM:WPARAM.TYPE.TT:@VM:WPARAM.TYPE.FT:@VM:PARAM.ID
    END
*
RETURN
*
* ========
INITIALISE:
* ========
*
*   Initialisation of working variables
*
    PROCESS.GOAHEAD   = 1
    PARAM.ID          = "ORANGE.PAYMT"
    WPARAM.TYPE.TT    = "TELLER"
    WPARAM.TYPE.FT    = "FUNDS.TRANSFER"
    DATE.PARAM        = "DATE.ORANGE"
    DATE.TO.PROCESS   = TODAY
*
    FN.TELLER         = "F.TELLER"
    F.TELLER         = ""
*
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER = ""
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""
*
    FN.SMAIL = 'F.REDO.INTERFACE.SMAIL'
    F.SMAIL = ''
*
    WPARAM.POS     = 1
    LOOP.CNT       = 1
    MAX.LOOPS      = 5
    NUM.FT.TRAN    = 0
    NUM.TT.TRAN    = 0
*
    TT.TRAN.LIST   = ""
    FT.TRAN.LIST   = ""
    W.ERROR        = ""
*
RETURN
*
* ========
OPEN.FILES:
* ========
*
*    Opens Files to be used during process
*
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
*
    CALL OPF(FN.TELLER,F.TELLER)
*
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
*
    CALL OPF(FN.SMAIL,F.SMAIL)
*
RETURN
*
* ===================
CHECK.PRELIM.CONDITIONS:
* ===================
*
*    Validates information in PARAMETER table
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    W.ERROR = "PARAMETER.MISSING.&":@FM:PARAM.ID
                END

            CASE LOOP.CNT EQ 2
*
                RIP.PARAM     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
                RIP.VALUE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
                FILE.PATH     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
                PRE.FILE.NAME = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FILE.NAME>

                IF NOT(RIP.PARAM) AND NOT(RIP.VALUE) THEN
                    W.ERROR = "NO.INFO.IN.RECORD.&":@FM:PARAM.ID
                END

            CASE LOOP.CNT EQ 3
                GOSUB B100.GET.PARAMS

        END CASE

        IF W.ERROR THEN
            PROCESS.GOAHEAD = 0
        END

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
