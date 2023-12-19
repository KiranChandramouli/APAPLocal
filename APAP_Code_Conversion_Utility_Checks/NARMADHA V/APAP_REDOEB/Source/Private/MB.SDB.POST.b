* @ValidationCode : MjotMjAyMjkxNDk5MzpVVEYtODoxNzAyODg1ODAzMDkwOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Dec 2023 13:20:03
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.POST

* Modification History
* CAPL20090831 - A.VINOTH KUMAR - Fixes for the issues HD0921730,HD0931898
* CAPL20090915 - A.VINOTH KUMAR - Fix for the issue HD0935396
* PACS00259762 - Overrides messages duplicated in MB.SDB.POST application.
* PACS00514342 - Removed OGM and Post the OFS through OFS.POST.MESSAGE
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion      TNO to C$T24.SESSION.NO, = to EQ, <> to NE, ++ to +=,REM to DISPLAY.MESSAGE(TEXT, '')
* 13-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
* 15-12-2023      Narmadha V        Manual R22 Conversion      Call Routine format Modified, F.READ to CACHE.READ, F.READU to CACHE.READ
*-----------------------------------------------------------------------------
*    $INCLUDE GLOBUS.BP I_COMMON        ;*/ TUS START
*    $INCLUDE GLOBUS.BP I_EQUATE
*    $INCLUDE GLOBUS.BP I_F.CUSTOMER
*    $INCLUDE GLOBUS.BP I_F.COMPANY
*    $INCLUDE GLOBUS.BP I_F.ACCOUNT
*    $INCLUDE GLOBUS.BP I_F.STANDING.ORDER
*    $INCLUDE GLOBUS.BP I_F.FT.COMMISSION.TYPE
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.POST
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.PARAM
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.TYPE
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.STATUS
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.CHARGES
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.CLOSED
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.ACCESS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.MB.SDB.CLOSED
    $INSERT I_F.MB.SDB.ACCESS        ;*/ TUS END
    $USING EB.OverrideProcessing
    $USING EB.TransactionControl

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOSUB V$EXIT ;* R22 Manual conversion - GOTO to GOSUB
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE

*************************************************************************

* Main Program Loop

    LOOP


* CALL RECORDID.INPUT
        EB.TransactionControl.RecordidInput() ;*Manual R22 Conversion

    UNTIL (MESSAGE EQ 'RET')

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID
            IF V$ERROR THEN
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO to GOSUB
            END ;*R22 Auto conversion

*CALL RECORD.READ
            EB.TransactionControl.RecordRead() ;*Manual R22 Conversion

            IF INDEX('I',V$FUNCTION,1) THEN
                IF R.NEW(SDB.POST.AUTHORISER) NE '' THEN
                    E = 'Record already Authorised. Input not allowed'
                    CALL ERR
                    GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO to GOSUB
                END
            END
            IF MESSAGE EQ 'REPEAT' THEN
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO to GOSUB
            END

            GOSUB CHECK.RECORD

            CALL MATRIX.ALTER

            IF V$ERROR THEN
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO to GOSUB
            END ;*R22 Auto conversion

            LOOP
                GOSUB PROCESS.FIELDS
                GOSUB PROCESS.MESSAGE
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

V$EXIT:
RETURN

PROCESS.FIELDS:

    LOOP
        IF SCREEN.MODE EQ 'MULTI' THEN
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.MULTI.INPUT
            END ELSE
                CALL FIELD.MULTI.DISPLAY
            END
        END ELSE
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.INPUT
            END ELSE
                CALL FIELD.DISPLAY
            END
        END

    WHILE NOT(MESSAGE)
        GOSUB CHECK.FIELDS

        IF T.SEQU NE '' THEN
            T.SEQU<-1> = A + 1
        END ;*R22 Auto conversion

    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

    IF MESSAGE EQ 'DEFAULT' THEN
        MESSAGE = 'ERROR'
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF MESSAGE EQ 'PREVIEW' THEN
        MESSAGE = 'ERROR'
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
            END
        END
    END

    IF MESSAGE EQ 'VAL' THEN
        MESSAGE = ''
        BEGIN CASE
            CASE V$FUNCTION EQ 'D'
                GOSUB CHECK.DELETE
            CASE V$FUNCTION EQ 'R'
                GOSUB CHECK.REVERSAL
            CASE OTHERWISE
                GOSUB CROSS.VALIDATION
                IF NOT(V$ERROR) THEN
                    GOSUB OVERRIDES
                END
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE
        END
        IF NOT(V$ERROR) THEN
*CALL UNAUTH.RECORD.WRITE
            EB.TransactionControl.UnauthRecordWrite() ;*Manual R22 Conversion - Call Routine format Modified
            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE
            END
        END

    END

    IF MESSAGE EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION
        IF NOT(V$ERROR) THEN

            GOSUB BEFORE.AUTH.WRITE
        END

        IF NOT(V$ERROR) THEN

*CALL AUTH.RECORD.WRITE
            EB.TransactionControl.AuthRecordWrite() ;*Manual R22 Conversion - Call Routine Format Modified

            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE
            END
        END ELSE
            TEXT = 'Error encountered. Transaction not completed'
* CALL DISPLAY.MESSAGE(TEXT, '')
            EB.OverrideProcessing.DisplayMessage(TEXT, '');*Manual R22 Conversion - Call Routine Format Modified
        END
    END

RETURN

CHECK.ID:

    V$ERROR = 0
    E = ''

*CALL EB.FORMAT.ID("SDB")
    EB.TransactionControl.FormatId("SDB");*Manual R22 Conversion

    IF E THEN
        V$ERROR = 1
        CALL ERR
    END


RETURN

*************************************************************************

CHECK.RECORD:

    IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'MODIFY' THEN
        IF R.NEW(SDB.POST.CUSTOMER.NO) EQ '' THEN
            T(SDB.POST.JOINT.HOLDER)<3> = 'NOINPUT'
            T(SDB.POST.RELATION.CODE)<3> = 'NOINPUT'
            T(SDB.POST.NO.OF.SIGNERS)<3> = 'NOINPUT'
            T(SDB.POST.CUSTOMER.ACCT)<3> = 'NOINPUT'
        END ELSE
            T(SDB.POST.JOINT.HOLDER)<3> = ''
            T(SDB.POST.RELATION.CODE)<3> = ''
            T(SDB.POST.NO.OF.SIGNERS)<3> = ''
            T(SDB.POST.CUSTOMER.ACCT)<3> = ''
        END
    END

RETURN

*************************************************************************

CHECK.FIELDS:

*CALL MB.SDB.POST.CHECK.FIELDS
    APAP.REDOEB.mbSdbPostCheckFields();*Manual R22 conversion
    IF E THEN
        T.SEQU = "IFLD"
        CALL ERR
    END

RETURN

*************************************************************************

CROSS.VALIDATION:

    V$ERROR = ''
    ETEXT = ''
    TEXT = ''

* CALL MB.SDB.POST.CROSSVAL
    APAP.REDOEB.mbSdbPostCrossval();*Manual R22 conversion
    IF END.ERROR THEN
        A = 1
        LOOP UNTIL T.ETEXT<A> <> "" DO A += 1 ; REPEAT
        T.SEQU = "D"
        T.SEQU<-1> = A
        V$ERROR = 1
        MESSAGE = 'ERROR'
    END

RETURN

*************************************************************************

OVERRIDES:

    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
    CURR.NO = 0     ;*PACS00259762
*CALL STORE.OVERRIDE(CURR.NO)        ;*PACS00259762
    EB.OverrideProcessing.StoreOverride(CURR.NO) ;*Manual R22 Conversion
    IF TEXT EQ "NO" THEN
        V$ERROR = 1
        MESSAGE = "ERROR"

    END

RETURN

*************************************************************************

AUTH.CROSS.VALIDATION:


RETURN

*************************************************************************

CHECK.DELETE:


RETURN

*************************************************************************

CHECK.REVERSAL:


RETURN

*************************************************************************
DELIVERY.PREVIEW:

RETURN

*************************************************************************

BEFORE.UNAU.WRITE:


    IF TEXT EQ "NO" THEN
* CALL TRANSACTION.ABORT
        EB.TransactionControl.TransactionAbort() ;*Manual R22 Conversion - Call Routine Format Modified
        V$ERROR = 1
        MESSAGE = "ERROR"
        RETURN
    END

    IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'VISIT' AND V$FUNCTION EQ 'I' THEN
        IF NOT(R.NEW(SDB.POST.ACCESS.TIME)) THEN
            R.NEW(SDB.POST.ACCESS.TIME) = OCONV(TIME(),'MTS')[1,2]:OCONV(TIME(),'MTS')[4,2]  ;* Don't store the ':' between the HH and MM. Just store the no.
        END ;*R22 Auto conversion
        IF NOT(R.NEW(SDB.POST.ACCESS.DATE)) THEN
            R.NEW(SDB.POST.ACCESS.DATE) = TODAY
        END ;*R22 Auto conversion
    END

RETURN

*************************************************************************

AFTER.UNAU.WRITE:


RETURN

*************************************************************************

