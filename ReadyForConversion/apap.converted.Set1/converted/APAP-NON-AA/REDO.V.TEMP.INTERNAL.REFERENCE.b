SUBROUTINE REDO.V.TEMP.INTERNAL.REFERENCE

*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep S
* Program Name  : REDO.V.INP.INTERNAL.REFERENCE
*-------------------------------------------------------------------------
* Description: This routine is input routine to default
*              DEBIT.THIER.REFERENCE/CREDIT.THEIR.REFERENCE for REDO.FT.TT.TRANSACTION
*-------------------------------------------------------------------------
* Linked with   :
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
* DATE                   Name          ODR / HD REF              DESCRIPTION
* 09-06-2017        Edwin Charles D         R15 Upgrade       Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

PROCESS:
*********

    BEGIN CASE

        CASE APPLICATION EQ "REDO.FT.TT.TRANSACTION"
            IF R.NEW(FT.TN.DEBIT.ACCT.NO) THEN
                Y.ACCT.ID = R.NEW(FT.TN.DEBIT.ACCT.NO)
                GOSUB READ.ACCT
                IF Y.AA.FLAG THEN
                    R.NEW(FT.TN.DEBIT.THEIR.REF) = Y.ACCT.ID
                    RETURN
                END
            END

            IF R.NEW(FT.TN.DEBIT.ACCT.NO) MATCHES "3A..." THEN
                Y.ACCT.ID = R.NEW(FT.TN.CREDIT.ACCT.NO)
                GOSUB READ.ACCT
                IF Y.AA.FLAG THEN
                    R.NEW(FT.TN.CREDIT.THEIR.REF) = Y.ACCT.ID
                    RETURN
                END
            END

    END CASE

RETURN

READ.ACCT:
***********

    R.ACC = ''
    Y.AA.ID = ''
    CALL F.READ(FN.ACCT,Y.ACCT.ID,R.ACC,F.ACCT,ERR.ACC)
    IF R.ACC AND R.ACC<AC.ARRANGEMENT.ID> MATCHES "AA..." THEN
        Y.AA.FLAG = @TRUE
        Y.AA.ID = R.ACC<AC.ARRANGEMENT.ID>
    END
RETURN


INIT:
******

    Y.AA.FLAG = @FALSE
    Y.ACCT.ID = ''

RETURN

OPEN.FILES:
************

    FN.ACCT = 'F.ACCOUNT'
    F.ACCT = ''
    CALL OPF(FN.ACCT,F.ACCT)

RETURN

END
