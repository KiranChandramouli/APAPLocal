* @ValidationCode : MjoxNDI0MzY5OTQ2OkNwMTI1MjoxNjgxNzMzNjg0NzY1OklUU1M6LTE6LTE6MTU0NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:44:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1547
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE AI.REDO.GET.REPRINT.VER
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : AI.REDO.GET.REPRINT.VERSION
*----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 11-APR-2023     Conversion tool    R22 Auto conversion       IF CONDITION ADDED
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.REFERENCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AI.REDO.PRINT.TXN.PARAM
    $INSERT I_F.REDO.H.SOLICITUD.CK
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*---------------
INITIALISE:
*---------------

    Y.TXN.NO = O.DATA
    Y.EXT.USR.NO = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        Y.EXT.USR.NO = ""
    END					;*R22 Auto conversion - END
    Y.CURR.ARR.ID = System.getVariable("CURRENT.ARR.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        Y.CURR.ARR.ID = ""
    END					;*R22 Auto conversion - END
    REPRINT.VER = ''
    Y.TXN.DET = ''

    Y.REPRINT.CK.REQ = 'REDO.H.SOLICITUD.CK,AI.REDO.PF.INPUT.REPRINT'
    Y.REPRINT.PAY.STP = 'REDO.PAYMENT.STOP.ACCOUNT,AI.REDO.INPUT.REPRINT'

RETURN

*---------------
OPEN.FILES:
*---------------

    FN.AI.REDO.PRINT.TXN.PARAM='F.AI.REDO.PRINT.TXN.PARAM'
    F.AI.REDO.PRINT.TXN.PARAM=''
    CALL OPF(FN.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.REFERENCE.DETAILS='F.AA.REFERENCE.DETAILS'
    F.AA.REFERENCE.DETAILS=''
    CALL OPF(FN.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY  = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER=''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS='F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS=''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.REDO.H.SOLICITUD.CK='F.REDO.H.SOLICITUD.CK'
    F.REDO.H.SOLICITUD.CK=''
    CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

    FN.REDO.PAYMENT.STOP.ACCOUNT='F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT=''
    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)

RETURN

*---------------
PROCESS:
*---------------

    BEGIN CASE
        CASE Y.TXN.NO[1,2] EQ 'FT'
            GOSUB PROCESS.FT
        CASE Y.TXN.NO[1,2] EQ 'PS'
            GOSUB PROCESS.PS
        CASE Y.TXN.NO[1,5] EQ 'AAACT'
            GOSUB PROCESS.AAACT
        CASE OTHERWISE
            GOSUB PROCESS.CK
    END CASE

    O.DATA = REPRINT.VER

*---------------
PROCESS.FT:
*---------------

    CALL F.READ(FN.FUNDS.TRANSFER, Y.TXN.NO, Y.TXN.DET, F.FUNDS.TRANSFER, ER.DET)
    IF Y.TXN.DET EQ '' THEN
        Y.TXN.NO := ";1"
        CALL F.READ(FN.FUNDS.TRANSFER.HIS, Y.TXN.NO, Y.TXN.DET, F.FUNDS.TRANSFER.HIS, ER.DET)
    END

    IF Y.TXN.DET NE '' THEN
        Y.TXN.TYPE = Y.TXN.DET<FT.TRANSACTION.TYPE>
        CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM, Y.TXN.TYPE, Y.REPRINT.DET, F.AI.REDO.PRINT.TXN.PARAM, ER.DET)
        IF ER.DET EQ '' THEN
            REPRINT.VER = Y.REPRINT.DET<AI.PRI.RE.PRINT.VERSION>:" S ":Y.TXN.NO
        END
    END

RETURN

*---------------
PROCESS.PS:
*---------------

    Y.TXN.NO = Y.TXN.NO[4,LEN(Y.TXN.NO)-3]
    CALL F.READ(FN.REDO.PAYMENT.STOP.ACCOUNT, Y.TXN.NO, Y.TXN.DET, F.REDO.PAYMENT.STOP.ACCOUNT, ER.DET)

    IF Y.TXN.DET NE '' THEN
        Y.TXN.CUST = Y.TXN.DET<REDO.PS.ACCT.CUSTOMER>
        IF Y.EXT.USR.NO EQ Y.TXN.CUST THEN
            REPRINT.VER = Y.REPRINT.PAY.STP:" S ":Y.TXN.NO
        END
    END

RETURN

*---------------
PROCESS.CK:
*---------------

    Y.TXN.NO = O.DATA
    CALL F.READ(FN.REDO.H.SOLICITUD.CK, Y.TXN.NO, Y.TXN.DET, F.REDO.H.SOLICITUD.CK, ER.ACC)

    IF Y.TXN.DET NE '' THEN
        Y.TXN.ACCT = Y.TXN.DET<REDO.H.SOL.ACCOUNT>
        CALL F.READ(FN.ACCOUNT, Y.TXN.ACCT, R.ACCT, F.ACCOUNT, ER.ACC)
        IF Y.EXT.USR.NO EQ R.ACCT<AC.CUSTOMER> THEN
            REPRINT.VER = Y.REPRINT.CK.REQ:" S ":Y.TXN.NO
        END
    END

RETURN

*---------------
PROCESS.AAACT:
*---------------

    Y.TXN.NO = O.DATA
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY, Y.TXN.NO, Y.TXN.DET, F.AA.ARRANGEMENT.ACTIVITY, ER.ARR)

    Y.AAA.ID = Y.TXN.DET<AA.ARR.ACT.MASTER.AAA>

    CALL F.READ(FN.AA.REFERENCE.DETAILS, Y.CURR.ARR.ID, Y.TXN.DET, F.AA.REFERENCE.DETAILS, ER.ARR)

    IF Y.TXN.DET NE '' THEN
        LOCATE Y.AAA.ID IN Y.TXN.DET<AA.REF.AAA.ID,1> SETTING POS1 THEN
            Y.TXN.FT.ID = Y.TXN.DET<AA.REF.TRANS.REF,POS1>
        END
        Y.TXN.NO = Y.TXN.FT.ID
        GOSUB PROCESS.FT
    END

RETURN

END
