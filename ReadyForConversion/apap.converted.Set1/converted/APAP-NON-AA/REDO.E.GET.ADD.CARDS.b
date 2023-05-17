SUBROUTINE REDO.E.GET.ADD.CARDS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.TERM.VAL
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to fetch additional cards
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                        Reference                    Description
*   ------          ------                      -------------                -------------
* 22-09-2010        Sakthi Sellappillai         ODR-2010-08-0031 B.187       Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    GOSUB INITIALISE

RETURN
*---------------------------
INITIALISE:
*---------------------------

    IF VC EQ 1 THEN
        FN.CARD.ISSUE.ACCOUNT='F.CARD.ISSUE.ACCOUNT'
        F.CARD.ISSUE.ACCOUNT=''
        CALL OPF(FN.CARD.ISSUE.ACCOUNT,F.CARD.ISSUE.ACCOUNT)

        Y.CURRENT.CARD =System.getVariable("CURRENT.CARD")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.CURRENT.CARD = ""
        END
        Y.ACCOUNT=O.DATA
        CALL F.READ(FN.CARD.ISSUE.ACCOUNT,Y.ACCOUNT,R.CARD.ISSUE,F.CARD.ISSUE.ACCOUNT,ERR)
        LOCATE Y.CURRENT.CARD IN R.CARD.ISSUE SETTING POS THEN
            DEL R.CARD.ISSUE<POS>
        END
        CALL System.setVariable("CURRENT.MUL.FIELD",R.CARD.ISSUE)
        VM.COUNT = DCOUNT(R.CARD.ISSUE,@FM)
        O.DATA = R.CARD.ISSUE<VC>
    END
    ELSE
        Y.SINGLE.VALUE=System.getVariable("CURRENT.MUL.FIELD")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.SINGLE.VALUE = ""
        END
        O.DATA = Y.SINGLE.VALUE<VC>
    END
RETURN
*-------------------------------------------------------------------------------------
END
