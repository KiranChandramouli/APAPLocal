*-----------------------------------------------------------------------------
* <Rating>-157</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RAISE.NAB.ACCOUNTING(NAB.ID)

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will process the selected IDs from the REDO.NAB.ACCOUNTING file.
* This will raise a Consolidated Accounting Entry for NAB Contracts
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
*
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.REDO.AA.INT.CLASSIFICATION
$INSERT I_F.REDO.NAB.ACCOUNTING
$INSERT I_F.STMT.ENTRY
$INSERT I_F.COMPANY
$INSERT I_REDO.RAISE.NAB.ACCOUNTING.COMMON
$INSERT I_F.AA.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.EB.CONTRACT.BALANCES  ;*Tus Start

*------------------------------------------------------------------------------------------------------------------
* Main Logic of the routine
*
MAIN.LOGIC:

  GOSUB READ.NAB.ACCOUNTING.REC

  IF (COMP EQ ID.COMPANY) THEN

    GOSUB PROCESS

  END

  RETURN
*------------------------------------------------------------------------------------------------------------------
* Read the NAB ACCOUNTING file for the CURRENCY-SECTOR
*
READ.NAB.ACCOUNTING.REC:

  CALL F.READ(FN.REDO.NAB.ACCOUNTING, NAB.ID, R.NAB.ACC.REC, F.REDO.NAB.ACCOUNTING, RET.ERR)

  GOSUB CHECK.FATAL.ERROR

  COMP = FIELD(NAB.ID,'-',5)

  AA.PRODUCT = R.NAB.ACC.REC<REDO.NAB.ACC.PRODUCT>

  GOSUB GET.ACCOUNT.CATEGORY

  R.DR.STMT.ENTRY = ''
  R.CR.STMT.ENTRY = ''
  R.STMT.ENTRY = ''

  RETURN
*------------------------------------------------------------------------------------------------------------------
*
*
CHECK.FATAL.ERROR:

  MSG.INFO = ''

  IF (RET.ERR) THEN

    MSG.INFO<1> = 'REDO.RAISE.NAB.ACCOUNTING'
    MSG.INFO<2> = ''
    MSG.INFO<3> = 'REDO.RAISE.NAB.ACCOUNTING'
    MSG.INFO<4> = 'Cannot find record in REDO.NAB.ACCOUNTING'
    MSG.INFO<5> = 'YES'

    CALL FATAL.ERROR(MSG.INFO)

  END

  RETURN
*---------------------------------------------------------------------------------------------------------------------
* Read Account Property for Account category
*
GET.ACCOUNT.CATEGORY:

  TXN.DATE = TODAY
  OUT.PROP.CLASS.LIST = ''
  OUT.PROP.COND = ''

  CALL AA.GET.PRODUCT.CONDITION.RECORDS(AA.PRODUCT,'DOP',TXN.DATE,'',OUT.PROP.CLASS.LIST,'',OUT.PROP.COND,RET.ERR)

  LOCATE 'ACCOUNT' IN OUT.PROP.CLASS.LIST SETTING ACCOUNT.POS THEN

    ACC.CAT.REC = RAISE(OUT.PROP.COND<ACCOUNT.POS>)
    ACC.CATEGORY = ACC.CAT.REC<AA.AC.CATEGORY>

  END

  RETURN
*------------------------------------------------------------------------------------------------------------------
* Processing logic for raising accounting
*
PROCESS:

  GOSUB GET.DEBIT.CREDIT.CATEGORY

  GOSUB FORM.RELATED.FIELDS

  GOSUB FORM.DEBIT.ENTRY

  GOSUB FORM.CREDIT.ENTRY

  GOSUB CALL.ACCOUNTING

  GOSUB DELETE.NAB.HISTORY    ;* This is to be done coz everytime when a COB is run it should raise new accounting entries for NAB accounting

  RETURN
