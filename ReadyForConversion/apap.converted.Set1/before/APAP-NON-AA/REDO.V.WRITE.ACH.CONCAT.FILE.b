*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.WRITE.ACH.CONCAT.FILE
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
* 16-09-2011        Prabhu.N       PACS00125978      Initial Creation

*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ACH.PARTICIPANTS


  GOSUB MAIN.INITIALISE
  GOSUB WRITE.ACH.CONCAT

  RETURN
*****************
MAIN.INITIALISE:
****************

  FN.ACH.PART = 'F.REDO.ACH.PARTICIPANTS'
  F.ACH.PART = ''
  CALL OPF(FN.ACH.PART,F.ACH.PART)

  FN.REDO.ACH.WRK = 'F.REDO.ACH.STORE.BANK.ID'
  F.REDO.ACH.WRK = ''
  CALL OPF(FN.REDO.ACH.WRK,F.REDO.ACH.WRK)
  ID.TABLE = ''
  INST.NAME = ''

  RETURN

*******************
WRITE.ACH.CONCAT:
*******************

  ID.TABLE = ID.NEW

  INST.NAME = R.NEW(REDO.ACH.PARTI.INSTITUTION)

  CHANGE ' ' TO '' IN INST.NAME

  CALL F.WRITE(FN.REDO.ACH.WRK,INST.NAME,ID.TABLE)
  RETURN

END
