*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ACCT.ID.VALIDATE
*-----------------------------------------------------------------------------
* DESCRIPTION
*-----------
* This is a id routine
*
*-------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -na-
* OUT    : -na-
* Dependencies
* ------------
*
*-------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who               Reference       Description
* 17 OCT 2011         KAVITHA           PACS00142989    Initial Creation
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  R.ACCOUNT = ''


  CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  IF  NOT(R.ACCOUNT) THEN
    E = 'Enter Valid Account Number'

  END

  RETURN
