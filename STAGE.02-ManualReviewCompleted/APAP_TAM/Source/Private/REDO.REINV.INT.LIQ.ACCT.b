* @ValidationCode : MjotNjcxNzQ4MzExOkNwMTI1MjoxNjgxMDU2NDg1MzY0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.INT.LIQ.ACCT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.INT.LIQ.ACCT
*--------------------------------------------------------------------------------
* Description: Liqudation Account will be defaulted to Account fields
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 01-08-2011 JEEVA T PACS00032973 Liqudation Account will be defaulted to Account fields
* 14-02-2013 Vignesh Kumaar M R PACS00249339 System not allowing the pay out using the closed account
* 03-08-2013 Vignesh Kumaar M R PACS00273376 CREDIT AMOUNT UPDATE
* 14-08-2013 Vignesh Kumaar M R PACS00294719 TELLER DENOM NAME AND UNITS UPDATE
* 18-07-2018 Gopala Krishnan R  PACS00682620 Fix Modification
*----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.DEFAULT
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------


    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.ACCOUNT.HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT.HIS = ''
    CALL OPF(FN.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS)

    FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
    F.TELLER.DEFAULT = ''
    CALL OPF(FN.TELLER.DEFAULT,F.TELLER.DEFAULT)

    FN.ACCOUNT.CLOSURE.NAU='F.ACCOUNT.CLOSURE$NAU'
    F.ACCOUNT.CLOSURE.NAU=''
    CALL OPF(FN.ACCOUNT.CLOSURE.NAU,F.ACCOUNT.CLOSURE.NAU)

* Fix for PACS00273376 [CREDIT AMOUNT UPDATE]

    Y.APPL = 'TELLER'
    Y.FIELD = 'L.CREDIT.AMOUNT'
    Y.POS = ''
    CALL GET.LOC.REF(Y.APPL,Y.FIELD,Y.POS)

* End of Fix

* Fix for PACS00249339 #1

    FN.ACCOUNT.CLOSURE ='F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE =''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    Y.APPL.1 = 'ACCOUNT.CLOSURE'
    Y.FIELD.1 = 'L.TT.AC.STATUS'
    Y.POS.1 = ''
    CALL GET.LOC.REF(Y.APPL.1,Y.FIELD.1,Y.POS.1)

* End of Fix

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TT
    END

RETURN
*---------------------------------------------------------------------------------
TT:
*---------------------------------------------------------------------------------

    Y.ACCOUNT.1 = ''
    R.TELLER.DEFAULT = ''
    Y.AZ.ID = COMI
    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HIS,Y.AZ.ID,R.AZ.ACCOUNT,AZ.ERR)
    END

    Y.INT.LIQ.ACC = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    Y.CCY = R.AZ.ACCOUNT<AZ.CURRENCY>
*This condition is used to close normal accounts
    IF Y.INT.LIQ.ACC EQ '' THEN
        Y.INT.LIQ.ACC = COMI
    END

    CALL F.READ(FN.ACCOUNT.CLOSURE.NAU,Y.INT.LIQ.ACC,R.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE.NAU,ACCT.CLOS.ERR)
    ACCT.STATUS = R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,Y.POS.1>
    IF R.ACCOUNT.CLOSURE AND ACCT.STATUS EQ "" THEN
        VAR.CURRENCY = R.ACCOUNT.CLOSURE<AC.ACL.CURRENCY>
        R.NEW(TT.TE.ACCOUNT.1) = R.ACCOUNT.CLOSURE<AC.ACL.SETTLEMENT.ACCT>
        GOSUB CHECK.CURR
        R.NEW(TT.TE.CURRENCY.1) = VAR.CURRENCY
    END ELSE

* Fix for PACS00249339 #2

        CALL F.READ(FN.ACCOUNT.CLOSURE,Y.INT.LIQ.ACC,R.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE,ERR.ACCT.CLSR)
        ACCT.STATUS = R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,Y.POS.1>
        IF R.ACCOUNT.CLOSURE AND ACCT.STATUS EQ "" THEN
            VAR.CURRENCY = R.ACCOUNT.CLOSURE<AC.ACL.CURRENCY>
            R.NEW(TT.TE.ACCOUNT.1) = R.ACCOUNT.CLOSURE<AC.ACL.SETTLEMENT.ACCT>
            GOSUB CHECK.CURR
            R.NEW(TT.TE.CURRENCY.1) = VAR.CURRENCY
        END ELSE

* End of Fix

            ETEXT = 'AC-REC.NOT.FOUND'
            CALL STORE.END.ERROR
        END
    END

RETURN
*-----------------------------------------------------------------------------------
CHECK.CURR:
*-----------------------------------------------------------------------------------
    IF VAR.CURRENCY EQ LCCY THEN
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = R.ACCOUNT.CLOSURE<AC.ACL.TOTAL.ACC.AMT>
    END ELSE
        R.NEW(TT.TE.AMOUNT.FCY.1)<1,1> = R.ACCOUNT.CLOSURE<AC.ACL.TOTAL.ACC.AMT>
    END
    R.NEW(TT.TE.LOCAL.REF)<1,Y.POS> = R.ACCOUNT.CLOSURE<AC.ACL.TOTAL.ACC.AMT>   ;* Fix for PACS00273376
    CALL TT.PERFORM.DEF.PROCESSING      ;* Fix for PACS00294719

RETURN
*------------------------------------------------------------------------------------
END
