*-----------------------------------------------------------------------------
* <Rating>159</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE AT.CALC.CREDIT.ACCT.NO(INCOMING,CREDIT.ACCT.NO)
*-------------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.ATM.BRANCH
  $INSERT I_F.ATM.BIN.ACCT
  $INSERT I_F.ATM.PARAMETER

* INCOMING ----> 2[1,6]*32*41
* 2 - Card No. (only first 6 digits)
* 32 - Acquirer BIN (Money Issuer BIN) - 6 digits
* 41 - ATM terminal id - 8 digits
*

  Y.CARD.BIN.NO = INCOMING[1,6]
  Y.ISSU.BIN.NO = INCOMING[7,6]
  Y.ATM.ID = INCOMING[13,8]
  Y.CCY=INCOMING[21,3]

*----------Modified on 11-05-11 for PACS00054730
  Y.BRANCH.ID = Y.ATM.ID
*----------end of modification-----------------
  Y.BRANCH.ID=TRIM(Y.BRANCH.ID,"0","L")

  Y.BR.ATM.NO = Y.ATM.ID[5,4]

  DEFAULT.BIN = '123123'

  GOSUB OPEN.FILES

  IF Y.ISSU.BIN.NO EQ OUR.BIN THEN
    GOSUB OUR.PROCESS
  END ELSE
    GOSUB OTH.PROCESS
  END

  RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*
  FN.ATM.PARAMETER = 'F.ATM.PARAMETER'
  CALL OPF(FN.ATM.PARAMETER,F.ATM.PARAMETER)

*  CALL F.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,F.ATM.PARAMETER,ER.ATM.PARAMETER) ;*Tus Start 
CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,ER.ATM.PARAMETER) ; * Tus End
  OUR.BIN = R.ATM.PARAMETER<ATM.PARA.BANK.IMD>

  FN.ATM.ISO.BRANCH = 'F.ATM.BRANCH'
  F.ATM.ISO.BRANCH = ''
  CALL OPF(FN.ATM.ISO.BRANCH,F.ATM.ISO.BRANCH)

  FN.ATM.BIN.ACCT = 'F.ATM.BIN.ACCT'
  F.ATM.BIN.ACCT = ''
  CALL OPF(FN.ATM.BIN.ACCT,F.ATM.BIN.ACCT)

  RETURN  ;* open files

*-------------------------------------------------------------------------------
OUR.PROCESS:
*
  CALL F.READ(FN.ATM.ISO.BRANCH,Y.BRANCH.ID,R.ATM.BRANCH,F.ATM.ISO.BRANCH,ER.ATM.BRANCH)

***modified on 19/11/2005 to accomodate HNB Cobas customer
*    IF Y.BRANCH.ID EQ '' THEN
  IF R.ATM.BRANCH EQ '' THEN
    CALL F.READ(FN.ATM.BIN.ACCT,'CWDRL',ABA.REC,F.ATM.BIN.ACCT,ABAERR)
    CREDIT.ACCT.NO = ABA.REC<BIN.PAY.ACCOUNT.NO>
  END ELSE
***end
    IF ER.ATM.BRANCH THEN
      PRINT ('ATM.BRANCH not set up')
    END
    IF R.ATM.BRANCH THEN
      FIND Y.BR.ATM.NO IN R.ATM.BRANCH<ATM.BR.DEVICE.ID> SETTING ATM.FOUND.POSN1,ATM.FOUND.POSN ELSE ATM.FOUND.POSN = ''
      IF ATM.FOUND.POSN THEN
        AC.SUFFX = R.ATM.BRANCH<ATM.BR.DEV.ID.AC.SUFX,ATM.FOUND.POSN>
        CR.ACCT.CATEG = R.ATM.BRANCH<ATM.BR.DEV.ID.CATEG,ATM.FOUND.POSN>
        IF AC.SUFFX THEN
          CREDIT.ACCT.NO = Y.CCY:CR.ACCT.CATEG:AC.SUFFX
        END ELSE
          CREDIT.ACCT.NO =R.ATM.BRANCH<ATM.BR.DEV.ID.INT.ACCT>
        END
      END
    END
  END
  RETURN  ;* from OUR.PROCESS

*-------------------------------------------------------------------------------
OTH.PROCESS:
*
  CALL F.READ(FN.ATM.BIN.ACCT,Y.ISSU.BIN.NO,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)

* for booking all in one acct
  IF NOT(R.ATM.BIN.ACCT) THEN
    CALL F.READ(FN.ATM.BIN.ACCT,DEFAULT.BIN,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)
  END
* end of booking all in one acct

  CREDIT.ACCT.NO = R.ATM.BIN.ACCT<BIN.PAY.ACCOUNT.NO>

  RETURN  ;* from OTH.PROCESS

*-------------------------------------------------------------------------------
