*-----------------------------------------------------------------------------
* <Rating>342</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE AT.ISO.MULTI.CCY.CR.ACCT(ATM.ID,CREDIT.ACCT.NO)
*
*
* Subroutine Type : Subroutine
* Attached to     : INTRF.MAPPING
* Attached as     : ATM Mapping Routine
* Primary Purpose : To form the Credit account with the Incoming ISO Field
*
*
* Incoming:
* ---------
*    ATM.ID - NUMERIC.CURRENCY.CODE - [1,3] OF ATM.ID - ISO FIELD 49
*             BIN.NO - [4,9] OF ATM.ID - ISO FIELD 2[1,6] OR 32
*             ATM.BRANCH - [10,17] OF ATM.ID - ISO FILED 41
*    For Example ATM.ID will be - 84091160100010001
*
* Outgoing:
* ---------
*    CREDIT ACCOUUNT NUMBER
*
* Error Variables:
* ----------------
* ERR.MSG
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 11/07/07 - S.Anitha
* Developed for Acleda bank to accept multi ccy credit account (internal account)
* which is accepted as per the ccy passed in the iso message
* Visa account is implemented for visa card processing
* which can accept multi ccy account as per the ccy passed in iso message
*
*
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ATM.BRANCH
$INSERT I_F.ATM.PARAMETER
$INSERT I_F.ATM.BIN.ACCT
$INSERT I_F.NUMERIC.CURRENCY

*/ISO 8583 ATM interface to find the atm cash account (credit) when atm id
*is passed


  GOSUB OPEN.FILES
  GOSUB BIN.CHECK

  RETURN


*-----------------*
BIN.CHECK:
*-----------------*

  IF BIN.NO NE OUR.BIN THEN
    GOSUB OTH.BNK.PROCESS
  END ELSE
    GOSUB OUR.BNK.PROCESS

  END

  RETURN

*-----------*
OPEN.FILES:
*-----------*

  FN.ATM.PARAMETER = 'F.ATM.PARAMETER'
  CALL OPF(FN.ATM.PARAMETER,F.ATM.PARAMETER)

*  CALL F.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,F.ATM.PARAMETER,ER.ATM.PARAMETER) ;*Tus Start 
CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,ER.ATM.PARAMETER) ; * Tus End

  FN.NUM.CCY = 'F.NUMERIC.CURRENCY'
  CALL OPF(FN.NUM.CCY,F.NUM.CCY)
  CCY.ID=FIELD(ATM.ID,'%',1)

  CALL F.READ(FN.NUM.CCY,CCY.ID,R.NUM.CCY,F.NUM.CCY,ERR.NUM.CCY)
  CCY.CDE=R.NUM.CCY<EB.NCN.CURRENCY.CODE>

  OUR.BIN = R.ATM.PARAMETER<ATM.PARA.BANK.IMD>
  BIN.NO = FIELD(ATM.ID,'%',2)
*
  FN.ATM.BRANCH = 'F.ATM.BRANCH'
  CALL OPF(FN.ATM.BRANCH,F.ATM.BRANCH)

  FN.ATM.BIN.ACCT = 'F.ATM.BIN.ACCT'
  CALL OPF(FN.ATM.BIN.ACCT,F.ATM.BIN.ACCT)
*
  RETURN  ;*Open files

*--------------------------------------------------------------------------*

OUR.BNK.PROCESS:
*----------*

* Branch ID -  ATM.ID[10,4]
* NUMERIC.ID.ATM - ATM.ID[14,4]

  ATM.BR=FIELD(ATM.ID,'%',3)

  IF OUR.BIN THEN
*Modified for PACS00054730--------------------------------------------------------
    CALL F.READ(FN.ATM.BRANCH,ATM.BR,R.ATM.BRANCH,F.ATM.BRANCH,ER.ATM.BRANCH)
*End of Modification--------------------------------------------------------------
    IF ER.ATM.BRANCH THEN

      CALL F.READ(FN.ATM.BRANCH,'HBDF01',R.ATM.BRANCH,F.ATM.BRANCH,ER.ATM.BRANCH)
      IF ER.ATM.BRANCH THEN
        PRINT ('ATM.BRANCH not set up default Account!')
      END ELSE
        AC.SUFFX = R.ATM.BRANCH<ATM.BR.DEV.ID.AC.SUFX,1>
        CR.ACCT.CATEG = R.ATM.BRANCH<ATM.BR.DEV.ID.CATEG,1>
        CR.ACCT=R.ATM.BRANCH<ATM.BR.DEV.ID.INT.ACCT,1>
        IF AC.SUFFX THEN
          IF CCY.CDE NE '' THEN
            CREDIT.ACCT.NO = CCY.CDE:CR.ACCT.CATEG:AC.SUFFX
          END
        END ELSE
          CREDIT.ACCT.NO =CR.ACCT
        END
      END
    END ELSE
      LEN.ATM.ID = LEN(ATM.BR)
      NUMERIC.ID.ATM = ATM.BR[7,2]
      FIND NUMERIC.ID.ATM IN R.ATM.BRANCH<ATM.BR.DEVICE.ID> SETTING ATM.FOUND.POSN1,ATM.FOUND.POSN ELSE ATM.FOUND.POSN = ''
      IF ATM.FOUND.POSN THEN
        AC.SUFFX = R.ATM.BRANCH<ATM.BR.DEV.ID.AC.SUFX,ATM.FOUND.POSN>
        CR.ACCT.CATEG = R.ATM.BRANCH<ATM.BR.DEV.ID.CATEG,ATM.FOUND.POSN>
        CR.ACCT=R.ATM.BRANCH<ATM.BR.DEV.ID.INT.ACCT,ATM.FOUND.POSN>
        IF AC.SUFFX THEN
          IF CCY.CDE NE '' THEN
            CREDIT.ACCT.NO = CCY.CDE:CR.ACCT.CATEG:AC.SUFFX
          END
        END ELSE
          CREDIT.ACCT.NO =CR.ACCT
        END
      END
    END
  END
  RETURN



*----------------*
VISA.PROCESS:
*-----------------*


*  CALL F.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,F.ATM.PARAMETER,ER.ATM.PARAMETER) ;*Tus Start 
CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,ER.ATM.PARAMETER) ; * Tus End
  IF ER.ATM.PARAMETER THEN
    PRINT ('ATM.PARAMETER not set up default acct not found!')
  END ELSE
    AC.SUFFX = R.ATM.PARAMETER<ATM.PARA.NET.IMD.AC.SUFX,POSITION>
    CR.ACCT.CATEG = R.ATM.PARAMETER<ATM.PARA.NET.IMD.CATEG,POSITION>
    IF AC.SUFFX THEN
      IF CCY.CDE NE '' THEN
        CREDIT.ACCT.NO = CCY.CDE:CR.ACCT.CATEG:AC.SUFFX
      END ELSE
        CREDIT.ACCT.NO =R.ATM.PARAMETER<ATM.PARA.NET.IMD.INT.AC,POSITION>
      END
    END
  END
  RETURN

*---------------------------------------------------------------------------*
OTH.BNK.PROCESS:
*--------------*

  CALL F.READ(FN.ATM.BIN.ACCT,BIN.NO,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)

  IF NOT(R.ATM.BIN.ACCT) THEN
    CALL F.READ(FN.ATM.BIN.ACCT,DEFAULT.BIN,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)
  END
  CREDIT.ACCT.NO = R.ATM.BIN.ACCT<BIN.PAY.ACCOUNT.NO>

  RETURN  ;*From oth.bnk.process

*---------------------------------------------------------------------------*
