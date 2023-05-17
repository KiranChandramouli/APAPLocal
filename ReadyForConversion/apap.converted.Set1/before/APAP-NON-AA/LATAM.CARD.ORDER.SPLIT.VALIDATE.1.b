*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.ORDER.SPLIT.VALIDATE.1
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.SPLIT.VALIDATE.1
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine called in LATAM.CARD.ORDER.VALIDATE
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 9 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
*11 JUN 2011    KAVITHA                PACS00063138              COMMENTED NAME DEFAULT
*--------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CARD.ISSUE
$INSERT I_F.ACCOUNT
$INSERT I_F.CARD.TYPE
$INSERT I_F.DATES
$INSERT I_F.COMPANY
$INSERT I_GTS.COMMON
$INSERT I_F.CURRENCY

*-------End of core---------------------
$INSERT I_F.LATAM.CARD.ORDER
$INSERT I_F.LATAM.CARD.CLASS.CODE
*-------------------------------------------------



  GOSUB INIT.PROCESS
  GOSUB MAIN.PROCESS


  RETURN
*---------------------------------------------
INIT.PROCESS:

  FN.CARD.TYPE = 'F.CARD.TYPE'
  F.CARD.TYPE = ''
  R.CARD.TYPE = ''
  CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)
  CARD.TYPE.ID = FIELD(ID.NEW,'.',1,1)
  CALL F.READ(FN.CARD.TYPE,CARD.TYPE.ID,R.CARD.TYPE,F.CARD.TYPE,CARD.TYPE.ERR)
  ALLOW.FCY.ACCT = R.CARD.TYPE<CARD.TYPE.ALLOW.FCY.ACCT>

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CCY = 'F.CURRENCY'
  F.CCY = ''
  CALL OPF(FN.CCY,F.CCY)
  CCY.ENRICHMENT = ''

  RETURN
*-------------------------------------------
MAIN.PROCESS:

  ACCOUNT.ID = R.NEW(CARD.IS.ACCOUNT)
  Y.AC.FLAG = 1
  GOSUB ACCOUNT.VAL
  IF Y.AC.FLAG THEN
    R.NEW(CARD.IS.CURRENCY) = R.ACCOUNT<AC.CURRENCY>

    CALL F.READ(FN.CCY,R.ACCOUNT<AC.CURRENCY>,R.CCY,F.CCY,CCY.ERR)
    CCY.ENRICHMENT = R.CCY<EB.CUR.CCY.NAME>

    IF OFS$BROWSER THEN
      OFS$ENRI<CARD.IS.CURRENCY> = CCY.ENRICHMENT
    END
  END


  IF R.NEW(CARD.IS.ISSUE.DATE) EQ '' THEN
    R.NEW(CARD.IS.ISSUE.DATE) = TODAY
  END


  EXPIRY.DATE = R.NEW(CARD.IS.EXPIRY.DATE)
  ISSUE.DATE = R.NEW(CARD.IS.ISSUE.DATE)
  GOSUB EXPIRY.DATE.VAL
  R.NEW(CARD.IS.EXPIRY.DATE) = EXPIRY.DATE


*PIN ISSUE VALIDATION
  ISSUE.DATE = R.NEW(CARD.IS.ISSUE.DATE)
  EXPIRY.DATE = R.NEW(CARD.IS.EXPIRY.DATE)

*CANECELLATION DATE VALIDATION
  ISSUE.DATE = R.NEW(CARD.IS.ISSUE.DATE) ; EXPIRY.DATE = R.NEW(CARD.IS.EXPIRY.DATE)
  CANCELLATION.DATE = R.NEW(CARD.IS.CANCELLATION.DATE)
  GOSUB CANCELLATION.DATE.VAL

  RETURN

*-----EXPIRY DATE--------------------------------------------------------
*
EXPIRY.DATE.VAL:
  IF EXPIRY.DATE='' THEN
    IF R.CARD.TYPE<CARD.TYPE.RENEWAL.DATE>='' THEN
      IF R.CARD.TYPE<CARD.TYPE.RENEWAL.FQU> THEN
        IF ISSUE.DATE THEN
          COMI =ISSUE.DATE:R.CARD.TYPE<CARD.TYPE.RENEWAL.FQU>
          CALL CFQ
          EXPIRY.DATE=COMI[1,8]
        END
      END
    END ELSE
      EXPIRY.DATE=R.CARD.TYPE<CARD.TYPE.RENEWAL.DATE>
    END
  END
  IF EXPIRY.DATE THEN
    IF EXPIRY.DATE LT ISSUE.DATE THEN
      AF = CARD.IS.EXPIRY.DATE
      ETEXT='ST-PIN.ISSUE.DATE.EARLY'
      CALL STORE.END.ERROR
    END
  END ELSE
    AF = CARD.IS.EXPIRY.DATE
    ETEXT='EB-INP.MISS'
    CALL STORE.END.ERROR
  END
  RETURN
*----------------------------------------------------------------
NAME.VAL:
  IF NAME='' THEN

    IF R.NEW(CARD.IS.ACCOUNT) THEN
      ACCOUNT.ID = R.NEW(CARD.IS.ACCOUNT)<1,1>
      CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    END

    NAME=ACCOUNT<AC.SHORT.TITLE>

  END
  RETURN
*--------------------------------------------------------------------
CANCELLATION.DATE.VAL:
  IF CANCELLATION.DATE THEN
    BEGIN CASE
    CASE CANCELLATION.DATE LT ISSUE.DATE
      AF= CARD.IS.CANCELLATION.DATE
      ETEXT = 'ST-PIN.ISSUE.DATE.EARLY'
      CALL STORE.END.ERROR
    CASE CANCELLATION.DATE GT EXPIRY.DATE AND EXPIRY.DATE
      AF = CARD.IS.CANCELLATION.DATE
      ETEXT ='ST-PIN.ISSUE.DATE.LATER'
      CALL STORE.END.ERROR
    END CASE
  END
  RETURN
*
*-----------------------------------------------------------------------
*
ACCOUNT.VAL:
  IF ACCOUNT.ID THEN
    YCUST = ''

    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACC,F.ACCOUNT,Y.AC.ERR)
    YCUST = R.ACC<AC.CUSTOMER>
    IF ETEXT THEN
      Y.AC.FLAG = 0
      AF = CARD.IS.ACCOUNT
      ETEXT = 'EB-AC.NOT.COMP'
      CALL STORE.END.ERROR
      RETURN
    END
    R.ACCOUNT=''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    IF R.CARD.TYPE<CARD.TYPE.CATEGORY> THEN
      LOCATE R.ACCOUNT<AC.CATEGORY> IN R.CARD.TYPE<CARD.TYPE.CATEGORY,1> SETTING V$ ELSE
        Y.AC.FLAG = 0
        AF = CARD.IS.ACCOUNT
        ETEXT = 'EB-AC.CATEG'
        CALL STORE.END.ERROR
      END
      IF R.ACCOUNT<AC.CURRENCY> <> LCCY AND ALLOW.FCY.ACCT[1,1] NE 'Y' THEN
        Y.AC.FLAG = 0
        AF = CARD.IS.ACCOUNT
        ETEXT='EB-AC.LCCY'
        CALL STORE.END.ERROR
      END
    END

  END
  RETURN
*---------------------------------------------------------------------
END