*-------------------------------------------------------------------------------------------------------------------
* Concatenate various fields which are used in framing STMT.ENTRY
*
FORM.RELATED.FIELDS:

  CURRENCY = FIELD(NAB.ID,'-',1)
  SECTOR = FIELD(NAB.ID,'-',2)
  LOAN.STATUS = R.NAB.ACC.REC<REDO.NAB.ACC.LOAN.STATUS>

  SWAP.CATEGORY = CREDIT.CATEGORY       ;* Temporary variable used to swap Dr & Cr Category for reversal entries


  DR.TRANS.REF = LOAN.STATUS:'-':CURRENCY:'-':ACC.CATEGORY:'-':SECTOR
  CR.TRANS.REF = LOAN.STATUS:'-':CURRENCY:'-':ACC.CATEGORY:'-':SECTOR
  SWAP.TRANS.REF = DR.TRANS.REF         ;* Temporary variable used to swap Dr & Cr Transaction Ref for reversal entries

  SEQ.NO = '000':LOAN.STATUS  ;* Sequence number for different loan status

  DR.ACCOUNT.NUMBER = CURRENCY:DEBIT.CATEGORY:SEQ.NO:R.COMPANY(EB.COM.SUB.DIVISION.CODE)
  CR.ACCOUNT.NUMBER = CURRENCY:CREDIT.CATEGORY:SEQ.NO:R.COMPANY(EB.COM.SUB.DIVISION.CODE)
  SWAP.ACCOUNT.NUMBER = CR.ACCOUNT.NUMBER         ;* Temporary variable used to swap Dr & Cr Account Number for reversal entries

* Create Internal Account

  CALL INT.ACC.OPEN(DR.ACCOUNT.NUMBER,RET.CODE)
  CALL INT.ACC.OPEN(CR.ACCOUNT.NUMBER,RET.CODE)

*   GOSUB CHECK.INT.ACC       ;* If the Internal Account already exist Reverse the Working Balance Amt

  GOSUB UPDATE.LOAN.STATUS

  AMT = R.NAB.ACC.REC<REDO.NAB.ACC.NAB.AMT>

* Reassign the Category codes after reversal

  GOSUB GET.DEBIT.CREDIT.CATEGORY

* Reassign the Dr & Cr account number to raise consolidated entry

  DR.ACCOUNT.NUMBER = CURRENCY:DEBIT.CATEGORY:SEQ.NO:R.COMPANY(EB.COM.SUB.DIVISION.CODE)
  CR.ACCOUNT.NUMBER = CURRENCY:CREDIT.CATEGORY:SEQ.NO:R.COMPANY(EB.COM.SUB.DIVISION.CODE)

* Reassign the Dr & Cr Trans Ref after reversal

  DR.TRANS.REF = LOAN.STATUS:'-':CURRENCY:'-':ACC.CATEGORY:'-':SECTOR
  CR.TRANS.REF = LOAN.STATUS:'-':CURRENCY:'-':ACC.CATEGORY:'-':SECTOR

  RETURN
*-------------------------------------------------------------------------------------------------------------------
* Update loan status in Account
*
UPDATE.LOAN.STATUS:

  CALL F.READ(FN.ACCOUNT, DR.ACCOUNT.NUMBER, DR.ACCOUNT, F.ACCOUNT, RET.ERR)

  IF NOT(RET.ERR) THEN
    DR.ACCOUNT<AC.LOCAL.REF,L.LOAN.STATUS.POS> = LOAN.STATUS
    CALL F.WRITE(FN.ACCOUNT,DR.ACCOUNT.NUMBER,DR.ACCOUNT)
  END

  CALL F.READ(FN.ACCOUNT, SWAP.ACCOUNT.NUMBER, CR.ACCOUNT, F.ACCOUNT, RET.ERR)

  IF NOT(RET.ERR) THEN
    CR.ACCOUNT<AC.LOCAL.REF,L.LOAN.STATUS.POS> = LOAN.STATUS
    CALL F.WRITE(FN.ACCOUNT,SWAP.ACCOUNT.NUMBER,CR.ACCOUNT)
  END

  RETURN
