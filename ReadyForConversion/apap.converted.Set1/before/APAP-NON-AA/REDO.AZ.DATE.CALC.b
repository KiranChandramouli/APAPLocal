*-----------------------------------------------------------------------------
* <Rating>37</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.DATE.CALC(Y.SELECT.ID)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: MANJU.G
* PROGRAM NAME: REDO.AZ.DATE.CALC
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION:Difference between VALUE.DATE date and opening date of the contract MATURITY.DATE the module AZ

*IN PARAMETER: NA
*OUT PARAMETER: NA
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*25.05.2010  Manju.G     ODR-2011-05-0118      INITIAL CREATION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_REDO.AZ.DATE.CALC.COMMON

  GOSUB PROCESS
  RETURN
PROCESS:
********

  CALL F.READ(FN.AZ.ACCOUNT,Y.SELECT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ERR.AZ)
  Y.VALUE.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
  Y.MATURE.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
  Y.INT.LIQ.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
  Y.CREATE.DATE = R.AZ.ACCOUNT<AZ.CREATE.DATE>
  Y.AZ.REF.NO = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.REF.NO>
  VAR.REF.ID = "AZ-":Y.SELECT.ID
* this condition is added for migrated contract is not updated on creation. but the same is applicable on roll over.
  IF (Y.AZ.REF.NO EQ VAR.REF.ID) AND (Y.CREATE.DATE EQ TODAY) ELSE
    CALL F.READ(FN.ACCOUNT,Y.SELECT.ID,R.ACCOUNT,F.ACCOUNT,ER.ACCOUNT)
    Y.VAL.DATE = R.ACCOUNT<AC.LOCAL.REF,Y.START.DT>
    Y.END.DATE = R.ACCOUNT<AC.LOCAL.REF,Y.END.DT>
* This IF condition is comment to update the account local fields after rollover.
    R.ACCOUNT<AC.LOCAL.REF,Y.START.DT> = Y.VALUE.DATE
    R.ACCOUNT<AC.LOCAL.REF,Y.END.DT> = Y.MATURE.DATE
    CALL F.LIVE.WRITE(FN.ACCOUNT,Y.SELECT.ID,R.ACCOUNT)
    Y.CURR.NO = R.ACCOUNT<AC.CURR.NO>
    Y.ACT.ID = Y.SELECT.ID:';':Y.CURR.NO
    R.ACCOUNT.ACT = TODAY

*    WRITE R.ACCOUNT.ACT ON F.ACCOUNT.ACT,Y.ACT.ID ;*Tus Start 
CALL F.WRITE(FN.ACCOUNT.ACT,Y.ACT.ID,R.ACCOUNT.ACT) ; *Tus End
* This part is used to update to int liq acct and category range is 6013 to 6020 - PACS00330420-S
    IF Y.INT.LIQ.ACCT THEN
      CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.LIQ.ACCOUNT,F.ACCOUNT,ER.ACCOUNT)
      Y.ACCT.CATEGORY = R.LIQ.ACCOUNT<AC.CATEGORY>
      IF R.LIQ.ACCOUNT AND (Y.ACCT.CATEGORY GE 6013 AND Y.ACCT.CATEGORY LE 6020) THEN
        Y.LIQ.CUSTOMER = R.LIQ.ACCOUNT<AC.CUSTOMER>
        IF Y.LIQ.CUSTOMER THEN
          R.LIQ.ACCOUNT<AC.LOCAL.REF,Y.START.DT> = Y.VALUE.DATE
          R.LIQ.ACCOUNT<AC.LOCAL.REF,Y.END.DT> = Y.MATURE.DATE
          CALL F.LIVE.WRITE(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.LIQ.ACCOUNT)
          Y.LIQ.CURR.NO = R.LIQ.ACCOUNT<AC.CURR.NO>
          Y.LIQ.ACT.ID = Y.INT.LIQ.ACCT:';':Y.LIQ.CURR.NO
          R.LIQ.ACCOUNT.ACT = TODAY

*          WRITE R.LIQ.ACCOUNT.ACT ON F.ACCOUNT.ACT,Y.LIQ.ACT.ID ;*Tus Start 
CALL F.WRITE(FN.ACCOUNT.ACT,Y.LIQ.ACT.ID,R.LIQ.ACCOUNT.ACT) ; *Tus End
        END
      END
    END
  END
  RETURN
*-----------------------------------------------------------------
END
