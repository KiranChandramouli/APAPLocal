*-----------------------------------------------------------------------------
* <Rating>-137</Rating>
*-----------------------------------------------------------------------------
*Developed By      : Ramesh,Temenos Application Management
*Development Date  : 15th September 2009
*Program   Name    : EB.ACCOUNTING.WRAPPER
*--------------------------------------------------------------------------------------------------------
*Description       : Validation for EB.ACCOUNTING
*Linked With       :
*In  Parameter     : SYSTEM.ID,TYPE,ENTRY.ARRAY,ACCOUNTING.TYPE
*Out Parameter     : ACCOUTING.ERROR.MESSAGE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE EB.ACCOUNTING.WRAPPER(SYSTEM.ID,TYPE,ENTRY.ARRAY,ACCOUNTING.TYPE,ACCOUTING.ERROR.MESSAGE)

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.ACCOUNT
  $INSERT I_F.FUNDS.TRANSFER
  $INSERT I_F.CURRENCY.MARKET
  $INSERT I_F.TRANSACTION
  $INSERT I_F.STMT.ENTRY
  $INSERT I_F.COMPANY
  $INSERT I_F.CATEGORY
  $INSERT I_F.FUNDS.TRANSFER
  $INSERT I_F.DEPT.ACCT.OFFICER
  $INSERT I_F.EB.SYSTEM.ID
  $INSERT I_F.FX.POS.TYPE
  $INSERT I_F.CURRENCY

  GOSUB OPEN.FILES
  GOSUB INTILIZATION
  GOSUB ENTRY.PROCESSING
  RETURN

OPEN.FILES:
*---------*

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.STATEMENT.ENTRY = 'F.STMT.ENTRY'
  F.STATEMENT.ENTRY = ''
  CALL OPF(FN.STATEMENT.ENTRY,F.STATEMENT.ENTRY)

  FN.COMPANY = 'F.COMPANY'
  F.COMPANY = ''
  CALL OPF(FN.COMPANY,F.COMPANY)

  FN.CATEGORY = 'F.CATEGORY'
  F.CATEGORY = ''
  CALL OPF(FN.CATEGORY,F.CATEGORY)

  FN.CURRENCY.MARKET = 'F.CURRENCY.MARKET'
  F.CURRENCY.MARKET = ''
  CALL OPF(FN.CURRENCY.MARKET,F.CURRENCY.MARKET)

  FN.TRANSACTION  = 'F.TRANSACTION'
  F.TRANSACTION  = ''
  CALL OPF(FN.TRANSACTION,F.TRANSACTION)

  FN.DEPARTMENT.ACCOUNT.OFFICER  = 'F.DEPT.ACCT.OFFICER'
  F.DEPARTMENT.ACCOUNT.OFFICER = ''
  CALL OPF(FN.DEPARTMENT.ACCOUNT.OFFICER,F.DEPARTMENT.ACCOUNT.OFFICER)

  FN.SYSTEM.ID = 'F.EB.SYSTEM.ID'
  F.SYSTEM.ID = ''
  CALL OPF(FN.SYSTEM.ID,F.SYSTEM.ID)

  FN.POSITION.TYPE = 'F.FX.POS.TYPE'
  F.POSITION.TYPE = ''
  CALL OPF(FN.POSITION.TYPE,F.POSITION.TYPE)

  FN.CURRENCY = 'F.CURRENCY'
  F.CURRENCY = ''
  CALL OPF(FN.CURRENCY,F.CURRENCY)

  RETURN

INTILIZATION:
*-----------*

  FT.ENTRY = ENTRY.ARRAY
  T.ENTRY = ''
  FLAG = 0
  ENTRY.COUNTER = 0
  ENTRY.COUNT = 0
  ENTRY.VALUE = 1
  ENTRY.COUNTER  = DCOUNT(FT.ENTRY,@FM)
  TOTAL.AMOUNT = 0
  RETURN


ENTRY.PROCESSING:
*---------------*
*ASSIGNMENT OF VALUES AND CHECK DONE BERFORE PASSING TO EB.ACCOUNTING

  FOR ENTRY.COUNT = ENTRY.VALUE TO ENTRY.COUNTER
    T.ENTRY = RAISE(FT.ENTRY<ENTRY.COUNT>)
    ENTRY.VALUE+ = 1

    ACCOUNT.NO = T.ENTRY<AC.STE.ACCOUNT.NUMBER>
    COMPANY.CODE = T.ENTRY<AC.STE.COMPANY.CODE>
    STE.SYSTEM.ID = T.ENTRY<AC.STE.SYSTEM.ID>
    AMOUNT.LCY = T.ENTRY<AC.STE.AMOUNT.LCY>
    TRANSACTION.NO = T.ENTRY<AC.STE.TRANSACTION.CODE>
    CUSTOMER.NO = T.ENTRY<AC.STE.CUSTOMER.ID>
    CURRENCY.MARKET = T.ENTRY<AC.STE.CURRENCY.MARKET>
    PRODUCT.CATEGORY.NO = T.ENTRY<AC.STE.PRODUCT.CATEGORY>
    ACCOUNT.OFFICER = T.ENTRY<AC.STE.ACCOUNT.OFFICER>
    DEPARTEMENT.CODE = T.ENTRY<AC.STE.DEPARTMENT.CODE>
    CURRENCY = T.ENTRY<AC.STE.CURRENCY>
    BOOK.DATE = T.ENTRY<AC.STE.BOOKING.DATE>
    VALUE.DATE = T.ENTRY<AC.STE.VALUE.DATE>
    EXPOSURE.DATE = T.ENTRY<AC.STE.EXPOSURE.DATE>
    POSITION.TYPE = T.ENTRY<AC.STE.POSITION.TYPE>

    TOTAL.AMOUNT  = TOTAL.AMOUNT + AMOUNT.LCY

    GOSUB PROCESS
  NEXT ENTRY.COUNT