AFTER.AUTH.WRITE:


RETURN

*************************************************************************

BEFORE.AUTH.WRITE:

    GOSUB READ.SDB.PARAM

    CUST.ID = R.NEW(SDB.POST.CUSTOMER.NO); R.CUSTOMER = ''; CUST.ERR = ''
    CALL F.READ(FN.CUSTOMER, CUST.ID, R.CUSTOMER, F.CUSTOMER, CUST.ERR)

    GOSUB GET.CUST.GROUP

    OFS.COMPANY = R.NEW(SDB.POST.SDB.COMPANY)
* NSCU20090929 - S
    CUST.ACCT = R.NEW(SDB.POST.CUSTOMER.ACCT)
    R.ACCOUNT = '' ; ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,CUST.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    CUST.ACCT.CURR = R.ACCOUNT<AC.CURRENCY>
* NSCU20090929 - E
    BEGIN CASE
        CASE R.NEW(V-8)[1,3] EQ "INA"

            BEGIN CASE
                CASE R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN'

                    GOSUB READU.SDB.STATUS

                    R.MB.SDB.STATUS = ''
                    R.MB.SDB.STATUS<SDB.STA.STATUS> ='RENTED'
                    R.MB.SDB.STATUS<SDB.STA.CUSTOMER.NO> = R.NEW(SDB.POST.CUSTOMER.NO)
                    R.MB.SDB.STATUS<SDB.STA.JOINT.HOLDER> = R.NEW(SDB.POST.JOINT.HOLDER)
                    R.MB.SDB.STATUS<SDB.STA.RELATION.CODE> = R.NEW(SDB.POST.RELATION.CODE)
                    R.MB.SDB.STATUS<SDB.STA.JOINT.NOTES> = R.NEW(SDB.POST.JOINT.NOTES)
                    R.MB.SDB.STATUS<SDB.STA.KEY.NUMBERS> = R.NEW(SDB.POST.KEY.NUMBERS)

                    R.MB.SDB.STATUS<SDB.STA.OPENING.DATE> = TODAY
                    R.MB.SDB.STATUS<SDB.STA.RENEW.METHOD> = R.NEW(SDB.POST.RENEW.METHOD)
                    R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT> = R.NEW(SDB.POST.CUSTOMER.ACCT)
                    R.MB.SDB.STATUS<SDB.STA.NOTES> = R.NEW(SDB.POST.NOTES)
                    R.MB.SDB.STATUS<SDB.STA.ADD.ACCESS.CUST> = R.NEW(SDB.POST.ADD.ACCESS.CUST)
                    R.MB.SDB.STATUS<SDB.STA.AMORT.Y.N> = R.NEW(SDB.POST.AMORT.Y.N)
                    R.MB.SDB.STATUS<SDB.STA.HOLDER.NAME> = R.NEW(SDB.POST.HOLDER.NAME)
                    R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT> = R.NEW(SDB.POST.PERIODIC.RENT)
                    R.MB.SDB.STATUS<SDB.STA.DISCOUNT.AMT> = R.NEW(SDB.POST.DISCOUNT.AMT)
                    R.MB.SDB.STATUS<SDB.STA.VAT.AMOUNT> = R.NEW(SDB.POST.VAT.AMOUNT)
                    R.MB.SDB.STATUS<SDB.STA.DEPOSIT.AMT> = R.NEW(SDB.POST.DEPOSIT.AMT)
                    R.MB.SDB.STATUS<SDB.STA.INITIAL.OFFER.AMT> = R.NEW(SDB.POST.INITIAL.OFFER.AMT)
                    R.MB.SDB.STATUS<SDB.STA.VAT.OFFER.AMT> = R.NEW(SDB.POST.VAT.OFFER.AMT)
                    R.MB.SDB.STATUS<SDB.STA.OFFER.EXPIRY.DATE> = R.NEW(SDB.POST.OFFER.EXPIRY.DATE)
                    R.MB.SDB.STATUS<SDB.STA.TOTAL.CHARGE.AMT> = R.NEW(SDB.POST.TOTAL.CHARGE.AMT)
                    R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY> = R.NEW(SDB.POST.RENEW.FREQUENCY)
                    IF R.NEW(SDB.POST.PERIODIC.RENT) GT 0 THEN      ;* Newly Included CAPL20090915
                        R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> = R.NEW(SDB.POST.RENEW.FREQUENCY)[1,8]
                    END
                    R.MB.SDB.STATUS<SDB.STA.NO.OF.SIGNERS> = R.NEW(SDB.POST.NO.OF.SIGNERS)
                    R.MB.SDB.STATUS<SDB.STA.NOTES> = R.NEW(SDB.POST.NOTES)

                    IF R.NEW(SDB.POST.COLLECT.NEXT.P) EQ 'YES' THEN
                        R.MB.SDB.STATUS<SDB.STA.RENT.AMT> = R.NEW(SDB.POST.PERIODIC.RENT) + R.NEW(SDB.POST.INITIAL.OFFER.AMT)
                    END ELSE
                        R.MB.SDB.STATUS<SDB.STA.RENT.AMT> = R.NEW(SDB.POST.INITIAL.OFFER.AMT)
                    END
* CAPL20090924 - S
                    IF RENT.ACCT NE RENT.PL THEN
                        R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = 0
                        R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
                    END ELSE
                        R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
                        R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = 0
                    END
* CAPL20090924 -E
                    RENT.VAT.AMT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT> * (VAT.PERCENT/100)
                    CALL EB.ROUND.AMOUNT(LCCY, RENT.VAT.AMT, '2', '')
                    R.MB.SDB.STATUS<SDB.STA.RENT.VAT> = RENT.VAT.AMT

                    CONSOL.DEP.ACCT.VAR = R.MB.SDB.PARAM<SDB.PAR.CONSOL.DEP.ACCT>
                    IF STAFF.FLAG NE 1 THEN
                        IF CONSOL.DEP.ACCT.VAR EQ "NO" AND R.MB.SDB.STATUS<SDB.STA.DEPOSIT.AMT> GT 0 AND R.MB.SDB.PARAM<SDB.PAR.DEP.ACCT.DETAIL> NE '' THEN
                            GOSUB CREATE.ACCOUNT
                            R.MB.SDB.STATUS<SDB.STA.DEPOSIT.ACCT> = OFS.TXN.ID
                        END
                    END

                    IF R.NEW(SDB.POST.RENEW.METHOD) EQ 'AUTO' THEN
                        IF R.NEW(SDB.POST.PERIODIC.RENT) GT 0 THEN
                            GOSUB CREATE.STO
                        END
                        R.MB.SDB.STATUS<SDB.STA.STO.REF> = OFS.TXN.ID
                        IF OFS.ERR.MSG THEN
*   TEXT = OFS.ERR.MSG
*  CALL REM
* V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
                            GOSUB DISP.ERR.MSG
                        END
                    END

                    GOSUB UPDATE.SDB.STATUS

                    IF CONSOL.DEP.ACCT.VAR EQ "NO" THEN
                        DEP.ACCT = R.MB.SDB.STATUS<SDB.STA.DEPOSIT.ACCT>
                    END ELSE
                        DEP.ACCT = DEPOSIT.ACCT
                    END

                    IF STAFF.FLAG EQ 1 THEN
                        IF R.MB.SDB.STATUS<SDB.STA.RENT.AMT> GT 0 THEN
                            DEP.ACCT =  RENT.ACCT
                            CR.AMOUNT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
                            FT.OFS.STR = ''
                            FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.CHG,//':OFS.COMPANY:','
                            FT.OFS.STR = ',TRANSACTION.TYPE::=':DQUOTE(FT.TXN.RENT)
                            FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.ACCT))
                            FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(CUST.ACCT.CURR)
                            FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(CR.AMOUNT)
                            FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(R.NEW(SDB.POST.SDB.NUMBER))
                            FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(ID.NEW)   ;* PACS00514342
*           FT.OFS.STR := ',CREDIT.CURRENCY::=':DQUOTE(LCCY)
                            FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(RENT.ACCT)
*          FT.OFS.STR := ',CREDIT.AMOUNT::=':DQUOTE(CR.AMOUNT)
                            FT.OFS.STR := ',COMMISSION.CODE::="DEBIT PLUS CHARGES"'
                            FT.OFS.STR := ',COMMISSION.TYPE::=':DQUOTE(SDBVAT)
                            SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR
                            GOSUB CALL.OGM
                            IF OFS.ERR.MSG THEN
*    TEXT = OFS.ERR.MSG
*   CALL REM
*  V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
                                GOSUB DISP.ERR.MSG
                            END
                        END
                    END ELSE

                        IF R.NEW(SDB.POST.DEPOSIT.AMT) GT 0 THEN
*  CR.AMOUNT = R.NEW(SDB.POST.DEPOSIT.AMT)
                            FT.OFS.STR = ''
                            FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.CHGS,//':OFS.COMPANY:','
                            FT.OFS.STR = ',TRANSACTION.TYPE::=':DQUOTE(FT.TXN.RENT)
                            FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.ACCT))
                            FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(CUST.ACCT.CURR)
