*-----------------------------------------------------------------------------
* <Rating>10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CRR.VAL.CARD.ACCOUNT
*-----------------------------------------------------------------------------
* Company   Name    : APAP
* Developed By      : GASSALI - Temenos Application Management
* Program Name      : CRR.VAL.CARD.ACCOUNT
*------------------------------------------------------------------------------
* Description       : This is an validation routine which validates the account
*                     numbers attached to LATAM.CARD.ORDER application belongs to
*                     same customer otherwise it throws the error message
* Linked With       : LATAM.CARD.ORDER
*-----------------------------------------------------------------------------
* Revision History :
*-------------------
*  Date            Who             References           Description
* 28-07-2010                    ODR-2010-06-0322      Initial Creation
*-----------------------------------------------------------
* Include Files
*-----------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.LATAM.CARD.ORDER

  TEMP.AF = AF
  TEMP.AV = AV

  GOSUB INITIALISE

  GOSUB PROCESS
  GOSUB RESET
  RETURN

*-----------
INITIALISE:
*-----------

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  ACCOUNTS = R.NEW(CARD.IS.ACCOUNT)
  RETURN

*--------
PROCESS:
*--------

  NO.OF.ACC = DCOUNT(ACCOUNTS,VM)
  FOR ACCOUNT.NO = 1 TO NO.OF.ACC
    ACCOUNT.ID = ACCOUNTS<1,ACCOUNT.NO>

    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
    Y.RELATION = R.ACCOUNT<AC.RELATION.CODE>
    IF R.NEW(CARD.IS.CUSTOMER.NO)<1,1> NE R.ACCOUNT<AC.CUSTOMER> THEN
      IF Y.JOINT.HOLDER EQ R.NEW(CARD.IS.CUSTOMER.NO)<1> AND Y.RELATION EQ '203' THEN
        GOSUB END.PROGRAM
      END ELSE
        IF ACCOUNT.NO EQ NO.OF.ACC THEN
          AF = CARD.IS.ACCOUNT
          AV = ACCOUNT.NO
          ETEXT = 'EB-INVALID.CUST'
          CALL STORE.END.ERROR
        END
      END
    END
    ELSE
      GOSUB END.PROGRAM
    END

  NEXT ACCOUNT.NO
  RETURN

*------
RESET:
*------
  AF = TEMP.AF
  AV = TEMP.AV
  RETURN
END.PROGRAM:
*---------------
END
*-----------------------------------------------------------------------------------------------------