*--------------------------------------------------------------------------------------------------------------------
* Get the DEBIT/CREDIT categories used for the AA.PRODUCT
*
GET.DEBIT.CREDIT.CATEGORY:

  CALL F.READ(FN.REDO.AA.INT.CLASSIFICATION, ID.COMPANY, R.AA.INT.CLASS.REC, F.REDO.AA.INT.CLASSIFICATION, RET.ERR)

  LOCATE AA.PRODUCT IN R.AA.INT.CLASS.REC<REDO.INT.CLASS.PRODUCT,1> SETTING PROD.POS THEN

    DEBIT.CATEGORY = R.AA.INT.CLASS.REC<REDO.INT.CLASS.DEBIT.CATEGORY,PROD.POS>
    CREDIT.CATEGORY = R.AA.INT.CLASS.REC<REDO.INT.CLASS.CREDIT.CATEGORY,PROD.POS>

  END

  RETURN
*----------------------------------------------------------------------------------------------------------------------
* If the Internal Account already exist Reverse the Working Balance Amt
*
CHECK.INT.ACC:

  CALL F.READ(FN.ACCOUNT, DR.ACCOUNT.NUMBER, DR.ACCOUNT, F.ACCOUNT, RET.ERR)

  IF NOT(RET.ERR) THEN
*    AMT = (DR.ACCOUNT<AC.WORKING.BALANCE> * -1)  ;*Tus Start 
    CALL EB.READ.HVT ('EB.CONTRACT.BALANCES',DR.ACCOUNT.NUMBER,R.ECB1,ECB.ERR1)
    AMT = (R.ECB1<ECB.WORKING.BALANCE> * -1)  ;* Tus End
    IF (AMT NE 0) THEN
      CR.ACCOUNT.NUMBER = DR.ACCOUNT.NUMBER
      CREDIT.CATEGORY = DEBIT.CATEGORY
      CR.TRANS.REF = DR.TRANS.REF
      GOSUB FORM.CREDIT.ENTRY
    END
    DR.ACCOUNT<AC.LOCAL.REF,L.LOAN.STATUS.POS> = LOAN.STATUS
    CALL F.WRITE(FN.ACCOUNT,DR.ACCOUNT.NUMBER,DR.ACCOUNT)
  END

  CALL F.READ(FN.ACCOUNT, SWAP.ACCOUNT.NUMBER, CR.ACCOUNT, F.ACCOUNT, RET.ERR)

  IF NOT(RET.ERR) THEN
    IF (AMT NE 0) THEN
*    AMT = CR.ACCOUNT<AC.WORKING.BALANCE>  ;*Tus Start 
    CALL EB.READ.HVT ('EB.CONTRACT.BALANCES',SWAP.ACCOUNT.NUMBER,R.ECB2,ECB.ERR2)
    AMT = R.ECB2<ECB.WORKING.BALANCE>  ;* Tus End
      DR.ACCOUNT.NUMBER = SWAP.ACCOUNT.NUMBER
      DEBIT.CATEGORY = SWAP.CATEGORY
      DR.TRANS.REF = SWAP.TRANS.REF
      GOSUB FORM.DEBIT.ENTRY
    END
    CR.ACCOUNT<AC.LOCAL.REF,L.LOAN.STATUS.POS> = LOAN.STATUS
    CALL F.WRITE(FN.ACCOUNT,SWAP.ACCOUNT.NUMBER,CR.ACCOUNT)

    GOSUB CALL.ACCOUNTING
* Clear the STMT.ENTRY Array after raising reversal entries
    R.DR.STMT.ENTRY = ''
    R.CR.STMT.ENTRY = ''
    R.STMT.ENTRY = ''
  END

  RETURN
