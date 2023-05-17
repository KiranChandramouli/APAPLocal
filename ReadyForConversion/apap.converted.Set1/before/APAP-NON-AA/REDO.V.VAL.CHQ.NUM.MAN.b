*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.CHQ.NUM.MAN
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SHANKAR RAJU
*Program   Name    :REDO.V.VAL.CHQ.NUM.MAN
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a validation routine to check if the account is a of Savings/Current account category
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference                    Description
* 17-MAY-2011       SHANKAR RAJU  ODR-2010-01-0081(PACS Issues)   Check if the account is Savings/Current
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CLASS
$INSERT I_F.ACCOUNT.PARAMETER
$INSERT I_F.FUNDS.TRANSFER

  GOSUB INIT
  GOSUB PROCESS

  RETURN
*-------------------------------------------------------------------------------------
INIT:
*~~~~
  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  R.ACCOUNT.CLASS = ''

  FN.ACCOUNT.PARAMETER = 'F.ACCOUNT.PARAMETER'
  F.ACCOUNT.PARAMETER  = ''
  CALL OPF(FN.ACCOUNT.PARAMETER,F.ACCOUNT.PARAMETER)

  RETURN
*-------------------------------------------------------------------------------------
PROCESS:
*~~~~~~~
  Y.ACCOUNT = R.NEW(FT.DEBIT.ACCT.NO)
  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR)
  CATEG.AC = R.ACCOUNT<AC.CATEGORY>

  CALL CACHE.READ(FN.ACCOUNT.PARAMETER,'SYSTEM',R.ACCOUNT.PARAMETER,ERR.AP)
  ALL.CAT.DESC = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.DESC>
  LOCATE 'Current Account Range' IN ALL.CAT.DESC<1,1> SETTING POS.AP THEN
    ST.CAT = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.STR,POS.AP>
    EN.CAT = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.END,POS.AP>
    IF CATEG.AC GE ST.CAT AND CATEG.AC LE EN.CAT THEN
      IF COMI EQ '' THEN
        ETEXT="EB-CHEQUE.NO.MAND"
        CALL STORE.END.ERROR
      END
    END
  END

  RETURN
END