*CHECK FOR AMOUNT IS EQUAL TO NULL
  IF TOTAL.AMOUNT NE '0' THEN
    ACCOUTING.ERROR.MESSAGE  = "PLEASE ENTER A VALID AMOUNT"
    FLAG = 1
  END

*CHECK FOR VALUE V
  IF V EQ ''OR V EQ '0' THEN
    ACCOUTING.ERROR.MESSAGE  = "VALUE V IS EMPTY"
    FLAG = 1
  END

*CHECK FOR ANY ERROR
  IF FLAG EQ '0' THEN
    CALL EB.ACCOUNTING(SYSTEM.ID,TYPE,ENTRY.ARRAY,ACCOUNTING.TYPE)
  END ELSE
    TEXT = ACCOUTING.ERROR.MESSAGE
    CALL FATAL.ERROR(APPLICATION)
  END
  RETURN


PROCESS:
*------*

  GOSUB ACCOUNT.CUSTOMER.SYSTEM.ID.CHECK
  GOSUB COMPANY.CATEGORY.TRANSACTION.POSITION.TYPE.CHECK
  GOSUB CURRENCY.MARKET.DEPARTMENT.OFFICER.CHECK
  GOSUB BOOK.VALUE.EXPOSURE.DATE.CHECK

  RETURN


ACCOUNT.CUSTOMER.SYSTEM.ID.CHECK:
*-------------------------------*
*CHECK FOR VALID ID,ACCOUNT NUMBER,SYSTEM ID,CUSTOMER NUMBER

*CHECK FOR ID IF AVAILABLE
  IF ID.NEW = '' THEN
    ACCOUTING.ERROR.MESSAGE = "ID NOT AVAILABLE"
    FLAG =1
  END

*CHECK FOR VALID SYSTEM.ID IN THE ARGUMENTS PASSED
  EB.SYSTEM.ID = SYSTEM.ID
  GOSUB CHECK.SYSTEM.ID
  IF SYSTEM.ID.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID SYSTEM ID"
    FLAG = 1
  END

*CHECK FOR VALID SYSTEM.ID IN ACCOUNTING ENTRY ARRAY
  EB.SYSTEM.ID = STE.SYSTEM.ID
  GOSUB CHECK.SYSTEM.ID
  IF SYSTEM.ID.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID SYSTEM ID"
    FLAG = 1
  END

*CHECK FOR VALID ACCOUNT NUMBER
  IF ACCOUNT.NO NE '' THEN
    CALL F.READ(FN.ACCOUNT,ACCOUNT.NO,ACCOUNT.RECORD,F.ACCOUNT,ACCOUNT.ERROR)

    IF ACCOUNT.ERROR NE '' THEN
      ACCOUTING.ERROR.MESSAGE  =  "INVALID ACCOUNT NO"
      FLAG = 1
    END
  END

*CHECK FOR VALID CUSTOMER NO
  IF CUSTOMER.NO NE '' THEN
    ACCOUNT.CUSTOMER.NO  = ACCOUNT.RECORD<AC.CUSTOMER>

    IF ACCOUNT.CUSTOMER.NO NE CUSTOMER.NO THEN
      ACCOUTING.ERROR.MESSAGE =  "CUSTOMER NO DOES NOT MATCHES THE ACCOUNT NO"
      FLAG = 1
    END
  END
  RETURN

COMPANY.CATEGORY.TRANSACTION.POSITION.TYPE.CHECK:
*-----------------------------------------------*
*CHECK FOR COMPANY,CATEGORY,TRANSACTION CODE,POSITION TYPE

*CHECK FOR VALID COMPANY CODE
  CALL F.READ(FN.COMPANY,COMPANY.CODE,COMPANY.RECORD,F.COMPANY,COMPANY.ERROR)
  IF COMPANY.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE =  "INVALID COMPANY CODE"
    FLAG = 1
  END

*CHECK FOR VALID CATEGORY
  CALL F.READ(FN.CATEGORY,PRODUCT.CATEGORY.NO,CATEGORY.RECORD,F.CATEGORY,CATEGORY.ERROR)
  IF CATEGORY.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID CATEGORY"
    FLAG = 1
  END

