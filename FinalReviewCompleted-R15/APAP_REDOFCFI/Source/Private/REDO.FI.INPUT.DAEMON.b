* @ValidationCode : MjotMTkxMTgyODExMTpVVEYtODoxNjgzNjE2MDk1MDUxOklUU1M6LTE6LTE6NTI5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:15
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 529
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.INPUT.DAEMON
*******************************************************************************
*    Monitors Input Directory for File Arrival
*
* =============================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2010/Oct/20
** Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED

*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_REDO.FI.VARIABLES.COMMON
    $USING APAP.REDOCHNLS
*
*************************************************************************
*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*

*   LOOP
*    WHILE NEVER.END.FLAG AND PROCESS.GOAHEAD DO
*

    WPR.INTERF.LIST    = PR.INTERF.LIST
    WPR.INTERF.MAN.DIR = PR.INTERF.MAN.DIR
    WPR.INTERF.AUT.DIR = PR.INTERF.AUT.DIR
    WPR.INTERF.HIS.DIR = PR.INTERF.HIS.DIR
    WPR.INTERF.RUT.ID  = PR.INTERF.RUT.ID

*

    LOOP
        REMOVE FI.INTERFACE FROM WPR.INTERF.LIST SETTING Y.SETPOS
    WHILE FI.INTERFACE : Y.SETPOS AND PROCESS.GOAHEAD DO
        CALL F.READ(FN.REDO.INTERFACE.PARAM, FI.INTERFACE, FI.REDO.INTERFACE.PARAM, FV.REDO.INTERFACE.PARAM, Y.ERR)
        IF Y.ERR THEN
            PROCESS.GOAHEAD = 0
            E = "EB-PARAMETER.MISSING"
            CALL ERR
        END
        REMOVE FI.ROUTINE.NAME FROM WPR.INTERF.RUT.ID SETTING LL
        GOSUB A010.ANALYZE.HISTORY.DIR
        GOSUB A020.ANALYZE.AUTOM.DIR
        GOSUB A030.ANALYZE.MANUAL.DIR
    REPEAT
*
*        SLEEP 10
*
*    REPEAT
*
RETURN
*
* ======================
A010.ANALYZE.HISTORY.DIR:
* ======================
*


    REMOVE FI.WORK.DIR FROM WPR.INTERF.HIS.DIR SETTING Y.SETPOS
    IF FI.WORK.DIR THEN
        Y.NAME.HIS.DIR = FI.WORK.DIR

        OPEN FI.WORK.DIR TO Y.HIS.DIR.POINTER ELSE
            PROCESS.GOAHEAD = 0
            E = "EB-MISSING.DIRECTORY"
            CALL ERR
        END
    END
*
RETURN
*
* =====================
A020.ANALYZE.AUTOM.DIR:
* =====================
*
    FI.COMM.PROC.TYPE.FLAG = "A"
    Y.FLAG.AUT.AVAIL.FUNDS = FI.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUT.AVAIL.FUNDS>
    Y.NAME.DIR             = FI.PATH.OFS
*
    IF Y.FLAG.AUT.AVAIL.FUNDS EQ "SI" THEN
        Y.NAME.DIR = FI.PATH.WORK
    END
*
    REMOVE FI.WORK.DIR FROM WPR.INTERF.AUT.DIR SETTING YY
    IF FI.WORK.DIR THEN
        GOSUB A040.OPEN.PROCESS.DIR
        GOSUB A060.PROCESS.CURRENT.DIR
    END
*
RETURN
*
* ======================
A030.ANALYZE.MANUAL.DIR:
* ======================
*

    FI.COMM.PROC.TYPE.FLAG = "M"
    Y.NAME.DIR             = FI.PATH.WORK
*
    REMOVE FI.WORK.DIR FROM WPR.INTERF.MAN.DIR SETTING Y.SETPOS

    IF FI.WORK.DIR THEN
        GOSUB A040.OPEN.PROCESS.DIR
        GOSUB A060.PROCESS.CURRENT.DIR
    END
