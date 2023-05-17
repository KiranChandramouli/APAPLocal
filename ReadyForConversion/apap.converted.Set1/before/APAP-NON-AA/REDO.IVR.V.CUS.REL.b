*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.IVR.V.CUS.REL
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :RMONDRAGON
*Program   Name    :REDO.IVR.V.CUS.REL
*---------------------------------------------------------------------------------
*DESCRIPTION       :It is the validation routine to validate the ordering customer is
*                   co-holder of debit account.
*
*LINKED WITH       :
*
* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 02-DEC-2014      RMONDRAGON     ODR-2010-08-0031      Initial Creation
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT

  GOSUB INIT
  GOSUB PROCESS

  RETURN

*----
INIT:
*----

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

*-------
PROCESS:
*-------

  Y.VAR.ACC.NO = R.NEW(FT.DEBIT.ACCT.NO)
  Y.CUS.DEBIT = COMI

  IF Y.CUS.DEBIT EQ '' THEN
    RETURN
  END

  CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)
  IF R.ACCOUNT THEN
    GOSUB CHECK.CUS.DEBIT
  END

  IF IF.CUS.REL EQ '' THEN
    ETEXT = 'EB-REDO.CUS.NOT.RELATED'
    R.NEW(FT.ORDERING.CUST) = COMI
    CALL STORE.END.ERROR
    RETURN
  END

  RETURN

*---------------
CHECK.CUS.DEBIT:
*---------------

  CUS.IDS.REL = R.ACCOUNT<AC.JOINT.HOLDER>
  IF.CUS.REL = ''

  IF CUS.IDS.REL NE '' THEN
    Y.TOT.CUS.IDS.REL = DCOUNT(CUS.IDS.REL,VM)
    Y.CNT.CUS.IDS.REL = 1
    LOOP
    WHILE Y.CNT.CUS.IDS.REL LE Y.TOT.CUS.IDS.REL
      Y.CUS.ID  = FIELD(CUS.IDS.REL,VM,Y.CNT.CUS.IDS.REL)
      IF Y.CUS.ID EQ Y.CUS.DEBIT THEN
        IF.CUS.REL = 'Y'
        Y.CNT.CUS.IDS.REL = Y.TOT.CUS.IDS.REL
      END
      Y.CNT.CUS.IDS.REL++
    REPEAT
  END

  RETURN

END