* PACS00193966-S
                            FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(R.NEW(SDB.POST.DEPOSIT.AMT))
* PACS00193966-E
                            FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(R.NEW(SDB.POST.SDB.NUMBER))
                            FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(ID.NEW)   ;* PACS00514342
*    FT.OFS.STR := ',CREDIT.CURRENCY::=':DQUOTE(LCCY)
                            FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(DEP.ACCT)
*   FT.OFS.STR := ',CREDIT.AMOUNT::=':DQUOTE(R.NEW(SDB.POST.DEPOSIT.AMT))
                            FT.OFS.STR := ',COMMISSION.CODE::="DEBIT PLUS CHARGES"'
                            FT.OFS.STR := ',COMMISSION.TYPE::=':DQUOTE(SAFEDEP)
                            COMM.AMOUNT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
                            FT.OFS.STR := ',COMMISSION.AMT::=':DQUOTE(LCCY:COMM.AMOUNT)
                            SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR
                            GOSUB CALL.OGM
                            IF OFS.ERR.MSG THEN
*   TEXT = OFS.ERR.MSG
*  CALL REM
* V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
                                GOSUB DISP.ERR.MSG
                            END
                        END ELSE

                            IF R.MB.SDB.STATUS<SDB.STA.RENT.AMT> GT 0 THEN
                                FT.OFS.STR = ''
                                CR.AMOUNT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
                                FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.CHG,//':OFS.COMPANY:','
                                FT.OFS.STR = ',TRANSACTION.TYPE::=':DQUOTE(FT.TXN.RENT)
                                FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.ACCT))
                                FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(CUST.ACCT.CURR)
                                FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(R.NEW(SDB.POST.SDB.NUMBER))
                                FT.OFS.STR := ',CREDIT.CURRENCY::=':DQUOTE(LCCY);
                                FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(RENT.ACCT)
                                FT.OFS.STR := ',CREDIT.AMOUNT::=':DQUOTE(CR.AMOUNT);
                                FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(ID.NEW)   ;* PACS00514342
                                FT.OFS.STR := ',CHARGES.ACCT.NO::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.ACCT))
                                FT.OFS.STR := ',COMMISSION.CODE::="DEBIT PLUS CHARGES"'
                                FT.OFS.STR := ',COMMISSION.TYPE::=':DQUOTE(SDBVAT)
                                SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR
                                GOSUB CALL.OGM
                                IF OFS.ERR.MSG THEN
* TEXT = OFS.ERR.MSG
*CALL REM
*V$ERROR = 'ERROR'
*GOTO BEF.AUT.EXIT
                                    GOSUB DISP.ERR.MSG
                                END
                            END
                        END
                    END


                    GOSUB READ.SDB.CHARGES

                    R.MB.SDB.CHARGES<SDB.CHG.TXN.REF,-1> = ID.NEW
                    R.MB.SDB.CHARGES<SDB.CHG.PERIODIC.RENT,-1> = R.NEW(SDB.POST.PERIODIC.RENT)
                    R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT,-1> = R.NEW(SDB.POST.DISCOUNT.AMT)
                    R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT,-1> = R.NEW(SDB.POST.VAT.AMOUNT)
                    R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT,-1> = R.NEW(SDB.POST.DEPOSIT.AMT)
                    R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT,-1> = R.NEW(SDB.POST.INITIAL.OFFER.AMT)
                    R.MB.SDB.CHARGES<SDB.CHG.VAT.OFFER.AMT,-1> = R.NEW(SDB.POST.VAT.OFFER.AMT)
                    R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT,-1> = R.NEW(SDB.POST.TOTAL.CHARGE.AMT)
                    R.MB.SDB.CHARGES<SDB.CHG.REFUND.AMT,-1> = 0
*   R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON,-1> = 'Opening Charges, VAT and deposit'
                    R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON,-1> = 'Opening Charges and GST'
                    R.MB.SDB.CHARGES<SDB.CHG.RENT.AMT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
                    R.MB.SDB.CHARGES<SDB.CHG.RENT.VAT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.VAT>
                    GOSUB UPDATE.SDB.CHARGES

                    GOSUB READ.SDB.ACCESS

                    R.MB.SDB.ACCESS<SDB.ACS.TXN.REF,-1> = ID.NEW
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.NAME,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME>
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.DATE,-1> = TODAY
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.TIME,-1> = OCONV(TIME(),'MTS')[1,2]:OCONV(TIME(),'MTS')[4,2]
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.SLIP.NO,-1> = 'Open'

                    GOSUB UPDATE.SDB.ACCESS

                CASE R.NEW(SDB.POST.SDB.OPERATE) EQ 'RESERVE'

                    GOSUB READU.SDB.STATUS
                    R.MB.SDB.STATUS<SDB.STA.STATUS> = 'RESERVED'
                    R.MB.SDB.STATUS<SDB.STA.CUSTOMER.NO> = R.NEW(SDB.POST.CUSTOMER.NO)
                    R.MB.SDB.STATUS<SDB.STA.NOTES> = R.NEW(SDB.POST.NOTES)
                    GOSUB UPDATE.SDB.STATUS

                CASE R.NEW(SDB.POST.SDB.OPERATE) EQ 'MAINTAIN'
                    GOSUB READU.SDB.STATUS
****  R.MB.SDB.STATUS<SDB.STA.STATUS> = 'REPAIR'
                    R.MB.SDB.STATUS<SDB.STA.NOTES> = R.NEW(SDB.POST.NOTES)
                    R.MB.SDB.STATUS<SDB.STA.MAINT.ACTION> = R.NEW(SDB.POST.MAINT.ACTION)
                    R.MB.SDB.STATUS<SDB.STA.KEY.NUMBERS> = R.NEW(SDB.POST.KEY.NUMBERS)

                    GOSUB UPDATE.SDB.STATUS

                CASE R.NEW(SDB.POST.SDB.OPERATE) EQ 'VISIT'
                    GOSUB READ.SDB.ACCESS
                    R.MB.SDB.ACCESS<SDB.ACS.TXN.REF,-1> = ID.NEW
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.NAME,-1> = R.NEW(SDB.POST.ACCESS.NAME)
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.DATE,-1> = R.NEW(SDB.POST.ACCESS.DATE)
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.TIME,-1> = R.NEW(SDB.POST.ACCESS.TIME)
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.SLIP.NO,-1> = R.NEW(SDB.POST.ACCESS.SLIP.NO)

                    GOSUB UPDATE.SDB.ACCESS

                CASE R.NEW(SDB.POST.SDB.OPERATE) EQ 'MODIFY'

                    GOSUB READU.SDB.STATUS
                    CURRENT.STO.REF = R.MB.SDB.STATUS<SDB.STA.STO.REF>
                    CALL F.READ(FN.STANDING.ORDER,CURRENT.STO.REF,R.STANDING.ORDER,F.STANDING.ORDER,STANDING.ORDER.ERR)
                    IF R.STANDING.ORDER THEN
                        CURRENT.AMT.BAL = R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>
                        CURRENT.FREQ = R.STANDING.ORDER<STO.CURRENT.FREQUENCY>
*CAPL20090831 - S - Suppose if incoming frequency is backdated the we can't create the STANDING.ORDER record for the backdated. So we are updating it to next frequency.
                        SAVE.COMI = COMI
                        LOOP
                        WHILE CURRENT.FREQ[1,8] LE TODAY
                            COMI = CURRENT.FREQ
                            CALL CFQ
                            CURRENT.FREQ = COMI
                        REPEAT
                        COMI = SAVE.COMI
*CAPL20090831 - E
                        IF R.NEW(SDB.POST.CUSTOMER.ACCT) AND (R.MB.SDB.STATUS<SDB.STA.RENEW.METHOD> NE R.NEW(SDB.POST.RENEW.METHOD)) THEN
                            IF R.NEW(SDB.POST.RENEW.METHOD) EQ 'MANUAL' THEN
                                GOSUB CANCEL.STO
                            END ;*R22 Auto conversion
                            IF R.NEW(SDB.POST.RENEW.METHOD) EQ 'AUTO' THEN
                                IF R.NEW(SDB.POST.PERIODIC.RENT) GT 0 THEN
                                    GOSUB CREATE.STO
                                    R.MB.SDB.STATUS<SDB.STA.STO.REF> = OFS.TXN.ID
                                END
                            END

                            IF OFS.ERR.MSG THEN
* TEXT = OFS.ERR.MSG
*CALL REM
*V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT

                                GOSUB DISP.ERR.MSG
                            END

                        END

                        IF R.NEW(SDB.POST.CUSTOMER.ACCT) AND R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT> AND R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT> NE R.NEW(SDB.POST.CUSTOMER.ACCT) THEN
                            RENEWAL.DUE.ON = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>

                            R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT> = R.NEW(SDB.POST.CUSTOMER.ACCT)
                            GOSUB CANCEL.STO
                            IF R.NEW(SDB.POST.PERIODIC.RENT) GT 0 THEN
                                GOSUB CREATE.STO
                            END
                            R.MB.SDB.STATUS<SDB.STA.STO.REF> = OFS.TXN.ID

                            IF OFS.ERR.MSG THEN