*
RETURN
*
* ====================
A040.OPEN.PROCESS.DIR:
* ====================
*

    OPEN FI.WORK.DIR TO FI.WORK.DIR.POINTER ELSE
        PROCESS.GOAHEAD = 0
        E = "EB-MISSING.DIRECTORY"
        CALL ERR
    END
*
RETURN
*
* ================
A050.HISTORY.FILE:
* ================
*
*
    OPENSEQ Y.NAME.HIS.DIR, FI.FILE.ID TO Y.HIS.DIR.POINTER ELSE
        CREATE Y.HIS.DIR.POINTER ELSE
            WERROR.MSG = "ERROR.OPENING.HISTORY.FILE"
        END
    END

    WRITESEQ WFIRST.RECORD TO Y.HIS.DIR.POINTER ELSE
        WERROR.MSG = "ERROR.WRITING.HISTORY.FILE"
    END
    WEOFSEQ   Y.HIS.DIR.POINTER ;* Writes an EOF
    CLOSESEQ  Y.HIS.DIR.POINTER
*
RETURN
*
* =======================
A060.PROCESS.CURRENT.DIR:
* =======================
*
    Y.FILE.POS=''
    LOOP.FLAG = 1
    LOOP
    WHILE NEVER.END.FLAG AND PROCESS.GOAHEAD AND LOOP.FLAG DO
        SELECT FI.WORK.DIR.POINTER  TO Y.FILE.LIST
*LOOP WHILE READNEXT FI.FILE.ID FROM Y.FILE.LIST DO ;*Tus Start
        LOOP
            REMOVE FI.FILE.ID FROM Y.FILE.LIST SETTING Y.FILE.POS
        WHILE FI.FILE.ID:Y.FILE.POS  ;*Tus End

            READ WFIRST.RECORD FROM FI.WORK.DIR.POINTER, FI.FILE.ID THEN

                GOSUB A050.HISTORY.FILE
                GOSUB A100.PROCESS.FILE
                W.FILE.TO.DELETE = FI.WORK.DIR : "/" : FI.FILE.ID
                DELETESEQ W.FILE.TO.DELETE SETTING F.POINTER ELSE
                    WERROR.MSG = "FILE.&.COULD.NOT.BE.DELETED"
                END
*JOURNAL
            END ELSE
                E = "EB-EMPTY FILE"
                CALL ERR
            END

        REPEAT
        LOOP.FLAG = ""
    REPEAT
*JOURNAL
*
RETURN
*
* ================
A100.PROCESS.FILE:
* ================
*
    CALL @FI.ROUTINE.NAME(WFIRST.RECORD, WERROR.MSG)
*
    IF WERROR.MSG THEN
        GOSUB A120.WRITE.ERROR.IN.LOG
    END
*
    APAP.REDOFCFI.redoFiRecordControl(WERROR.MSG) ;*MANUAL R22 CODE CONVERSION
