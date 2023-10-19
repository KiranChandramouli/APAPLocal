* @ValidationCode : Mjo1MTc5MDMzMDc6Q3AxMjUyOjE2ODgzNjE1MTEwMTI6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Jul 2023 10:48:31
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                           AUTHOR                          Modification                 DESCRIPTION
*03/07/2023                    VIGNESHWARI              MANUAL R22 CODE CONVERSION             T24.BP is removed in insertfile
*03/07/2023                 CONVERSION TOOL             AUTO R22 CODE CONVERSION               NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.A.MAN.MAN.RT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
*    $INSERT BP I_F.ST.LAPAP.LY.POINT.MAN
    $INSERT  I_F.REDO.LY.POINTS

    GOSUB PRINCIPAL
RETURN
PRINCIPAL:

    IF V$FUNCTION EQ 'A' THEN
        GOSUB PROCESO
    END
RETURN

PROCESO:
    FN.LYP = 'F.REDO.LY.POINTS'
    F.LYP = ''
    CALL OPF(FN.LYP,F.LYP)

    Y.CODIGO.CLIENTE = R.NEW(ST.LAPLY.CODIGO.CLIENTE)

    CALL F.READ(FN.LYP,Y.CODIGO.CLIENTE,R.LYP, F.LYP, LYP.ERR)
    IF R.LYP NE '' THEN
        Y.MY.PROGRAM = R.NEW(ST.LAPLY.PROGRAMA)
        Y.MY.TXN.ID = R.NEW(ST.LAPLY.ID.TXN)
        Y.MY.QUANTITY = R.NEW(ST.LAPLY.PUNTOS.GENERADOS)
        Y.MY.VALUE = R.NEW(ST.LAPLY.VALOR.MONETARIO)
        Y.ORI.PROGRAM = R.LYP<REDO.PT.PROGRAM>    ;*REDO.PT.PROGRAM
        Y.ORI.TXN.ID = R.LYP<REDO.PT.TXN.ID>
        Y.ORI.QUANTITY = R.LYP<REDO.PT.QUANTITY>
        Y.ORI.VALUE = R.LYP<REDO.PT.QTY.VALUE>
        Y.ORI.GEN.DATE = R.LYP<REDO.PT.GEN.DATE>
        Y.ORI.AVAIL.DATE = R.LYP<REDO.PT.AVAIL.DATE>
        Y.ORI.EXPIRY.DATE = R.LYP<REDO.PT.EXP.DATE>
        Y.ORI.STATUS = R.LYP<REDO.PT.STATUS>
        Y.GEN.DATE = TODAY
        Y.AVAIL.DATE = TODAY
        PROCESS.DATE = TODAY
        DAY.COUNT = "1095C"   ;*3 YEARS
        CALL CDT('', PROCESS.DATE, DAY.COUNT)
        Y.EXPIRY.DATE = PROCESS.DATE

        Y.COUNT.PROG = DCOUNT(Y.ORI.PROGRAM,@SM)
        Y.NXT = Y.COUNT.PROG + 1

        Y.ORI.PROGRAM<1,1,Y.NXT> = Y.MY.PROGRAM
        Y.ORI.TXN.ID<1,1,Y.NXT> = Y.MY.TXN.ID
        Y.ORI.QUANTITY<1,1,Y.NXT> = Y.MY.QUANTITY
        Y.ORI.VALUE<1,1,Y.NXT> = Y.MY.VALUE
        Y.ORI.GEN.DATE<1,1,Y.NXT> = Y.GEN.DATE
        Y.ORI.AVAIL.DATE<1,1,Y.NXT> = Y.AVAIL.DATE
        Y.ORI.EXPIRY.DATE<1,1,Y.NXT> = Y.EXPIRY.DATE
        Y.ORI.STATUS<1,1,Y.NXT> = 'Liberada'
        Y.ORI.MAN.STATUS<1,1,Y.NXT> = 'SI'
        GOSUB OFS.PROC

    END

RETURN

OFS.PROC:
    Y.TRANS.ID = Y.CODIGO.CLIENTE
    Y.APP.NAME = "REDO.LY.POINTS"
    Y.VER.NAME = Y.APP.NAME :",REC.MAN3"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = "0"
    FINAL.OFS = ""
    OPTIONS = ""
    R.UPD.LYP = ""

    R.UPD.LYP<REDO.PT.PROGRAM> = Y.ORI.PROGRAM
    R.UPD.LYP<REDO.PT.TXN.ID> = Y.ORI.TXN.ID
    R.UPD.LYP<REDO.PT.QUANTITY> = Y.ORI.QUANTITY
    R.UPD.LYP<REDO.PT.QTY.VALUE> = Y.ORI.VALUE
*R.UPD.LYP<REDO.PT.STATUS> = Y.ORI.STATUS
    R.UPD.LYP<REDO.PT.GEN.DATE> = Y.ORI.GEN.DATE
    R.UPD.LYP<REDO.PT.AVAIL.DATE> = Y.ORI.AVAIL.DATE
    R.UPD.LYP<REDO.PT.EXP.DATE> = Y.ORI.EXPIRY.DATE
    R.UPD.LYP<REDO.PT.MAN.STATUS> = Y.ORI.MAN.STATUS

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.UPD.LYP,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"OFS.LYP",'')

RETURN

END