*    TEXT = OFS.ERR.MSG
* CALL REM
* V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
                                GOSUB DISP.ERR.MSG
                            END

                        END

                        R.MB.SDB.STATUS<SDB.STA.ADD.ACCESS.CUST> = R.NEW(SDB.POST.ADD.ACCESS.CUST)
                        R.MB.SDB.STATUS<SDB.STA.HOLDER.NAME> = R.NEW(SDB.POST.HOLDER.NAME)
                        R.MB.SDB.STATUS<SDB.STA.JOINT.HOLDER> = R.NEW(SDB.POST.JOINT.HOLDER)
                        R.MB.SDB.STATUS<SDB.STA.RELATION.CODE> = R.NEW(SDB.POST.RELATION.CODE)
                        R.MB.SDB.STATUS<SDB.STA.JOINT.NOTES> = R.NEW(SDB.POST.JOINT.NOTES)
                        R.MB.SDB.STATUS<SDB.STA.NO.OF.SIGNERS> = R.NEW(SDB.POST.NO.OF.SIGNERS)
                        R.MB.SDB.STATUS<SDB.STA.KEY.NUMBERS> = R.NEW(SDB.POST.KEY.NUMBERS)
                        R.MB.SDB.STATUS<SDB.STA.MAINT.ACTION> = R.NEW(SDB.POST.MAINT.ACTION)
                        R.MB.SDB.STATUS<SDB.STA.NOTES> = R.NEW(SDB.POST.NOTES)
                        GOSUB UPDATE.SDB.STATUS
                    END
***        CASE R.NEW(SDB.POST.SDB.OPERATE) = 'CLOSE' AND R.NEW(SDB.POST.NOTES) NE ''

***            GOSUB READU.SDB.STATUS

***    IF R.MB.SDB.STATUS<SDB.STA.STATUS> = 'RESERVED' THEN
***        R.NEW(SDB.POST.NOTES) = 'Reservation is cancelled'
***    END

***    IF R.MB.SDB.STATUS<SDB.STA.STATUS> = 'REPAIR' THEN
***        R.NEW(SDB.POST.NOTES) = 'Repair is finished, Box is ready for rent'
***    END

***            R.MB.SDB.STATUS = ''
***            R.MB.SDB.STATUS<SDB.STA.STATUS> = 'AVAILABLE'

***            GOSUB UPDATE.SDB.STATUS

                CASE R.NEW(SDB.POST.SDB.OPERATE) EQ 'CLOSE'

                    CONSOL.DEP.ACCT.VAR = R.MB.SDB.PARAM<SDB.PAR.CONSOL.DEP.ACCT>
                    GOSUB READU.SDB.STATUS

                    IF R.MB.SDB.STATUS<SDB.STA.STO.REF> NE '' THEN
                        GOSUB CANCEL.STO
                        IF OFS.ERR.MSG THEN
*  TEXT = OFS.ERR.MSG
* CALL REM
* V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
                            GOSUB DISP.ERR.MSG
                        END
                    END

                    IF CONSOL.DEP.ACCT.VAR EQ "NO" THEN
                        DEP.ACCT = R.MB.SDB.STATUS<SDB.STA.DEPOSIT.ACCT>
                    END ELSE
                        DEP.ACCT = DEPOSIT.ACCT
                    END

                    IF R.NEW(SDB.POST.DEPOSIT.AMT) GT 0 THEN
                        FT.OFS.STR = ''
                        FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.CHGS.CLOSE,//':OFS.COMPANY:','
                        FT.OFS.STR = ',TRANSACTION.TYPE::=':DQUOTE(FT.TXN.REFUND)
                        FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.ACCT))
                        FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(R.NEW(SDB.POST.SDB.NUMBER))
                        FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(ID.NEW)   ;* PACS00514342
                        FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(LCCY)
                        FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(DEP.ACCT)
                        FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(R.NEW(SDB.POST.DEPOSIT.AMT))
                        FT.OFS.STR := ',ORDERING.BANK::="999999"'
                        SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR
                        GOSUB CALL.OGM
                        IF OFS.ERR.MSG THEN
*   TEXT = OFS.ERR.MSG
*  CALL REM
* V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
                            GOSUB DISP.ERR.MSG
                        END
                    END

                    GOSUB READ.SDB.CHARGES

                    FLAG.SDB.CHARGES = ''
                    IF R.NEW(SDB.POST.DEPOSIT.AMT) GT 0 THEN
                        R.MB.SDB.CHARGES<SDB.CHG.TXN.REF,-1> = ID.NEW
                        R.MB.SDB.CHARGES<SDB.CHG.PERIODIC.RENT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT,-1> = R.NEW(SDB.POST.DEPOSIT.AMT) * -1
                        R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.VAT.OFFER.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.REFUND.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON,-1> = 'Deposit Refunded'
                        R.MB.SDB.CHARGES<SDB.CHG.RENT.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.RENT.VAT,-1> = 0

                        FLAG.SDB.CHARGES = 'YES'
                    END


                    IF R.NEW(SDB.POST.REFUND.METHOD) EQ 'AUTO' AND R.NEW(SDB.POST.REFUND.AMT) GT 0 THEN

                        FT.OFS.STR = ''
                        FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.CHGS.CLOSE,//':OFS.COMPANY:','
                        FT.OFS.STR = ',TRANSACTION.TYPE::=':DQUOTE(FT.TXN.REFUND)
                        FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.ACCT))
                        FT.OFS.STR := ',CREDIT.CURRENCY::=':DQUOTE(CUST.ACCT.CURR)
                        FT.OFS.STR := ',CREDIT.AMOUNT::=':DQUOTE(R.NEW(SDB.POST.REFUND.AMT))
                        FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(R.NEW(SDB.POST.SDB.NUMBER))
                        FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(ID.NEW)   ;* PACS00514342
*                FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(LCCY)
                        FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(RENT.ACCT)
*               FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(R.NEW(SDB.POST.REFUND.AMT))
                        FT.OFS.STR := ',ORDERING.CUST::="999999"'
                        SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR

                        GOSUB CALL.OGM
                        IF OFS.ERR.MSG THEN
*  TEXT = OFS.ERR.MSG
* CALL REM
* V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
                            GOSUB DISP.ERR.MSG
                        END

                        R.MB.SDB.CHARGES<SDB.CHG.TXN.REF,-1> = ID.NEW
                        R.MB.SDB.CHARGES<SDB.CHG.PERIODIC.RENT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.VAT.OFFER.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT,-1> = 0
                        R.MB.SDB.CHARGES<SDB.CHG.REFUND.AMT,-1> = R.NEW(SDB.POST.REFUND.AMT)
                        R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON,-1> = 'Un-amortised amount Refunded'
                        R.MB.SDB.CHARGES<SDB.CHG.RENT.AMT,-1> = R.NEW(SDB.POST.REFUND.AMT) * -1
                        R.MB.SDB.CHARGES<SDB.CHG.RENT.VAT,-1> = 0
                        FLAG.SDB.CHARGES = 'YES'

                        REFUND.VAT.AMT = R.NEW(SDB.POST.REFUND.AMT) * (VAT.PERCENT/100) + 0
                        CALL EB.ROUND.AMOUNT(LCCY, REFUND.VAT.AMT, '2', '')

                        IF REFUND.VAT.AMT GT 0 THEN
                            FT.OFS.STR = ''
                            FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.CHGS.CLOSE,//':OFS.COMPANY:','
                            FT.OFS.STR = ',TRANSACTION.TYPE::=':DQUOTE(FT.TXN.REFUND)
                            FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.ACCT))
                            FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(R.NEW(SDB.POST.SDB.NUMBER))
                            FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(ID.NEW)         ;* PACS00514342
                            FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(LCCY)
                            FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(VAT.ACCT)
                            FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(REFUND.VAT.AMT)
                            FT.OFS.STR := ',ORDERING.CUST::="999999"'
                            SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR
                            GOSUB CALL.OGM
                            IF OFS.ERR.MSG THEN
*   TEXT = OFS.ERR.MSG
*  CALL REM
*  V$ERROR = 'ERROR'
*  GOTO BEF.AUT.EXIT
                                GOSUB DISP.ERR.MSG
                            END

                            R.MB.SDB.CHARGES<SDB.CHG.TXN.REF,-1> = ID.NEW
                            R.MB.SDB.CHARGES<SDB.CHG.PERIODIC.RENT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.VAT.OFFER.AMT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.REFUND.AMT,-1> = REFUND.VAT.AMT
                            R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON,-1> = 'VAT on un-amortised rent refunded'
                            R.MB.SDB.CHARGES<SDB.CHG.RENT.AMT,-1> = 0
                            R.MB.SDB.CHARGES<SDB.CHG.RENT.VAT,-1> = REFUND.VAT.AMT * -1

                        END
                    END

                    IF R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> LT R.NEW(SDB.POST.AMORTISED.AMT) THEN
                        AMORT.AMT = R.NEW(SDB.POST.AMORTISED.AMT) - R.MB.SDB.STATUS<SDB.STA.AMORT.AMT>
                        IF AMORT.AMT GT 0 AND RENT.ACCT NE RENT.PL THEN
                            FT.OFS.STR = ''
                            FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.TRF,//':OFS.COMPANY:','
                            FT.OFS.STR = ',TRANSACTION.TYPE::="AC"'
                            FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(RENT.PL)
                            FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(R.NEW(SDB.POST.SDB.NUMBER))
                            FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(ID.NEW)         ;* PACS00514342
                            FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(LCCY)
                            FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(RENT.ACCT)
                            FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(AMORT.AMT)
                            FT.OFS.STR := ',ORDERING.CUST::="999999"'
                            SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR

                            R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = R.NEW(SDB.POST.AMORTISED.AMT)
                            R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = R.NEW(SDB.POST.NON.AMORT.AMT)

                            GOSUB CALL.OGM
                            IF OFS.ERR.MSG THEN
