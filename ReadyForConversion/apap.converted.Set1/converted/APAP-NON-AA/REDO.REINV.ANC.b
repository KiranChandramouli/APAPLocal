SUBROUTINE REDO.REINV.ANC
*-------------------------------------------------------

* DESCRIPTION: This routine is default ANC fields for reversal of FT.


*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 14-Jul-2011     H Ganesh    PACS00072695 - N.11   Initial Draft.


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER


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
    LOC.REF.FIELDS='L.FT.AZ.ACC.REF':@VM:'L.FT.ORG.DEPST':@VM:'L.FT.AZ.TXN.REF'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.FT.AZ.ACC.REF = LOC.REF.POS<1,1>
    POS.L.FT.ORG.DEPST  = LOC.REF.POS<1,2>
    POS.L.FT.AZ.TXN.REF = LOC.REF.POS<1,3>


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
*R.NEW(FT.DEBIT.VALUE.DATE)  = R.FT<FT.CREDIT.VALUE.DATE>
*R.NEW(FT.CREDIT.VALUE.DATE) = TODAY
    R.NEW(FT.CREDIT.AMOUNT)     = R.FT<FT.DEBIT.AMOUNT>

    IF R.FT<FT.CREDIT.VALUE.DATE> NE R.FT<FT.DEBIT.VALUE.DATE> THEN
        R.NEW(FT.DEBIT.VALUE.DATE)  = R.FT<FT.CREDIT.VALUE.DATE>
        R.NEW(FT.CREDIT.VALUE.DATE) = TODAY
    END ELSE
        R.NEW(FT.DEBIT.VALUE.DATE)  = R.FT<FT.CREDIT.VALUE.DATE>
        R.NEW(FT.CREDIT.VALUE.DATE) = R.FT<FT.DEBIT.VALUE.DATE>
    END


    R.NEW(FT.DEBIT.CURRENCY)    = R.FT<FT.CREDIT.CURRENCY>
    R.NEW(FT.CREDIT.CURRENCY)   = R.FT<FT.DEBIT.CURRENCY>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.ACC.REF> = R.FT<FT.LOCAL.REF,POS.L.FT.AZ.ACC.REF>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.ORG.DEPST>  = R.FT<FT.LOCAL.REF,POS.L.FT.ORG.DEPST>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.TXN.REF> = Y.FT.ID


RETURN
END
