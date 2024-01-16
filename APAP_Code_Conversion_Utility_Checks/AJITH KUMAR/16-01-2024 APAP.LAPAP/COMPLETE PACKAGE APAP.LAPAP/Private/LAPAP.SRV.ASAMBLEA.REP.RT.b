* @ValidationCode : MjotMjQ2MDcyNjU1OlVURi04OjE2OTAxNjc1NTI0NDc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:12
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.SRV.ASAMBLEA.REP.RT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 17-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion -START
    $INSERT  I_EQUATE
    $INSERT  I_F.DATES
    $INSERT  I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT  I_F.ST.L.APAP.ASAMBLEA.PARAM ;*R22 Manual Conversion -END
   $USING EB.TransactionControl

    GOSUB CARGADOR
    GOSUB GET.PARAMS
    GOSUB DETALLES
    GOSUB FINAL
RETURN

CARGADOR:
    FN.PA = "FBNK.ST.L.APAP.ASAMBLEA.PARTIC"
    FV.PA = ""
    R.PA = ""
    PA.ERR = ""
    CALL OPF(FN.PA,FV.PA)

    FN.PRM = "FBNK.ST.L.APAP.ASAMBLEA.PARAM"
    FV.PRM = ""

    CALL OPF(FN.PRM,FV.PRM)

    FN.REP = "F.L.APAP.REPORTE.ASAMBLEA.T1"
    FV.REP = ""
    CALL OPF(FN.REP,FV.REP)
RETURN

DETALLES:
    TOTAL.CUENTA = 0
    TOTAL.PROMEDIO = 0
    TOTAL.VOTOS = 0
    SEL.CMD = "SELECT " : FN.PA
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    LOOP REMOVE PA.ID FROM SEL.LIST SETTING STMT.POS

    WHILE PA.ID DO
        GOSUB GET.PARTIC

    REPEAT

    GOSUB GET.PARAMS
RETURN

GET.PARTIC:
    CALL F.READ(FN.PA,PA.ID,R.PA, FV.PA, PA.ERR)
    IF R.PA NE '' THEN
        TOTAL.CUENTA += 1
        TOTAL.PROMEDIO += R.PA<ST.L.APA.BALANCE.PROM.ANU>
        TOTAL.VOTOS += R.PA<ST.L.APA.VOTOS.CUENTA>
*CRT "CONTADOR CUENTA: " : TOTAL.CUENTA : "| TOTAL.PROMEDIO: " : TOTAL.PROMEDIO : " | TOTAL VOTOS: " : TOTAL.VOTOS
    END
RETURN

GET.PARAMS:

*    CALL F.READ(FN.PRM,"4",R.PARAM4, FV.PRM, PRM.ERR)
IDVAR.1 = "4" ;* R22 UTILITY AUTO CONVERSION
    CALL F.READ(FN.PRM,IDVAR.1,R.PARAM4, FV.PRM, PRM.ERR);* R22 UTILITY AUTO CONVERSION

    Y.PARAM4 = R.PARAM4<2>

RETURN

FINAL:
    RETURN.MSG = TOTAL.CUENTA : "|" : TOTAL.PROMEDIO : "|" : TOTAL.VOTOS
    REC.ID = "ASAMBLEA." : Y.PARAM4[5,2] : "-" : Y.PARAM4[7,2] : "-" : Y.PARAM4[1,4]

    CALL F.WRITE(FN.REP, REC.ID, RETURN.MSG)
*    CALL JOURNAL.UPDATE(REC.ID)
EB.TransactionControl.JournalUpdate(REC.ID);* R22 UTILITY AUTO CONVERSION
RETURN


END
