* @ValidationCode : MjoxNzIwNTc3NDM3OkNwMTI1MjoxNjkxOTk2MDI4MDIxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Aug 2023 12:23:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.B.GET.DD.DAT
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Routine for getting Direct Debit Data
* Type         : Batch Routine
* Attached to  : BATCH > BNK/REDO.VP.DD.SERVICE
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------
    COMMON /NS/P.FLAG
* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_F.REDO.VISION.PLUS.DD

*  $INSERT I_RAPID.APP.DEV.COMMON ;*R22 Manual Code Conersion
*  $INSERT I_RAPID.APP.DEV.EQUATE ;*R22 Manual Code Conersion
    $USING APAP.REDOSRTN
    
* </region>

    GOSUB INIT
    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************

* Log writing: process started
    APAP.REDOSRTN.redoSNotifyInterfaceAct ('VPL004', 'BATCH', '06', 'EMAIL ARCHIVO DEBITO DIRECTO', 'INICIO - DEBITO DIRECTO A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '') ;*MANUAL R22 CODE CONVERSION

    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM  = ''
    R.REDO.VISION.PLUS.PARAM  = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    FN.REDO.VISION.PLUS.DD = 'F.REDO.VISION.PLUS.DD'
    F.REDO.VISION.PLUS.DD = ''
    R.REDO.VISION.PLUS.DD = ''

    Y.ERR = ''

    MAP.FMT = 'MAP'
    DD.RCL = 'VP.DD.FILE'
    APP = ''
    APP.ID = ''

    FILE.OPENED = 0
    READ.FILE = 0

    DD.LIST    = ''
    DD.LIST.NAME   = ''
    DD.SELECTED    = ''
    DD.RETURN.CODE = ''

    DD.SEQ = ''

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM)
    CALL OPF(FN.REDO.VISION.PLUS.DD,F.REDO.VISION.PLUS.DD)

RETURN

***********************
* Main Process
PROCESS:
***********************
    IF P.FLAG THEN
        RETURN
    END
    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, Y.ERR)
    PROCESS.DATE = TODAY
    DD.DATE = PROCESS.DATE[7,2] : PROCESS.DATE[5,2]

    DD.PATH = TRIM(R.REDO.VISION.PLUS.PARAM<VP.PARAM.DD.FILE.PATH>,' ','B')
    DD.FILE = TRIM(R.REDO.VISION.PLUS.PARAM<VP.PARAM.DD.FILE.NAME>,' ','B')
    DD.FILE = EREPLACE(DD.FILE, "<DDMM>", DD.DATE)

    GOSUB GET.DD.ID

* Read the input file
    OPENSEQ DD.PATH, DD.FILE TO DD.FILE.POINTER THEN
        FILE.OPENED = 1
        LOOP
            READSEQ DD.LINE FROM DD.FILE.POINTER THEN
                READ.FILE = 1
                Y.NEW.D =  FIELD(DD.LINE,";",7)
                DD.LINE = EREPLACE(DD.LINE,Y.NEW.D,Y.NEW.D[1,8])
                Y.MONTO = FIELD(DD.LINE,';',6)
                IF Y.MONTO GT 0 THEN
                    GOSUB GET.DD.DATA
                END
            END ELSE
                EXIT
            END
        REPEAT
    END ELSE
        APAP.REDOSRTN.redoSNotifyInterfaceAct ('VPL004', 'BATCH', '06', 'EMAIL ARCHIVO DEBITO DIRECTO', 'DEBITO DIRECTO ARCHIVO NO ENCONTRADO EN ' : DD.PATH : '/' : DD.FILE, '', '', '', '', '', OPERATOR, '') ;*MANUAL R22 CODE CONVERSION
        CALL FATAL.ERROR('ERROR: Archivo no encontrado: ' : DD.FILE)
    END

    IF NOT(READ.FILE) THEN
        APAP.REDOSRTN.redoSNotifyInterfaceAct ('VPL004', 'BATCH', '06', 'EMAIL ARCHIVO DEBITO DIRECTO', 'DEBITO DIRECTO ARCHIVO NO SE PUDO LEER EN ' : DD.PATH : '/' : DD.FILE, '', '', '', '', '', OPERATOR, '') ;*MANUAL R22 CODE CONVERSION
        CALL FATAL.ERROR('ERROR: Archivo no encontrado: ' : DD.FILE)
    END

    IF FILE.OPENED THEN
* Close input file
        CLOSESEQ DD.FILE.POINTER
    END
    P.FLAG = 1
RETURN

************************
* Get Direct Debit Data
GET.DD.DATA:
************************

* Apply RAD Mapping
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, DD.RCL, APP, APP.ID, DD.LINE, R.REDO.VISION.PLUS.DD, DD.ERR.MSG)

    IF DD.ERR.MSG THEN
        CALL FATAL.ERROR("ERROR IN MAPPING: " : DD.ERR.MSG)

    END ELSE
* Transform to OFS Message
        Y.APPLICATION  = 'REDO.VISION.PLUS.DD'
        Y.VERSION      = Y.APPLICATION : ',' : 'INPUT'
        TRANS.FUNC.VAL = "I"
        TRANS.OPER.VAL = "PROCESS"
        NO.AUTH        = "0"
        OFS.SOURCE     = "VP.OFS"

* msth testing
        REDO.VISION.PLUS.DD.ID = PROCESS.DATE : '.' : FMT(DD.SEQ,"R%4")
        CALL OFS.BUILD.RECORD(Y.APPLICATION, TRANS.FUNC.VAL, TRANS.OPER.VAL, Y.VERSION, '', NO.AUTH, REDO.VISION.PLUS.DD.ID, R.REDO.VISION.PLUS.DD, OFS.MSG.REQ)
        Y.OPTIONS = OFS.SOURCE : @FM : "OFS"

* Invoking OBM
        Y.TXN.COMMITED = 0
        CALL OFS.CALL.BULK.MANAGER(Y.OPTIONS, OFS.MSG.REQ, OFS.MSG.RES, Y.TXN.COMMITED)
        IF NOT(Y.TXN.COMMITED) THEN
            CALL FATAL.ERROR("ERROR IN OFS PROCESS: " : OFS.MSG.RES)
        END ELSE
            DD.SEQ += 1
        END
    END

RETURN

**********************
* Get Direct Debit ID
GET.DD.ID:
**********************
    SELECT.STATEMENT  = 'SSELECT ' : FN.REDO.VISION.PLUS.DD
    SELECT.STATEMENT := ' WITH @ID LIKE ' : PROCESS.DATE : '...'
    SELECT.STATEMENT := ' BY-DSND @ID'

    CALL EB.READLIST(SELECT.STATEMENT, DD.LIST, DD.LIST.NAME, DD.SELECTED, DD.RETURN.CODE)

    IF DD.SELECTED GT 0 THEN
        REMOVE DD.ID FROM DD.LIST SETTING DD.POS
        DD.SEQ = DD.ID['.',2,1] + 1
    END ELSE
        DD.SEQ = 1
    END

RETURN

* </region>

END