*   TEXT = OFS.ERR.MSG
*  CALL REM
*  V$ERROR = 'ERROR'
*  GOTO BEF.AUT.EXIT
                                GOSUB DISP.ERR.MSG
                            END
                        END
                    END

                    IF FLAG.SDB.CHARGES THEN
                        GOSUB UPDATE.SDB.CHARGES
                    END

                    GOSUB READ.SDB.ACCESS

                    R.MB.SDB.ACCESS<SDB.ACS.TXN.REF,-1> = ID.NEW
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.NAME,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME>
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.DATE,-1> = TODAY
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.TIME,-1> = OCONV(TIME(),'MTS')[1,2]:OCONV(TIME(),'MTS')[4,2]
                    R.MB.SDB.ACCESS<SDB.ACS.ACCESS.SLIP.NO,-1> = 'Close'
                    GOSUB UPDATE.SDB.ACCESS

                    IF CONSOL.DEP.ACCT.VAR EQ "NO" THEN
                        GOSUB CLOSE.ACCOUNT
                    END

                    ID.CNT = 0 ; NEW.ID = '' ; R.MB.SDB.CLOSED.TEMP = ''; YERR = ''
                    MB.SDB.CLOSED.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER):'.':R.NEW(SDB.POST.CUSTOMER.NO)
                    CALL F.READ(FN.MB.SDB.CLOSED,MB.SDB.CLOSED.ID,R.MB.SDB.CLOSED.TEMP,F.MB.SDB.CLOSED,YERR)

                    LOOP
                    WHILE R.MB.SDB.CLOSED.TEMP
                        R.MB.SDB.CLOSED.TEMP = ''
                        ID.CNT += 1
                        NEW.ID = MB.SDB.CLOSED.ID:'.':ID.CNT
                        CALL F.READ(FN.MB.SDB.CLOSED,NEW.ID,R.MB.SDB.CLOSED.TEMP,F.MB.SDB.CLOSED,YERR)
                    REPEAT

                    IF ID.CNT GT 0 THEN
                        MB.SDB.CLOSED.ID = NEW.ID
                    END ;*R22 Auto conversion

                    GOSUB UPDATE.CLOSED.RECORD
                    R.MB.SDB.CLOSED<SDB.CLO.CLOSED.ON> = TODAY

                    CALL F.WRITE(FN.MB.SDB.CLOSED,MB.SDB.CLOSED.ID,R.MB.SDB.CLOSED)

                    R.MB.SDB.STATUS = ''
                    R.MB.SDB.STATUS<SDB.STA.STATUS> = 'AVAILABLE'
                    GOSUB UPDATE.SDB.STATUS

                    CALL F.DELETE(FN.MB.SDB.CHARGES,MB.SDB.CHARGES.ID)
                    CALL F.DELETE(FN.MB.SDB.ACCESS,MB.SDB.ACCESS.ID)

            END CASE

        CASE R.NEW(V-8)[1,3] EQ "RNA"

    END CASE

BEF.AUT.EXIT:

    IF V$ERROR EQ 'ERROR' THEN
        RELEASE
    END ;*R22 Auto conversion

RETURN

************************************************************************
UPDATE.CLOSED.RECORD:

    R.MB.SDB.CLOSED<SDB.CLO.CUSTOMER.NO> = R.MB.SDB.STATUS<SDB.STA.CUSTOMER.NO>
    R.MB.SDB.CLOSED<SDB.CLO.STATUS> = R.MB.SDB.STATUS<SDB.STA.STATUS>
    R.MB.SDB.CLOSED<SDB.CLO.JOINT.HOLDER> = R.MB.SDB.STATUS<SDB.STA.JOINT.HOLDER>
    R.MB.SDB.CLOSED<SDB.CLO.RELATION.CODE> =  R.MB.SDB.STATUS<SDB.STA.RELATION.CODE>
    R.MB.SDB.CLOSED<SDB.CLO.JOINT.NOTES>  =  R.MB.SDB.STATUS<SDB.STA.JOINT.NOTES>
    R.MB.SDB.CLOSED<SDB.CLO.KEY.NUMBERS> =  R.MB.SDB.STATUS<SDB.STA.KEY.NUMBERS>
    R.MB.SDB.CLOSED<SDB.CLO.OPENING.DATE> =  R.MB.SDB.STATUS<SDB.STA.OPENING.DATE>
    R.MB.SDB.CLOSED<SDB.CLO.RENEW.METHOD> =  R.MB.SDB.STATUS<SDB.STA.RENEW.METHOD>
    R.MB.SDB.CLOSED<SDB.CLO.CUSTOMER.ACCT> =  R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT>
    R.MB.SDB.CLOSED<SDB.CLO.NOTES> =  R.MB.SDB.STATUS<SDB.STA.NOTES>
    R.MB.SDB.CLOSED<SDB.CLO.ADD.ACCESS.CUST> =  R.MB.SDB.STATUS<SDB.STA.ADD.ACCESS.CUST>
    R.MB.SDB.CLOSED<SDB.CLO.RENEWAL.DUE.ON> =  R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
    R.MB.SDB.CLOSED<SDB.CLO.STO.REF> =  R.MB.SDB.STATUS<SDB.STA.STO.REF>
    R.MB.SDB.CLOSED<SDB.CLO.AMORT.Y.N>  =  R.MB.SDB.STATUS<SDB.STA.AMORT.Y.N>
    R.MB.SDB.CLOSED<SDB.CLO.HOLDER.NAME>  =  R.MB.SDB.STATUS<SDB.STA.HOLDER.NAME>
    R.MB.SDB.CLOSED<SDB.CLO.DEPOSIT.ACCT> =  R.MB.SDB.STATUS<SDB.STA.DEPOSIT.ACCT>
    R.MB.SDB.CLOSED<SDB.CLO.LAST.RENEWAL.DATE> =  R.MB.SDB.STATUS<SDB.STA.LAST.RENEWAL.DATE>
    R.MB.SDB.CLOSED<SDB.CLO.PERIODIC.RENT> =  R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT>
    R.MB.SDB.CLOSED<SDB.CLO.DISCOUNT.AMT> =  R.MB.SDB.STATUS<SDB.STA.DISCOUNT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.VAT.AMOUNT> =  R.MB.SDB.STATUS<SDB.STA.VAT.AMOUNT>
    R.MB.SDB.CLOSED<SDB.CLO.DEPOSIT.AMT> =  R.MB.SDB.STATUS<SDB.STA.DEPOSIT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.INITIAL.OFFER.AMT> =  R.MB.SDB.STATUS<SDB.STA.INITIAL.OFFER.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.VAT.OFFER.AMT> =  R.MB.SDB.STATUS<SDB.STA.VAT.OFFER.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.OFFER.EXPIRY.DATE> =  R.MB.SDB.STATUS<SDB.STA.OFFER.EXPIRY.DATE>
    R.MB.SDB.CLOSED<SDB.CLO.TOTAL.CHARGE.AMT> =  R.MB.SDB.STATUS<SDB.STA.TOTAL.CHARGE.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.RENEW.FREQUENCY> =  R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY>
    R.MB.SDB.CLOSED<SDB.CLO.AMORT.AMT> =  R.MB.SDB.STATUS<SDB.STA.AMORT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.UNAMORT.AMT> =  R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.RENT.AMT> =  R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.RENT.VAT> =  R.MB.SDB.STATUS<SDB.STA.RENT.VAT>
    R.MB.SDB.CLOSED<SDB.CLO.MAINT.ACTION> =  R.MB.SDB.STATUS<SDB.STA.MAINT.ACTION>
    R.MB.SDB.CLOSED<SDB.CLO.NO.OF.SIGNERS> =  R.MB.SDB.STATUS<SDB.STA.NO.OF.SIGNERS>

    R.MB.SDB.CLOSED<SDB.CLO.CHG.TXN.REF>  = R.MB.SDB.CHARGES<SDB.CHG.TXN.REF>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.PERIODIC.RENT> = R.MB.SDB.CHARGES<SDB.CHG.PERIODIC.RENT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.DISCOUNT.AMT> = R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.VAT.AMOUNT> = R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.DEPOSIT.AMT> = R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.INITIAL.OFFER.AMT> = R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.VAT.OFFER.AMT> = R.MB.SDB.CHARGES<SDB.CHG.VAT.OFFER.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.TOTAL.CHARGE.AMT> = R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.REFUND.AMT> = R.MB.SDB.CHARGES<SDB.CHG.REFUND.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.PAY.REASON> = R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.RENT.AMT> = R.MB.SDB.CHARGES<SDB.CHG.RENT.AMT>
    R.MB.SDB.CLOSED<SDB.CLO.CHG.RENT.VAT> = R.MB.SDB.CHARGES<SDB.CHG.RENT.VAT>

    R.MB.SDB.CLOSED<SDB.CLO.ACS.TXN.REF> = R.MB.SDB.ACCESS<SDB.ACS.TXN.REF>
    R.MB.SDB.CLOSED<SDB.CLO.ACS.ACCESS.NAME> = R.MB.SDB.ACCESS<SDB.ACS.ACCESS.NAME>
    R.MB.SDB.CLOSED<SDB.CLO.ACS.ACCESS.DATE> = R.MB.SDB.ACCESS<SDB.ACS.ACCESS.DATE>
    R.MB.SDB.CLOSED<SDB.CLO.ACS.ACCESS.TIME> = R.MB.SDB.ACCESS<SDB.ACS.ACCESS.TIME>
    R.MB.SDB.CLOSED<SDB.CLO.ACS.ACCESS.SLIP.NO> = R.MB.SDB.ACCESS<SDB.ACS.ACCESS.SLIP.NO>

