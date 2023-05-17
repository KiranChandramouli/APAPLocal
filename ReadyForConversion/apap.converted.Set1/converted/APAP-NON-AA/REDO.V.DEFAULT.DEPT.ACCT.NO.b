SUBROUTINE REDO.V.DEFAULT.DEPT.ACCT.NO
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to default internal account FT versions
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-08-2011         Bharath G       PACS00100502         Default internal Acct from REDO.ISSUE.DEPT.CODE.
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ISSUE.DEPT.CODE

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----*
INIT:
*----*
    Y.DEPT.ID = COMI

RETURN
*---------*
OPEN.FILES:
*---------*
    FN.REDO.ISSUE.DEPT.CODE ='F.REDO.ISSUE.DEPT.CODE'
    F.REDO.ISSUE.DEPT.CODE = ''
    R.REDO.ISSUE.DEPT.CODE = ''
    CALL OPF(FN.REDO.ISSUE.DEPT.CODE,F.REDO.ISSUE.DEPT.CODE)

RETURN
*-------*
PROCESS:
*-------*
    CALL CACHE.READ(FN.REDO.ISSUE.DEPT.CODE,Y.DEPT.ID,R.REDO.ISSUE.DEPT.CODE,Y.ERR)
    IF R.REDO.ISSUE.DEPT.CODE THEN
        R.NEW(FT.CREDIT.ACCT.NO) =  R.REDO.ISSUE.DEPT.CODE<REDO.IDC.DEPT.ACCT.NO>
    END

RETURN
END
