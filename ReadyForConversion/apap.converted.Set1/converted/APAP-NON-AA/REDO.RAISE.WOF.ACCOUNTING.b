SUBROUTINE REDO.RAISE.WOF.ACCOUNTING(WOF.ID)

*DESCRIPTION:
*------------
* This is the COB routine for CR-43.
*
* This will process the selected IDs from the REDO.WOF.ACCOUNTING file.
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
* 26 Feb 2012    Ravikiran AV              CR.43                 Initial Creation
*
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.AA.INT.CLASSIFICATION
    $INSERT I_F.REDO.WOF.ACCOUNTING
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_REDO.RAISE.WOF.ACCOUNTING.COMMON
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.ACCOUNT

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

    CALL F.READ(FN.REDO.WOF.ACCOUNTING, WOF.ID, R.WOF.ACC.REC, F.REDO.WOF.ACCOUNTING, RET.ERR)

    GOSUB CHECK.FATAL.ERROR

    COMP = FIELD(WOF.ID,'-',5)

    AA.PRODUCT = R.WOF.ACC.REC<REDO.WOF.ACC.PRODUCT>

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

    GOSUB DELETE.WOF.HISTORY    ;* This is to be done coz everytime when a COB is run it should raise new accounting entries for NAB accounting

RETURN
*-------------------------------------------------------------------------------------------------------------------
* Get the DEBIT/CREDIT categories used for the AA.PRODUCT
*
GET.DEBIT.CREDIT.CATEGORY:

    CALL F.READ(FN.REDO.AA.INT.CLASSIFICATION, ID.COMPANY, R.AA.INT.CLASS.REC, F.REDO.AA.INT.CLASSIFICATION, RET.ERR)

    LOCATE AA.PRODUCT IN R.AA.INT.CLASS.REC<REDO.INT.CLASS.PRODUCT,1> SETTING PROD.POS THEN

        DEBIT.CATEGORY = R.AA.INT.CLASS.REC<REDO.INT.CLASS.CREDIT.CATEGORY,PROD.POS>
        CREDIT.CATEGORY = R.AA.INT.CLASS.REC<REDO.INT.CLASS.DEBIT.CATEGORY,PROD.POS>

    END

RETURN
*----------------------------------------------------------------------------------------------------------------------
* Concatenate various fields which are used in framing STMT.ENTRY
*
FORM.RELATED.FIELDS:

    CURRENCY = FIELD(WOF.ID,'-',1)
    SECTOR = FIELD(WOF.ID,'-',2)
    LOAN.STATUS = R.WOF.ACC.REC<REDO.WOF.ACC.LOAN.STATUS>

    DR.TRANS.REF = LOAN.STATUS:'-':CURRENCY:'-':ACC.CATEGORY:'-':SECTOR
    CR.TRANS.REF = LOAN.STATUS:'-':CURRENCY:'-':ACC.CATEGORY:'-':SECTOR

    SEQ.NO = '000':LOAN.STATUS  ;* Sequence number for different loan status

    DR.ACCOUNT.NUMBER = CURRENCY:DEBIT.CATEGORY:SEQ.NO:R.COMPANY(EB.COM.SUB.DIVISION.CODE)
    CR.ACCOUNT.NUMBER = CURRENCY:CREDIT.CATEGORY:SEQ.NO:R.COMPANY(EB.COM.SUB.DIVISION.CODE)

    GOSUB UPDATE.LOAN.STATUS

    AMT = R.WOF.ACC.REC<REDO.WOF.ACC.WOF.AMT>


RETURN
*----------------------------------------------------------------------------------------------------------------------------
* Update loan status in Account
*
UPDATE.LOAN.STATUS:

    CALL F.READ(FN.ACCOUNT, DR.ACCOUNT.NUMBER, DR.ACCOUNT, F.ACCOUNT, RET.ERR)

    IF NOT(RET.ERR) THEN
        DR.ACCOUNT<AC.LOCAL.REF,L.LOAN.STATUS.POS> = LOAN.STATUS
        CALL F.WRITE(FN.ACCOUNT,DR.ACCOUNT.NUMBER,DR.ACCOUNT)
    END

    CALL F.READ(FN.ACCOUNT, CR.ACCOUNT.NUMBER, CR.ACCOUNT, F.ACCOUNT, RET.ERR)

    IF NOT(RET.ERR) THEN
        CR.ACCOUNT<AC.LOCAL.REF,L.LOAN.STATUS.POS> = LOAN.STATUS
        CALL F.WRITE(FN.ACCOUNT,CR.ACCOUNT.NUMBER,CR.ACCOUNT)
    END

RETURN
*--------------------------------------------------------------------------------------------------------------------
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

    CHANGE @FM TO @SM IN R.DR.STMT.ENTRY
    CHANGE @SM TO @VM IN R.DR.STMT.ENTRY

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

    CHANGE @FM TO @SM IN R.CR.STMT.ENTRY
    CHANGE @SM TO @VM IN R.CR.STMT.ENTRY

    R.STMT.ENTRY<-1> = R.CR.STMT.ENTRY

RETURN

*-------------------------------------------------------------------------------------------------------------------------
* Raise Accounting for Consolidated NAB
*
CALL.ACCOUNTING:

    ACC.PRODUCT = 'RAISE.WOF.ACCOUNTING'
    ACC.TYPE = 'SAO'  ;*Automatically overridden when an override conditions

    CALL EB.ACCOUNTING(ACC.PRODUCT,ACC.TYPE,R.STMT.ENTRY,'')  ;* Raise accounting for Consolidated NAB

RETURN
*-------------------------------------------------------------------------------------------------------------------------
* Delete the NAB History file once the Accounting is raised
*
DELETE.WOF.HISTORY:

    CALL F.DELETE(FN.REDO.WOF.ACCOUNTING, WOF.ID)   ;* Delete the file once the ACCOUNTING is raised

RETURN
*---------------------------------------------------------------------------------------------------------------------------
*
*
END