RETURN

*************************************************************************
CHECK.FUNCTION:

    IF INDEX('VR',V$FUNCTION,1) THEN
        E = 'EB.RTN.FUNT.NOT.ALLOWED.APP'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN

*************************************************************************
GET.CUST.GROUP:

    CUST.GROUP = ''
    DISCOUNT.FLAT = ''; DISCOUT.PERCENT = ''; STAFF.FLAG = ''

    IF R.NEW(SDB.POST.CUSTOMER.NO) THEN
        APPL.R = ''
        APPL.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)

        APPL.R<SDB.STA.CUSTOMER.NO> = R.NEW(SDB.POST.CUSTOMER.NO)
        APPL.R<SDB.STA.CUSTOMER.ACCT> = R.NEW(SDB.POST.CUSTOMER.ACCT)

        CALL APPL.GRP.CONDITION('MB.SDB.STATUS', APPL.ID, APPL.R, CUST.GROUP)
        LOCATE CUST.GROUP IN STAFF.GROUP<1,1> SETTING POS THEN
* PACS00193966-S
            IF CUST.GROUP NE '' AND STAFF.GROUP NE ''THEN
* PACS00193966-E
                STAFF.FLAG = '1'
            END
        END

        IF CUST.GROUP THEN
            LOCATE CUST.GROUP IN DISC.GROUP<1,1> SETTING POS THEN
                DISCOUNT.FLAT = DISC.FLAT.AMT<1,POS>
                DISCOUNT.PERCENT = DISC.PERCENT<1,POS>
            END
        END

*END

        RETURN

*************************************************************************
INITIALISE:

        FN.COMPANY = 'F.COMPANY'; FP.COMPANY = ''
        CALL OPF(FN.COMPANY, FP.COMPANY)

        FN.STANDING.ORDER = 'F.STANDING.ORDER'
        F.STANDING.ORDER = ''
        CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)

        FN.CUSTOMER = 'F.CUSTOMER'
        F.CUSTOMER = ''
        CALL OPF(FN.CUSTOMER,F.CUSTOMER)

        FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
        CALL OPF(FN.ACCOUNT, F.ACCOUNT)

        FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'
        F.MB.SDB.PARAM = ''
        CALL OPF(FN.MB.SDB.PARAM,F.MB.SDB.PARAM)

        FN.MB.SDB.TYPE = 'F.MB.SDB.TYPE'
        F.MB.SDB.TYPE = ''
        CALL OPF(FN.MB.SDB.TYPE,F.MB.SDB.TYPE)

        FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
        F.MB.SDB.STATUS = ''
        CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

        FN.MB.SDB.STATUS.HIST = 'F.MB.SDB.STATUS$HIS'
        F.MB.SDB.STATUS.HIST = ''
        CALL OPF(FN.MB.SDB.STATUS.HIST, F.MB.SDB.STATUS.HIST)

        FN.MB.SDB.CHARGES = 'F.MB.SDB.CHARGES'
        F.MB.SDB.CHARGES = ''
        CALL OPF(FN.MB.SDB.CHARGES,F.MB.SDB.CHARGES)
        R.MB.SDB.CHARGES = ''

        FN.MB.SDB.ACCESS = 'F.MB.SDB.ACCESS'
        F.MB.SDB.ACCESS = ''
        CALL OPF(FN.MB.SDB.ACCESS,F.MB.SDB.ACCESS)

        FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
        F.FT.COMMISSION.TYPE = ''
        CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

        FN.MB.SDB.CLOSED = 'F.MB.SDB.CLOSED'
        F.MB.SDB.CLOSED = ''
        CALL OPF(FN.MB.SDB.CLOSED,F.MB.SDB.CLOSED)

        IF R.NEW(SDB.POST.SDB.COMPANY) THEN
            MB.SDB.PARAM.ID = R.NEW(SDB.POST.SDB.COMPANY)
        END ELSE
            MB.SDB.PARAM.ID = ID.COMPANY
        END

        R.MB.SDB.PARAM = ''; YERR = ''
*CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,YERR)
        CALL CACHE.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,YERR) ;*Manual R22 Conversion - F.READ to CACHE.READ
        DISC.GROUP = R.MB.SDB.PARAM<SDB.PAR.DISC.GROUP>
        DISC.FLAT.AMT = R.MB.SDB.PARAM<SDB.PAR.DISC.FLAT.AMT>
        DISC.PERCENT = R.MB.SDB.PARAM<SDB.PAR.DISC.PERCENT>
        STAFF.GROUP = R.MB.SDB.PARAM<SDB.PAR.STAFF.GROUP>
        FREQ.TYPE = R.MB.SDB.PARAM<SDB.PAR.FREQ.TYPE>
        VAT.PERCENT = R.MB.SDB.PARAM<SDB.PAR.VAT.PERCENT>
        VAT.ACCT = R.MB.SDB.PARAM<SDB.PAR.VAT.ACCT>
        RENT.PL = 'PL':R.MB.SDB.PARAM<SDB.PAR.RENT.PL>
        RENEW.NOTICE.FREQ = R.MB.SDB.PARAM<SDB.PAR.RENEW.NOTICE.FREQ>
        RENEW.FREQUENCY = R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY>
        SDBVAT = R.MB.SDB.PARAM<SDB.PAR.FT.COMM.1>
        SAFEDEP = R.MB.SDB.PARAM<SDB.PAR.FT.COMM.2>
        FT.TXN.RENT = R.MB.SDB.PARAM<SDB.PAR.FT.TXN.TYPE.RENT>
        FT.TXN.REFUND = R.MB.SDB.PARAM<SDB.PAR.FT.TXN.TYPE.REFUND>
        DEPOSIT.ACCT = R.MB.SDB.PARAM<SDB.PAR.DEPOSIT.ACCT>
        RENT.ACCT = R.MB.SDB.PARAM<SDB.PAR.ADV.RENT.ACCT>
        IF NOT(RENT.ACCT) THEN
            RENT.ACCT = RENT.PL
        END

        SV.COMI = COMI
        IF RENEW.FREQUENCY AND RENEW.FREQUENCY[1,8] LE TODAY THEN

            LOOP UNTIL RENEW.FREQUENCY[1,8] GT TODAY
                COMI = RENEW.FREQUENCY; CALL CFQ
                RENEW.FREQUENCY = COMI
            REPEAT

            R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY> = RENEW.FREQUENCY
            CALL F.WRITE(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM)
        END
        COMI = SV.COMI


        RETURN

*************************************************************************
DEFINE.PARAMETERS:
* SEE 'I_RULES' FOR DESCRIPTIONS *

*CALL MB.SDB.POST.FIELD.DEFINITIONS
        APAP.REDOEB.mbSdbPostFieldDefinitions();*Manual R22 conversion
        RETURN

*************************************************************************

UPDATE.SDB.STATUS:

        R.MB.SDB.STATUS<SDB.STA.CURR.NO> += 1
        XX = ''; XX = OCONV(DATE(),"D-"); XX.TIME = TIMEDATE()
        XX = XX[9,2]:XX[1,2]:XX[4,2]:XX.TIME[1,2]:XX.TIME[4,2]
        R.MB.SDB.STATUS<SDB.STA.DATE.TIME> = XX
        R.MB.SDB.STATUS<SDB.STA.INPUTTER,1> = C$T24.SESSION.NO:'_':OPERATOR
        R.MB.SDB.STATUS<SDB.STA.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR

        MB.SDB.STATUS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
        CALL F.WRITE(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS)

        IF R.MB.SDB.STATUS.HIST THEN
            CALL F.WRITE(FN.MB.SDB.STATUS.HIST,MB.SDB.STATUS.HIST.ID,R.MB.SDB.STATUS.HIST)
        END

        RETURN