*CHECK FOR VALID TRANSACTION CODE
  CALL F.READ(FN.TRANSACTION,TRANSACTION.NO,TRANSACTION.RECORD,F.TRANSACTION,TRANSACTION.ERROR)
  IF TRANSACTION.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID TRANSACTION CODE"
    FLAG = 1
  END

*CHECK FOR VALID POSITION TYPE
  IF POSITION.TYPE NE '' THEN

    CALL F.READ(FN.POSITION.TYPE,POSITION.TYPE,POSITION.TYPE.RECORD,F.POSITION.TYPE,POSITION.TYPE.ERROR)
    IF POSITION.TYPE.ERROR NE '' THEN
      ACCOUTING.ERROR.MESSAGE = "INVALID POSITION TYPE"
      FLAG = 1
    END
  END
  RETURN

CURRENCY.MARKET.DEPARTMENT.OFFICER.CHECK:
*---------------------------------------*
*CHECK FOR VALID CURRENCY,CURRENCY MARKET,ACCOUNT OFFICER,DEPARTMENT

*CHECK FOR VALID CURRENCY MARKET
  CALL F.READ(FN.CURRENCY.MARKET,CURRENCY.MARKET,CURRENCY.MARKET.RECORD,F.CURRENCY.MARKET,CURRENCY.MARKET.ERROR)
  IF CURRENCY.MARKET.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID CURRENCY MARKET"
    FLAG = 1
  END

*CHECK FOR VALID DEPARTMENT ACCOUNT OFFICER
  DEPARTMENT.ACCOUNT.OFFICER = ACCOUNT.OFFICER
  GOSUB CHECK.DEPARTMENT.ACCOUNT.OFFICER
  IF DEPARTMENT.OFFICER.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID ACCOUNT OFFICER"
    FLAG = 1
  END

*CHECK FOR VALID DEPARTMENT
  DEPARTMENT.ACCOUNT.OFFICER = DEPARTEMENT.CODE
  GOSUB CHECK.DEPARTMENT.ACCOUNT.OFFICER
  IF DEPARTMENT.OFFICER.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID DEPARTMENT NUMBER"
    FLAG = 1
  END

*CHECK FOR VALID CURRENCY
  CALL F.READ(FN.CURRENCY,CURRENCY,CURRENCY.RECORD,F.CURRENCY,CURRENCY.ERROR)
  IF CURRENCY.ERROR NE '' THEN
    ACCOUTING.ERROR.MESSAGE = "INVALID CURRENCY"
    FLAG = 1
  END

  RETURN


BOOK.VALUE.EXPOSURE.DATE.CHECK:
*-----------------------------*
*CHECK FOR VALID BOOK DATE,VALUE DATE AND EXPOSURE DATE

*CHECK FOR VALID BOOK DATE
  CHECK.DATE.VALUE  = BOOK.DATE
  GOSUB CHECK.DATE
  IF DAYTYPE NE 'W' THEN
    ACCOUTING.ERROR.MESSAGE =  "INVALID BOOK DATE"
    FLAG = 1
  END

*CHECK FOR VALID VALUE DATE
  CHECK.DATE.VALUE = VALUE.DATE
  GOSUB CHECK.DATE
  IF DAYTYPE NE 'W' THEN
    ACCOUTING.ERROR.MESSAGE =  "INVALID VALUE DATE"
    FLAG = 1
  END

*CHECK FOR VALID EXPOSURE DATE
  CHECK.DATE.VALUE = EXPOSURE.DATE
  GOSUB CHECK.DATE
  IF DAYTYPE NE 'W' THEN
    ACCOUTING.ERROR.MESSAGE =  "INVALID EXPOSURE DATE"
    FLAG = 1
  END

  RETURN


CHECK.DATE:
*---------*
*CHECK FOR VALID DATE FORMAT,HOLIDAY,WORKING DAY AND UNDEFINED DATE

  IF LEN(CHECK.DATE.VALUE) GT 8 OR LEN(CHECK.DATE.VALUE) LT 8 THEN
    ACCOUTING.ERROR.MESSAGE =  "INVALID DATE LENGTH"
    FLAG = 1
  END ELSE
    CALL AWD("",CHECK.DATE.VALUE,DAYTYPE)
  END

  RETURN

CHECK.SYSTEM.ID:
*--------------*
*READING SYSTEM ID

  CALL F.READ(FN.SYSTEM.ID,EB.SYSTEM.ID,SYSTEM.ID.RECORD,F.SYSTEM.ID,SYSTEM.ID.ERROR)
  RETURN

CHECK.DEPARTMENT.ACCOUNT.OFFICER:
*-------------------------------*
*READING DEPARTMENT ACCOUNT OFFICER

  CALL F.READ(FN.DEPARTMENT.ACCOUNT.OFFICER,DEPARTMENT.ACCOUNT.OFFICER,DEPT.OFFICER.RECORD,F.DEPARTMENT.ACCOUNT.OFFICER,DEPARTMENT.OFFICER.ERROR)
  RETURN

END