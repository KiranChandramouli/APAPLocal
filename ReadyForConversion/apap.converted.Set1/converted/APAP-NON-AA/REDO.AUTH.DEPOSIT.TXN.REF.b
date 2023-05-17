SUBROUTINE REDO.AUTH.DEPOSIT.TXN.REF
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will update TT id to the Deposit account
*--------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 17.04.2012 S.Sudharsanan PACS00190868 Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    LOC.POS = ''
    CALL GET.LOC.REF('AZ.ACCOUNT','L.AZ.REF.NO',LOC.POS)

RETURN
*-------
PROCESS:
*-------
    Y.VALUE= R.NEW(TT.TE.ACCOUNT.2)
    Y.TXN.REF = ID.NEW
    CALL F.READ(FN.AZ.ACCOUNT,Y.VALUE,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
    R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.POS> = Y.TXN.REF
    CALL F.WRITE(FN.AZ.ACCOUNT,Y.VALUE,R.AZ.ACCOUNT)
RETURN

END