READ.SDB.COMPANY:

        COMP.ID = R.NEW(SDB.POST.SDB.COMPANY); R.COMP = ''; COMP.ERR = ''
        CALL CACHE.READ(FN.COMPANY, COMP.ID, R.COMP, COMP.ERR) ;*R22 Auto conversion

        RETURN

UPDATE.SDB.CHARGES:

        MB.SDB.CHARGES.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
        CALL F.WRITE(FN.MB.SDB.CHARGES,MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES)

        RETURN

UPDATE.SDB.ACCESS:

        MB.SDB.ACCESS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
        CALL F.WRITE(FN.MB.SDB.ACCESS,MB.SDB.ACCESS.ID,R.MB.SDB.ACCESS)

        RETURN

CREATE.STO:

        YOFS.COMPANY = OFS.COMPANY
        ACCT.ID = R.NEW(SDB.POST.CUSTOMER.ACCT); ACCT.REC = ''; ACCT.ERR = ''
        CALL F.READ(FN.ACCOUNT, ACCT.ID, ACCT.REC, F.ACCOUNT, ACCT.ERR)
        ACCT.COM.CODE = ACCT.REC<AC.CO.CODE>
        IF ACCT.COM.CODE THEN
            YOFS.COMPANY = ACCT.COM.CODE
        END ;*R22 Auto conversion
        IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'MODIFY' THEN
            STO.END.DATE = ''
            STO.OFS.HEADER = 'STANDING.ORDER,MB.SDB,//':YOFS.COMPANY
            STO.OFS.HEADER := ",":R.NEW(SDB.POST.CUSTOMER.ACCT)
            STO.OFS.STR = ',TYPE::="FI"'
            STO.OFS.STR := ',PAY.METHOD::=':DQUOTE(FT.TXN.RENT)
            STO.OFS.STR := ',CURRENCY::=':DQUOTE(LCCY)
            STO.OFS.STR := ',CURRENT.AMOUNT.BAL::=':DQUOTE(CURRENT.AMT.BAL)
            STO.OFS.STR := ',CURRENT.FREQUENCY::=':DQUOTE(CURRENT.FREQ)
            IF YOFS.COMPANY NE OFS.COMPANY THEN
                STO.OFS.STR := ',CPTY.ACCT.NO::=':DQUOTE(RENT.ACCT):"\":SDB.COMPANY.MNEM
            END ELSE
                STO.OFS.STR := ',CPTY.ACCT.NO::=':DQUOTE(RENT.ACCT)
            END
            STO.OFS.STR := ',COMMISSION.CODE::="DEBIT PLUS CHARGES"'
            STO.OFS.STR := ',COMMISSION.TYPE::=':DQUOTE(SDBVAT)
            STO.OFS.STR := ',DEBIT.THEIR.REF::=':R.NEW(SDB.POST.SDB.NUMBER)
            STO.OFS.STR := ',BEN.REFERENCE::=':R.NEW(SDB.POST.SDB.NUMBER)
            STO.OFS.STR := ',PRINT.ADVICE::="N"'
            STO.OFS.STR := ',FT.ROUTINE::="@MB.SDB.STO.RENEW"'
            SDB.OFS.STR = STO.OFS.HEADER:STO.OFS.STR
            GOSUB CALL.OGM
        END ELSE
            STO.END.DATE = ''
            STO.OFS.HEADER = 'STANDING.ORDER,MB.SDB,//':YOFS.COMPANY
            STO.OFS.HEADER := ",":R.NEW(SDB.POST.CUSTOMER.ACCT)
            STO.OFS.STR = ',TYPE::="FI"'
            STO.OFS.STR := ',PAY.METHOD::=':DQUOTE(FT.TXN.RENT)
            STO.OFS.STR := ',CURRENCY::=':DQUOTE(LCCY)
            STO.OFS.STR := ',CURRENT.AMOUNT.BAL::=':DQUOTE(R.NEW(SDB.POST.PERIODIC.RENT))
            STO.OFS.STR := ',CURRENT.FREQUENCY::=':DQUOTE(R.NEW(SDB.POST.RENEW.FREQUENCY))
            IF YOFS.COMPANY NE OFS.COMPANY THEN
                STO.OFS.STR := ',CPTY.ACCT.NO::=':DQUOTE(RENT.ACCT):"\":SDB.COMPANY.MNEM
            END ELSE
                STO.OFS.STR := ',CPTY.ACCT.NO::=':DQUOTE(RENT.ACCT)
            END
            STO.OFS.STR := ',COMMISSION.CODE::="DEBIT PLUS CHARGES"'
            STO.OFS.STR := ',COMMISSION.TYPE::=':DQUOTE(SDBVAT)
            STO.OFS.STR := ',DEBIT.THEIR.REF::=':R.NEW(SDB.POST.SDB.NUMBER)
            STO.OFS.STR := ',BEN.REFERENCE::=':R.NEW(SDB.POST.SDB.NUMBER)
            STO.OFS.STR := ',PRINT.ADVICE::="N"'
            STO.OFS.STR := ',FT.ROUTINE::="@MB.SDB.STO.RENEW"'
            SDB.OFS.STR = STO.OFS.HEADER:STO.OFS.STR
            GOSUB CALL.OGM
        END

        RETURN

CALL.OGM:
* PACS00514342 -S
*  SV.RUNNING.UNDER.BATCH = RUNNING.UNDER.BATCH
*  RUNNING.UNDER.BATCH = 'YES'
*  SV.ID.COMPANY = ID.COMPANY
*  CALL LOAD.COMPANY(OFS.COMPANY)
* PACS00514342 -E
        OFS.ERR.MSG = ''
        OFS.MSG.ID = ""
        OPTIONS = ""
        CALL OFS.POST.MESSAGE(SDB.OFS.STR,OFS.MSG.ID,SDB.OFS.SOURCE,OPTIONS)
* PACS00514342 -S
* CALL OFS.GLOBUS.MANAGER(SDB.OFS.SOURCE, SDB.OFS.STR)
*  ID.COMPANY = SV.ID.COMPANY
*  CALL LOAD.COMPANY(ID.COMPANY)
*  RUNNING.UNDER.BATCH = SV.RUNNING.UNDER.BATCH
        OFS.TXN.ID = ''; OFS.ERROR = ''; OFS.ERR.MSG = ''
*  OFS.TXN.ID = FIELD(SDB.OFS.STR,'/',1)
*  OFS.ERROR = FIELD(SDB.OFS.STR,'/',3,1)
*  IF OFS.ERROR = '-1' THEN
*      OFS.ERR.MSG = FIELD(SDB.OFS.STR,'/',4)[4,LEN(SDB.OFS.STR)]
*  END
* PACS00514342 -E

        RETURN

READ.SDB.TYPE:

        MB.SDB.TYPE.ID = FIELD(R.NEW(SDB.POST.SDB.NUMBER),'.',1)
        R.MB.SDB.TYPE = ''; YERR = ''
        CALL F.READ(FN.MB.SDB.TYPE,MB.SDB.TYPE.ID,R.MB.SDB.TYPE,F.MB.SDB.TYPE,YERR)

        RETURN

CANCEL.STO:

        STO.OFS.STR = ''
        YOFS.COMPANY = OFS.COMPANY
        ACCT.ID = FIELD(R.MB.SDB.STATUS<SDB.STA.STO.REF>, '.', 1); ACCT.REC = ''; ACCT.ERR = ''
        CALL F.READ(FN.ACCOUNT, ACCT.ID, ACCT.REC, F.ACCOUNT, ACCT.ERR)
        ACCT.COM.CODE = ACCT.REC<AC.CO.CODE>
        IF ACCT.COM.CODE THEN
            YOFS.COMPANY = ACCT.COM.CODE
        END ;*R22 Auto conversion
*CAPL20090831 - S - If the incoming STANDIN.ORDER has the frequency backdated then we cant reverse the STANDING.ORDER diretly.
* So through OFS.POST.MESSAGE we can post 2 operation to do this
        STO.ID = R.MB.SDB.STATUS<SDB.STA.STO.REF>
        R.STANDING.ORDER = ''
        STANDING.ORDER.ERR = ''
        CALL F.READ(FN.STANDING.ORDER,STO.ID,R.STANDING.ORDER,F.STANDING.ORDER,STANDING.ORDER.ERR)
        CUR.FREQ = R.STANDING.ORDER<STO.CURRENT.FREQUENCY>
        IF CUR.FREQ[1,8] LE TODAY THEN
            CURR.END.DATE = TODAY
            IF CURR.END.DATE THEN
                CALL CDT("",CURR.END.DATE,"+1C")
            END
            Y.OFS.MSG = ''
            STO.OFS.HEADER = 'STANDING.ORDER,MB.SDB,//':YOFS.COMPANY:',':R.MB.SDB.STATUS<SDB.STA.STO.REF>
            STO.OFS.STR := ',CURRENT.FREQUENCY::=':DQUOTE(CURR.END.DATE:CUR.FREQ[9,LEN(CUR.FREQ)-8])
            STO.OFS.STR := ',CURRENT.END.DATE::=':DQUOTE(CURR.END.DATE)
            Y.OFS.MSG = STO.OFS.HEADER:STO.OFS.STR
            OFS.MSG.ID = ""
            OPTIONS = ""
            CALL OFS.POST.MESSAGE(Y.OFS.MSG,OFS.MSG.ID,SDB.OFS.SOURCE,OPTIONS)
            STO.OFS.HEADER = 'STANDING.ORDER,MB.SDB/R,//':YOFS.COMPANY:',':R.MB.SDB.STATUS<SDB.STA.STO.REF>
            Y.OFS.MSG = STO.OFS.HEADER
            OFS.ERR.MSG = ''
            OFS.MSG.ID = ""
            OPTIONS = ""
            CALL OFS.POST.MESSAGE(Y.OFS.MSG,OFS.MSG.ID,SDB.OFS.SOURCE,OPTIONS)
        END ELSE
            STO.OFS.HEADER = 'STANDING.ORDER,MB.SDB/R,//':YOFS.COMPANY:',':R.MB.SDB.STATUS<SDB.STA.STO.REF>
            SDB.OFS.STR = STO.OFS.HEADER:STO.OFS.STR
            GOSUB CALL.OGM
        END
