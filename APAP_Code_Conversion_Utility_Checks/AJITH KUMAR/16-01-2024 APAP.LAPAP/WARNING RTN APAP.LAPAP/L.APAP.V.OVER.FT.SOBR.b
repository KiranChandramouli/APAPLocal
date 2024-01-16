* @ValidationCode : MjoxMzg5MzIyNjgzOkNwMTI1MjoxNjgyMzM1OTQ0MzI2OklUU1M6LTE6LTE6MzUyOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 352
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* COMPANY NAME    : APAP
*
*----------------------------------------------------------
*
* DESCRIPTION     : BEFORE AUTHORISATION routine to be used in FT versions.
*                   Check to see whether account gets overdrawn.
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO                 REFERENCE       DESCRIPTION
*  29.10.2020       APAP                MDA-50153       No permitir que se sobregiren las  cuenta de categoria
*                                                       ahorro
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 F.READ TO CACHE.READ, BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------
*
SUBROUTINE L.APAP.V.OVER.FT.SOBR

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION START BP REMOVED
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
   $USING EB.LocalReferences
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.OVERRIDE ;*AUTO R22 CODE CONVERSION END
*

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
*
RETURN
*
* ===
INIT:
* ===
*

    Y.DR.ACCT.NO      = ''
    Y.TXN.CCY         = ''
*
RETURN          ;* Return INIT
*
* =========
OPEN.FILES:
* =========

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.OVERRIDE = 'F.OVERRIDE'
    FV.OVERRIDE = ''
    CALL OPF (FN.OVERRIDE,FV.OVERRIDE)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    FV.FUNDS.TRANSFER = ''
    CALL OPF (FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

*    CALL GET.LOC.REF("ACCOUNT", "L.AC.AV.BAL",L.AC.AV.BAL.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.AV.BAL",L.AC.AV.BAL.POS);* R22 UTILITY AUTO CONVERSION

*    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.TT.TAX.CODE",L.TT.TAX.CODE.POS)
EB.LocalReferences.GetLocRef("FUNDS.TRANSFER", "L.TT.TAX.CODE",L.TT.TAX.CODE.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.TT.TAX.AMT",L.TT.TAX.AMT.POS)
EB.LocalReferences.GetLocRef("FUNDS.TRANSFER", "L.TT.TAX.AMT",L.TT.TAX.AMT.POS);* R22 UTILITY AUTO CONVERSION

RETURN          ;* Return OPEN.FILES

* ======
PROCESS:
* ======
*
    GOSUB GET.TRANSACTION.INFO

    GOSUB GET.OVERRIDE.MSG

RETURN          ;* Return PROCESS
*

* ===================
GET.TRANSACTION.INFO:
* ===================
*

    Y.FT.ID         = ID.NEW
    Y.DR.ACCT.NO    = R.NEW(FT.DEBIT.ACCT.NO)

RETURN
*
* ===============
GET.OVERRIDE.MSG:
*================
    CALL CACHE.READ(FN.OVERRIDE, 'ACCT.UNAUTH.OD', R.OVERRIDE, ERRO.OVERRIDE) ;*AUTO R22 CODE CONVERSION
    Y.EB.OR.MESSAGE = R.OVERRIDE<EB.OR.MESSAGE>
    Y.EB.OR.MESSAGE = Y.EB.OR.MESSAGE<1,3,2>
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
    YACCNO = Y.DR.ACCT.NO
    Y.L.AC.AV.BAL = R.ACCOUNT<AC.LOCAL.REF,L.AC.AV.BAL.POS>

    Y.L.TT.TAX.CODE = R.NEW(FT.LOCAL.REF)<1,L.TT.TAX.CODE.POS>
    Y.L.TT.TAX.AMT = R.NEW(FT.LOCAL.REF)<1,L.TT.TAX.AMT.POS>

    IF R.ACCOUNT<AC.CATEGORY> GE 6000 AND R.ACCOUNT<AC.CATEGORY> LE 6599 THEN
        IF Y.L.TT.TAX.CODE EQ 'IMP015%' AND Y.L.AC.AV.BAL LT 0 OR Y.L.AC.AV.BAL LT Y.L.TT.TAX.AMT THEN
            AF = FT.DEBIT.ACCT.NO

            MESSAGE = Y.EB.OR.MESSAGE
            E = MESSAGE
            ETEXT = E
            CALL ERR

        END
    END
RETURN

END
