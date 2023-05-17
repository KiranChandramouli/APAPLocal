SUBROUTINE REDO.GET.CARDS.CNT
************************************************************
*----------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.CUR.ACCT.DET
*                 to get the no of associated card with the account
* Linked with   : Enquiry  REDO.CUR.ACCT.DET as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010  PRABHU N      ODR-2010-08-0031   INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    GOSUB INITIALISE
    GOSUB READ.AND.ASSIGN

RETURN

*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------

    FN.CARD.ISSUE.ACCOUNT='F.CARD.ISSUE.ACCOUNT'
    F.CARD.ISSUE.ACCOUNT=''
    CALL OPF(FN.CARD.ISSUE.ACCOUNT,F.CARD.ISSUE.ACCOUNT)
    Y.ACCOUNT.NO= O.DATA
RETURN


*-----------------------------------------------------------------
READ.AND.ASSIGN:
*-----------------------------------------------------------------

    CALL F.READ(FN.CARD.ISSUE.ACCOUNT,Y.ACCOUNT.NO,R.CARD.ISSUE,F.CARD.ISSUE.ACCOUNT,ERR)
    O.DATA = DCOUNT(R.CARD.ISSUE,@FM)
RETURN
END
