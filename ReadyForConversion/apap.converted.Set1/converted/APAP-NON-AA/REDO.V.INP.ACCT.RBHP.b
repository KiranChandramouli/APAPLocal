SUBROUTINE REDO.V.INP.ACCT.RBHP
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.V.INP.ACCT.RBHP
*-------------------------------------------------------------------------
* Description: This routine is before Unauth routine for the version ACCOUNT,RBHP
*-------------------------------------------------------------------------
* Linked with   : VERSION>ACCOUNT,RBHP
* In parameter  :
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
    $INSERT I_F.USER
    $INSERT I_F.REDO.ACCT.EXCE.RBHP
    $INSERT I_F.REDO.ACCT.COMP.EXCE

    GOSUB OPEN.PROCESS
    GOSUB PROCESS

RETURN

OPEN.PROCESS:
*-----------



    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.ACCT.EXCE.RBHP='F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP=''

    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

    FN.REDO.ACCT.COMP.EXCE='F.REDO.ACCT.COMP.EXCE'
    F.REDO.ACCT.COMP.EXCE=''

    CALL OPF(FN.REDO.ACCT.COMP.EXCE,F.REDO.ACCT.COMP.EXCE)

    FN.USER='F.USER'
    F.USER=''

    CALL OPF(FN.USER,F.USER)

RETURN

PROCESS:
*-------

    Y.ACCT.NO=ID.NEW
    Y.CO.CODE=R.NEW(AC.CO.CODE)

    GOSUB READ.USER

    IF Y.USER.COMP.CODE NE ID.COMPANY THEN

        GOSUB WRITE.CONCAT

        GOSUB WRITE.COMP.EXCEP

    END

RETURN

WRITE.CONCAT:
*------------

    ERR.EXCE=''
    R.REDO.ACCT.EXCE.RBHP=''

    CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,Y.USER.COMP.CODE,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,ERR.EXCE)

    R.REDO.ACCT.EXCE.RBHP<-1>=Y.ACCT.NO

    CALL F.WRITE(FN.REDO.ACCT.EXCE.RBHP,Y.USER.COMP.CODE,R.REDO.ACCT.EXCE.RBHP)

RETURN

WRITE.COMP.EXCEP:
*---------------

    ERR.EX.COMP=''
    R.REDO.ACCT.COMP.EXCE=''

    CALL F.READ(FN.REDO.ACCT.COMP.EXCE,ID.COMPANY,R.REDO.ACCT.COMP.EXCE,F.REDO.ACCT.COMP.EXCE,ERR.EX.COMP)

    R.REDO.ACCT.COMP.EXCE<-1>=Y.ACCT.NO

    CALL F.WRITE(FN.REDO.ACCT.COMP.EXCE,ID.COMPANY,R.REDO.ACCT.COMP.EXCE)

RETURN


READ.USER:
*---------

    R.OP.USER=''
    ERR.USR=''

    CALL CACHE.READ(FN.USER, OPERATOR, R.OP.USER, ERR.USR)

    Y.USER.COMP.CODE=R.OP.USER<EB.USE.COMPANY.CODE,1>

RETURN


END