*
RETURN
*
* ======================
A120.WRITE.ERROR.IN.LOG:
* ======================
*

    FI.INTERFACES = ""
    FI.INTERFACES = FI.INTERFACE:".INT"

    BEGIN CASE

        CASE FI.INTERFACE EQ 'BACEN'

            FI.INT.ACT.ID = "BCN001"

        CASE FI.INTERFACE EQ 'ORANGE'

            FI.INT.ACT.ID = "ORG001"

        CASE FI.INTERFACE EQ 'INTNOMINA'

            FI.INT.ACT.ID = "INM001"

        CASE FI.INTERFACE EQ 'EXTNOMINA' OR FI.INTERFACE EQ 'EXTNOMINANOTAX'

            FI.INT.ACT.ID = "ENM001"

    END CASE

    INT.TYPE = 'BATCH'
    BAT.NO = '1'
    BAT.TOT = '1'
    INFO.OR = FI.FILE.ID
    INFO.DE = FI.ROUTINE.NAME
    ID.PROC = FI.INTERFACE
    MON.TP = '04'
    ID.DESC = FI.INTERFACE
    REC.CON = WERROR.MSG
    EX.USER = OPERATOR ;
    EX.PC = ''

    APAP.REDOCHNLS.redoInterfaceRecAct(FI.INT.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
*
RETURN
*
* =================
B100.GET.ALL.PATHS:
* =================
*
    LOOP
    WHILE WPARAM.POS GT 0 DO
        LOCATE FI.ID IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
            NUM.DIR                += 1
            PARAM.ID.LIST<NUM.DIR>  = RIP.VALUE<1, PARAM.POS>
            WPARAM.POS              = PARAM.POS + 1
        END ELSE
            WPARAM.POS              = 0
        END
    REPEAT
*
* Locate PATH.WORK
*
    WPARAM.POS = 1
    LOCATE PATH.WORK IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.PATH.WORK = RIP.VALUE<1,PARAM.POS>
        WPARAM.POS   = PARAM.POS + 1
    END ELSE
        WERROR.MSG = "&.Directory.not.defined.in.&":@FM:PATH.WORK:@VM:W.PARAM.DATA
    END

*
* Locate PATH.OFS
*
    WPARAM.POS = 1
    LOCATE PATH.OFS IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.PATH.OFS  = RIP.VALUE<1,PARAM.POS>
        WPARAM.POS   = PARAM.POS + 1
    END ELSE
        WERROR.MSG = "&.Directory.not.defined.in.&":@FM:PATH.OFS:@VM:W.PARAM.DATA
    END

*
* Locate PATH.REJ
*
    WPARAM.POS = 1
    LOCATE PATH.REJ IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.PATH.REJ  = RIP.VALUE<1,PARAM.POS>
        WPARAM.POS   = PARAM.POS + 1
    END ELSE
        WERROR.MSG = "&.Directory.not.defined.in.&":@FM:PATH.REJ:@VM:W.PARAM.DATA
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD           = 1
    NEVER.END.FLAG            = 1
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 4
    NUMBER.OF.INTERFACE.TYPES = 1
    WPARAM.POS                = 1
    NUM.DIR                   = 0
    NUM.INT                   = 0
    FI.ID                     = "FI.ID"
    PATH.WORK                 = "PATH.WORK"
    PATH.OFS                  = "PATH.OFS"
    PATH.REJ                  = "PATH.REJ"
    Y.NAME.HIS.DIR            = ""
    NUM.INTERF                = 0
    DIRP.COUNT                = 1
    DIRP.LOOPS                = 7
    Y.HIS.DIR.POINTER         = ""
*
    FI.WORK.DIR.POINTER       = ""
    FI.INPUT.DIR.POINTER      = ""
*
*   CONSTANTS
*
    PARAM.ID                  = "RFID"
    W.PARAM.DATA              = "RFID record in REDO.INTERFACE.PARAM"
*
    FN.REDO.INTERFACE.PARAM   = "F.REDO.INTERFACE.PARAM"
    FV.REDO.INTERFACE.PARAM   = ""
*
RETURN
*
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.INTERFACE.PARAM,FV.REDO.INTERFACE.PARAM)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R.REDO.INTERFACE.PARAM, FV.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    PROCESS.GOAHEAD = 0
                    W.E = "PARAMETER.MISSING.&":@FM:PARAM.ID
                END

            CASE LOOP.CNT EQ 2
*Locate ID.INTERFACE.LIST
                RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
                RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
                GOSUB B100.GET.ALL.PATHS

            CASE LOOP.CNT EQ 3
                IF PARAM.ID.LIST EQ "" THEN
                    WERROR.MSG   = "MISSING.PARAMETER.ID.IN.RFID.RECORD"
                    CALL TXT(WERROR.MSG)
                    PROCESS.GOAHEAD = 0
                    CALL ERR
                END

            CASE LOOP.CNT EQ 4
                LOOP
                    REMOVE PARAM.ID FROM PARAM.ID.LIST SETTING Y.SETPOS
                WHILE Y.SETPOS : PARAM.ID AND PROCESS.GOAHEAD DO
                    NUM.INT   += 1
                    DIRP.COUNT = 1

                    APAP.REDOFCFI.redoFiGetDirList(PARAM.ID,W.ERROR) ;* MANUAL R22 CONVERSION
                    IF W.ERROR THEN
                        PROCESS.GOAHEAD = 0
                    END
                REPEAT

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*


END
