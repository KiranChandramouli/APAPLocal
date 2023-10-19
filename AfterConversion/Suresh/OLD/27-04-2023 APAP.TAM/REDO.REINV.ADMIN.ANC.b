* @ValidationCode : MjotNDE1MzE4Nzg1OkNwMTI1MjoxNjgyNDk1NzQxODM2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 13:25:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.ADMIN.ANC
*---------------------------------------------
* Description: This routine is to auto default the values for reversal.

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 14-Jul-2011     H Ganesh    PACS00072695 - N.11   Initial Draft.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.VERSION.IDS


    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    LOC.REF.APPLICATION="FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.FT.AZ.ACC.REF':@VM:'L.FT.ORG.DEPST':@VM:'L.FT.AZ.TXN.REF':@VM:'BENEFIC.NAME':@VM:'L.FT.CONCEPT':@VM:'L.FT.ADD.INFO'
    LOC.REF.POS=''
    CALL APAP.TAM.MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)  ;*MANUAL R22 CODE CONVERSION
    POS.L.FT.AZ.ACC.REF = LOC.REF.POS<1,1>
    POS.L.FT.ORG.DEPST  = LOC.REF.POS<1,2>
    POS.L.FT.AZ.TXN.REF = LOC.REF.POS<1,3>
    POS.BENEFIC.NAME    = LOC.REF.POS<1,4>
    POS.L.FT.CONCEPT    = LOC.REF.POS<1,5>
    POS.L.FT.ADD.INFO   = LOC.REF.POS<1,6>

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.FT.ID=FIELD(Y.DATA,"*",2)
    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FT,F.FUNDS.TRANSFER,FT.ERR)

    R.NEW(FT.DEBIT.ACCT.NO)     = R.FT<FT.CREDIT.ACCT.NO>
    R.NEW(FT.CREDIT.ACCT.NO)    = R.FT<FT.DEBIT.ACCT.NO>
    IF R.FT<FT.CREDIT.VALUE.DATE> NE R.FT<FT.DEBIT.VALUE.DATE> THEN
        R.NEW(FT.DEBIT.VALUE.DATE)  = R.FT<FT.CREDIT.VALUE.DATE>
        R.NEW(FT.CREDIT.VALUE.DATE) = TODAY
    END ELSE
        R.NEW(FT.DEBIT.VALUE.DATE)  = R.FT<FT.CREDIT.VALUE.DATE>
        R.NEW(FT.CREDIT.VALUE.DATE) = R.FT<FT.DEBIT.VALUE.DATE>
    END

    R.NEW(FT.CREDIT.AMOUNT)     = R.FT<FT.DEBIT.AMOUNT>
    R.NEW(FT.DEBIT.CURRENCY)    = R.FT<FT.CREDIT.CURRENCY>
    R.NEW(FT.CREDIT.CURRENCY)   = R.FT<FT.DEBIT.CURRENCY>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.ACC.REF> = R.FT<FT.LOCAL.REF,POS.L.FT.AZ.ACC.REF>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.ORG.DEPST>  = R.FT<FT.LOCAL.REF,POS.L.FT.ORG.DEPST>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.TXN.REF> = Y.FT.ID
    R.NEW(FT.LOCAL.REF)<1,POS.BENEFIC.NAME>    = R.FT<FT.LOCAL.REF,POS.BENEFIC.NAME>
    R.NEW(FT.CREDIT.THEIR.REF)                 = R.FT<FT.CREDIT.THEIR.REF>
    R.NEW(FT.PAYMENT.DETAILS)                  = R.FT<FT.PAYMENT.DETAILS>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.CONCEPT>    = R.FT<FT.LOCAL.REF,POS.L.FT.CONCEPT>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.ADD.INFO>   = R.FT<FT.LOCAL.REF,POS.L.FT.ADD.INFO>

RETURN
END