*CAPL20090831 - E
        RETURN


READ.SDB.CHARGES:

        MB.SDB.CHARGES.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
        R.MB.SDB.CHARGES = ""; YERR = ''
        RETRY = "P"
        CALL F.READU(FN.MB.SDB.CHARGES, MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES,F.MB.SDB.CHARGES,YERR,RETRY)

        RETURN

READ.SDB.ACCESS:

        MB.SDB.ACCESS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
        R.MB.SDB.ACCESS = ""; YERR = ''
        RETRY = "P"
* CALL F.READU(FN.MB.SDB.ACCESS, MB.SDB.ACCESS.ID,R.MB.SDB.ACCESS,F.MB.SDB.ACCESS,YERR,RETRY)
        CALL CACHE.READ(FN.MB.SDB.ACCESS, MB.SDB.ACCESS.ID,R.MB.SDB.ACCESS,YERR) ;*Manual R22 Conversion - F.READU to CACHE.READ

        RETURN

READ.SDB.PARAM:

        MB.SDB.PARAM.ID = R.NEW(SDB.POST.SDB.COMPANY); R.MB.SDB.PARAM = ''; YERR = ''
        CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,YERR)

        R.COMPANY.REC = ''; COMPANY.REC.ERR = ''
        CALL CACHE.READ(FN.COMPANY, MB.SDB.PARAM.ID, R.COMPANY.REC, COMPANY.REC.ERR) ;*R22 Auto conversion
        SDB.COMPANY.MNEM = R.COMPANY.REC<EB.COM.MNEMONIC>

        DISC.GROUP = R.MB.SDB.PARAM<SDB.PAR.DISC.GROUP>
        DISC.FLAT.AMT = R.MB.SDB.PARAM<SDB.PAR.DISC.FLAT.AMT>
        DISC.PERCENT = R.MB.SDB.PARAM<SDB.PAR.DISC.PERCENT>
        STAFF.GROUP = R.MB.SDB.PARAM<SDB.PAR.STAFF.GROUP>
        FREQ.TYPE = R.MB.SDB.PARAM<SDB.PAR.FREQ.TYPE>
        VAT.PERCENT = R.MB.SDB.PARAM<SDB.PAR.VAT.PERCENT>
        VAT.ACCT = R.MB.SDB.PARAM<SDB.PAR.VAT.ACCT>
        RENT.PL = 'PL':R.MB.SDB.PARAM<SDB.PAR.RENT.PL>
        RENEW.NOTICE.FREQ = R.MB.SDB.PARAM<SDB.PAR.RENEW.NOTICE.FREQ>
        RENEW.FREQUENCY = R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY>
        SDB.OFS.SOURCE = R.MB.SDB.PARAM<SDB.PAR.OFS.SOURCE>
        SDBVAT = R.MB.SDB.PARAM<SDB.PAR.FT.COMM.1>
        SAFEDEP = R.MB.SDB.PARAM<SDB.PAR.FT.COMM.2>
        FT.TXN.RENT = R.MB.SDB.PARAM<SDB.PAR.FT.TXN.TYPE.RENT>
        FT.TXN.REFUND = R.MB.SDB.PARAM<SDB.PAR.FT.TXN.TYPE.REFUND>
        DEPOSIT.ACCT = R.MB.SDB.PARAM<SDB.PAR.DEPOSIT.ACCT>
        RENT.ACCT = R.MB.SDB.PARAM<SDB.PAR.ADV.RENT.ACCT>
* CAPL20090924 - S
        IF NOT(RENT.ACCT) THEN
            RENT.ACCT = RENT.PL
        END
* CAPL20090924 - E
        SV.COMI = COMI
        IF RENEW.FREQUENCY AND RENEW.FREQUENCY[1,8] LE TODAY THEN

            LOOP UNTIL RENEW.FREQUENCY[1,8] GT TODAY
                COMI = RENEW.FREQUENCY; CALL CFQ
                RENEW.FREQUENCY = COMI
            REPEAT

            R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY> = RENEW.FREQUENCY
            CALL F.WRITE(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM)
        END
        COMI = SV.COMI

        RETURN

READ.FT.COMM:

        R.FT.COMMISSION.TYPE = ''; YERR = ''
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ID, R.FT.COMMISSION.TYPE, YERR) ;*R22 Auto conversion

        RETURN

READU.SDB.STATUS:

        MB.SDB.STATUS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
        R.MB.SDB.STATUS = ""; YERR = ''; R.MB.SDB.STATUS.HIST = ''
        RETRY = "P"; MB.SDB.STATUS.HIST.ID = ''
        CALL F.READU(FN.MB.SDB.STATUS, MB.SDB.STATUS.ID,R.MB.SDB.STATUS,F.MB.SDB.STATUS,YERR,RETRY)
        IF R.MB.SDB.STATUS THEN
            R.MB.SDB.STATUS.HIST = R.MB.SDB.STATUS
            MB.SDB.STATUS.HIST.ID = MB.SDB.STATUS.ID:";":R.MB.SDB.STATUS<SDB.STA.CURR.NO>
        END

        RETURN

CREATE.ACCOUNT:

        CUSTOMER.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        LOCKER.NO = R.NEW(SDB.POST.SDB.NUMBER)
        SHORT.TITLE.STR = CUSTOMER.NAME:'-':LOCKER.NO

        AC.OFS.STR = ''
        AC.OFS.HEADER = 'ACCOUNT,MB.SDB.OPEN,//':OFS.COMPANY:','
        AC.OFS.STR = ',CUSTOMER::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.NO))
        AC.OFS.STR := ',CATEGORY::=':DQUOTE(R.MB.SDB.PARAM<SDB.PAR.DEP.ACCT.DETAIL>)

        AC.OFS.STR := ',ACCOUNT.TITLE.1::=':DQUOTE(R.NEW(SDB.POST.HOLDER.NAME))
        AC.OFS.STR := ',ACCOUNT.TITLE.2::=':DQUOTE(R.NEW(SDB.POST.CUSTOMER.NO))
        AC.OFS.STR := ',SHORT.TITLE::=':DQUOTE(SHORT.TITLE.STR)

        AC.OFS.STR := ',POSITION.TYPE::="TR"'
        AC.OFS.STR := ',CURRENCY::=':DQUOTE(LCCY)

        SDB.OFS.STR = AC.OFS.HEADER:AC.OFS.STR
        GOSUB CALL.OGM
        IF OFS.ERR.MSG THEN
*TEXT = OFS.ERR.MSG
*CALL REM
*V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
            GOSUB DISP.ERR.MSG
        END

        RETURN
***************************************************************************************************************

CLOSE.ACCOUNT:

        ACCOUNT.NO = R.MB.SDB.STATUS<SDB.STA.DEPOSIT.ACCT>
        TOD.DATE = TODAY

        AC.CLOSE.OFS.STR = ''
        AC.CLOSE.OFS.HEADER = 'ACCOUNT.CLOSURE,MB.SDB.CLOSE,//':OFS.COMPANY:',':ACCOUNT.NO

        AC.CLOSE.OFS.STR = ',CAPITAL.DATE::=':DQUOTE(TOD.DATE)
        AC.CLOSE.OFS.STR := ',POSTING.RESTRICT::="90"'

        AC.CLOSE.OFS.STR := ',CAP.INTEREST::="WAIVE"'
        AC.CLOSE.OFS.STR := ',CLOSE.ONLINE::="N"'


        SDB.OFS.STR = AC.CLOSE.OFS.HEADER:AC.CLOSE.OFS.STR
        GOSUB CALL.OGM
        IF OFS.ERR.MSG THEN
* TEXT = OFS.ERR.MSG
*CALL REM
*V$ERROR = 'ERROR'
* GOTO BEF.AUT.EXIT
        END

        RETURN

***************************************************************************************************************
DISP.ERR.MSG:
        E = OFS.ERR.MSG
        CALL ERR
        RETURN

***************************************************************************************************************

    END
