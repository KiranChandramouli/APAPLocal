* @ValidationCode : MjoxOTEwNDAxMzk0OkNwMTI1MjoxNjgwNjAxOTk2NTk2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:23:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.OVERRIDE.APPROVAL
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OVERRIDE
    $INSERT I_GTS.COMMON
    $INSERT I_F.PGM.FILE
*-------------------------------------------------------------------------------------
*MODIFICATIONS
* Date                   who                   Reference              
* 04-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM
* 04-04-2023          ANIL KUMAR B     R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------

    IF APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION EQ ',PAY.SUPP.IN' THEN
        Y.CR.DEB.ID = R.NEW(FT.CREDIT.ACCT.NO)
        LREF.APP='ACCOUNT':@FM:'AZ.ACCOUNT':@FM:'EB.LOOKUP'
        LREF.FIELD='L.AC.NOTIFY.1':@FM:'L.AC.NOTIFY.1':@FM:'L.POST.RESTRICT'
        LREF.POS = ''

        CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
        ACC.NOTIFY.POS =LREF.POS<1,1>
        AZ.NOTIFY.POS = LREF.POS<2,1>
        POST.RESTRICT.POS = LREF.POS<3,1>

        FN.ACCOUNT='F.ACCOUNT'
        F.ACCOUNT=''
        CALL OPF(FN.ACCOUNT,F.ACCOUNT)

        CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,CRE.ERR)
        IF R.ACCOUNT THEN
            Y.NOTIFY=R.ACCOUNT<AC.LOCAL.REF,ACC.NOTIFY.POS>
        END
        Y.NOTIFY.MSGS = 'ARMA.TU.COMBO.2':@FM:'ARMA.TU.COMBO.3':@FM:'ARMA.TU.COMBO.4':@FM:'DEBIT.PAYMENT':@FM:'EMPLOYEE':@FM:'LOST.DEPOSIT':@FM:'LOST.PASSBOOK':@FM:'MANCOMUNADA.Y':@FM:'NOMINA.APEC'
        LOCATE Y.NOTIFY IN Y.NOTIFY.MSGS SETTING NOTIFY.POS THEN
            TEXT = 'Y'
        END
    END
RETURN
