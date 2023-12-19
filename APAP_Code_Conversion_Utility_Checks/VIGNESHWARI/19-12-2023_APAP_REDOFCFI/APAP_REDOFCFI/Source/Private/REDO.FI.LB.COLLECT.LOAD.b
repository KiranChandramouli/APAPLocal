* @ValidationCode : Mjo1MDEzNzI5Nzk6Q3AxMjUyOjE3MDI4ODA2NzQyODM6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Dec 2023 11:54:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.COLLECT.LOAD
*
* =============================================================================
*    - Looks for  ".apli"  file in a directory specified in  PLANILLA record of
*      REDO.INTERFACE.PARAM table. The name of the file defines which PLANILLA
*      process should be executed
*
*    - Opens required T24 Tables
*
*    - Stores required variables in a COMMON area for .SELECT and PROCESS routines
*
* ==============================================================================
*
* Subroutine Type : Multithreaded ROUTINE
* Attached to     : REDO.FI.COLLECT service
* Attached as     : Service
* Primary Purpose : Apply payments reported in APAP-Planillas
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 26, 2010
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*17-12-2023          VIGNESHWARI                   MANUAL R22 CODE CONVERSION               VARIABLE IS ASSIGN
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.TRANSACTION
*
    $INSERT I_F.REDO.FI.LB.BPROC
    $INSERT I_F.REDO.FI.LB.BPROC.DET
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.CANCELLED
    $USING APAP.REDOCHNLS
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES


    GOSUB PROCESS
    IF WERROR.MSG THEN
        GOSUB WRITE.ERROR.IN.LOG
    END
*
RETURN

* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
    LOOP.CNT        = 1
    MAX.LOOPS       = 3

*Id planilla to generate

*
    PARAM.ID        = COMM.PLANILLA.PROCESS
    PLANILLA.ID     = "PLANILLA"
*

*   CONSTANTS
*
    L.PAY.METH      = ""
    WERROR.MSG      = ""
    Y.DEST.PATH     = ""        ;* Path for APAP file
    FI.FILE.NEW     = ""        ;* Name for APAP File
    QUEUE.PATH.ID   = "PROC.QUEUE"        ;* Directory path to store the process key

*   Batch Process Detail table
    FN.REDO.FI.LB.BATCH.PROCESS.DET = "F.REDO.FI.LB.BPROC.DET"
    F.REDO.FI.LB.BATCH.PROCESS.DET  = ""
    R.REDO.FI.LB.BATCH.PROCESS.DET  = ""
*
*   Batch Process Header table
    FN.REDO.FI.LB.BATCH.PROCESS = "F.REDO.FI.LB.BPROC"
    F.REDO.FI.LB.BATCH.PROCESS  = ""
    R.REDO.FI.LB.BATCH.PROCESS  = ""
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM  = ""
    R.REDO.INTERFACE.PARAM  = ""
*

    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    F.FT.TXN.TYPE.CONDITION  = ""
    R.FT.TXN.TYPE.CONDITION  = ""
*

    FN.FT.COMMISSION.TYPE = "F.FT.COMMISSION.TYPE"
    F.FT.COMMISSION.TYPE  = ""
    R.FT.COMMISSION.TYPE  = ""

*
    FN.REDO.NCF.ISSUED = "F.REDO.NCF.ISSUED"
    F.REDO.NCF.ISSUED  = ""
    R.REDO.NCF.ISSUED  = ""

    FN.REDO.L.NCF.UNMAPPED = 'F.REDO.L.NCF.UNMAPPED'
    F.REDO.L.NCF.UNMAPPED  = ''
    R.REDO.L.NCF.UNMAPPED  = ''

    FN.REDO.L.NCF.STATUS = 'F.REDO.L.NCF.STATUS'
    F.REDO.L.NCF.STATUS  = ''
    R.REDO.L.NCF.STATUS  = ''


    FN.REDO.L.NCF.CANCELLED = 'F.REDO.L.NCF.CANCELLED'
    F.REDO.L.NCF.CANCELLED  = ''
    R.REDO.L.NCF.CANCELLED  = ''

*
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER  = ""
    R.FUNDS.TRANSFER  = ""

*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    R.ACCOUNT  = ""

    FN.TELLER  = "F.TELLER"
    F.TELLER   = ""
    R.TELLER   = ""

    FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION  = ""
    R.TELLER.TRANSACTION  = ""


    GOSUB B120.LOCAL.FIELDS
RETURN
*
*=================
B120.LOCAL.FIELDS:
*=================



    APPL = "ACCOUNT":@FM:"FUNDS.TRANSFER":@FM:"TELLER"
    FLD  = "L.AC.AV.BAL":@FM:"L.TT.TAX.AMT":@FM:"L.TT.TAX.AMT"
    POS  = ""
    CALL MULTI.GET.LOC.REF (APPL, FLD,POS)
    L.AC.AV.BAL.POS    = POS<1,1>
    Y.L.TT.TAX.AMT.POS = POS<2,1>
    Y.L.FT.TAX.AMT.POS = POS<3,1>

RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.FI.LB.BATCH.PROCESS.DET,F.REDO.FI.LB.BATCH.PROCESS.DET)
    CALL OPF(FN.REDO.FI.LB.BATCH.PROCESS,F.REDO.FI.LB.BATCH.PROCESS)
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)
    CALL OPF(FN.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED)
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)
    CALL OPF(FN.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.TELLER,F.TELLER)
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)
*
RETURN
* =================
WRITE.ERROR.IN.LOG:
* =================
    CALL TXT(WERROR.MSG)
    FI.INT.ACT.ID = "PLA001"
    INT.TYPE = 'BATCH'
    BAT.NO = '1'
    BAT.TOT = '1'
    INFO.OR = 'T24'
    INFO.DE = 'T24'
    ID.PROC = PLANILLA.ID
    MON.TP = '04'
    ID.DESC = PLANILLA.ID
    REC.CON = WERROR.MSG
    EX.USER = OPERATOR ;
    EX.PC = ''
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(FI.INT.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(FI.INT.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CONVERSION

RETURN
*
* ======
PROCESS:
* ======

    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PLANILLA.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        W.ERROR = "PARAMETER.MISSING.&":@FM:PLANILLA.ID
    END
    WPARAM.POS = 1
    RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
    COMM.USER = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.USER.SIGN.ON>
    COMM.PW   = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.USER.PWD>
    LOCATE QUEUE.PATH.ID IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.QUEUE.PATH  = RIP.VALUE<1,PARAM.POS>
        OPEN FI.QUEUE.PATH ELSE
            PROCESS.GOAHEAD = 0
            WERROR.MSG =  'Queue path Directory Missing ' : FI.QUEUE.PATH
        END
    END ELSE
        WERROR.MSG = "&.Directory.not.defined.in.&":@FM:QUEUE.PATH.ID:@VM:PLANILLA.ID
        PROCESS.GOAHEAD = 0
    END

    Y.PATH.SEND.ID = "PATH.SEND"

    YWORK.OFS.SOURCE          = "OFS.SOURCE"
    COMM.VERSION   = ""
    FI.PATH.SEND   = ""

*  Locate PATH.SEND
    WPARAM.POS = 1
    LOCATE Y.PATH.SEND.ID IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.PATH.SEND   = RIP.VALUE<1,PARAM.POS>
        OPEN FI.PATH.SEND ELSE
            PROCESS.GOAHEAD = 0
            WERROR.MSG =  'Send path Directory Missing ' : FI.PATH.SEND
        END
    END ELSE
        WERROR.MSG = "&.Directory.not.defined.in.&":@FM:QUEUE.PATH.ID:@VM:PLANILLA.ID
        PROCESS.GOAHEAD = 0
    END
*   Locate OFS.SOURCE
    WPARAM.POS = 1
    LOCATE YWORK.OFS.SOURCE IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        COMM.OFS.SOURCE = RIP.VALUE<1,PARAM.POS>
    END ELSE
        WERROR.MSG = "EB-Parameter.&.not.defined.in.&":@FM:YWORK.OFS.SOURCE:@VM:PLANILLA.ID
        PROCESS.GOAHEAD = 0
    END
ID.VAR='APAP-EXTERNOS-TAX'
*    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,'APAP-EXTERNOS-TAX', R.REDO.INTERFACE.PARAM, Y.ERR)
  CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,ID.VAR, R.REDO.INTERFACE.PARAM, Y.ERR);* MANUAL R22 CODE CONVERSION - VARIABLE IS ASSIGN
    IF Y.ERR THEN
        W.ERROR = "PARAMETER.MISSING.&":@FM:'APAP-EXTERNOS-TAX'
        PROCESS.GOAHEAD = 0
    END ELSE
        COMM.EXT.TAX.COMP = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.AFF.COMPANY>
        CHANGE @VM TO @FM IN COMM.EXT.TAX.COMP
        COMM.EXT.TAX.COMP = 'APAP-EXTERNOS-TAX':'*':COMM.EXT.TAX.COMP
    END
ID.VAR2='APAP-EXTERNOS-NOTAX'
*    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,'APAP-EXTERNOS-NOTAX', R.REDO.INTERFACE.PARAM, Y.ERR)
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,ID.VAR2, R.REDO.INTERFACE.PARAM, Y.ERR);* MANUAL R22 CODE CONVERSION - VARIABLE IS ASSIGN
    IF Y.ERR THEN
        W.ERROR = "PARAMETER.MISSING.&":@FM:'APAP-EXTERNOS-NOTAX'
        PROCESS.GOAHEAD = 0
    END ELSE
        COMM.EXT.NOTAX.COMP = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.AFF.COMPANY>
        CHANGE @VM TO @FM IN COMM.EXT.NOTAX.COMP
        COMM.EXT.NOTAX.COMP = 'APAP-EXTERNOS-NOTAX':'*':COMM.EXT.NOTAX.COMP
    END


RETURN
*

END