*----------------------------------------------------------------------------------------------------------------------
* Form the DEBIT stmt entry for the NAB History record
*
FORM.DEBIT.ENTRY:


  R.DR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER> = DR.ACCOUNT.NUMBER
  R.DR.STMT.ENTRY<AC.STE.COMPANY.CODE> = ID.COMPANY
  R.DR.STMT.ENTRY<AC.STE.AMOUNT.LCY> = '-':AMT
  R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = '1'
  R.DR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> = DEBIT.CATEGORY
  R.DR.STMT.ENTRY<AC.STE.VALUE.DATE> = TODAY
  R.DR.STMT.ENTRY<AC.STE.CURRENCY> = CURRENCY
  R.DR.STMT.ENTRY<AC.STE.OUR.REFERENCE> = DR.TRANS.REF
  R.DR.STMT.ENTRY<AC.STE.EXPOSURE.DATE> = TODAY
  R.DR.STMT.ENTRY<AC.STE.CURRENCY.MARKET> = '1'
  R.DR.STMT.ENTRY<AC.STE.TRANS.REFERENCE> = DR.TRANS.REF
  R.DR.STMT.ENTRY<AC.STE.SYSTEM.ID> = 'AC'
  R.DR.STMT.ENTRY<AC.STE.BOOKING.DATE> = TODAY

  CHANGE FM TO SM IN R.DR.STMT.ENTRY
  CHANGE SM TO VM IN R.DR.STMT.ENTRY

  R.STMT.ENTRY<-1> = R.DR.STMT.ENTRY

  RETURN
*-------------------------------------------------------------------------------------------------------------------------
* Form the CREDIT part of the Entry
*
FORM.CREDIT.ENTRY:


  R.CR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER> = CR.ACCOUNT.NUMBER
  R.CR.STMT.ENTRY<AC.STE.COMPANY.CODE> = ID.COMPANY
  R.CR.STMT.ENTRY<AC.STE.AMOUNT.LCY> = AMT
  R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = '1'
  R.CR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> = CREDIT.CATEGORY
  R.CR.STMT.ENTRY<AC.STE.VALUE.DATE> = TODAY
  R.CR.STMT.ENTRY<AC.STE.CURRENCY> = CURRENCY
  R.CR.STMT.ENTRY<AC.STE.OUR.REFERENCE> = CR.TRANS.REF
  R.CR.STMT.ENTRY<AC.STE.EXPOSURE.DATE> = TODAY
  R.CR.STMT.ENTRY<AC.STE.CURRENCY.MARKET> = '1'
  R.CR.STMT.ENTRY<AC.STE.TRANS.REFERENCE> = CR.TRANS.REF
  R.CR.STMT.ENTRY<AC.STE.SYSTEM.ID> = 'AC'
  R.CR.STMT.ENTRY<AC.STE.BOOKING.DATE> = TODAY

  CHANGE FM TO SM IN R.CR.STMT.ENTRY
  CHANGE SM TO VM IN R.CR.STMT.ENTRY

  R.STMT.ENTRY<-1> = R.CR.STMT.ENTRY

  RETURN
*-------------------------------------------------------------------------------------------------------------------------
* Raise Accounting for Consolidated NAB
*
CALL.ACCOUNTING:

  ACC.PRODUCT = 'RAISE.NAB.ACCOUNTING'
  ACC.TYPE = 'SAO'  ;*Automatically overridden when an override conditions

  CALL EB.ACCOUNTING(ACC.PRODUCT,ACC.TYPE,R.STMT.ENTRY,'')  ;* Raise accounting for Consolidated NAB

  RETURN
*-------------------------------------------------------------------------------------------------------------------------
* Delete the NAB History file once the Accounting is raised
*
DELETE.NAB.HISTORY:

  CALL F.DELETE(FN.REDO.NAB.ACCOUNTING, NAB.ID)   ;* Delete the file once the ACCOUNTING is raised

  RETURN
*---------------------------------------------------------------------------------------------------------------------------
*
*
END
