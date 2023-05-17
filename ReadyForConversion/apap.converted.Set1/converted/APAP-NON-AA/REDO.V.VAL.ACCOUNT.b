SUBROUTINE REDO.V.VAL.ACCOUNT
*------------
*DESCRIPTION:
*------------
*This routine is attached as a validation routine to the version TELLER,REDO.CR.CARD.ACCT.TFR
*it will default USD account in ACCOUNT.2if currency is USD and if currency is DOP then it will
*default DOP Account in ACCOUNT.2

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536   Initial Creation

*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER

    IF COMI EQ 'USD' THEN
        R.NEW(TT.TE.ACCOUNT.2)='USD128010002'
    END
    IF COMI EQ 'DOP' THEN
        R.NEW(TT.TE.ACCOUNT.2)='DOP128010002'
    END
RETURN
END
