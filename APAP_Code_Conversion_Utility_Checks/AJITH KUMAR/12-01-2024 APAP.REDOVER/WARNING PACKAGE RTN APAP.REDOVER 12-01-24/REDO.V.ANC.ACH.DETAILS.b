* @ValidationCode : MjoxNDAxNDg2NDYyOkNwMTI1MjoxNzAzNjU5NzAxNTIzOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 12:18:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ANC.ACH.DETAILS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.ANC.ACH.DETAILS
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to check and default the Credit account number
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 29 Oct 2010     SWAMINATHAN          ODR-2009-12-0290              Initial Creation
*06-04-2023       Conversion Tool       R22 Auto Code conversion       = to EQ
*06-04-2023       Samaran T             R22 Manual Code Conversion     No Changes
* 27-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ACH.PARAM

*--------------------------------------------------------------------------------------------------------
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILES:
************
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.ACH.PARAM  = 'F.REDO.ACH.PARAM'
    F.REDO.ACH.PARAM = ''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    LOC.REF.APPLICATION="FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.FT.CR.CARD.NO'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.CR.CARD.NO=LOC.REF.POS<1,1>

RETURN
*------------------------------------------------------------------------------------------------------------
PROCESS:
*********
    Y.CREDIT.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)
    Y.LEN.CR.ACT = LEN(Y.CREDIT.ACCOUNT)
    IF PGM.VERSION EQ ",CARD.IN" THEN
        IF Y.LEN.CR.ACT EQ '16' THEN
            R.NEW(FT.LOCAL.REF)<1,POS.L.CR.CARD.NO> =  Y.CREDIT.ACCOUNT
        END ELSE
*      CALL F.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,F.REDO.ACH.PARAM,Y.ERR.ACH.PARAM) ;*Tus Start

            ID.VAR = "SYSTEM" ;*R22 MANUAL CODE CONVERSION
            CALL CACHE.READ(FN.REDO.ACH.PARAM,ID.VAR,R.REDO.ACH.PARAM,Y.ERR.ACH.PARAM) ; * Tus End
            R.NEW(FT.LOCAL.REF)<1,POS.L.CR.CARD.NO> = R.REDO.ACH.PARAM<REDO.ACH.PARAM.CARD.INTL.ACCT>
        END
    END

    IF PGM.VERSION EQ ",CARD.REJ" THEN
        IF Y.LEN.CR.ACT EQ '16' THEN
            R.NEW(FT.LOCAL.REF)<1,POS.L.CR.CARD.NO> =  Y.CREDIT.ACCOUNT
        END ELSE
            CALL CACHE.READ(FN.REDO.ACH.PARAM,ID.VAR,R.REDO.ACH.PARAM,Y.ERR.ACH.PAR)
*CALL F.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,F.REDO.ACH.PARAM,Y.ERR.ACH.PARAM)
            R.NEW(FT.LOCAL.REF)<1,POS.L.CR.CARD.NO> = R.REDO.ACH.PARAM<REDO.ACH.PARAM.CARD.INTL.ACCT>
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------
END
