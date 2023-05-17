*-----------------------------------------------------------------------------
* <Rating>-36</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.IVR.CUENTAEXISTE(R.DATA)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is an Nofile routine to define if an account exists or not for enquiry
* REDO.IVR.CUENTAEXISTE related to C.3 IVR Interface
*
* Input/Output:
*--------------
* IN : LINKED.APPL.ID
* OUT : R.DATA (ALL DATA)
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 14-JUN-2011    RMONDRAGON            ODR-2011-02-0099          FIRST VERSION

*-----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
* </region>
*-----------------------------------------------------------------------------

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN
*
*****
INIT:
*****

  Y.LINKED.APPL.ID = ''
  Y.DATACOUNT = ''
  Y.ARR.REC = ''

  RETURN

*********
OPENFILES:
*********
*Open files ACCOUNT

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

********
PROCESS:
********

  LOCATE "ACCOUNT.NO" IN D.FIELDS<1> SETTING ACCOUNT.NO.POS THEN
    Y.ACCOUNT.NO.ID = D.RANGE.AND.VALUE<ACCOUNT.NO.POS>
    COMI = Y.ACCOUNT.NO.ID
    CALL IN2POSANT(19,'')
    Y.ACCOUNT.NO.ID = COMI
  END

*    Y.SEL.ACCOUNT = "SELECT ":FN.ACCOUNT:" WITH @ID EQ ":Y.ACCOUNT.NO.ID ; * Changed select to read - start
*    CALL EB.READLIST(Y.SEL.ACCOUNT,Y.SEL.ACCOUNT.LIST,'',Y.SEL.ACCOUNT.LIST.NO,ACCOUNT.ERR)
  YR.ACCOUNT = ''; ACCOUNT.ERR = ''
  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO.ID,YR.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

* IF Y.SEL.ACCOUNT.LIST.NO EQ "1" THEN ; * Changed select to read - End
  IF YR.ACCOUNT THEN
    R.DATA<-1> = "T"
    RETURN
  END ELSE
    R.DATA<-1> = "F"
    RETURN
  END

  RETURN

END
