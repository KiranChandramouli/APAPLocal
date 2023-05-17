SUBROUTINE REDO.E.BLD.ACCT.NAU(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.E.BLD.ACCT.NAU
*-------------------------------------------------------------------------
* Description: This is a Built routine for the application ACCOUNT.
*-------------------------------------------------------------------------
* Linked with   : ENQUIRY>REDO.LIST.ACCT.NAU
* In parameter  : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ENQUIRY
    $INSERT I_F.REDO.ACCT.COMP.EXCE
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPEN.PROCESS
    GOSUB PROCESS
    GOSUB ACCT.EXCEPTION

RETURN

OPEN.PROCESS:
*-----------

    FN.REDO.ACCT.EXCE.RBHP = 'F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP = ''
    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)


RETURN


PROCESS:
*-------
    Y.FILE.NAME = R.ENQ<ENQ.FILE.NAME>

    Y.FILE.NAME = FIELD(Y.FILE.NAME,'$',1)

    R.REDO.ACCT.EXCE.RBHP = ''
    CURRNT.COMP = ID.COMPANY
    Y.ID = Y.FILE.NAME:'-':CURRNT.COMP
    Y.FINAL.DATA = ''
    CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,Y.ID,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,ERR.RBHP)
    IF R.REDO.ACCT.EXCE.RBHP THEN
        Y.ACCT.LIST<-1> = R.REDO.ACCT.EXCE.RBHP
    END

RETURN

ACCT.EXCEPTION:
*--------------
    IF Y.ACCT.LIST THEN
        CHANGE @FM TO @SM IN Y.ACCT.LIST
        ENQ.DATA<2>= '@ID'
        ENQ.DATA<3>= 'EQ'
        ENQ.DATA<4>= Y.ACCT.LIST
    END ELSE
        ENQ.ERROR  = 'EB-NO.REC.SELECT'
    END

RETURN

END
