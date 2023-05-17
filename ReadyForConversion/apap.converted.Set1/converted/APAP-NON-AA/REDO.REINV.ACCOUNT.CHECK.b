SUBROUTINE REDO.REINV.ACCOUNT.CHECK
*-------------------------------------------------------
* Description: This routine is to restrict the Reinvested
* Interest Liq account from doing the transactions.
*-------------------------------------------------------

* In  Arg : N/A
* Out Arg : N/A

*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO                REFERENCE         DESCRIPTION
* 10 Sep 2011     H Ganesh        PACS00102785 - N.11  INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS
RETURN

*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------

    Y.ACC.ID = COMI
    IF COMI EQ '' THEN
        RETURN
    END
    GOSUB OPEN.FILES

    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>

    IF Y.CATEGORY GE 6011 AND Y.CATEGORY LE 6020 THEN
        ETEXT = 'EB-REDO.REINV.ACC.CHECK'
        CALL STORE.END.ERROR
    END


RETURN
*-------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
END
