* @ValidationCode : Mjo4MTEwNzY3OTM6Q3AxMjUyOjE3MDQ5NzI0NDE4NTI6SGFyaXNodmlrcmFtQzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 16:57:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
* Version 3 21/07/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>43116</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.CHECK.FIELDS
*
*-----------------------------------------------------------------------
* Check fields subroutine for T24.FUND.SERVICES template
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
* 10/20/04 - Sathish PS
*            Though DC does nt allow manual input of A/Cs not belonging to the
*            current company, when tried thru OFS, it does nt raise any error
*            and the Inter-Co entries are raised correctly, . So commented
*            the Check if both the A/Cs in a TFS Line belong to the same
*            Company.
*
* 10/25/04 - Sathish PS
*            Validations to new field STANDING.ORDER - this will pull
*            in the details of Dr & Cr accounts from STANDING.ORDER and
*            create an FT - this is to effect adhoc on-demand bill payments
*            A version routine V.TFS.FT.POPULATE.STO.DETS attached to
*            FT,T24.FS will pull in other details like Bene Addr. etc from
*            either STANDING.ORDER or STO.BULK.CODE.
*
* 10/30/03 - Sathish PS
*            Changes made to handle History Reversal for FT, as long
*            as HIS.REVERSAL is enabled in FT.TXN.TYPE.CONDITION &
*            defined in TFS.PARAMETER
*
* 02/10/05 - Sathish PS
*            New Functionality to support Cash Denominations
*
* 03/24/05 - Sathish PS
*            Functionality to restrict amendments to values if an Underlying
*            has already been created and authorised.
*
* 03/25/05 - Sathish PS
*            New functionality to clear pre-specified fields in a multi value
*            whenever TRANSACTION is changed.
*
* 04/26/05 - Sathish PS
*            Dont set ACCOUNT MISSING error in CHECK.DENOM.REQD
*
* 05/12/05 - Sathish PS
*            Introduction of 2 new common variables - TFS$LINE.FIRST.FIELD &
*            TFS$LINE.LAST.FIELD pointing to fields TFS.TRANSACTION & TFS.RETRY resp.
*
* 05/13/05 - Sathish PS
*            Validations added to PRIMARY.ACCOUNT, for new field PRIMARY.CUSTOMER
*
* 05/17/05 - Sathish PS
*            New field SURROGATE.AC that will act as a surrogate to both Dr and Cr accounts
*
* 06/24/05 - Sathish PS
*            Use the TFS$R.NEW which gets built by T24.FS.CHECK.RECORD, if we are in Browser
*
*
* 07/09/05 - Ganesh Prasad K
*            Added validations for coins dispense
*
* 07/15/05 - PS/GP
*            Storing the value in a reserved field and checking comi with the reserved field
*            to avoid problem of not refreshing the amounts for the successive inputs
*
* 07/20/05 - GP
*            Changed mix.amt.validations to allow the user to change split amount
*
* 08/03/05 - Sathish PS
*            Commented code that defaults CR.EXP.DATE and DR.EXP.DATE based on EXP.SCHEDULE
*            EXP.SCHEDULE has nothing to do with EXPOSURE.DATE. It will be passed on to
*            EXP.SPT.DAT in TELLER.
*
*
* 08/25/05 - GP
*            Moved code to HANDLE.BREAKUP so that the mix lines populate can be called when the user
*            changes the split.introduced a new para for deleting only the mixed lines when the split is
*            changed.
*
* 09/02/05  -GP
*             Introduced a new GOSUB for expanding the Denominations at the check field level
*             as the mix amt fields will be HOT.FIELD this is necessary.
*             Calls the same routine T24.FS.CHECK.FIELDS recursively.
*
* 10 OCT 06 - Sathish PS
*             Cash Back Functionality - Add the feature to insert new lines based on input in
*             DEPOSIT.AMOUNT, ACTUAL.DEPOSIT and CASH.BACK
*
* 21 MAY 07 - Sathish PS
*             Stupid mistake done on IF Condition in CALCULATE.CASH.BACK gosub on DEPOSIT.CCY and
*             CASH.BACK.CCY
*
* 29 AUG 07 - Sathish PS
*             Changes for Netting entries so only one entry hits the customer account.
*             And fixes to Denomination Processing
*             And changes to call TFS.GET.OPEN.TILL instead of inbuilt logic.
*
* 30 AUG 07 - Sathish PS
*             Fix issue for ITEM.EXP.DATE to fetch from the right multi-value. Earlier it was
*             fetching from R.NEW(TFS.CR.VALUE.DATE) instead of R.NEW(TFS.CR.VALUE.DATE)<1,AV>
*             Also in Amount check field, if E is already set, return that error message instead
*             of the generic EB-TFS.UNABLE.TO.DEFAULT.AC
*
* 02 SEP 07 - Sathish PS
*             Expand Denom regardless of whether flagged in ACCOUNT as 'DENOM', as long as the category
*             is defined in TELLER.PARAMETER>TRAN.CATEGORY field.
*
* 04 SEP 07 - Sathish PS
*             Dont repeat CREATE.NET.ENTRY CHECK.FIELDS during F5 or VALIDATE.
*             New logic to determine, if there is a surrogate account and different from PRIMARY.ACCOUNT
*             then which Account field to default it to.
*
* 07 SEP 07 - Sathish PS
*             If the Net Amount is negative, then swap the Dr and Cr Accounts and populate the absolute amount
*
* 09 SEP 07 - Sathish PS
*             If the first line is withdrawal and the debit is more than credit, the system was not netting it properly.
*
* 09 SEP 07 - Sathish PS
*             For Netted Entry transactions, Look for TELLER ID regardless of whether the underlying is FT or
*             TT or DC. This is becasue the wash-thru account needs to be defaulted with a TELLER ID so each
*             teller has his own account to reconcile at the end of the day and also to avoid locking contentions.
*
* 11 SEP 07 - Sathish PS
*             Incorrect IF Condition checking for IF NET.ENTRY EQ 'YES' - but this field will only have
*             CREDIT, DEBIT, BOTH or NO as the values.
*             Also when set to NULL, default to NO.
*
* 12 SEP 07 - Sathish PS
*             Reset denom if the Amount field is changed...
*
* 12 SEP 07 - Sathish PS
*             Netting problem when out of 2 lines, first line is a debit and 2nd line is a credit
*             but the credit is greater than debit. This is the other side of fix above done on 09 SEP 07 for netting.
*             And, dont allow input of amount if Surrogate Account is not input but defined in TFS.TRANSACTION.
*             And after creating net entries, set the CREATE.NET.ENTRY field to NO, so the next time, the user
*             can simply change it to YES to rebuild.
*
* 18 SEP 07 - Sathish PS
*             Allow account currency to be different from Transaction Currency
*             Bug fix for TELLER ID Check
*
* 26 SEP 07 - Sathish PS
*             Flag all lines to R if CREATE.NET.ENTRY is set to REVERSE.
*
* 04 OCT 07 - Sathish PS
*             Check for validations that NET.ENTRY Washthru category is available in TFS.PARAMETER
*
* Mar 17 2008 - Code amended to cater to withdrawals.
*
* 08 Apr 08 - Code corrected since when raising the actual TT transaction, the transaction amount was
*           - doubled.A new common variable has been introduced TFS$TFS.NET.ENTRY.POPULATED for this case.
*
* 15 Apr 08 - Code amended to save original value of variable ACCOUNT since it was getting overwritten
*             in CHECK.FOR.WASHTHRU.ACCOUNTS para.
*
* 30 Apr 2008 - Code amended to remove validation of cheque numbers.
*
* 06/06/08 - Geetha Balaji
*            CHNG060608 - The changes done in this fix have been linked to this code for easy retrieval.
*            Fix done to populate the correct AMOUNT.LCY when multi currencies are involved.
*            In future, all TFS transactions will have to be input with a Primary a/c
*            in the local currency.
*            This will facilitate the Washthrough a/c to be in Lcy and inturn simplify the
*            process of arriving at the appropriate deal rates(Buy/Sell rate depending on the type of
*            transaction).
*            Additional fixes done:
*            - Net Entry was not raised with the correct amount.
*            - Exposure amounts are calculated using the field TFS.AMOUNT.LCY rather than TFS.AMOUNT.
*
* 10/07/2008 - Geetha Balaji
*              NSCU Gap 40
*              Included check fields for the new field introduced, TFS.DEAL.RATE.
*              Fixed the problem when Invalid Minus was prompted for a debit net entry on Customer a/c.
*
*
* 23/03/09    - Anitha
*              HD0904350
*              Commented the hardcoding of category to arrive at the Till internal accounts
*

* 24/03/09    - Anitha S
*              HD0904143
*              added the below comment and changed the code for issue HD0904350
*              where the CONTROL.TYPE throws error if STOCK.CONTROL.TYPE EQ ''
*              whereas the check should only be done if STOCK.CONTROL.TYPE EQ 'DENOM'
*
*
* 13/04/09    - Anitha S
*              HD0908906
*              The primary account should be in local currency mandate is only for foreign currency
*              transactions involving netting of entries. The issue under consideration is for a
*              single line of FCY draft and no netting is involved here.
*              have done a check where if the account currency NE LCCY then call CUSTRATE and get the equivalent
*              local currency and assign it to AMOUNT.LCY
* 21/05/2012   - Sudhakar S
*                PACS00192240
*                While inputting the T24.FUND.SERVICES record, System does not form the internal account correctly for the field ACCOUNT.DR
*
* 05/07/2022 -   Gomathi S / Defect: 4912861
*                When Primary account has been changed during input, Cr and Dr accounts and account number fields are not updated.
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion             USPLATFORM.BP File Removed, CALL routine format modified, FM TO @FM, VM TO @VM, SM TO @SM
*--------------------------------------------------------------------------------------------*
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion

    $INSERT I_F.USER

    $INSERT I_F.CURRENCY
    $INSERT I_F.CATEGORY
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.TRANSACTION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.DATA.CAPTURE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.STO.BULK.CODE
    $INSERT I_F.BC.SORT.CODE
    $INSERT I_F.TELLER.DENOMINATION
    $INSERT I_F.TT.STOCK.CONTROL
    $INSERT I_F.TELLER.ID
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.TELLER.PARAMETER

    $INCLUDE I_F.TFS.PARAMETER ;*R22 Manual Conversion - START
    $INCLUDE I_F.TFS.TRANSACTION
    $INCLUDE I_F.T24.FUND.SERVICES
    $INCLUDE I_F.TFS.EXPOSURE.SCHEDULE        ;* 29 AUG 07 - Sathish PS s/e ;*R22 Manual Conversion - END
 
    GOSUB INITIALISE

    IF UNASSIGNED(AS) THEN
        AS =0
    END

    LOG.MSG = 'AF=':AF:'. AV=':AV:'. AS=':AS:'. COMI=':COMI:'. E=':E:'. ETEXT=':ETEXT ; GOSUB LOG.MESSAGE
    IF NOT(PROCESS.GOAHEAD) THEN
        RETURN
    END
*
    BEGIN CASE
        CASE AS
            INTO.FIELD = R.NEW(AF)<1,AV,AS>
        CASE AV
            INTO.FIELD = R.NEW(AF)<1,AV>
        CASE OTHERWISE
            INTO.FIELD = R.NEW(AF)
    END CASE

    IF NOT(E) THEN
        GOSUB CHECK.FIELDS
    END

    IF COMI THEN
        COMI.ENRI.SAVE = COMI.ENRI
        COMI.ENRI = ''
        GOSUB DEFAULT.OTHER.FIELDS
        COMI.ENRI = COMI.ENRI.SAVE
    END

    IF TFS$MESSAGE EQ 'CHECK.RECORD' THEN
        E = ''      ;* 18 SEP 07 - Sathish PS s/e
    END

RETURN
*-----------------------------------------------------------------------
INITIALISE:
    PROCESS.GOAHEAD = 1
    E = ''
    AMT2.ARR = ''
    ETEXT = ''
    FIELD.TO.DEF = '' ; ENRI.TO.DEF = ''
    DEFAULTED.FIELDS = '' ; DEFAULTED.ENRI = ''
    U.LANG = R.USER<EB.USE.LANGUAGE>
    LINE.FIRST.FIELD = TFS$LINE.FIRST.FIELD
    LINE.LAST.FIELD = TFS$LINE.LAST.FIELD
    FIELDS.TO.RESET = TFS$RESET.FIELD.NOS         ;* 03/25/05 - Sathish PS s/e
    TELLER.ID = ''
    CR.AC.CCY = '' ; DR.AC.CCY = ''
    DEFAULT.DENOM.AND.UNITS = 0
    WE.ARE.IN.BROWSER = (GTSACTIVE AND OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> EQ 'SESSION')  ;* 06/24/05 - Sathish PS s/e

    FN.AC = 'F.ACCOUNT' ; F.AC = ''
    FN.CATEG = 'F.CATEGORY' ; F.CATEG = ''
    FN.TXN = 'F.TRANSACTION' ; F.TXN = ''
    FN.FT.TXN = 'F.FT.TXN.TYPE.CONDITION' ; F.FT.TXN = ''
    FN.TT.TXN = 'F.TELLER.TRANSACTION' ; F.TT.TXN = ''
    FN.TFS.TXN = 'F.TFS.TRANSACTION' ; F.TFS.TXN = ''
    FN.FT.CHG = 'F.FT.CHARGE.TYPE' ; F.FT.CHG = ''
    FN.FT.COMM = 'F.FT.COMMISSION.TYPE' ; F.FT.COMM = ''
    FN.TTP = 'F.TELLER.PARAMETER' ; F.TT = '' ; CALL OPF(FN.TTP,F.TTP)

    FN.TU = 'F.TELLER.USER' ; F.TU = ''
    FN.TI = 'F.TELLER.ID' ; F.TI = ''
    FN.TI.NAU = 'F.TELLER.ID$NAU' ; F.TI.NAU = ''
    FN.FT = 'F.FUNDS.TRANSFER' ; F.FT = ''
    FN.TT = 'F.TELLER' ; F.TT = ''
    FN.TT.SC = 'F.TT.STOCK.CONTROL' ; F.TT.SC = ''
    FN.DC = 'F.DATA.CAPTURE' ; F.DC = ''
    FN.STO = 'F.STANDING.ORDER' ; F.STO = ''
    FN.SBC = 'F.STO.BULK.CODE' ; F.SBC = ''
    FN.BSC = 'F.BC.SORT.CODE' ; F.BSC = ''
    FN.NA = 'F.NOSTRO.ACCOUNT' ; F.NA = ''
    FN.CA = 'F.CUSTOMER.ACCOUNT' ; F.CA = ''
    FN.CUS = 'F.CUSTOMER' ; F.CUS = ''
    FN.UES = 'F.US.EXPOSURE.SCHEDULE' ; F.UES = '' ; FN.UES<2> = 'NO.FATAL.ERROR'
    CALL OPF(FN.UES,F.UES)
    IF ETEXT THEN
        ETEXT = ''
        FN.UES = '' ; F.UES = ''
    END
    ! 29 AUG 07 - Sathish PS /s
    FN.TFS.EXP = 'F.TFS.EXPOSURE.SCHEDULE' ; F.TFS.EXP = ''
    CALL OPF(FN.TFS.EXP,F.TFS.EXP)
    ! 29 AUG 07 - Sathish PS /e

    ! 12 SEP 07 - Sathish PS /s
    NET.ENTRY.CROSSVAL.FIELDS = TFS.PRIMARY.ACCOUNT :@VM: TFS.PRIMARY.CUSTOMER :@VM: TFS.NET.ENTRY
    NET.ENTRY.CROSSVAL.FIELDS := @VM: TFS.TRANSACTION :@VM: TFS.ACCOUNT.DR :@VM: TFS.ACCOUNT.CR
    NET.ENTRY.CROSSVAL.FIELDS := @VM: TFS.CURRENCY :@VM: TFS.AMOUNT
    ! 12 SEP 07 - Sathish PS /e

    ! 12 SEP 07 - Sathish PS /s
    IF AF EQ TFS.NET.ENTRY THEN
        NET.ENTRY = COMI
    END ELSE
        NET.ENTRY = R.NEW(TFS.NET.ENTRY)
    END
    IF NET.ENTRY NE 'NO' THEN
        T(TFS.ACCOUNT.DR)<3> = 'NOINPUT'
        T(TFS.ACCOUNT.CR)<3> = 'NOINPUT'
    END ELSE
        T(TFS.ACCOUNT.DR)<3> = ''
        T(TFS.ACCOUNT.CR)<3> = ''
    END
    ! 12 SEP 07 - Sathish PS /e

    IF MESSAGE EQ 'HLD' THEN
        PROCESS.GOAHEAD = 0   ;* 12 SEP 07 - Sathish PS s/e
    END
    GOSUB CHECK.PRELIM.CONDS

RETURN
*-----------------------------------------------------------------------
CHECK.PRELIM.CONDS:

    LOOP.CNT = 1 ; MAX.LOOPS = 6
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IGNORE.FIELDS.ON.F5 = TFS.CR.EXP.DATE :@VM : TFS.DR.EXP.DATE ;*R22 Manual Conversion
                IGNORE.FIELDS.ON.F5 := @VM : TFS.EXP.SCHEDULE

                IF AF MATCHES IGNORE.FIELDS.ON.F5 AND TFS$MESSAGE NE '' THEN
                    PROCESS.GOAHEAD = 0
                END

            CASE LOOP.CNT EQ 2
*
* Yes its an overhead but can't do otherwise because we can't capture Expanding/Deleting
* a Multi value here in our template
*
                IF AF NE TFS.TRANSACTION THEN
                    IF TFS$MESSAGE NE 'CHECK.OTHER.FIELDS' THEN
*
* TFS$MESSAGE will be set to CHECK.OTHER.FIELDS when T24.FS.CHECK.FIELDS is being called
* recursively
*
                        ALL.TFS.TXNS = R.NEW(TFS.TRANSACTION)
                        NO.OF.TXNS = DCOUNT(ALL.TFS.TXNS,@VM)
                        FOR XX = 1 TO NO.OF.TXNS
                            TFS.TXN = ALL.TFS.TXNS<1,XX>
                            TFS$R.TFS.TXN(XX) = ''
                            IF TFS.TXN THEN
*                                CALL TFS.LOAD.TRANSACTION(TFS.TXN,R.TFS.TXN,'','','')
*                                APAP.TFS.tfsLoadTransaction(TFS.TXN,R.TFS.TXN,'','','') ;*R22 Manual Conversion
                                APAP.TFS.t24LoadTransaction(TFS.TXN,R.TFS.TXN,'','','') ;*R22 Manual Conversion    ;* TSR-734921 fix
                                TFS$R.TFS.TXN(XX) = R.TFS.TXN
                                SAVE.AV = AV ; AV = XX
                                GOSUB LOAD.STO.RECORD
                                AV = SAVE.AV
                            END
                        NEXT XX
                    END
                END

            CASE LOOP.CNT EQ 3
* 05/25/05 - Sathish PS /s
                SURROGATE.AC = R.NEW(TFS.SURROGATE.AC)<1,AV>
                IF TFS$MESSAGE NE 'CHECK.OTHER.FIELDS' THEN
                    IF NOT(SURROGATE.AC) THEN
                        IF WE.ARE.IN.BROWSER THEN
                            SURROGATE.AC = TFS$R.NEW<TFS.SURROGATE.AC,AV>
                        END
                    END
                    PRIMARY.ACCOUNT = R.NEW(TFS.PRIMARY.ACCOUNT)
                    IF NOT(PRIMARY.ACCOUNT) THEN
                        IF WE.ARE.IN.BROWSER THEN
                            PRIMARY.ACCOUNT = TFS$R.NEW<TFS.PRIMARY.ACCOUNT>
                        END
                    END
                    IF NOT(SURROGATE.AC) THEN
                        SURROGATE.AC = PRIMARY.ACCOUNT
                    END
                END
* 05/25/05 - Sathish PS /e
            CASE LOOP.CNT EQ 4
*
* Instead of making TFS.TRANSACTION as Mandatory Input, make it optional
* but check for all other fields if the corresponding multi value of
* TFS.TRANSACTION has been input.
* LINE.FIRST.FIELD is set to TFS.TRANSACTION and hence the condition GT instead
* of GE.
*
                IF AF GT LINE.FIRST.FIELD AND AF LE LINE.LAST.FIELD AND AF NE TFS.IMPORT.UL THEN
                    IF T(AF)<3> MATCHES 'NOINPUT' :@VM: 'NOCHANGE' THEN
                        PROCESS.GOAHEAD = 0
                    END ELSE
                        IF NOT(R.NEW(TFS.TRANSACTION)<1,AV>) THEN
                            BEGIN CASE
                                CASE COMI
                                    E = 'EB-TFS.TRANS.INP.MISS'

                                CASE NOT(COMI)
                                    PROCESS.GOAHEAD = 0   ;* CROSSVAL will remove the Multivalue set

                            END CASE
                        END
                    END
                END

            CASE LOOP.CNT EQ 5
                ID.TTP = ID.COMPANY ; R.TTP = '' ; ERR.TTP = ''
                CALL CACHE.READ(FN.TTP,ID.TTP,R.TTP,ERR.TTP)

        END CASE
        LOOP.CNT += 1

        IF E THEN
            PROCESS.GOAHEAD = 0         ;* 09 SEP 07 - Sathish PS s/e
        END

    REPEAT

RETURN
*-----------------------------------------------------------------------
DEFAULT.OTHER.FIELDS:

RETURN
*
*------------------------------------------------------------------------
CHECK.FIELDS:

    DEFAULTED.FIELD = '' ; DEFAULTED.ENRI = ''
    FIELD.TO.DEF = '' ; ENRI.TO.DEF = ''

    BEGIN CASE
        CASE AF EQ TFS.BOOKING.DATE
            IF COMI EQ '' THEN
                COMI = TODAY
            END ELSE
                IF COMI GT TODAY THEN
                    E = 'EB-TFS.BOOKING.CANT.BE.IN.FUTURE'
                END
            END
* 07/09/05 -GP /S
        CASE AF EQ TFS.MIX.WD.AMOUNT
*        LOG.MSG = 'AF=& ; COMI=& ; ' :FM: 'MIX.WD.AMOUNT' :VM: COMI ; GOSUB LOG.MESSAGE

            IF COMI THEN
                IF TFS$R.TFS.PAR<TFS.PAR.MIX.WITHDRAWAL> EQ 'YES' THEN
                    GOSUB MIX.WD.AMT.VALIDATIONS
                END ELSE
                    E = 'EB-INP.NOT.ALLOWED'
                END
            END
* 07/09/05 -GP /E                                     ;*  08/25/05 GP/S
        CASE AF EQ TFS.MIX.WD.SRC.AMT
            IF COMI THEN
                IF COMI NE R.NEW(TFS.STORE.SPLIT.AMT)<1,AV> THEN
                    SPLIT.CHANGED =1 ;TOTAL.AMT.CHANGED =0
                    GOSUB REFRESH.SPLIT.TXN.LINES
                    R.NEW(TFS.MIX.WD.SRC.AMT)<1,AV+1> = R.NEW(TFS.MIX.WD.AMOUNT) - COMI
                    GOSUB HANDLE.BREAKUP
                    GOSUB STORE.POPULATED.AMT
                END
            END         ;* 08/25/05 GP/E

* 10 OCT 06 - Sathish PS /s
        CASE AF EQ TFS.DEPOSIT.AMOUNT
            IF COMI THEN
                DEPOSIT.AMOUNT = COMI
                IF NOT(R.NEW(TFS.DEPOSIT.CCY)) THEN
                    R.NEW(TFS.DEPOSIT.CCY) = LCCY
                END
                IF NOT(R.NEW(TFS.CASH.BACK.CCY)) THEN
                    R.NEW(TFS.CASH.BACK.CCY) = LCCY
                END
                IF R.NEW(TFS.ACTUAL.DEPOSIT) THEN
                    IF R.NEW(TFS.ACTUAL.DEPOSIT) LE COMI THEN
                        ACTUAL.DEPOSIT = R.NEW(TFS.ACTUAL.DEPOSIT)
                        DEPOSIT.CCY = R.NEW(TFS.DEPOSIT.CCY) ; CASH.BACK.CCY = R.NEW(TFS.CASH.BACK.CCY)
                        GOSUB CALCULATE.CASH.BACK
                    END ELSE
                        E = 'EB-TFS.AMT.MUST.BE.GREATER.THAN.ACTUAL.DEPOSIT'
                    END
                END
            END

        CASE AF EQ TFS.ACTUAL.DEPOSIT
            IF COMI THEN
                IF NOT(R.NEW(TFS.DEPOSIT.CCY)) THEN
                    R.NEW(TFS.DEPOSIT.CCY) = LCCY
                END
                IF NOT(R.NEW(TFS.CASH.BACK.CCY)) THEN
                    R.NEW(TFS.CASH.BACK.CCY) = LCCY
                END
                IF R.NEW(TFS.DEPOSIT.AMOUNT) THEN
* PACS00269522 - S
                    IF R.NEW(TFS.DEPOSIT.AMOUNT) GE COMI THEN
* PACS00269522 - E
                        DEPOSIT.AMOUNT = R.NEW(TFS.DEPOSIT.AMOUNT)
                        ACTUAL.DEPOSIT = COMI
                        DEPOSIT.CCY = R.NEW(TFS.DEPOSIT.CCY) ; CASH.BACK.CCY = R.NEW(TFS.CASH.BACK.CCY)
                        GOSUB CALCULATE.CASH.BACK
                    END ELSE
                        E = 'EB-TFS.AMT.MUST.BE.LESS.THAN.DEPOSIT.AMT'
                    END
                END ELSE
                    E = 'EB-INP.NOT.ALLOWED'
                END
            END

        CASE AF EQ TFS.CASH.BACK.CCY
            IF NOT(COMI) THEN
                IF R.NEW(TFS.DEPOSIT.AMOUNT) AND R.NEW(TFS.ACTUAL.DEPOSIT) THEN     ;* 29 AUG 07 - Sathish PS s/e Dont default if its not a cash back screen
                    COMI = LCCY
                END
            END
            ! 21 MAY 07 - Sathish PS /s
            !        IF COMI NE R.NEW(TFS.DEPOSIT.CCY) THEN
            IF COMI NE R.NEW(TFS.DEPOSIT.CCY) AND R.NEW(TFS.DEPOSIT.CCY) AND COMI THEN
                ! 21 MAY 07 - Sathish PS /e
                DEPOSIT.AMOUNT = R.NEW(TFS.DEPOSIT.AMOUNT)
                ACTUAL.DEPOSIT = R.NEW(TFS.ACTUAL.DEPOSIT)
                DEPOSIT.CCY = R.NEW(TFS.DEPOSIT.CCY) ; CASH.BACK.CCY = COMI
                GOSUB CALCULATE.CASH.BACK
            END

        CASE AF EQ TFS.CASH.BACK
* IF NOT(COMI) THEN
            DEPOSIT.AMOUNT = R.NEW(TFS.DEPOSIT.AMOUNT)
            ACTUAL.DEPOSIT = R.NEW(TFS.ACTUAL.DEPOSIT)
            DEPOSIT.CCY = R.NEW(TFS.DEPOSIT.CCY) ; CASH.BACK.CCY = R.NEW(TFS.CASH.BACK.CCY)
            GOSUB CALCULATE.CASH.BACK
* END

        CASE AF EQ TFS.DO.CASH.BACK
            IF COMI EQ 'YES' THEN
                GOSUB INSERT.CASH.BACK.LINES
* CHANGES START - PACS00311432
                SPLIT.CHANGED =1 ;TOTAL.AMT.CHANGED =0
                GOSUB REFRESH.SPLIT.TXN.LINES
                R.NEW(TFS.MIX.WD.SRC.AMT)<1,AV+1> = R.NEW(TFS.MIX.WD.AMOUNT) - COMI
                GOSUB HANDLE.BREAKUP
                GOSUB STORE.POPULATED.AMT
* CHANGES END - PACS00311432
            END ELSE
                GOSUB REFRESH.CASH.BACK.LINES
            END
* 10 OCT 06 - Sathish PS /e

        CASE AF EQ TFS.TRANSACTION
            IF COMI THEN
                TFS.TXN = COMI
*                CALL TFS.LOAD.TRANSACTION(TFS.TXN,R.TFS.TXN,'','','')
*                APAP.TFS.tfsLoadTransaction(TFS.TXN,R.TFS.TXN,'','','') ;*R22 Manual Conversion
                APAP.TFS.t24LoadTransaction(TFS.TXN,R.TFS.TXN,'','','') ;*R22 Manual Conversion          ;* TSR-734921 fix
                IF NOT(E) THEN
                    LOCATE R.TFS.TXN<TFS.TXN.INTERFACE.TO> IN TFS$R.TFS.PAR<TFS.PAR.APPLICATION,1> SETTING INTERFACE.OK THEN
                        TFS$R.TFS.TXN(AV) = R.TFS.TXN
                        IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'TT' THEN
                            GOSUB CHECK.TELLER.ID
                            IF NOT(TELLER.ID) THEN
                                TFS$R.TFS.TXN(AV) = ''
                            END ELSE
                                GOSUB LOAD.STO.RECORD
                            END
                        END ELSE
                            IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'DC' THEN
                                IF INDEX('IC',V$FUNCTION,1) AND TFS$AUTH.NO EQ 0 AND TFS$R.TFS.PAR<TFS.PAR.ALLOW.DC.ZERO.AUT> NE 'YES' THEN
                                    E = 'EB-TFS.DC.ZERO.AUTH.RESTRICTION'
                                END
                            END
                        END
                        IF NOT(E) THEN
                            GOSUB DEFAULT.CHG.CODE
                        END
                    END ELSE
                        E = 'EB-TFS.INTERFACE.NOT.IN.PARAM' :@FM: R.TFS.TXN<TFS.TXN.INTERFACE.TO>
                    END
                END
                IF NOT(E) AND COMI NE R.NEW(TFS.TRANSACTION)<1,AV> THEN
                    IF R.OLD(TFS.UNDERLYING)<1,AV> THEN
                        E = 'EB-TFS.CANT.CHANGE.TRANSACTION'
                    END ELSE
                        GOSUB CLEAR.OTHER.FIELDS
                    END
                END
            END
        CASE AF EQ TFS.ACCOUNT.DR
            GOSUB VALIDATE.ACCOUNT
            IF COMI THEN
                IF NOT(E) THEN
                    IF COMI EQ R.NEW(TFS.ACCOUNT.CR)<1,AV> THEN
                        E = 'EB-TFS.AC.CR.EQ.AC.DR'
                    END ELSE
                        CR.AC = R.NEW(TFS.ACCOUNT.CR)<1,AV> ; DR.AC = COMI
* 10/20/04 - Sathish PS /s
* DC Allows A/Cs belonging to different companies, when created thru OFS. So
* commented till we have a problem with it.
*                    GOSUB CHECK.AC.BRANCHES
* 10/20/04 - Sathish PS /e
                    END
                END
            END ELSE
                IF TFS$R.TFS.TXN(AV)<TFS.TXN.DR.ALLOWED.AC> EQ 'CUSTOMER' OR (TFS$R.TFS.TXN(AV)<TFS.TXN.DR.ALLOWED.AC> EQ 'ANY' AND NOT(TFS$R.TFS.TXN(AV)<TFS.TXN.DR.CATEG>)) THEN
                    ! 29 AUG 07 - Sathish PS /s
                    ! Defaulting COMI with SURROGATE.AC has been moved to a central gosub.
                    OTHER.ACCOUNT = TFS.ACCOUNT.CR
                    GOSUB DEFAULT.FROM.SURROGATE.OR.WASHTHRU
                    ! 29 AUG 07 - Sathish PS /e
                    IF NOT(COMI) THEN
                        IF R.NEW(TFS.ACCOUNT.CR)<1,AV> NE PRIMARY.ACCOUNT THEN
                            COMI = PRIMARY.ACCOUNT
                            GOSUB VALIDATE.ACCOUNT
                            IF E THEN
                                COMI = '' ; E = '' ; COMI.ENRI = ''
                            END
                        END
                    END
                END
                IF NOT(COMI) THEN
                    IF MAND.INP THEN
                        E = 'EB-INPUT.MISSING'
                    END
                END
            END

        CASE AF EQ TFS.ACCOUNT.CR
            GOSUB VALIDATE.ACCOUNT
            IF COMI THEN
                IF NOT(E) THEN
                    IF COMI EQ R.NEW(TFS.ACCOUNT.DR)<1,AV> THEN
                        E = 'EB-TFS.AC.CR.EQ.AC.DR'
                    END ELSE
                        CR.AC = COMI ; DR.AC = R.NEW(TFS.ACCOUNT.DR)<1,AV>
* 10/20/04 - Sathish PS /s
* DC Allows A/Cs belonging to different companies, when created thru OFS. So
* commented till we have a problem with it.
*                    GOSUB CHECK.AC.BRANCHES
* 10/20/04 - Sathish PS /e
                    END
                END
            END ELSE
                IF TFS$R.TFS.TXN(AV)<TFS.TXN.CR.ALLOWED.AC> EQ 'CUSTOMER' OR (TFS$R.TFS.TXN(AV)<TFS.TXN.CR.ALLOWED.AC> EQ 'ANY' AND NOT(TFS$R.TFS.TXN(AV)<TFS.TXN.CR.CATEG>)) THEN
                    ! 29 AUG 07 - Sathish PS /s
                    ! Defaulting COMI with SURROGATE.AC has been moved to a central gosub.
                    OTHER.ACCOUNT = TFS.ACCOUNT.DR
                    GOSUB DEFAULT.FROM.SURROGATE.OR.WASHTHRU
                    ! 29 AUG 07 - Sathish PS /e
                    IF NOT(COMI) THEN
                        IF R.NEW(TFS.ACCOUNT.DR)<1,AV> NE PRIMARY.ACCOUNT THEN
                            COMI = PRIMARY.ACCOUNT
                            GOSUB VALIDATE.ACCOUNT
                            IF E THEN
                                COMI = '' ; E = '' ; COMI.ENRI = ''
                            END
                        END
                    END
                END
            END
            IF NOT(COMI) THEN
                IF MAND.INP THEN
                    E = 'EB-INPUT.MISSING'
                END
            END

        CASE AF EQ TFS.CURRENCY
            IF NOT(COMI) THEN
                IF R.NEW(TFS.ACCOUNT.DR)<1,AV> OR R.NEW(TFS.ACCOUNT.CR)<1,AV> THEN
                    COMI = LCCY
                END
            END
            IF COMI THEN
                CHECK.CCY = COMI
                GOSUB VALIDATE.CURRENCY
            END

            IF COMI AND NOT(E) AND R.NEW(TFS.AMOUNT)<1,AV> AND COMI NE LCCY THEN
                AMOUNT.FCY = R.NEW(TFS.AMOUNT)<1,AV> ; FCY = COMI
                GOSUB FIND.AMOUNT.LCY
                IF NOT(E) THEN
                    R.NEW(TFS.AMOUNT.LCY)<1,AV> = AMOUNT.LCY
                    FIELD.TO.DEF = TFS.AMOUNT.LCY :'.': AV ; ENRI.TO.DEF = AMOUNT.LCY.ENRI ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                END
            END

        CASE AF EQ TFS.AMOUNT
            IF COMI THEN
                IF TFS$MESSAGE EQ 'CHECK.RECORD' THEN ;* When called from T24.FUND.SERVICES template
                    GOSUB UPDATE.RUNNING.TOTAL
                END ELSE
                    IF R.NEW(TFS.CURRENCY)<1,AV> EQ '' THEN
                        R.NEW(TFS.CURRENCY)<1,AV> = LCCY
                        CHECK.CCY = R.NEW(TFS.CURRENCY)<1,AV>
                        GOSUB VALIDATE.CURRENCY
                        IF E THEN
                            R.NEW(TFS.CURRENCY)<1,AV> = '' ; E = ''
                        END
                    END
                    GOSUB CHECK.AND.DEFAULT.ACCOUNTS
                    IF R.NEW(TFS.ACCOUNT.DR)<1,AV> AND R.NEW(TFS.ACCOUNT.CR)<1,AV> THEN
                        IF R.NEW(TFS.ACCOUNT.DR)<1,AV> EQ R.NEW(TFS.ACCOUNT.CR)<1,AV> THEN
                            E = 'EB-TFS.AC.CR.EQ.AC.DR'
                        END
                    END ELSE
                        IF NOT(E) THEN
                            E = 'EB-TFS.UNABLE.TO.DEFAULT.AC'   ;* 30 AUG 07 - Sathish PS s/e
                        END
                    END
                    COMI.ENRI = ''
                    IF NOT(E) THEN
                        IF R.NEW(TFS.CURRENCY)<1,AV> NE LCCY THEN
                            AMOUNT.FCY = COMI ; FCY = R.NEW(TFS.CURRENCY)<1,AV>
                            GOSUB FIND.AMOUNT.LCY
                            IF NOT(E) THEN
                                R.NEW(TFS.AMOUNT.LCY)<1,AV> = AMOUNT.LCY
                            END
                        END ELSE
*                        IF NOT(TFS$TFS.NET.ENTRY.POPULATED) THEN      ;* 08 Apr 08 /s
                            R.NEW(TFS.AMOUNT.LCY)<1,AV> = COMI  ;* CHNG060608 S - Default TFS.AMOUNT.LCY with TFS.AMOUNT for local Ccy txns too.
*                        END   ;* 08 Apr 08 /e ;* CHNG060608 E
                        END
                        FIELD.TO.DEF = TFS.AMOUNT.LCY :'.': AV ; ENRI.TO.DEF = AMOUNT.LCY.ENRI ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                    END
                END
* Default Charges
                ! 29 AUG 07 - Sathish PS /s
                IF NOT(E) AND R.NEW(TFS.NET.ENTRY) NE 'NO' THEN
                    IF R.NEW(TFS.WAIVE.CHARGE)<1,AV> EQ '' THEN
                        R.NEW(TFS.WAIVE.CHARGE)<1,AV> = 'YES'
                    END
                END
                ! 29 AUG 07 - Sathish PS /e
                IF NOT(E) AND NOT(R.NEW(TFS.WAIVE.CHARGE)<1,AV> EQ 'YES') THEN
                    IF NOT(E) AND TFS$MESSAGE NE '' THEN        ;* Only during F5
                        IF COMI LT R.NEW(TFS.CHG.AMT)<1,AV> THEN
                            E = 'EB-TFS.TXN.AMOUNT.LESS.THAN.CHG' :@FM: R.NEW(TFS.CHG.CCY)<1,AV> :@VM: R.NEW(TFS.CHG.AMT)<1,AV> ;*R22 Manual Conversion
                        END
                    END
                    IF NOT(E) AND TFS$MESSAGE EQ '' THEN        ;* Only during Field Input
                        GOSUB DEFAULT.CHG.CODE
                        IF (R.NEW(TFS.CHG.CODE)<1,AV> AND NOT(R.NEW(TFS.CHG.CCY)<1,AV>)) OR (R.NEW(TFS.CHG.CODE)<1,AV> AND R.NEW(TFS.CHG.CCY)<1,AV> NE R.NEW(TFS.CURRENCY)<1,AV>) THEN
                            R.NEW(TFS.CHG.CCY)<1,AV> = R.NEW(TFS.CURRENCY)<1,AV>
                        END
                        CHG.CODE = R.NEW(TFS.CHG.CODE)<1,AV> ; CHG.CCY = R.NEW(TFS.CHG.CCY)<1,AV>
                        GOSUB TRY.TO.DEFAULT.CHG.AMT
                    END
                END     ;* 29 AUG 07 - Sathish PS s/e
                IF NOT(E) THEN
                    GOSUB DENOMINATION.PROCESSING     ;* 02/10/05 - Sathish PS /e
                END
                IF NOT(E) THEN
                    GOSUB UPDATE.RUNNING.TOTAL
                END
                IF NOT(E) THEN
                
                    ! 12 SEP 07 - Sathish PS /s
                    IF (TFS$R.TFS.TXN(AV)<TFS.TXN.SURROGATE.AC> NE '') AND NOT(R.NEW(TFS.SURROGATE.AC)<1,AV>) AND PRIMARY.ACCOUNT THEN
                        E = 'EB-SURROGATE.AC.INPUT.MISSING'
                    END ELSE
                        ! 12 SEP 07 - Sathish PS /e
                        R.NEW(TFS.SURROGATE.AC)<1,AV> = PRIMARY.ACCOUNT
                        SAVE.COMI = COMI ; SAVE.COMI.ENRI = COMI.ENRI ; COMI = R.NEW(TFS.SURROGATE.AC)<1,AV> ; GOSUB GET.AC.ENRI
                        COMI = SAVE.COMI ; SURR.AC.ENRI = COMI.ENRI ; COMI.ENRI = SAVE.COMI.ENRI
                        FIELD.TO.DEF = TFS.SURROGATE.AC :'.': AV ; ENRI.TO.DEF = SURR.AC.ENRI ; GOSUB APPEND.TO.DEFAULTED.FIELDS

                     
                    END ;* 12 SEP 07 - Sathish PS s/e
                END
            END

* Gap 40 - 10/07/2008 S
        CASE AF MATCHES TFS.DEAL.RATE
            IF COMI THEN
                PRI.ACC = R.NEW(TFS.PRIMARY.ACCOUNT)  ;* Change request dated 20090827 - umar
                CALL CACHE.READ(FN.AC,PRI.ACC,R.ACC,ERR.ACC)    ;* Change request dated 20090827 - umar
                IF R.NEW(TFS.CURRENCY)<1,AV> EQ LCCY AND R.ACC<AC.CURRENCY> EQ LCCY THEN      ;* Change request dated 20090827 - umar
*            IF R.NEW(TFS.CURRENCY)<1,AV> EQ LCCY THEN ; * Change request dated 20090827 - umar
                    E = 'EB-INVALID.CCY'
                END
                IF NOT(E) AND NOT(R.NEW(TFS.AMOUNT)<1,AV>) THEN
                    E = 'EB-TFS.AMOUNT.MISSING'
                END
                IF R.NEW(TFS.CURRENCY)<1,AV> NE LCCY THEN       ;* Change request dated 20090827 - umar
                    AMOUNT.FCY = R.NEW(TFS.AMOUNT)<1,AV> ; FCY = R.NEW(TFS.CURRENCY)<1,AV>
                    GOSUB FIND.AMOUNT.LCY
                    IF NOT(E) THEN
                        R.NEW(TFS.AMOUNT.LCY)<1,AV> = AMOUNT.LCY
                        FIELD.TO.DEF = TFS.AMOUNT.LCY :'.': AV ; ENRI.TO.DEF = AMOUNT.LCY.ENRI ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                        GOSUB UPDATE.RUNNING.TOTAL
                    END
                END     ;* Change request dated 20090827 - umar
            END
* Gap 40 - 10/07/2008 S

        CASE AF MATCHES TFS.CR.VALUE.DATE
            IF NOT(COMI) THEN
                IF NOT(R.NEW(AF)<1,AV>) THEN
                    TEMP.TXN.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.CR.TXN.CODE>
                    GOSUB GET.DEFAULT.VALUE.DATE
                    IF NOT(VALUE.DATE) THEN
                        VALUE.DATE = TODAY
                    END
                    COMI = VALUE.DATE
                END
            END

        CASE AF MATCHES TFS.CR.EXP.DATE
            IF NOT(COMI) THEN
                IF NOT(R.NEW(AF)<1,AV>) THEN
                    TEMP.TXN.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.CR.TXN.CODE>
                    GOSUB GET.DEFAULT.VALUE.DATE
                    COMI = VALUE.DATE
                END
            END

        CASE AF MATCHES TFS.DR.VALUE.DATE

            IF NOT(COMI) THEN
                IF NOT(R.NEW(AF)<1,AV>) THEN
                    TEMP.TXN.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.TXN.CODE>
                    GOSUB GET.DEFAULT.VALUE.DATE
                    IF NOT(VALUE.DATE) THEN
                        VALUE.DATE = TODAY
                    END
                    COMI = VALUE.DATE
                END
            END

        CASE AF MATCHES TFS.DR.EXP.DATE

            IF NOT(COMI) THEN
                IF NOT(R.NEW(AF)<1,AV>) THEN
                    TEMP.TXN.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.TXN.CODE>
                    GOSUB GET.DEFAULT.VALUE.DATE
                    COMI = VALUE.DATE
                END
            END

        CASE AF EQ TFS.EXP.SCHEDULE
            IF COMI THEN
                GOSUB PROCESS.EXPOSURE.SCHEDULE       ;* 29 AUG 07 - Sathish PS s/e
* 08/03/05 - Sathish PS /s
*            GOSUB CHECK.AND.DEFAULT.EXP.DATES
* 08/03/05 - Sathish PS /e
            END

        CASE AF EQ TFS.STANDING.ORDER
            IF COMI THEN
                IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> NE 'FT' THEN
                    E = 'EB-TFS.INPUT.NOT.ALLOWED'
                END ELSE
                    IF R.NEW(TFS.ACCOUNT.DR)<1,AV> AND TFS$MESSAGE EQ '' THEN
                        E = 'EB-TFS.INPUT.NOT.ALLOWED'
                    END
                END
                IF NOT(E) THEN
*                    CALL US.GET.LOCAL.REF.POS.ARRAY('FUNDS.TRANSFER','TFS.STO.ID',FT.LREF.POS,FT.LREF.ERR)
                    CALL MULTI.GET.LOC.REF('FUNDS.TRANSFER','TFS.STO.ID',FT.LREF.POS)   ;* TSR-734921 fix
                    IF NOT(FT.LREF.POS) THEN
                        E = 'EB-TFS.LOCAL.REF.FIELD.MISSING' :@FM: 'TFS.STO.ID' :@FM: 'FUNDS.TRANSFER'
                    END
                END
                IF NOT(E) AND COMI.ENRI THEN
                    COMI.ENRI = COMI.ENRI<1,1>
                END
            END

        CASE AF EQ TFS.AMOUNT.LCY
* PACS00331852 - S
*        IF R.NEW(TFS.CURRENCY) NE LCCY THEN
            IF R.NEW(TFS.CURRENCY)<1,AV> NE LCCY THEN
* PACS00331852 - E
                AMOUNT.FCY = R.NEW(TFS.AMOUNT)<1,AV> ; FCY = R.NEW(TFS.CURRENCY)<1,AV>
                GOSUB FIND.AMOUNT.LCY
            END ELSE
                AMOUNT.LCY = R.NEW(TFS.AMOUNT)<1,AV>
            END
            IF NOT(E) THEN
                IF (R.NEW(TFS.AMOUNT.LCY)<1,AV> EQ '') THEN     ;* 08 Apr 08 s/e
                    COMI = AMOUNT.LCY
                    IF COMI THEN
                        COMI.ENRI = AMOUNT.LCY.ENRI
                    END
                END     ;* 08 Apr 08 s/e
            END

        CASE AF EQ TFS.CHG.CODE
            IF R.NEW(TFS.WAIVE.CHARGE)<1,AV> NE 'YES' THEN      ;* 29 AUG 07 - Sathish PS s/e
                IF COMI THEN
                    GOSUB VALIDATE.CHG.CODE
                END ELSE
* 05/25/05 - Sathish PS /s
                    GOSUB DEFAULT.CHG.CODE
                    COMI = CHG.CODE
                    IF (COMI AND NOT(R.NEW(TFS.CHG.CCY)<1,AV>)) OR (COMI AND R.NEW(TFS.CHG.CCY)<1,AV> NE R.NEW(TFS.CURRENCY)<1,AV>) THEN
                        R.NEW(TFS.CHG.CCY)<1,AV> = R.NEW(TFS.CURRENCY)<1,AV>
                    END
                END
            END ELSE
                COMI = ''
            END
* 05/25/05 - Sathish PS /e

        CASE AF EQ TFS.CHG.CCY
            IF R.NEW(TFS.WAIVE.CHARGE)<1,AV> NE 'YES' THEN      ;* 29 AUG 07 - Sathish PS s/e
                IF COMI EQ '' THEN
                    IF R.NEW(TFS.CHG.CODE)<1,AV> THEN
                        COMI = R.NEW(TFS.CURRENCY)<1,AV>
                    END
                END
                IF COMI THEN
                    IF COMI NE R.NEW(TFS.CURRENCY)<1,AV> THEN
                        E = 'EB-TFS.INVALID.CCY' :@FM: COMI
                    END ELSE
                        CHECK.CCY = COMI
                        GOSUB VALIDATE.CURRENCY
                    END
                END
            END ELSE
                COMI = ''
            END

        CASE AF EQ TFS.CHG.AMT
            IF R.NEW(TFS.WAIVE.CHARGE)<1,AV> NE 'YES' THEN      ;* 29 AUG 07 - Sathish PS s/e
                IF COMI # '' THEN
                    IF R.NEW(TFS.CHG.CCY)<1,AV> EQ '' THEN
                        R.NEW(TFS.CHG.CCY)<1,AV> = R.NEW(TFS.CURRENCY)<1,AV>
                    END ELSE
                        IF R.NEW(TFS.CHG.CODE)<1,AV> EQ '' THEN
                            E = 'EB-TFS.CHG.CODE.INP.MISS'
                        END ELSE
                            COMI.ENRI = R.NEW(TFS.CHG.CCY)<1,AV>
                        END
                    END
                    IF NOT(E) AND R.NEW(TFS.CHG.CCY)<1,AV> NE LCCY THEN
                        FCY = R.NEW(TFS.CHG.CCY)<1,AV> ; AMOUNT.FCY = COMI
                        GOSUB FIND.AMOUNT.LCY
                        IF NOT(E) THEN
                            R.NEW(TFS.CHG.AMT.LCY)<1,AV> = AMOUNT.LCY
                            FIELD.TO.DEF = TFS.CHG.AMT.LCY :'.': AV ; ENRI.TO.DEF = AMOUNT.LCY.ENRI ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                        END
                    END
                    IF NOT(E) AND TFS$MESSAGE NE '' THEN        ;* Only during F5
                        IF COMI GT R.NEW(TFS.AMOUNT)<1,AV> THEN
                            E = 'EB-TFS.CHG.MORE.THAN.TXN.AMOUNT' :@FM: R.NEW(TFS.CURRENCY)<1,AV> :@VM: R.NEW(TFS.AMOUNT)<1,AV>
                        END
                    END
                END ELSE
                    IF R.NEW(TFS.CHG.CCY)<1,AV> THEN
                        CHG.CODE = R.NEW(TFS.CHG.CODE)<1,AV> ; CHG.CCY = R.NEW(TFS.CHG.CCY)<1,AV>
                        GOSUB TRY.TO.DEFAULT.CHG.AMT
                        IF NOT(COMI) THEN
                            E = 'EB-INPUT.MISSING'
                        END

                    END ELSE
                        IF R.NEW(TFS.CHG.CODE)<1,AV> THEN
                            CHG.CODE = R.NEW(TFS.CHG.CODE)<1,AV> ; CHG.CCY = R.NEW(TFS.CURRENCY)<1,AV>
                            GOSUB TRY.TO.DEFAULT.CHG.AMT
                            IF NOT(COMI) THEN
                                E = 'EB-INPUT.MISSING'
                            END
                        END ELSE
                            R.NEW(TFS.CHG.AMT.LCY)<1,AV> = ''
                        END
                    END
                END
                IF NOT(E) AND TFS$MESSAGE EQ '' THEN
                    GOSUB UPDATE.RUNNING.TOTAL
                END
            END ELSE
                COMI = ''
            END

        CASE AF EQ TFS.PRODUCT.CATEG
            IF COMI THEN
                BEGIN CASE
                    CASE NOT(R.NEW(TFS.ACCOUNT.DR)<1,AV> MATCHES '2A1N0X') AND NOT(R.NEW(TFS.ACCOUNT.CR)<1,AV> MATCHES '2A1N0X')
                        E = 'EB-TFS.INPUT.NOT.ALLOWED'
                    CASE R.NEW(TFS.ACCOUNT.DR)<1,AV> MATCHES '2A1N0X'
                        IF R.NEW(TFS.ACCOUNT.DR)<1,AV>[5] GE 60000 AND R.NEW(TFS.ACCOUNT.DR)<1,AV>[5] LE 69999 THEN
                            E = 'EB-TFS.INPUT.NOT.ALLOWED'
                        END
                    CASE R.NEW(TFS.ACCOUNT.CR)<1,AV> MATCHES '2A1N0X'
                        IF R.NEW(TFS.ACCOUNT.CR)<1,AV>[5] GE 60000 AND R.NEW(TFS.ACCOUNT.CR)<1,AV>[5] LE 69999 THEN
                            E = 'EB-TFS.INPUT.NOT.ALLOWED'
                        END
                END CASE
            END ELSE
                BEGIN CASE
                    CASE R.NEW(TFS.ACCOUNT.DR)<1,AV> MATCHES '2A1N0X'
                        IF R.NEW(TFS.ACCOUNT.DR)<1,AV>[5] GE 50000 AND R.NEW(TFS.ACCOUNT.DR)<1,AV>[5] LE 59999 THEN
                            E = 'EB-INPUT.MISSING'
                        END

                    CASE R.NEW(TFS.ACCOUNT.CR)<1,AV> MATCHES '2A1N0X'
                        IF R.NEW(TFS.ACCOUNT.CR)<1,AV>[5] GE 50000 AND R.NEW(TFS.ACCOUNT.CR)<1,AV>[5] LE 59999 THEN
                            E = 'EB-INPUT.MISSING'
                        END
                END CASE
            END
            IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> NE 'DC' THEN
                E = '' ; COMI = ''
            END

        CASE AF EQ TFS.CUSTOMER.NO
            IF NOT(COMI) THEN
                IF (R.NEW(TFS.ACCOUNT.DR)<1,AV> MATCHES '2A1N0X' OR R.NEW(TFS.ACCOUNT.CR)<1,AV> MATCHES '2A1N0X') AND NOT(R.NEW(TFS.ACCOUNT.OFFICER)<1,AV>) THEN
                    E = 'EB-INPUT.MISSING'
                END
            END

        CASE AF EQ TFS.ACCOUNT.OFFICER
            IF NOT(COMI) THEN
                IF (R.NEW(TFS.ACCOUNT.DR)<1,AV> MATCHES '2A1N0X' OR R.NEW(TFS.ACCOUNT.CR)<1,AV> MATCHES '2A1N0X') AND NOT(R.NEW(TFS.CUSTOMER.NO)<1,AV>) THEN
                    E = 'EB-INPUT.MISSING'
                END
            END

        CASE AF EQ TFS.DC.REVERSE.MARK
            IF COMI THEN
                IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> NE 'DC' THEN
                    E = 'EB-TFS.INPUT.NOT.ALLOWED'
                END
            END
            IF R.NEW(TFS.REVERSAL.MARK)<1,AV> THEN
*
* If we are trying to reverse this line, then this DC.REVERSE.MARK should be the same as
* what it was when the line was originally processed
*
                UL.TXN.ID = R.NEW(TFS.UNDERLYING)<1,AV>
                UL.TXN.ID.IN.ROLD = R.OLD(TFS.UNDERLYING)
                LOCATE UL.TXN.ID IN UL.TXN.ID.IN.ROLD<1,1> SETTING UL.IN.ROLD.POS THEN
                    IF R.OLD(TFS.DC.REVERSE.MARK)<1,UL.IN.ROLD.POS> NE COMI THEN
                        E = 'EB-TFS.CANT.BE.CHANGED.FROM' :@FM: DQUOTE(R.OLD(TFS.DC.REVERSE.MARK)<1,UL.IN.ROLD.POS>)
                    END
                END ELSE
                    IF R.NEW(TFS.IMPORT.UL)<1,AV> THEN
* Nothing
                    END ELSE
                        IF R.NEW(TFS.CURR.NO) GT 1 THEN
                            E = 'EB-TFS.CANT.FIND.UL.IN.R.OLD' :@FM: UL.TXN.ID
                        END
                    END
                END
            END
            IF NOT(E) AND COMI THEN
                COMI.ENRI = 'This DC is a Reversal Entry'
            END

        CASE AF EQ TFS.SURROGATE.AC
            IF COMI THEN
                GOSUB GET.AC.ENRI
            END ELSE
                ! 12 SEP 07 - Sathish PS /s
                IF TFS$R.TFS.TXN(AV)<TFS.TXN.SURROGATE.AC> NE '' THEN
                    E = 'EB-INPUT.MISSING'
                END ELSE
                    ! 12 SEP 07 - Sathish PS /e
                    IF PRIMARY.ACCOUNT THEN
                        COMI = PRIMARY.ACCOUNT
                        GOSUB GET.AC.ENRI
                    END
                END
            END

        CASE AF EQ TFS.CHQ.TYPE
            DR.AC = R.NEW(TFS.ACCOUNT.DR)<1,AV>
            CALL F.READ(FN.AC,DR.AC,R.AC,F.AC,ERR.AC)
            DR.TXN.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.TXN.CODE>
            CALL F.READ(FN.TXN,DR.TXN.CODE,R.TXN,F.TXN,ERR.TXN)
            IF COMI THEN
                IF R.AC<AC.CUSTOMER> EQ '' THEN
                    E = 'EB-TFS.CHQ.TYPE.INP.ALLOWED.FOR.CUS'
                END
            END ELSE
                IF R.TXN<AC.TRA.CHEQUE.IND> EQ 'Y' AND R.AC<AC.CUSTOMER> NE '' THEN
                    IF R.TXN<AC.TRA.CHQ.TYPE> THEN
                        COMI = R.TXN<AC.TRA.CHQ.TYPE>
                    END ELSE
                        E = 'EB-TFS.INPUT.MAND' :@FM: 'Txn ':DR.TXN.CODE
                    END
                END
            END

        CASE AF EQ TFS.CHEQUE.NUMBER
* 30 Apr 2008 /s
            !DR.TXN.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.TXN.CODE>
            !CALL F.READ(FN.TXN,DR.TXN.CODE,R.TXN,F.TXN,ERR.TXN)
            !IF COMI THEN
            !   IF R.TXN<AC.TRA.CHEQUE.IND> NE 'Y' THEN
            !       IF R.NEW(TFS.REVERSAL.MARK)<1,AV> EQ '' AND R.NEW(TFS.R.UNDERLYING)<1,AV> EQ '' THEN
            ! E = 'EB-TFS.CHEQUE.IND.NOT.SET.Y'
            !      END
            ! END
            !        END ELSE
            !           IF R.NEW(TFS.CHQ.TYPE)<1,AV> THEN
            !              E = 'EB-INPUT.MISSING'
            !         END ELSE
            !            IF R.TXN<AC.TRA.CHEQUE.IND> EQ 'Y' THEN
            !E = 'EB-TFS.INPUT.MAND' :FM: 'Txn ':DR.TXN.CODE
            !           END
            !      END
            ! END
* 30 Apr 2008 /e

        CASE AF EQ TFS.REVERSAL.MARK
            IF COMI THEN
                IF R.NEW(TFS.UNDERLYING)<1,AV> THEN
                    IF R.NEW(TFS.R.UNDERLYING)<1,AV> THEN
                        IF R.NEW(TFS.R.UL.STATUS)<1,AV> MATCHES 'AUT' :@VM: 'REVE' THEN
                            E = 'EB-TFS.TXN.ALREADY.REVERSED'
                        END ELSE
                            COMI.ENRI = 'Undo REV'
                        END
                    END ELSE
                        IF COMI EQ 'R' THEN
                            GOSUB CHECK.SUPPORT.FOR.REVERSAL
                            IF NOT(E) THEN
                                UL.TXN.ID = R.NEW(TFS.UNDERLYING)<1,AV>
                                IF R.NEW(TFS.CURR.NO) GT 1 THEN
                                    UL.TXN.ID.IN.ROLD = R.OLD(TFS.UNDERLYING)
                                    LOCATE UL.TXN.ID IN UL.TXN.ID.IN.ROLD<1,1> SETTING UL.IN.ROLD.POS THEN
                                        COMI.ENRI = 'Marked REV'
                                    END ELSE
                                        IF R.NEW(TFS.IMPORT.UL)<1,AV> THEN
                                            COMI.ENRI = 'Marked REV'
                                        END ELSE
                                            E = 'EB-TFS.CANT.FIND.UL.IN.R.OLD' :@FM: UL.TXN.ID
                                        END
                                    END
                                END ELSE
                                    COMI.ENRI = 'Marked REV'
                                END
                            END
                        END
                    END
                END ELSE
                    E = 'EB-TFS.CANT.REVERSE.NON.EXIST.TXN'
                END
            END ELSE    ;* 26 Sep 07 - /s
                IF R.NEW(TFS.NET.ENTRY) NE 'NO' OR R.NEW(TFS.ACCOUNTING.STYLE) EQ 'ATOMIC' THEN
                    LOCATE 'R' IN R.NEW(TFS.REVERSAL.MARK)<1,1> SETTING REV.LINE.POS THEN
                        IF REV.LINE.POS NE AV THEN
                            E = 'EB-TFS.REVERSE.ALL.LINES'
                        END
                    END
                END
            END         ;* 26 Sep 07 /e

        CASE AF EQ TFS.CR.DENOM

        CASE AF EQ TFS.CR.DEN.UNIT
            GOSUB DENOMINATION.PROCESSING

        CASE AF EQ TFS.CR.SERIAL.NO
            AC.NO = R.NEW(TFS.ACCOUNT.CR)<1,AV> ; DENOM = R.NEW(TFS.CR.DENOM)<1,AV,AS>
            GOSUB VALIDATE.SERIAL.NO


        CASE AF EQ TFS.DR.DENOM

        CASE AF EQ TFS.DR.DEN.UNIT
            GOSUB DENOMINATION.PROCESSING

        CASE AF EQ TFS.DR.SERIAL.NO
            AC.NO = R.NEW(TFS.ACCOUNT.DR)<1,AV> ; DENOM = R.NEW(TFS.DR.DENOM)<1,AV,AS>
            GOSUB VALIDATE.SERIAL.NO

        CASE AF EQ TFS.IMPORT.UL
            IF COMI THEN
                GOSUB IMPORT.UNDERLYING
            END

        CASE AF EQ TFS.RETRY
            IF COMI THEN
                IF R.NEW(TFS.UNDERLYING)<1,AV> THEN
                    E = 'EB-TFS.CANT.RETRY.LINE.ALREADY.DONE'
                END ELSE
                    IF NOT(R.NEW(TFS.VAL.ERROR)<1,AV>) THEN
                        E = 'EB-TFS.LINE.NOT.PROCESSED.YET'
                    END
                END
            END ELSE
                IF R.NEW(TFS.VAL.ERROR)<1,AV> AND NOT(R.NEW(TFS.UNDERLYING)<1,AV>) AND R.NEW(TFS.ACCOUNTING.STYLE) NE 'ATOMIC' THEN
                    E = 'EB-INPUT.MISSING'
                END
            END

        CASE AF EQ TFS.PRIMARY.ACCOUNT
            IF COMI THEN
                CALL CACHE.READ(FN.AC,COMI,R.AC,ERR.AC)
                IF R.AC<AC.CUSTOMER> THEN
                    R.NEW(TFS.PRIMARY.CUSTOMER) = R.AC<AC.CUSTOMER>
                    FIELD.TO.DEF = TFS.PRIMARY.CUSTOMER ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                END
            END
            IF COMI NE PRIMARY.ACCOUNT THEN
                R.NEW(TFS.AMOUNT)<1,AV> = ""
            END

        CASE AF EQ TFS.PRIMARY.CUSTOMER
            IF COMI THEN
                PRIMARY.ACCOUNT = PRIMARY.ACCOUNT
                IF PRIMARY.ACCOUNT THEN
                    PRIMARY.ACCOUNT = PRIMARY.ACCOUNT
                    CALL CACHE.READ(FN.AC,PRIMARY.ACCOUNT,R.AC,ERR.AC)
                    IF R.AC<AC.CUSTOMER> NE COMI THEN
                        E = 'EB-TFS.AC.DOESNT.BELONG.TO.CU' :@FM: PRIMARY.ACCOUNT :@VM: COMI
                    END
                END ELSE
                    CALL CACHE.READ(FN.CA,COMI,R.CA,ERR.CA)
                    IF R.CA THEN
                        LOOP
                            REMOVE ID.AC FROM R.CA SETTING NEXT.ID.AC.POS
                        WHILE ID.AC : NEXT.ID.AC.POS DO
                            CALL CACHE.READ(FN.AC,ID.AC,R.AC,ERR.AC)
                            IF R.AC THEN
                                IF R.AC<AC.CURRENCY> EQ LCCY THEN
                                    PRIMARY.ACCOUNT = ID.AC
                                    BREAK
                                END
                            END
                        REPEAT
                    END
                    IF PRIMARY.ACCOUNT THEN
                        R.NEW(TFS.PRIMARY.ACCOUNT) = PRIMARY.ACCOUNT
                        FIELD.TO.DEF = TFS.PRIMARY.ACCOUNT ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                    END
                END
            END


        CASE AF EQ TFS.ACCOUNTING.STYLE
            T(TFS.RETRY)<3> = ''
            IF NOT(COMI) THEN
                COMI = TFS$R.TFS.PAR<TFS.PAR.DEF.ACCNTG.STYLE>
            END
            IF COMI THEN
                BEGIN CASE
                    CASE COMI EQ 'ATOMIC'
                        COMI.ENRI = 'Entries - All Done or None'
                        T(TFS.RETRY)<3> = 'NOINPUT'

                    CASE COMI EQ 'INDEPENDENT'
                        COMI.ENRI = 'Entries - Independent of each other'
                END CASE
            END
            ! 29 AUG 07 - Sathish PS /s
        CASE AF EQ TFS.NET.ENTRY
            ! 11 SEP 07 - Sathish PS /s
            !        IF COMI EQ 'YES' THEN
            IF COMI THEN
                IF COMI NE 'NO' THEN
                    ! 11 SEP 07 - Sathish PS /e
                    IF NOT(R.NEW(TFS.PRIMARY.ACCOUNT)) THEN
                        E = 'EB-PRIMARY.ACCOUNT.INPUT.MISSING'
                    END
                END
                ! 11 SEP 07 - Sathish PS /s
            END ELSE
                COMI = 'NO'
            END
            ! 11 SEP 07 - Sathish PS /e

        CASE AF EQ TFS.CREATE.NET.ENTRY
            REVERSE.NET.ENTRY = 0 ;* 26 Sep 07 s/e
            BEGIN CASE
                CASE COMI EQ 'YES'
                    IF R.NEW(TFS.NET.ENTRY) NE 'NO' THEN
                        BEGIN CASE
                            CASE TFS$MESSAGE EQ ''  ;* 04 SEP 07 - Sathish PS s/e
                                IF TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU> THEN
                                    GOSUB CREATE.NETTED.ENTRIES
                                END ELSE
                                    E = 'EB-TFS.PAR.WASHTHRU.CATEG.MISSING'
                                END

                            CASE OTHERWISE

                        END CASE
                        !* 12 SEP 07 - Sathish PS /e
                    END ELSE
                        E = 'EB-INP.NOT.ALLOWED'
                    END
* PACS00312677 - S
*COMI = ''         ;* 12 SEP 07 - Sathish PS s/e
* PACS00312677 - E

                    ! 12 SEP 07 - Sathish PS /s
                CASE COMI EQ 'NO'
                    BEGIN CASE
                        CASE TFS$MESSAGE EQ ''
                            GOSUB REFRESH.NETTED.ENTRIES
                        CASE OTHERWISE
                    END CASE
                    ! 12 SEP 07 - Sathish PS /s

                    ! 26 Sep 07 - Sathish PS /s
                CASE COMI EQ 'REVERSE'
                    IF R.NEW(TFS.NET.ENTRY) NE 'NO' THEN
                        BEGIN CASE
                            CASE TFS$MESSAGE EQ ''
                                IF TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU> THEN ;* 04 OCT 07 - Sathish PS s/e
                                    REVERSE.NET.ENTRY = 1
                                    GOSUB CREATE.NETTED.ENTRIES
                                END ELSE
                                    E = 'EB-TFS.PAR.WASHTHRU.CATEG.MISSING'
                                END
                            CASE OTHERWISE
                        END CASE
                        ! 04 OCT 07 - Sathish PS /e
                    END ELSE
                        E = 'EB-INP.NOT.ALLOWED'
                    END
* PACS00312677 - S
*COMI = ''
* PACS00312677 - E
                    ! 26 SEP 07 - Sathish PS /e
                CASE OTHERWISE
            END CASE

            ! 29 AUG 07 - Sathish PS /e

    END CASE
    IF TFS$MESSAGE EQ '' OR E THEN
        IF DEFAULTED.FIELD THEN
            CALL REFRESH.FIELD(DEFAULTED.FIELD,DEFAULTED.ENRI)
        END ELSE
            IF NOT(GTSACTIVE) AND TFS$MESSAGE EQ '' THEN
                CALL REBUILD.SCREEN
            END
        END
    END

RETURN
*----------------------------------------------------------------------*
*                 L O C A L   S U B R O U T I N E S                    *
*----------------------------------------------------------------------*
MIX.WD.AMT.VALIDATIONS:
*----------------------*
    TOTAL.AMT.CHANGED ='0'
    SPLIT.CHANGED= '0'
*
    IF COMI NE R.NEW(TFS.STORE.MIX.WD.AMT) THEN   ;*  If Total amount changed PS/GP 07/20/05 S/E
        GOSUB CALL.MIX.WD.API ;*split
        TOTAL.AMT.CHANGED = '1'         ;*1st time split need to refresh and populate lines
    END
    GOSUB COMPARE.SPLIT.AMT.WITH.STORED

*
    IF SPLIT.CHANGED EQ '1'OR TOTAL.AMT.CHANGED EQ '1' THEN
        GOSUB COMPARE.WITH.TOTAL.AMT
        IF E = '' THEN
            GOSUB REFRESH.MIX.TRANSACTION.LINES   ;*delete previous lines
            GOSUB POPULATE.MIX.TXN.LINES
        END
    END
    GOSUB STORE.POPULATED.AMT
*
RETURN          ;*from mix.wd.amt validations
*--------------------------------------------------------------------------------- *
COMPARE.WITH.TOTAL.AMT:
*---------------------*

    SPLIT.VM.CNT = DCOUNT(R.NEW(TFS.MIX.WD.SRC.AMT),@VM)

    FOR II=1 TO SPLIT.VM.CNT
        TOT.AMT.FROM.SPLIT += R.NEW(TFS.MIX.WD.SRC.AMT)<1,II>

    NEXT II
    IF TOT.AMT.FROM.SPLIT NE R.NEW(TFS.MIX.WD.AMOUNT) AND TOTAL.AMT.CHANGED NE '1' THEN
        E = "EB-TFS.MIX.AMT.NE.SPLIT.TOTAL"
        AF = TFS.MIX.WD.SRC.AMT
    END

RETURN          ;*comp with total amt
*--------------------------------------------------------------------------------------*
COMPARE.SPLIT.AMT.WITH.STORED:
*---------------------------*

    SPLIT.VM.CNT = DCOUNT(R.NEW(TFS.MIX.WD.SRC.AMT),@VM)
*    LOG.MSG = "COMPARE":II :SPLIT.VM.CNT ; GOSUB LOG.MESSAGE
    FOR II=1 TO SPLIT.VM.CNT
        IF  R.NEW (TFS.STORE.SPLIT.AMT)<1,II> NE R.NEW(TFS.MIX.WD.SRC.AMT)<1,II> THEN
            SPLIT.CHANGED =1
            II = SPLIT.VM.CNT ;*Get out of here!

        END ELSE
            SPLIT.CHANGED = '0'
        END

    NEXT II

    IF AF EQ TFS.MIX.WD.SRC.AMT  THEN
    END

RETURN          ;*from compare split amt
*-----------------------------------------------------------------------------------*
STORE.POPULATED.AMT:
*-------------------*
*                                           whole of this is for a browser bug
    IF AF EQ TFS.MIX.WD.AMOUNT THEN
        R.NEW(TFS.STORE.MIX.WD.AMT) = COMI
    END
    SPLIT.VM.CNT = DCOUNT(R.NEW(TFS.MIX.WD.SRC.AMT),@VM)
    FOR II =1 TO SPLIT.VM.CNT
        R.NEW (TFS.STORE.SPLIT.AMT)<1,II> = R.NEW(TFS.MIX.WD.SRC.AMT)<1,II>
    NEXT II
    IF AF EQ TFS.MIX.WD.SRC.AMT THEN
        R.NEW(TFS.STORE.SPLIT.AMT)<1,AV> = COMI
    END

RETURN          ;*from store populated amt

*-------------------------------------------------------------------------------- *
REFRESH.SPLIT.TXN.LINES:
*--------------------------*
    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)

    FOR XX = NO.OF.TXNS TO  2 STEP -1
        IF R.NEW(TFS.MIX.WITHDRAWAL)<1,XX> EQ 'YES' THEN
            FOR FLD.CNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD         ;* 07/09/05  - Sathish PS /s
                DEL R.NEW(FLD.CNT)<1,XX>
            NEXT FLD.CNT
        END
    NEXT XX

RETURN          ;*from clear mix transaction lines
*------------------------------------------------------------------------------
REFRESH.MIX.TRANSACTION.LINES:
*--------------------------*
    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)

    FOR XX = NO.OF.TXNS TO  1 STEP -1
        IF R.NEW(TFS.MIX.WITHDRAWAL)<1,XX> EQ 'YES' THEN
            FOR FLD.CNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD         ;* 07/09/05  - Sathish PS /s
                DEL R.NEW(FLD.CNT)<1,XX>
            NEXT FLD.CNT      ;* 07/09/05 - Sathish PS /e
        END
    NEXT XX

RETURN          ;*from clear mix transaction lines
*------------------------------------------------------------------------------
CALL.MIX.WD.API:
*--------------*
    API.COUNT = DCOUNT(TFS$R.TFS.PAR<TFS.PAR.MIX.WD.API>,@VM)

    FOR II =1 TO API.COUNT
        IF TFS$R.TFS.PAR<TFS.PAR.MIX.WD.API,II> NE '' THEN
            API.TO.CALL = TFS$R.TFS.PAR<TFS.PAR.MIX.WD.API,II>
            CALL  @API.TO.CALL
        END
    NEXT II

RETURN          ;*from call mix wd api
*------------------------------------------------------------------------------
POPULATE.MIX.TXN.LINES:
*---------------------*

    IF AF EQ TFS.MIX.WD.AMOUNT THEN
        WHOLE.AMT = COMI
    END ELSE
        WHOLE.AMT = R.NEW(TFS.MIX.WD.AMOUNT)<1,1>
    END
    WASH.TFS.TXN.TYPE = TFS$R.TFS.PAR<TFS.PAR.MIX.WASH.TXN.TYPE>
    MIX.WD.SRC.ACCS = R.NEW(TFS.MIX.WD.SRC.ACC)
    IF R.NEW(TFS.MIX.WD.SRC.ACC) THEN
* First populate the Customer to Washthru TFS Line
        IF NOT(R.NEW(TFS.MIX.WD.CCY)) THEN
            R.NEW(TFS.MIX.WD.CCY) = LCCY
        END
        MIX.WD.WTHRU.AC = R.NEW(TFS.MIX.WD.CCY) : TFS$R.TFS.PAR<TFS.PAR.MIX.WD.WASH.THRU> : '0001'
        TFS.TXN = WASH.TFS.TXN.TYPE ; CR.AC = MIX.WD.WTHRU.AC ; DR.AC = ''
        CCY = R.NEW(TFS.MIX.WD.CCY) ; AMT = WHOLE.AMT
        GOSUB POPULATE.TFS.LINE
        GOSUB HANDLE.BREAKUP  ;* 08/25/05  GP -S/E
    END

RETURN          ;*pop.mix.txn.lines
*------------------------------------------------------------------------------
HANDLE.BREAKUP:
*-------------*
* Now for the break ups                           ;*08/25/05 GP moved whole para
    NO.OF.MIX.ACCS = DCOUNT(R.NEW(TFS.MIX.WD.SRC.ACC),@VM)
    MIX.WD.WTHRU.AC = R.NEW(TFS.MIX.WD.CCY) : TFS$R.TFS.PAR<TFS.PAR.MIX.WD.WASH.THRU> : '0001'
    FOR MIX.CNT = 1 TO NO.OF.MIX.ACCS
        MIX.WD.SRC.ACC = R.NEW(TFS.MIX.WD.SRC.ACC)<1,MIX.CNT>
        MIX.WD.SRC.AMT = R.NEW(TFS.MIX.WD.SRC.AMT)<1,MIX.CNT>
        IF NOT(MIX.WD.SRC.AMT) THEN
            MIX.WD.SRC.AMT = COMI
        END
        IF MIX.WD.SRC.AMT THEN
            MIX.WD.SRC.CAT = MIX.WD.SRC.ACC[4,5]
            LOCATE MIX.WD.SRC.CAT IN TFS$R.TFS.PAR<TFS.PAR.MIX.WD.SRC.CAT,1> SETTING SRC.CAT.POS THEN
                TFS.TXN = TFS$R.TFS.PAR<TFS.PAR.MIX.WD.TXN.TYPE,SRC.CAT.POS>
            END ELSE
                TFS.TXN = ''
            END
            DR.AC = MIX.WD.WTHRU.AC ; CR.AC = MIX.WD.SRC.ACC
            CCY = R.NEW(TFS.MIX.WD.CCY) ; AMT = MIX.WD.SRC.AMT
            IF MIX.CNT EQ '2' AND AF EQ TFS.MIX.WD.SRC.AMT THEN       ;*GP
                IF AMT EQ '' THEN
                    AMT = COMI
                END
            END
            GOSUB POPULATE.TFS.LINE
        END
    NEXT MIX.CNT

    GOSUB HANDLE.DENOM.EXPANSION        ;*09/02/05 GP - s/e
RETURN          ;*from HANDLE BREAKUP

*------------------------------------------------------------------------------

POPULATE.TFS.LINE:

    IF R.NEW(TFS.TRANSACTION) THEN
        APPEND.DELIM = @VM
    END ELSE
        APPEND.DELIM = ''
    END
    FOR FLD.CNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD
        BEGIN CASE
            CASE FLD.CNT EQ TFS.TRANSACTION
                R.NEW(FLD.CNT) := APPEND.DELIM : TFS.TXN

            CASE FLD.CNT EQ TFS.ACCOUNT.CR
                R.NEW(FLD.CNT) := APPEND.DELIM : CR.AC

            CASE FLD.CNT EQ TFS.ACCOUNT.DR
                R.NEW(FLD.CNT) := APPEND.DELIM : DR.AC

            CASE FLD.CNT EQ TFS.CURRENCY
                R.NEW(FLD.CNT) := APPEND.DELIM : CCY

            CASE FLD.CNT EQ TFS.AMOUNT
                R.NEW(FLD.CNT) := APPEND.DELIM : AMT

            CASE FLD.CNT EQ TFS.MIX.WITHDRAWAL
                R.NEW(FLD.CNT) := APPEND.DELIM : 'YES'

            CASE OTHERWISE
                R.NEW(FLD.CNT) := APPEND.DELIM : ''

        END CASE
    NEXT FLD.CNT

RETURN
*------------------------------------------------------------------------------
* 10 OCT 06 - Sathish PS /s
CALCULATE.CASH.BACK:

    ! 21 MAY 07 - Sathish PS /s
    IF NOT(DEPOSIT.CCY) OR NOT(CASH.BACK.CCY) THEN
        RETURN
    END
    ! 21 MAY 07 - Sathish PS /e
    IF DEPOSIT.AMOUNT EQ '' AND ACTUAL.DEPOSIT EQ '' THEN
        CASH.BACK = ''
    END ELSE
        CASH.BACK = DEPOSIT.AMOUNT - ACTUAL.DEPOSIT
    END
    IF DEPOSIT.CCY NE CASH.BACK.CCY THEN
        E = 'EB-TFS.CASHBACK.CCY.NE.DEPOSIT.CCY'  ;* For the time being
* Add code here to handle Cash Back Currency being different from Deposit Currency
    END
    IF AF EQ TFS.CASH.BACK THEN
        COMI = CASH.BACK
    END ELSE
        IF CASH.BACK EQ '0' OR CASH.BACK EQ '0.00' THEN
* PACS00269522 - S
            R.NEW(TFS.CASH.BACK) = '0'
* PACS00269522 - E
        END ELSE
            R.NEW(TFS.CASH.BACK) = CASH.BACK
        END
    END
RETURN
*------------------------------------------------------------------------------
INSERT.CASH.BACK.LINES:

    IF R.NEW(TFS.CASH.BACK) NE R.NEW(TFS.STORE.CASH.BACK) THEN        ;* Value stored to overcome Browser issue
        DEPOSIT.AMOUNT = R.NEW(TFS.DEPOSIT.AMOUNT)
        ACTUAL.DEPOSIT = R.NEW(TFS.ACTUAL.DEPOSIT)
        DEPOSIT.CCY = R.NEW(TFS.DEPOSIT.CCY)
        CASH.BACK = R.NEW(TFS.CASH.BACK)
        CASH.BACK.CCY = R.NEW(TFS.CASH.BACK.CCY)
        GOSUB CHECK.TELLER.ID
        IF NOT(E) THEN
            GOSUB REFRESH.CASH.BACK.LINES
            CASH.BACK.WTHRU = TFS$R.TFS.PAR<TFS.PAR.CASH.BACK.WTHRU>
*
            IF CASH.BACK.WTHRU THEN
                GOSUB INSERT.CASH.BACK.LINES.WITH.WASHTHRU
            END ELSE
                GOSUB INSERT.CASH.BACK.LINES.WITHOUT.WASHTHRU
            END
        END
        R.NEW(TFS.STORE.CASH.BACK) = R.NEW(TFS.CASH.BACK)
    END

RETURN
*------------------------------------------------------------------------------
REFRESH.CASH.BACK.LINES:

    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)

    FOR XX = NO.OF.TXNS TO  2 STEP -1
        IF R.NEW(TFS.CASH.BACK.TXN)<1,XX> EQ 'YES' THEN
            FOR FLD.CNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD         ;* 07/09/05  - Sathish PS /s
                DEL R.NEW(FLD.CNT)<1,XX>
            NEXT FLD.CNT
        END
    NEXT XX

RETURN          ;*from clear cash back transaction lines
*------------------------------------------------------------------------------
INSERT.CASH.BACK.LINES.WITH.WASHTHRU:

* Txn 1 - Cash Deposit to Customer Account
    TFS.TXN = TFS$R.TFS.PAR<TFS.PAR.CASH.BACK.TXN.1>
    IF NOT(TFS.TXN) THEN
        E = 'EB-TFS.CASH.BACK.TXN.1.MISSING'
    END
    AMT = ACTUAL.DEPOSIT
    CCY = DEPOSIT.CCY
    IN.OUT = 'OUT'
    GOSUB POPULATE.CASH.BACK.LINE
* Txn 2 - Cash Incoming
    TFS.TXN = TFS$R.TFS.PAR<TFS.PAR.CASH.BACK.TXN.2>
    IF NOT(TFS.TXN) THEN
        E = 'EB-TFS.CASH.BACK.TXN.2.MISSING'
    END
    AMT = DEPOSIT.AMOUNT
    CCY = DEPOSIT.CCY
    IN.OUT = 'IN'
    GOSUB POPULATE.CASH.BACK.LINE
* Txn 3 - Cash Outgoing
    TFS.TXN = TFS$R.TFS.PAR<TFS.PAR.CASH.BACK.TXN.3>
    IF NOT(TFS.TXN) THEN
        E = 'EB-TFS.CASH.BACK.TXN.3.MISSING'
    END
    AMT = CASH.BACK
    CCY = CASH.BACK.CCY
    IN.OUT = 'OUT'
* PACS00331852 - S
    IF AMT NE '0' THEN
        GOSUB POPULATE.CASH.BACK.LINE
    END
* PACS00331852 - E

RETURN
*---------------------------------------------------------------------------------
INSERT.CASH.BACK.LINES.WITHOUT.WASHTHRU:

* When there can be 2 entries to the Customer a/c - where there is no need for an
* additional wash-thru account
* Txn 1 - Cash Deposit to Customer Account
    TFS.TXN = TFS$R.TFS.PAR<TFS.PAR.CASH.BACK.TXN.1>
    IF NOT(TFS.TXN) THEN
        E = 'EB-TFS.CASH.BACK.TXN.1.MISSING'
    END
    AMT = DEPOSIT.AMOUNT
    CCY = DEPOSIT.CCY
    IN.OUT = 'OUT'
    GOSUB POPULATE.CASH.BACK.LINE
* Txn 2 - Cash Outgoing
    TFS.TXN = TFS$R.TFS.PAR<TFS.PAR.CASH.BACK.TXN.2>
    IF NOT(TFS.TXN) THEN
        E = 'EB-TFS.CASH.BACK.TXN.2.MISSING'
    END
    AMT = CASH.BACK
    CCY = CASH.BACK.CCY
    IN.OUT = 'IN'
    GOSUB POPULATE.CASH.BACK.LINE

RETURN
*----------------------------------------------------------------------------------
POPULATE.CASH.BACK.LINE:

    IF NOT(E) THEN
        IF R.NEW(TFS.TRANSACTION) THEN
            APPEND.DELIM = @VM
        END ELSE
            APPEND.DELIM = ''
        END
        FOR FLD.CNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD
            BEGIN CASE
                CASE FLD.CNT EQ TFS.TRANSACTION
                    R.NEW(FLD.CNT) := APPEND.DELIM : TFS.TXN

                CASE FLD.CNT EQ TFS.CURRENCY
                    R.NEW(FLD.CNT) := APPEND.DELIM : CCY

                CASE FLD.CNT EQ TFS.AMOUNT
                    R.NEW(FLD.CNT) := APPEND.DELIM : AMT

                CASE FLD.CNT EQ TFS.ACCOUNT.CR
                    R.NEW(FLD.CNT) := APPEND.DELIM : CR.AC

                CASE FLD.CNT EQ TFS.CASH.BACK.DIR
                    R.NEW(FLD.CNT) := APPEND.DELIM : IN.OUT

                CASE FLD.CNT EQ TFS.CASH.BACK.TXN
                    R.NEW(FLD.CNT) := APPEND.DELIM : 'YES'

                CASE OTHERWISE
                    R.NEW(FLD.CNT) := APPEND.DELIM : ''

            END CASE
        NEXT FLD.CNT
    END

RETURN
* 10 OCT 06 - Sathish PS /e
*------------------------------------------------------------------------------
HANDLE.DENOM.EXPANSION:
*---------------------*
    NO.OF.TFS.LINES = DCOUNT(R.NEW(TFS.TRANSACTION),@VM)     ;*09/02/05 GP - whole para
    FOR TFS.LINE.CNT =1 TO  NO.OF.TFS.LINES
        SAV.AF = AF  ; SAV.COMI = COMI
        SAV.E = E    ; SAV.AV = AV ; SAV.AS =AS

        AF = TFS.AMOUNT ;AV = TFS.LINE.CNT
        COMI = R.NEW(TFS.AMOUNT)<1,TFS.LINE.CNT>
*        CALL T24.FS.CHECK.FIELDS
        APAP.TFS.t24FsCheckFields() ;*R22 Manual Conversion
        AF = SAV.AF ; COMI = SAV.COMI
        E = SAV.E ; AV = SAV.AV ; AS = SAV.AS
    NEXT TFS.LINE.CNT

RETURN          ;*from HANDLE.DENOM.EXP
*------------------------------------------------------------------------------
CLEAR.OTHER.FIELDS:

    IF FIELDS.TO.RESET<1,1> THEN
        LOOP
            REMOVE FIELD.TO.RESET FROM FIELDS.TO.RESET SETTING NEXT.FIELD.POS
        WHILE FIELD.TO.RESET : NEXT.FIELD.POS DO

            IF R.NEW(FIELD.TO.RESET)<1,AV> THEN
                R.NEW(FIELD.TO.RESET)<1,AV> = ''
                FIELD.TO.DEF = FIELD.TO.RESET :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            END

        REPEAT
    END
    FIELDS.TO.RESET = FIELDS.TO.RESET

RETURN
*------------------------------------------------------------------------------
CHECK.TELLER.ID:

    IF NOT(TELLER.ID) THEN
* 29 AUG 07 - Sathish PS /s
        !    CALL TFS.GET.OPEN.TILL(TELLER.ID)
        !    IF NOT(TELLER.ID) THEN E = 'EB-TFS.TELLER.ID.MISSING' :FM: OPERATOR
        ! Commented due to some strange failure in TFS.AMOUNT check fields...
        ! 29 AUG 07 - Sathish PS /e
        TU.ID = OPERATOR
        CALL F.READ(FN.TU,TU.ID,R.TU,F.TU,ERR.TU)
        LOOP
            REMOVE TELLER.ID FROM R.TU SETTING NEXT.ID.POS
        WHILE TELLER.ID : NEXT.ID.POS DO
            CALL F.READ(FN.TI,TELLER.ID,R.TI,F.TI,ERR.TI)
            IF R.TI THEN
                IF R.TI<TT.TID.STATUS> EQ 'OPEN' THEN
                    CALL F.READ(FN.TI.NAU,TELLER.ID,R.TI.NAU,F.TI.NAU,ERR.TI.NAU)
                    IF R.TI.NAU THEN
                        E = 'TT-UNAUTH.TEL.ID.EXISTS'
                    END ELSE
                        BREAK
                    END
                END ELSE
                    CONTINUE
                END
            END ELSE
                E = 'EB-TFS.TELLER.ID.MISSING' :@FM: OPERATOR
            END
        REPEAT
    END

    IF NOT(TELLER.ID) THEN
        E = 'EB-TFS.TELLER.ID.MISSING' :@FM: OPERATOR        ;* 18 SEP 07 - Sathish PS s/e
    END

    IF E THEN
        TELLER.ID = ''
    END

RETURN
*-----------------------------------------------------------------------
! 29 AUG 07 - Sathish PS /s
CREATE.NETTED.ENTRIES:

    NET.ENTRY.WTHRU.CATEG = TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU> ;* 12 SEP 07 - Sathish PS s/e
    GOSUB REFRESH.NETTED.ENTRIES
    IF NOT(REVERSE.NET.ENTRY) THEN      ;* 26 Sep 07 - Sathish PS s/e
        GOSUB BUILD.NETTED.ENTRIES
        IF NOT(E) THEN
            GOSUB POPULATE.NETTED.ENTRIES
        END         ;* 26 Sep 07 - Sathish PS s/e
    END

RETURN
*-----------------------------------------------------------------------
REFRESH.NETTED.ENTRIES:

    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)

    FOR XX = NO.OF.TXNS TO  1 STEP -1
        ! 26 SEP 07 - Sathish PS /s
        IF REVERSE.NET.ENTRY THEN
            IF R.NEW(TFS.UNDERLYING)<1,XX> THEN
                IF R.NEW(TFS.R.UNDERLYING)<1,XX> EQ '' THEN
                    IF R.NEW(TFS.REVERSAL.MARK)<1,XX> EQ '' THEN
                        R.NEW(TFS.REVERSAL.MARK)<1,XX> = 'R'
                    END
                END ELSE
                    E = 'EB-TFS.TXN.ALREADY.REVERSED'
                END
            END ELSE
                E = 'EB-TFS.CANT.REVERSE.NON.EXIST.TXN'
            END
        END ELSE
            ! 26 SEP 07 - Sathish PS /e
            IF R.NEW(TFS.NETTED.ENTRY)<1,XX> EQ 'YES' THEN
                IF R.NEW(TFS.UNDERLYING)<1,XX> EQ '' THEN
                    FOR FLD.CNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD ;* 07/09/05  - Sathish PS /s
                        DEL R.NEW(FLD.CNT)<1,XX>
                    NEXT FLD.CNT
                END
            END
        END
    NEXT XX

RETURN
*-----------------------------------------------------------------------
BUILD.NETTED.ENTRIES:
    NET.ENTRY = R.NEW(TFS.NET.ENTRY)    ;* CREDIT or DEBIT or BOTH or NONE.
    CCY.VAL.ARR = ''
    NETTED.ENTRIES = ''
    ! Lines will be netted by CCY and Value Date
    PRIMARY.AC = R.NEW(TFS.PRIMARY.ACCOUNT)       ;* 12 SEP 07 - Sathish PS s/e
*** TESTING /S
    CALL CACHE.READ(FN.AC,PRIMARY.AC,R.PRI.AC,ERR.PRI.AC)
    IF R.PRI.AC THEN
        PRI.AC.CCY = R.PRI.AC<AC.CURRENCY>
    END
*** TESTING /E

    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)
    N.TFS.TXN.LOOP = 1
    LOOP
        REMOVE N.TFS.TXN FROM ALL.TXNS SETTING NEXT.N.TFS.TXN.POS
    WHILE N.TFS.TXN : NEXT.N.TFS.TXN.POS DO

        IF R.NEW(TFS.UNDERLYING)<1,N.TFS.TXN.LOOP> EQ '' THEN
            N.TFS.AMOUNT = R.NEW(TFS.AMOUNT)<1,N.TFS.TXN.LOOP> ; SAVE.LINE.AMT = 0 ; SAVE.LINE.AMT = N.TFS.AMOUNT       ;* 08 Apr 08 /s
            N.TFS.CCY = R.NEW(TFS.CURRENCY)<1,N.TFS.TXN.LOOP> ; SAVE.LINE.CCY = '' ; SAVE.LINE.CCY = N.TFS.CCY          ;* 08 Apr 08 /e
** 08 Apr 08 /s
            ITS.A.FCY.LINE = 0
            IF SAVE.LINE.CCY NE LCCY THEN
                ITS.A.FCY.LINE = 1
            END ELSE
                ITS.A.FCY.LINE = 0
            END
*** 08 Apr 08 /e
*** TESTING /S
            !        IF N.TFS.CCY NE LCCY THEN N.TFS.AMOUNT = R.NEW(TFS.AMOUNT.LCY)<1,N.TFS.TXN.LOOP>
            !        N.TFS.CCY = LCCY
            N.TFS.CCY = PRI.AC.CCY
* CHNG060608 S
* Henceforth, the Primary a/c will always be in Lccy, so the following IF part has been commented
*            IF N.TFS.CCY NE LCCY THEN
*                ERR.TFS.TXN = ''
*                CALL CACHE.READ(FN.TFS.TXN,N.TFS.TXN,R.TFS.TXN,ERR.TFS.TXN)
*                IF R.TFS.TXN THEN
*                    TFS.CCY.MKT = '' ; TFS.CCY.MKT = R.TFS.TXN<TFS.TXN.LOCAL.REF,1>
*                    CCY1 = R.NEW(TFS.CURRENCY)<1,N.TFS.TXN.LOOP> ; CCY2 = N.TFS.CCY ; AMT1 = N.TFS.AMOUNT ; AMT2 = ''
*                    IF CCY1 NE CCY2 THEN
*                        TR.RATE = ''; LCY.AMT1 = '' ; LCY.AMT2 = '' ; CUST.SPREAD = '' ; SPREAD.PCT = '' ; CUST.RATE = '' ; RET.CODE = ''
*                        SAVE.AMT2 = '' ; SAVE.TR.RATE = '' ; SAVE.CUST.RATE = '' ; SAVE.LCY.AMT1 = '' ; SAVE.LCY.AMT2 = ''
*                        CALL CUSTRATE(TFS.CCY.MKT,CCY1,AMT1,CCY2,AMT2,'',TR.RATE,CUST.RATE,CUST.SPREAD,SPREAD.PCT,LCY.AMT1,LCY.AMT2,RET.CODE)
*                        N.TFS.AMOUNT = AMT2
*                    END
*                END
*            END ELSE
            N.TFS.AMOUNT = R.NEW(TFS.AMOUNT.LCY)<1,N.TFS.TXN.LOOP>
            IF NOT(N.TFS.AMOUNT) THEN
                N.TFS.AMOUNT = R.NEW(TFS.AMOUNT)<1,N.TFS.TXN.LOOP>    ;* TESTING S/E
            END
*            END
* CHNG060608 E
*** TESTING /E
            ENTRY.SIDE = '' ; INCLUDE.THIS.ENTRY = 1
            BEGIN CASE
                CASE R.NEW(TFS.ACCOUNT.DR)<1,N.TFS.TXN.LOOP>[4,5] EQ NET.ENTRY.WTHRU.CATEG
                    VALUE.DATE = R.NEW(TFS.DR.VALUE.DATE)<1,N.TFS.TXN.LOOP>
                    ENTRY.SIDE = 'DR'
                    NET.ENTRY.WTHRU.AC = R.NEW(TFS.ACCOUNT.DR)<1,N.TFS.TXN.LOOP>    ;* 12 SEP 07 - Sathish PS s/e

                CASE R.NEW(TFS.ACCOUNT.CR)<1,N.TFS.TXN.LOOP>[4,5] EQ NET.ENTRY.WTHRU.CATEG
                    VALUE.DATE = R.NEW(TFS.CR.VALUE.DATE)<1,N.TFS.TXN.LOOP>
                    ENTRY.SIDE = 'CR'
                    NET.ENTRY.WTHRU.AC = R.NEW(TFS.ACCOUNT.CR)<1,N.TFS.TXN.LOOP>    ;* 12 SEP 07 - Sathish PS s/e

                CASE OTHERWISE
                    INCLUDE.THIS.ENTRY =  0
            END CASE
            IF ENTRY.SIDE EQ 'DR' AND NOT(R.NEW(TFS.NET.ENTRY) MATCHES 'DEBIT' :@VM: 'BOTH') THEN
                INCLUDE.THIS.ENTRY = 0
            END
            IF ENTRY.SIDE EQ 'CR' AND NOT(R.NEW(TFS.NET.ENTRY) MATCHES 'CREDIT' :@VM: 'BOTH') THEN
                INCLUDE.THIS.ENTRY = 0
            END

            IF INCLUDE.THIS.ENTRY THEN
                GOSUB INCLUDE.IN.ENTRY.ARRAY
            END
        END
        N.TFS.TXN.LOOP += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------
INCLUDE.IN.ENTRY.ARRAY:

    ! 12 SEP 07 - Sathish PS /s
    !    CCY.VAL = N.TFS.CCY : VALUE.DATE
    CCY.VAL = N.TFS.CCY : VALUE.DATE :'-': NET.ENTRY.WTHRU.AC :'-': PRIMARY.AC
    ! 12 SEP 07 - Sathish PS /e
    LOCATE CCY.VAL IN CCY.VAL.ARR<1> SETTING CCY.VAL.POS THEN

* CHNG060608 S
* After the design change on 06/06/08, Net entry will always involve LCCY accounts.
* Hence AMOUNT.LCY of each transaction is added/subtracted to/from the Netted entries TFS.AMOUNT.LCY.
        BEGIN CASE
            CASE ENTRY.SIDE EQ 'DR'
                NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT.LCY> -= N.TFS.AMOUNT
            CASE ENTRY.SIDE EQ 'CR'
                NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT.LCY> += N.TFS.AMOUNT
            CASE OTHERWISE
        END CASE

* Update TFS.AMOUNT with TFS.AMOUNT.LCY since both will be equal for the net entry after this change.
        NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT> = NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT.LCY>
*CHNG060608 E

        IF R.NEW(TFS.EXP.SCHEDULE)<1,N.TFS.TXN.LOOP> THEN
            NETTED.ENTRIES<CCY.VAL.POS,TFS.EXP.SCHEDULE,-1> = R.NEW(TFS.EXP.SCHEDULE)<1,N.TFS.TXN.LOOP>
            NETTED.ENTRIES<CCY.VAL.POS,TFS.EXP.DATE,-1> = R.NEW(TFS.EXP.DATE)<1,N.TFS.TXN.LOOP>
            NETTED.ENTRIES<CCY.VAL.POS,TFS.EXP.AMT,-1> = R.NEW(TFS.EXP.AMT)<1,N.TFS.TXN.LOOP>
        END
    END ELSE
        CCY.VAL.POS = DCOUNT(CCY.VAL.ARR,@FM) + 1
        NETTED.ENTRIES<CCY.VAL.POS,TFS.TRANSACTION> = TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.TXN>

* CHNG060608 S
* After the design change on 06/06/08, Net entry will always involve LCCY accounts.
* Hence N.TFS.AMOUNT is stored in the Netted entries TFS.AMOUNT.LCY rather than TFS.AMOUNT.
        BEGIN CASE
            CASE ENTRY.SIDE EQ 'DR'
                !            NETTED.ENTRIES<CCY.VAL.POS,TFS.ACCOUNT.CR> = R.NEW(TFS.ACCOUNT.DR)<1,N.TFS.TXN.LOOP> ;* 12 SEP 07 - Sathish PS s/e
                !            NETTED.ENTRIES<CCY.VAL.POS,TFS.ACCOUNT.DR> = R.NEW(TFS.PRIMARY.ACCOUNT) ;* 12 SEP 07 - Sathish PS s/e
                NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT.LCY> = -N.TFS.AMOUNT          ;* 09 SEP 07 - Sathish PS s/e
            CASE ENTRY.SIDE EQ 'CR'
                !            NETTED.ENTRIES<CCY.VAL.POS,TFS.ACCOUNT.CR> = R.NEW(TFS.PRIMARY.ACCOUNT) ;* 12 SEP 07 - Sathish PS s/e
                !            NETTED.ENTRIES<CCY.VAL.POS,TFS.ACCOUNT.DR> = R.NEW(TFS.ACCOUNT.CR)<1,N.TFS.TXN.LOOP> ;* 12 SEP 07 - Sathish PS s/e
*** 08 Apr /s
                NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT.LCY> = N.TFS.AMOUNT ;* 09 SEP 07 - Sathish PS s/e ; * TESTING S/E
        END CASE    ;* CHNG060608 S/E - Brought the End Case before the IF, since it didnt make sense to have the TFS.AMOUNT populated only inside the CR side of the Case

* Commenting the FCY checks to update TFS.AMOUNT since the net entry will only involve LCCY after this change.
*        IF SAVE.LINE.CCY NE LCCY THEN
*            NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT> = SAVE.LINE.AMT
*            NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT.LCY> = N.TFS.AMOUNT ;* CHNG060608 S/E Already assigned with the same amount
*        END ELSE
        NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT> = N.TFS.AMOUNT
*            NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT.LCY> = N.TFS.AMOUNT  ;* CHNG060608 S/E Already assigned with the same amount
*        END
*        END CASE ;* CHNG060608 E
*** 08 Apr 08 /e

        NETTED.ENTRIES<CCY.VAL.POS,TFS.CURRENCY> = N.TFS.CCY
        !        NETTED.ENTRIES<CCY.VAL.POS,TFS.AMOUNT> = N.TFS.AMOUNT ;* 09 SEP 07 - Sathish PS s/e
        NETTED.ENTRIES<CCY.VAL.POS,TFS.DR.VALUE.DATE> = VALUE.DATE
        NETTED.ENTRIES<CCY.VAL.POS,TFS.CR.VALUE.DATE> = VALUE.DATE

        IF R.NEW(TFS.EXP.SCHEDULE)<1,N.TFS.TXN.LOOP> THEN
            NETTED.ENTRIES<CCY.VAL.POS,TFS.EXP.SCHEDULE> = R.NEW(TFS.EXP.SCHEDULE)<1,N.TFS.TXN.LOOP>
            NETTED.ENTRIES<CCY.VAL.POS,TFS.EXP.DATE> = R.NEW(TFS.EXP.DATE)<1,N.TFS.TXN.LOOP>
            NETTED.ENTRIES<CCY.VAL.POS,TFS.EXP.AMT> = R.NEW(TFS.EXP.AMT)<1,N.TFS.TXN.LOOP>
        END
        IF CCY.VAL.ARR THEN
            CCY.VAL.ARR := @FM: CCY.VAL
        END ELSE
            CCY.VAL.ARR = CCY.VAL
        END
    END

RETURN
*-----------------------------------------------------------------------
POPULATE.NETTED.ENTRIES:

    TFS$TFS.NET.ENTRY.POPULATED = 0     ;* 08 Apr 08 s/e
    NO.OF.NETTED.ENTRIES = DCOUNT(NETTED.ENTRIES,@FM)
    FOR NET.ENTRY.CNT = 1 TO NO.OF.NETTED.ENTRIES
        NETTED.ENTRY = NETTED.ENTRIES<NET.ENTRY.CNT>
        CCY.VAL = CCY.VAL.ARR<NET.ENTRY.CNT>
        ! 07 SEP 07 - Sathish PS /s
        ! 12 SEP 07 - Sathish PS /s
        IF NETTED.ENTRY<1,TFS.AMOUNT.LCY> LT 0 THEN         ;* CHNG060608 S/E
            NETTED.ENTRY<1,TFS.ACCOUNT.DR> = CCY.VAL['-',3,1]         ;* Primary Account
            NETTED.ENTRY<1,TFS.ACCOUNT.CR> = CCY.VAL['-',2,1]         ;* Net Entry Wash-thru Account
            NETTED.ENTRY<1,TFS.AMOUNT.LCY> = ABS(NETTED.ENTRY<1,TFS.AMOUNT.LCY>)          ;* CHNG060608 S/E
            NETTED.ENTRY<1,TFS.AMOUNT> = ABS(NETTED.ENTRY<1,TFS.AMOUNT>)        ;* Gap 40 - 10/07/2008 S/E
        END ELSE
            NETTED.ENTRY<1,TFS.ACCOUNT.DR> = CCY.VAL['-',2,1]         ;* Net Entry Wash-thru Account
            NETTED.ENTRY<1,TFS.ACCOUNT.CR> = CCY.VAL['-',3,1]         ;* Primary Account
        END
        !            IF NETTED.ENTRY<1,TFS.ACCOUNT.DR>[4,5] EQ NET.ENTRY.WTHRU.CATEG THEN          ;! 09 SEP 07 - Sathish PS /s
        !                SAVE.DR.AC = NETTED.ENTRY<1,TFS.ACCOUNT.DR>
        !                NETTED.ENTRY<1,TFS.ACCOUNT.DR> = NETTED.ENTRY<1,TFS.ACCOUNT.CR>
        !                NETTED.ENTRY<1,TFS.ACCOUNT.CR> = SAVE.DR.AC
        !                SAVE.DR.AC = ''
        !            END     ;! 09 SEP 07 - Sathish PS /e
        !        END
        ! 12 SEP 07 - Sathish PS /e
        ! 07 SEP 07 - Sathish PS /e
** Apr 08 /s
* CHNG060608 S
* The foll. 4 lines are not needed after this change hence commenting it.
*        TEMP.TFS.AMOUNT.LCY = 0 ; TEMP.TFS.AMOUNT.LCY = NETTED.ENTRY<1,TFS.AMOUNT.LCY>
*        IF TEMP.TFS.AMOUNT.LCY THEN
*            NETTED.ENTRY<1,TFS.AMOUNT.LCY> = TEMP.TFS.AMOUNT.LCY
*        END
* CHNG060608 E
** Apr 08 /e

        IF NETTED.ENTRY<1,TFS.EXP.SCHEDULE> THEN
            TOTAL.EXP.AMT = SUM(NETTED.ENTRY<1,TFS.EXP.AMT>)
            IF TOTAL.EXP.AMT NE NETTED.ENTRY<1,TFS.AMOUNT.LCY> THEN   ;* CHNG060608 S/E - Utilise TFS.Amount.Lcy instead of TFS.Amount
                IF TFS$R.TFS.PAR<TFS.PAR.CASH.ITEM.CODE> THEN
                    ID.TFS.EXP = TFS$R.TFS.PAR<TFS.PAR.CASH.ITEM.CODE>
                    ITEM.EXP.DATE= NETTED.ENTRY<1,TFS.CR.VALUE.DATE>
                    GOSUB GET.ITEM.EXP.DATE
                    IF NOT(E) THEN
                        NETTED.ENTRY<1,TFS.EXP.SCHEDULE,-1> = ID.TFS.EXP
                        NETTED.ENTRY<1,TFS.EXP.DATE,-1> = ITEM.EXP.DATE
                        NETTED.ENTRY<1,TFS.EXP.AMT,-1> = NETTED.ENTRY<1,TFS.AMOUNT.LCY> - TOTAL.EXP.AMT       ;* CHNG060608 S/E - Utilise TFS.Amount.Lcy instead of TFS.Amount
                    END
                END
            END
        END
        IF R.NEW(TFS.TRANSACTION) THEN
            APPEND.DELIM = @VM
        END ELSE
            APPEND.DELIM = ''
        END

        FOR FLD.CNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD
            BEGIN CASE
                CASE FLD.CNT EQ TFS.TRANSACTION
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.TRANSACTION>

                CASE FLD.CNT EQ TFS.CURRENCY
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.CURRENCY>

                CASE FLD.CNT EQ TFS.ACCOUNT.DR
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.ACCOUNT.DR>

                CASE FLD.CNT EQ TFS.ACCOUNT.CR
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.ACCOUNT.CR>

                CASE FLD.CNT EQ TFS.AMOUNT
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.AMOUNT>

                CASE FLD.CNT EQ TFS.WAIVE.CHARGE
                    R.NEW(FLD.CNT) := APPEND.DELIM : 'NO'

                CASE FLD.CNT EQ TFS.DR.VALUE.DATE
                    R.NEW(FLD.CNT) :=  APPEND.DELIM : NETTED.ENTRY<1,TFS.DR.VALUE.DATE>

                CASE FLD.CNT EQ TFS.CR.VALUE.DATE
                    R.NEW(FLD.CNT) :=  APPEND.DELIM : NETTED.ENTRY<1,TFS.CR.VALUE.DATE>

                CASE FLD.CNT EQ TFS.EXP.SCHEDULE
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.EXP.SCHEDULE>

                CASE FLD.CNT EQ TFS.EXP.DATE
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.EXP.DATE>

                CASE FLD.CNT EQ TFS.EXP.AMT
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.EXP.AMT>

                CASE FLD.CNT EQ TFS.NETTED.ENTRY
                    R.NEW(FLD.CNT) := APPEND.DELIM : "YES"
*** 08 Apr 08 /s
                CASE FLD.CNT EQ TFS.AMOUNT.LCY
                    R.NEW(FLD.CNT) := APPEND.DELIM : NETTED.ENTRY<1,TFS.AMOUNT.LCY>
**** 08 Apr 08 /e

                CASE OTHERWISE
                    R.NEW(FLD.CNT) := APPEND.DELIM : ''

            END CASE
        NEXT FLD.CNT
    NEXT NET.ENTRY.CNT
    TFS$TFS.NET.ENTRY.POPULATED = 1     ;* 08 Apr 08 s/e
RETURN
*------------------------------------------------------------------------------
PROCESS.EXPOSURE.SCHEDULE:
    ID.TFS.EXP = COMI
    ITEM.EXP.DATE = R.NEW(TFS.CR.VALUE.DATE)<1,AV>          ;* 30 AUG 07 - Sathish PS s/e
    GOSUB GET.ITEM.EXP.DATE
    IF NOT(E) THEN
        R.NEW(TFS.EXP.DATE)<1,AV,AS> = ITEM.EXP.DATE
* CHNG060608 S - Utilise TFS.Amount.lcy instead of Tfs.Amount
        R.NEW(TFS.EXP.AMT)<1,AV,AS> = R.NEW(TFS.AMOUNT.LCY)<1,AV> - SUM(R.NEW(TFS.EXP.AMT)<1,AV>) + R.NEW(TFS.EXP.AMT)<1,AV,AS>
* CHNG060608 E
    END

RETURN
*------------------------------------------------------------------------------
GET.ITEM.EXP.DATE:

    NO.OF.EXP.DAYS = ''
    BEGIN CASE
        CASE TFS$R.TFS.PAR<TFS.PAR.TFS.EXPOSURE> EQ 'NATIVE'
            CALL CACHE.READ(FN.TFS.EXP,ID.TFS.EXP,R.TFS.EXP,ERR.TFS.EXP)
            IF ERR.TFS.EXP THEN
                E = 'EB-US.REC.MISS.FILE'
                E<2,1> = ID.TFS.EXP
                E<2,2> = FN.TFS.EXP
            END ELSE
                NO.OF.EXP.DAYS = R.TFS.EXP<TFS.EXP.SCH.NO.OF.EXP.DAYS>
            END
        CASE TFS$R.TFS.PAR<TFS.PAR.TFS.EXPOSURE> EQ 'REGCC'
            FIELD.NAME = 'NO.OF.EXP.DAYS'
            CALL EB.FIND.FIELD.NO('US.EXPOSURE.SCHEDULE',FIELD.NAME)
            IF FIELD.NAME THEN
                CALL F.READV(FN.UES,ID.TFS.EXP,NO.OF.EXP.DAYS,FIELD.NAME,F.UES,ERR.UES)
            END
        CASE OTHERWISE
    END CASE

    IF NOT(NO.OF.EXP.DAYS) THEN
        NO.OF.EXP.DAYS = '+00W'
    END
    IF NOT(ITEM.EXP.DATE) THEN
        ITEM.EXP.DATE = TODAY
    END
    CALL CDT('',ITEM.EXP.DATE,NO.OF.EXP.DAYS)

RETURN
! 29 AUG 07 - Sathish PS /e
*------------------------------------------------------------------------------
VALIDATE.ACCOUNT:

    IF AF EQ TFS.ACCOUNT.CR THEN
        ALLOWED.AC = TFS$R.TFS.TXN(AV)<TFS.TXN.CR.ALLOWED.AC>
        CATEG = TFS$R.TFS.TXN(AV)<TFS.TXN.CR.CATEG>
    END ELSE
        ALLOWED.AC = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.ALLOWED.AC>
        CATEG = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.CATEG>
    END

    MAND.INP = 0
    IF COMI THEN
        GOSUB GET.AC.ENRI

        IF NOT(E) THEN
            BEGIN CASE
                CASE PL
                    IF NOT(ALLOWED.AC MATCHES 'ANY' :@VM: 'PL') THEN
                        E = 'EB-TFS.AC.MUST.BE' :@FM: ALLOWED.AC
                    END

                CASE CUS
                    IF NOT(ALLOWED.AC MATCHES 'ANY' :@VM: 'CUSTOMER') THEN
                        E = 'EB-TFS.AC.MUST.BE' :@FM: ALLOWED.AC
                    END

                CASE OTHERWISE
                    IF NOT(ALLOWED.AC MATCHES 'ANY' :@VM: 'INTERNAL') THEN
                        E = 'EB-TFS.AC.MUST.BE' :@FM: ALLOWED.AC
                    END
            END CASE
        END
    END ELSE
* See if its mandatory
        MAND.INP = (ALLOWED.AC EQ 'CUSTOMER') OR (ALLOWED.AC EQ 'ANY' AND NOT(CATEG)) AND NOT(WE.ARE.IN.BROWSER AND TFS$MESSAGE EQ '')
    END

RETURN
*-------------------------------------------------------------------------
GET.AC.ENRI:

    PL = 0 ; CUS = 0
    BEGIN CASE
        CASE COMI MATCHES '2A1N0X'          ;* PL
            YCATEG = COMI[3,5]
            CALL F.READ(FN.CATEG,YCATEG,R.CATEG,F.CATEG,ERR.CATEG)
            COMI.ENRI = R.CATEG<EB.CAT.DESCRIPTION,U.LANG>
            PL = 1

        CASE NUM(COMI)
            CALL F.READ(FN.AC,COMI,R.AC,F.AC,ERR.AC)
            IF R.AC THEN
                COMI.ENRI = R.AC<AC.SHORT.TITLE,U.LANG>
                CUS = 1
            END ELSE
                E = 'AC-AC.REC.MISS' :@FM: COMI
            END

        CASE NOT(NUM(COMI[1,3]))
            IF COMI[1,3] MATCHES TFS$CCY.LIST THEN
                CALL F.READ(FN.AC,COMI,R.AC,F.AC,ERR.AC)
                COMI.ENRI = R.AC<AC.SHORT.TITLE,U.LANG>
                IF NOT(COMI.ENRI) THEN
                    IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> MATCHES 'FT' :@VM: 'DC' THEN
                        E = 'AC-AC.REC.MISS' :@FM: COMI
                    END ELSE
* 04/26/05 - Sathish PS /s
* Rather, take the enrichment from the default Internal account for that
* Category
*                    YCATEG = COMI[4,5]
*                    CALL F.READ(FN.CATEG,YCATEG,R.CATEG,F.CATEG,ERR.CATEG)
*                    COMI.ENRI = R.CATEG<EB.CAT.DESCRIPTION,U.LANG>
*                    IF NOT(COMI.ENRI) THEN
*                        E = 'EB-TFS.INVALID.AC' :FM: COMI
*                    END
                        TEMP.COMI = COMI
                        TEMP.COMI[9,4] = '0001'
                        CALL F.READ(FN.AC,TEMP.COMI,R.AC,F.AC,ERR.AC)
                        COMI.ENRI = R.AC<AC.SHORT.TITLE,U.LANG>
                        IF NOT(COMI.ENRI) THEN
                            ! 29 AUG 07 - Sathish PS /s
                            ! Dont throw error for missing internal a/c. let the underlying app return it if it cant automatically create it
                            !                        E = 'EB-US.REC.MISS.FILE' :FM: TEMP.COMI :VM: FN.AC
                            ! 29 AUG 07 - Sathish PS /e
                        END
* 04/26/05 - Sathish PS /e

                    END
                END
            END ELSE
                E = 'EB-TFS.INVALID.CCY' :@FM: COMI
            END

    END CASE
*

RETURN
*------------------------------------------------------------------------------------------------------------------------------------
CHECK.AC.BRANCHES:

*
* If this is going to be a DC txn, then, both A/Cs must be in the same company
* - they dont have to be in the Current Company - but must be in the same
* Company
*
    IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'DC' THEN
        IF CR.AC AND DR.AC THEN
            CALL GET.ACCT.BRANCH(CR.AC,CR.AC.CO.MNE,CR.AC.CO.CODE)
            CALL GET.ACCT.BRANCH(DR.AC,DR.AC.CO.MNE,DR.AC.CO.CODE)
            IF CR.AC.CO.MNE AND DR.AC.CO.MNE AND CR.AC.CO.MNE NE DR.AC.CO.MNE THEN
                E = 'EB-TFS.ACCTS.NOT.IN.SAME.COMPANY'
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------------------
CHECK.AND.DEFAULT.ACCOUNTS:

    SAVE.COMI.ENRI = COMI.ENRI ; SAVE.COMI = COMI ; SAVE.ETEXT = ETEXT
    SAVE.AF = AF
    SAVE.TFS.MESSAGE = TFS$MESSAGE ; TFS$MESSAGE = 'CHECK.OTHER.FIELDS'

    ACCOUNT.TO.DEFAULT = TFS.ACCOUNT.DR ; OTHER.ACCOUNT = TFS.ACCOUNT.CR
    ALLOWED.AC = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.ALLOWED.AC>
    ALLOWED.CATEG = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.CATEG>
    GOSUB DEFAULT.THE.ACCOUNT
    IF AC.INPUT.MISSING AND NOT(E) THEN ;* 12 SEP 07 - Sathish PS s/e - Check E before setting it.
        E = 'EB-TFS.AC.DR.INP.MISS'
    END
*
    ACCOUNT.TO.DEFAULT = TFS.ACCOUNT.CR ; OTHER.ACCOUNT = TFS.ACCOUNT.DR
    ALLOWED.AC = TFS$R.TFS.TXN(AV)<TFS.TXN.CR.ALLOWED.AC>
    ALLOWED.CATEG = TFS$R.TFS.TXN(AV)<TFS.TXN.CR.CATEG>
    GOSUB DEFAULT.THE.ACCOUNT
    IF AC.INPUT.MISSING AND NOT(E) THEN ;* 12 SEP 07 - Sathish PS s/e - Check E before setting it.
        E = 'EB-TFS.AC.CR.INP.MISS'
    END

    COMI.ENRI = SAVE.COMI.ENRI ; COMI = SAVE.COMI ; ETEXT = SAVE.ETEXT
    AF = SAVE.AF
    TFS$MESSAGE = SAVE.TFS.MESSAGE

RETURN
*-------------------------------------------------------------------------
DEFAULT.THE.ACCOUNT:

    !**      AC.CCY = R.NEW(TFS.CURRENCY)<1,AV>
    IF NOT(AC.CCY) THEN
        AC.CCY = LCCY         ;* 27 May 08 s/e
    END

*-- 27 May 2008 /s

    PRIMARY.AC = R.NEW(TFS.PRIMARY.ACCOUNT)
    CALL CACHE.READ(FN.AC,PRIMARY.AC,R.PRI.AC,ERR.PRI.AC)
    IF R.PRI.AC THEN
        PRI.AC.CCY = R.PRI.AC<AC.CURRENCY>
    END

    AC.CCY = PRI.AC.CCY       ;** GPACK

*- 27 May 2008 /e

    AC.INPUT.MISSING = 0 ; COMI = '' ; CHECK.ACCOUNT = 0

    IF R.NEW(TFS.STANDING.ORDER)<1,AV> THEN
        CHECK.ACCOUNT = 1
        GOSUB DEFAULT.ACCOUNT.FROM.STO
        IF NOT(COMI) THEN
            AC.INPUT.MISSING = 1
        END
    END ELSE
*        IF NOT(R.NEW(ACCOUNT.TO.DEFAULT)<1,AV>) THEN
        CHECK.ACCOUNT = 1
        IF ALLOWED.AC EQ 'CUSTOMER' OR (ALLOWED.AC EQ 'ANY' AND NOT(ALLOWED.CATEG)) THEN
            GOSUB DEFAULT.FROM.SURROGATE.OR.WASHTHRU    ;* 29 AUG 07 - Sathish PS /s
            IF NOT(COMI) AND NOT(E) THEN
                IF PRIMARY.ACCOUNT AND R.NEW(OTHER.ACCOUNT)<1,AV> NE PRIMARY.ACCOUNT THEN
                    COMI = PRIMARY.ACCOUNT
                END ELSE
                    AC.INPUT.MISSING = 1
                END
            END
        END ELSE
            !** IF ALLOWED.CATEG THEN ; * 27 May 2008 s/e
*-- 27 May 2008 /s
*--23/03/2009 S/E    IF (ALLOWED.CATEG EQ 10001) OR (ALLOWED.CATEG EQ 14821) THEN

*-- 27 May 2008 /e
            !**COMI = AC.CCY : ALLOWED.CATEG ; * 27 May 2008 s/e
* PACS00192240 - Start
*  COMI = R.NEW(TFS.CURRENCY)<1,AV>:ALLOWED.CATEG        ;* 27 May 2008 s/e
            IF LEN(ALLOWED.CATEG) GT '5' THEN
                DAO.ID = ALLOWED.CATEG[6,4]
                ALLOWED.CATEG1 = ALLOWED.CATEG[1,5]
                COMI = R.NEW(TFS.CURRENCY)<1,AV>:ALLOWED.CATEG1
            END ELSE
                COMI = R.NEW(TFS.CURRENCY)<1,AV>:ALLOWED.CATEG
            END
* PACS00192240 - End
            CALL IN2.ALLACCVAL('35','')

            IF NOT(ETEXT) THEN
                IF NOT(LEN(ALLOWED.CATEG) EQ 9) THEN    ;* HD0932541 umar 29 Sep 2009 - s/e
                    IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'TT' THEN
                        GOSUB CHECK.TELLER.ID
                        IF COMI[9,4] NE TELLER.ID THEN
                            COMI[9,4] = TELLER.ID
                        END
                    END
                END ELSE  ;* HD0932541 umar 29 Sep 2009 - s/e
*PACS00306800-S
*CHANGE COMI[9,4] TO DAO.ID IN COMI
                    A=COMI[1,8]
                    B=COMI[9,4]
                    C=COMI[13,4]
                    COMI=A:DAO.ID:C
*PACS00306800-E
                END
            END
        END
*        END
*--23/03/2009 S/E    END
*
        IF CHECK.ACCOUNT AND NOT(AC.INPUT.MISSING) AND NOT(E) THEN
            AF = ACCOUNT.TO.DEFAULT
*            CALL T24.FS.CHECK.FIELDS
            APAP.TFS.t24FsCheckFields() ;*R22 Manual Conversion
            IF NOT(E) THEN
                R.NEW(AF)<1,AV> = COMI
                FIELD.TO.DEF = ACCOUNT.TO.DEFAULT :'.': AV ; ENRI.TO.DEF = COMI.ENRI ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            END
        END
*
        RETURN
*----------------------------------------------------------------------------------------------------------------------------------
DEFAULT.ACCOUNT.FROM.STO:

        IF R.NEW(TFS.STANDING.ORDER)<1,AV> THEN
            GOSUB LOAD.STO.RECORD
        END
        IF R.STO THEN
            R.NEW(TFS.CURRENCY)<1,AV> = R.STO<STO.CURRENCY>
            AC.CCY = R.NEW(TFS.CURRENCY)<1,AV>
            IF ACCOUNT.TO.DEFAULT EQ TFS.ACCOUNT.DR THEN
                COMI = STO.ID['.',1,1]
            END ELSE
                IF ACCOUNT.TO.DEFAULT EQ TFS.ACCOUNT.CR THEN
*
                    SBC.ID = R.STO<STO.BULK.CODE.NO>
                    IF SBC.ID THEN
                        CALL F.READV(FN.SBC,SBC.ID,PAYEE.DETAILS,STO.BC.BANK.SORT.CODE,F.SBC,ERR.SBC)
                        IF PAYEE.DETAILS THEN
* See if there is a susp defined - we had come up with a work-around, where the last multivalue
* in the field BENEFICIARY in STO.BULK.CODE will be the Susp. Category
                            NO.OF.VMS = DCOUNT(PAYEE.DETAILS,@VM)
                            SUSP.CATEG = PAYEE.DETAILS<1,NO.OF.VMS>
                            IF SUSP.CATEG GE 10000 AND SUSP.CATEG LE 19999 THEN
                                CALL F.READ(FN.CATEG,SUSP.CATEG,R.CATEG,F.CATEG,ERR.CATEG)
                                IF R.CATEG THEN
                                    COMI = AC.CCY : PAYEE.DETAILS<1,NO.OF.VMS>
                                    CALL IN2.ALLACCVAL('35','')
                                    IF ETEXT THEN
                                        ETEXT = '' ; COMI = ''
                                    END
                                END
                            END
                        END
                    END
                    IF ETEXT OR NOT(COMI) THEN
* If not, then the Nostro from Standing Order
                        COMI = R.STO<STO.CPTY.ACCT.NO>
                    END
                    IF NOT(COMI) THEN
* If not, then Nostro for the currency
                        FT.TXN = TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.AS>
                        CALL GET.NOSTRO(AC.CCY, 'FT', TEMP.AC.NO, FT.TXN, '', '', '', '', '', RET.CODE, '')
                    END
                END
            END
        END

        RETURN
*------------------------------------------------------------------------------------------------------------------------
* 02/10/05 - Sathish PS /s
DENOMINATION.PROCESSING:

        BEGIN CASE
            CASE AF EQ TFS.AMOUNT
                GOSUB SETUP.DENOM

            CASE OTHERWISE
*        GOSUB VALIDATE.DENOM
        END CASE

        RETURN
*-------------------------------------------------------------------------------------------------------------------------
SETUP.DENOM:

        IF AF NE TFS.AMOUNT THEN
            AMOUNT = R.NEW(TFS.AMOUNT)<1,AV>
        END ELSE
            AMOUNT = COMI
        END
        CCY = R.NEW(TFS.CURRENCY)<1,AV>
        IF NOT(AMOUNT) THEN
            E = 'EB-TFS.AMOUNT.MISSING'
        END
*
        IF NOT(E) THEN
            AC.NO = R.NEW(TFS.ACCOUNT.CR)<1,AV> ; SIDE = 'CR' ; DENOM.FIELD = TFS.CR.DENOM
            DENOM.UNIT.FIELD = TFS.CR.DEN.UNIT ; DENOM.SER.FIELD = TFS.CR.SERIAL.NO
            GOSUB PROCESS.DENOM.FOR.THIS.SIDE
            IF NOT(E) THEN
                AC.NO = R.NEW(TFS.ACCOUNT.DR)<1,AV> ; SIDE = 'DR' ; DENOM.FIELD = TFS.DR.DENOM
                DENOM.UNIT.FIELD = TFS.DR.DEN.UNIT ; DENOM.SER.FIELD = TFS.DR.SERIAL.NO
                GOSUB PROCESS.DENOM.FOR.THIS.SIDE
            END
        END

        RETURN
*--------------------------------------------------------------------------------------------------------------------------
PROCESS.DENOM.FOR.THIS.SIDE:
*
        IF E THEN
            RETURN
        END

        GOSUB CHECK.DENOM.REQD
        IF DENOM.REQD  THEN
            IF NOT(E) THEN
                GOSUB LOAD.TT.STOCK.CONTROL
                !  29 AUG 07 - Sathish PS /s
                ! 12 SEP 07 - Sathish PS /s
                !            IF NOT(R.NEW(DENOM.FIELD)<1,AV>) THEN
                IF (AF EQ TFS.AMOUNT) AND TFS$MESSAGE EQ '' THEN      ;* When coming from the Amount check.fields and not during crossval...
                    ! 12 SEP 07 - Sathish PS /e
                    GOSUB INITIALISE.DENOM
                    IF SIDE EQ 'CR' THEN
                        ! Apply filter or raise Inventory error message only if we are withdrawing. not for deposits
                        IF NOT(R.TT.SC) THEN
                            E = 'EB-TFS.INVENTORY.NOT.AVAILABLE' :@FM: AC.NO
                        END ELSE
                            GOSUB APPLY.STANDARD.FILTER
                        END
                    END
                END
                !  29 AUG 07 - Sathish PS /e
                !  29 AUG 07 - Sathish PS /s
                ! Commented the whole section below. Rewritten code above.
                !            IF R.TT.SC THEN
                !                IF NOT(R.NEW(DENOM.FIELD)<1,AV>) THEN
                !                    GOSUB INITIALISE.DENOM
                !                    GOSUB APPLY.STANDARD.FILTER
                !                END
                !            END ELSE
                !                E = 'EB-TFS.INVENTORY.NOT.AVAILABLE' :FM: AC.NO
                !            END
                ! 29 AUG 07 - Sathish PS /e
            END
        END

        RETURN
*------------------------------------------------------------------------------------------------------------------------
CHECK.DENOM.REQD:

        DENOM.REQD = 0 ; SERIAL.REQD = 0
        CALL F.READ(FN.AC,AC.NO,R.AC,F.AC,ERR.AC)
        ! 02 SEP 07 - Sathish PS /s
        !    IF ERR.AC THEN
        !    END ELSE
        !        IF R.AC<AC.CATEGORY> AND R.AC<AC.CUSTOMER> EQ '' THEN
        !            AC.CATEG = R.AC<AC.CATEGORY>
        !            LOCATE AC.CATEG IN R.TTP<TT.PAR.TRAN.CATEGORY,1> SETTING CASH.POS THEN
        !                DENOM.REQD = 1
        !            END
        !        END
        !        IF DENOM.REQD THEN
        !        END
        !    END
        IF ERR.AC THEN
            ACCOUNT.CATEG = AC.NO[4,5]
            ACCOUNT.CCY = AC.NO[1,3]
        END ELSE
            ACCOUNT.CATEG = R.AC<AC.CATEGORY>
            ACCOUNT.CCY = R.AC<AC.CURRENCY>
        END
        LOCATE ACCOUNT.CATEG IN R.TTP<TT.PAR.TRAN.CATEGORY,1> SETTING CASH.POS THEN

            !25 MAR 09 - Anitha s
* commented and changed the code for issue HD0904143
*        DENOM.REQD = 1
*    END
            ! 02 SEP 07 - Sathish PS /e
*    IF DENOM.REQD THEN
*changed the below code
*where the CONTROL.TYPE throws error if STOCK.CONTROL.TYPE EQ ''
*whereas the check should only be done if STOCK.CONTROL.TYPE EQ 'DENOM'

*        IF NOT(TFS$TT.DENOM.CCY) THEN
*            E = 'EB-TFS.DENOM.DATA.NOT.AVAILABLE'
*        END ELSE
            ! 02 SEP 07 - Sathish PS s/e
* 24 MAR 09 - Removed the comment added on 02 SEP 07 for issue HD0904143


            BEGIN CASE
                CASE R.AC<AC.STOCK.CONTROL.TYPE> EQ ''
                    !                E = 'EB-TFS.CONTROL.TYPE.NOT.DEFINED'
                    DENOM.REQD = 0
                CASE R.AC<AC.STOCK.CONTROL.TYPE> EQ 'DENOM'
                    IF NOT(TFS$TT.DENOM.CCY) THEN     ;*added 24 MAR 09
                        E = 'EB-TFS.DENOM.DATA.NOT.AVAILABLE'   ;*added 24 MAR 09
                        DENOM.REQD = 1
                    END
                    DENOM.REQD = 1
                CASE R.AC<AC.STOCK.CONTROL.TYPE> EQ 'SERIAL'
                    DENOM.REQD = 0
            END CASE
            ! 02 SEP 07 - Sathish PS s/e
*    END
        END

        RETURN
*--------------------------------------------------------------------------------------------------------------------------
INITIALISE.DENOM:

        LOCATE ACCOUNT.CCY IN TFS$TT.DENOM.CCY<1> SETTING CCY.POS THEN          ;* 02 SEP 07 - Sathish PS s/e
            R.NEW(DENOM.FIELD)<1,AV> = ''
            R.NEW(DENOM.FIELD)<1,AV> = LOWER(TFS$TT.DENOM(CCY.POS)<1>)
            R.NEW(DENOM.UNIT.FIELD)<1,AV> = ''
            R.NEW(DENOM.SER.FIELD)<1,AV> = ''
        END

        RETURN
*------------------------------------------------------------------------------------------------------------------------
APPLY.STANDARD.FILTER:

        ALL.DENOMS = R.NEW(DENOM.FIELD)<1,AV> ; TEMP.DENOM.ARR = ''
        LOOP
            REMOVE DENOM FROM ALL.DENOMS SETTING NEXT.DENOM.POS
        WHILE DENOM : NEXT.DENOM.POS DO

            LOCATE DENOM IN STOCK.DENOMINATIONS<1,1> SETTING DENOM.IN.STOCK THEN
                IF STOCK.UNITS<1,DENOM.IN.STOCK> THEN
                    IF TEMP.DENOM.ARR THEN
                        TEMP.DENOM.ARR := @VM: DENOM
                        TEMP.UNIT.ARR := @VM: ''
                    END ELSE
                        TEMP.DENOM.ARR = DENOM
                        TEMP.UNIT.ARR = ''
                    END
                END
            END

        REPEAT
*
        R.NEW(DENOM.FIELD)<1,AV> = LOWER(TEMP.DENOM.ARR)
        R.NEW(DENOM.UNIT.FIELD)<1,AV> = LOWER(TEMP.UNIT.ARR)
        R.NEW(DENOM.SER.FIELD)<1,AV> = LOWER(TEMP.UNIT.ARR)

        RETURN
*------------------------------------------------------------------------------------------------------------------------
*-------------- Not Used For the time being ----------------------*
POPULATE.DENOM:

        IF WE.ARE.IN.BROWSER THEN
            TXN.AMOUNT = 0
            RETURN
        END

        LOCATE R.NEW(TFS.CURRENCY)<1,AV> IN TFS$TT.DENOM.CCY<1> SETTING CCY.POS THEN
            CCY.DENOM = TFS$TT.DENOM(CCY.POS)
        END
*
        ALL.DENOMS = R.NEW(DENOM.FIELD)<1,AV>
        TXN.AMOUNT = AMOUNT
        NO.OF.DENOMS = DCOUNT(ALL.DENOMS,@SM) ;*R22 Manual Conversion
*
        FOR XX = 1 TO NO.OF.DENOMS
            CALC.UNITS = ''
            IF TXN.AMOUNT GT 0 THEN
                DENOM = ALL.DENOMS<1,1,XX>
                LOCATE DENOM IN CCY.DENOM<1,1> SETTING CCY.DENOM.POS THEN
                    DENOM.VALUE = CCY.DENOM<2,CCY.DENOM.POS>
                    IF XX EQ AS THEN
                        CALC.UNITS = COMI
                    END
                    IF NOT(CALC.UNITS) THEN
                        CALC.UNITS = INT(TXN.AMOUNT/DENOM.VALUE)
                    END
                END ELSE
                    DENOM.VALUE = 0
                END
                GOSUB CHECK.AVAIL.DENOM.UNITS
                BEGIN CASE
                    CASE XX LT AS

                    CASE XX EQ AS
                        COMI = CALC.UNITS

                    CASE XX GT AS
                        R.NEW(DENOM.UNIT.FIELD)<1,AV,XX> = CALC.UNITS
                        IF SERIAL.REQD THEN
                            R.NEW(DENOM.SER.FIELD)<1,AV,XX> = SERIAL.NO
                        END
                END CASE
                FIELD.TO.DEF = DENOM.UNIT.FIELD :'.': AV :'.': XX ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            END ELSE
                BREAK         ;* No amount to allocate
            END
        NEXT XX
*
        RETURN
*-------------------------------------------------------------------------------------------------------------------------
CHECK.AVAIL.DENOM.UNITS:

        LOCATE DENOM IN STOCK.DENOMINATIONS<1,1> SETTING STOCK.DENOM.POS THEN
            AVAIL.UNIT = STOCK.UNITS<1,STOCK.DENOM.POS>
            SERIAL.NO = STOCK.SERIAL.NOS<1,STOCK.DENOM.POS>
        END ELSE
            AVAIL.UNIT = 0
        END
*
        BEGIN CASE
            CASE AVAIL.UNIT AND AVAIL.UNIT LT CALC.UNITS
                CALC.UNITS = AVAIL.UNIT

            CASE AVAIL.UNIT AND AVAIL.UNIT GT CALC.UNITS
* Nothing

            CASE NOT(AVAIL.UNIT)
                CALC.UNITS = 0

            CASE NOT(CALC.UNITS)
                CALC.UNITS = AVAIL.UNIT
        END CASE
*
        DENOM.AMOUNT = CALC.UNITS * DENOM.VALUE
        TXN.AMOUNT = TXN.AMOUNT - DENOM.AMOUNT
*
        SERIAL.NO = ''

        RETURN
*---------------------------Not Used for the time being--------------------------------*
*------------------------------------------------------------------------------------------------------------------------
LOAD.TT.STOCK.CONTROL:

        ID.TT.SC = AC.NO ; R.TT.SC = ''
        STOCK.DENOMINATIONS = '' ; STOCK.UNITS = ''
        CALL F.READ(FN.TT.SC,ID.TT.SC,R.TT.SC,F.TT.SC,ERR.TT.SC)
        IF ERR.TT.SC THEN
            IF DENOM.REQD THEN
                IF SIDE EQ 'CR' THEN
                    ! 29 AUG 07 - Sathish PS /s
                    ! Raise error message for missing TT.STOCK.CONTROL only for withdrawals. Not deposits
                    E = 'EB-US.REC.MISS.FILE' :@FM: ID.TT.SC :@VM: FN.TT.SC
                END
            END
            ! 29 AUG 07 - Sathish PS /e
        END ELSE
            CALL F.READU(FN.TT.SC,ID.TT.SC,R.TT.SC,F.TT.SC,ERR.TT.SC,'')
            STOCK.DENOMINATIONS = R.TT.SC<TT.SC.DENOMINATION> ; STOCK.UNITS = R.TT.SC<TT.SC.QUANTITY>
            STOCK.SERIAL.NOS = R.TT.SC<TT.SC.SERIAL.NO>
        END

        RETURN
*-------------------------------------------------------------------------------------------------------------------------
VALIDATE.SERIAL.NO:

        SERIAL.REQD = '' ; STOCK.TYPE = ''
        CALL F.READV(FN.AC,AC.NO,STOCK.TYPE,AC.STOCK.CONTROL.TYPE,F.AC,ERR.AC)
*
        BEGIN CASE
            CASE COMI AND NOT(DENOM)
                E = 'EB-INP.MISS.4' :@FM: 'DENOM'

            CASE COMI
                IF STOCK.TYPE NE 'SERIAL' THEN
                    E = 'EB-TFS.INPUT.NOT.ALLOWED'
                END
            CASE NOT(COMI)
                IF STOCK.TYPE EQ 'SERIAL' THEN
                    E = 'EB-INPUT.MISSING'
                END
        END CASE

        RETURN
* 02/10/05 - Sathish PS /e
*-------------------------------------------------------------------------------------------------------------------------
UPDATE.RUNNING.TOTAL:

        OLD.AMOUNT = 0
        R.NEW(TFS.ACCOUNT.NUMBER) = ''
        R.NEW(TFS.NET.TXN.AMT) = ''
*
        ACCOUNTS.TO.UPDATE = R.NEW(TFS.ACCOUNT.CR)
        SIGN = 1
        GOSUB PROCESS.ACCOUNTS.TO.NET

        ACCOUNTS.TO.UPDATE = R.NEW(TFS.ACCOUNT.DR)
        SIGN = -1
        GOSUB PROCESS.ACCOUNTS.TO.NET

        IF NOT(GTSACTIVE) THEN
            CALL REBUILD.SCREEN         ;* Just to get T.FIELDNO updated with multivalues in ACCOUNT.NUMBER & NET.TXN.AMT fields
        END
        RETURN
*----------------------------------------------------------------------------------------------------------------------------------
PROCESS.ACCOUNTS.TO.NET:
        NO.OF.ACCOUNTS.TO.UPDATE = DCOUNT(ACCOUNTS.TO.UPDATE,@VM)
        FOR XX = 1 TO NO.OF.ACCOUNTS.TO.UPDATE
            SAVE.COMI = COMI ; SAVE.AF = AF ; SAVE.COMI.ENRI = COMI.ENRI ; AC.ENRI = ''

            IF R.NEW(TFS.CURRENCY)<1,XX> EQ LCCY THEN
                IF AF EQ TFS.AMOUNT AND AV EQ XX THEN
                    AMOUNT = COMI
                END ELSE
                    AMOUNT = R.NEW(TFS.AMOUNT)<1,XX>
                END
            END ELSE
                IF AF EQ TFS.AMOUNT.LCY AND AV EQ XX THEN
                    AMOUNT = COMI
                END ELSE
                    AMOUNT = R.NEW(TFS.AMOUNT.LCY)<1,XX>
                END
            END

            ACCOUNT = ACCOUNTS.TO.UPDATE<1,XX>

            GOSUB CHECK.FOR.WASHTHRU.ACCOUNTS

            CHG.AMT = R.NEW(TFS.CHG.AMT.LCY)<1,XX>
            CHG.PL.AMT = ''
            GOSUB DETERMINE.WHAT.TO.DO.WITH.CHARGES

            AMOUNT = AMOUNT * SIGN
            GOSUB UPDATE.RUN.TOTAL.FOR.THIS.AC

            IF CHG.PL.AMT THEN
                CHG.PL.ACCOUNT = '' ; AC.ENRI = ''
                GOSUB GET.CHG.PL.ACCOUNT
                IF CHG.PL.ACCOUNT THEN
                    ACCOUNT = CHG.PL.ACCOUNT ; AMOUNT = CHG.PL.AMT
                    ACCOUNT = 'PL':ACCOUNT
                    GOSUB UPDATE.RUN.TOTAL.FOR.THIS.AC
                END
            END

            COMI = SAVE.COMI ; AF = SAVE.AF ; COMI.ENRI = SAVE.COMI.ENRI

        NEXT XX
*

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------
UPDATE.RUN.TOTAL.FOR.THIS.AC:
        IF NOT(AC.ENRI) THEN
            COMI = ACCOUNT ; AC.ENRI = '' ; COMI.ENRI = ''
            GOSUB GET.AC.ENRI
            IF E THEN
                E = ''
            END ELSE
                AC.ENRI = COMI.ENRI
            END
        END

        AMT.CCY = LCCY
        CALL SC.FORMAT.CCY.AMT(AMT.CCY,AMOUNT)

        ALL.ACCOUNTS = R.NEW(TFS.ACCOUNT.NUMBER)

        IF ACCOUNT THEN
            LOCATE ACCOUNT IN ALL.ACCOUNTS<1,1> SETTING AC.POS THEN
                R.NEW(TFS.NET.TXN.AMT)<1,AC.POS> = R.NEW(TFS.NET.TXN.AMT)<1,AC.POS> + AMOUNT
            END ELSE
                R.NEW(TFS.ACCOUNT.NUMBER)<1,-1> = ACCOUNT
                R.NEW(TFS.NET.TXN.AMT)<1,-1> = AMOUNT
                AC.POS = DCOUNT(R.NEW(TFS.ACCOUNT.NUMBER),@VM)
                FIELD.TO.DEF = TFS.ACCOUNT.NUMBER :'.': AC.POS ; ENRI.TO.DEF = AC.ENRI ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            END
        END
*
        RETURN
*-------------------------------------------------------------------------
VALIDATE.CURRENCY:
        VALID.CURRENCIES = TFS$R.TFS.TXN(AV)<TFS.TXN.CR.ALLOWED.CCY>
        BEGIN CASE
            CASE CHECK.CCY EQ LCCY
                IF NOT(VALID.CURRENCIES MATCHES 'ANY' :@VM: 'LOCAL') THEN
                    E = 'EB-TFS.VALID.CURRENCIES' :@FM: VALID.CURRENCIES
                END

            CASE CHECK.CCY NE LCCY
                IF NOT(VALID.CURRENCIES MATCHES 'ANY' :@VM: 'FOREIGN') THEN
                    E = 'EB-TFS.VALID.CURRENCIES' :@FM: VALID.CURRENCIES
                END
        END CASE
*
        VALID.CURRENCIES = TFS$R.TFS.TXN(AV)<TFS.TXN.DR.ALLOWED.CCY>
        BEGIN CASE
            CASE CHECK.CCY EQ LCCY
                IF NOT(VALID.CURRENCIES MATCHES 'ANY' :@VM: 'LOCAL') THEN
                    E = 'EB-TFS.VALID.CURRENCIES' :@FM: VALID.CURRENCIES
                END

            CASE CHECK.CCY NE LCCY
                IF NOT(VALID.CURRENCIES MATCHES 'ANY' :@VM: 'FOREIGN') THEN
                    E = 'EB-TFS.VALID.CURRENCIES' :@FM: VALID.CURRENCIES
                END
        END CASE

        IF NOT(E) THEN
            CR.AC = R.NEW(TFS.ACCOUNT.CR)<1,AV>
            CALL F.READV(FN.AC,CR.AC,CR.AC.CCY,AC.CURRENCY,F.AC,ERR.AC)
            IF CR.AC.CCY THEN
                IF CR.AC.CCY NE CHECK.CCY THEN
                    !                E = 'EB-TFS.CCY.NOT.CR.AC.CCY' :FM: CR.AC.CCY ;* 18 SEP 07 - Sathish PS s/e
                END
            END
*
            DR.AC = R.NEW(TFS.ACCOUNT.DR)<1,AV>
            CALL F.READV(FN.AC,DR.AC,DR.AC.CCY,AC.CURRENCY,F.AC,ERR.AC)
            IF DR.AC.CCY THEN
                IF DR.AC.CCY NE CHECK.CCY THEN
                    !                E = 'EB-TFS.CCY.NOT.DR.AC.CCY' :FM: DR.AC.CCY ;* 18 SEP 07 - Sathish PS s/e
                END
            END
        END
*
        RETURN
*-------------------------------------------------------------------------
GET.DEFAULT.VALUE.DATE:

        CALL F.READ(FN.TXN,TEMP.TXN.CODE,R.TXN,F.TXN,ERR.TXN)
        DISPL = R.TXN<AC.TRA.DEFAULT.VALUE.DATE>
        BEGIN CASE
            CASE DISPL EQ 'Y'
                VALUE.DATE = TODAY

            CASE DISPL NE '' AND DISPL NE 'NO'
                VALUE.DATE = TODAY
                CALL CDT('',VALUE.DATE,DISPL)

            CASE OTHERWISE
                VALUE.DATE = ''
        END CASE

        RETURN
*-------------------------------------------------------------------------
CHECK.AND.DEFAULT.EXP.DATES:
        ! 29 AUG 07 - Sathish PS /s
        !    IF FN.UES THEN
        !        UES.ID = COMI
        !        FIELD.NAME = 'NO.OF.EXP.DAYS'
        !        CALL EB.FIND.FIELD.NO('US.EXPOSURE.SCHEDULE',FIELD.NAME)
        !        IF FIELD.NAME THEN
        !            CALL F.READV(FN.UES,UES.ID,DISPL,FIELD.NAME,F.UES,ERR.UES)
        !            IF DISPL THEN
        !                COMI.ENRI = DISPL
        !                EXP.DATE = TODAY
        !                CALL CDT('',EXP.DATE,DISPL)
        !                IF EXP.DATE THEN
        !                    IF NOT(R.NEW(TFS.CR.EXP.DATE)<1,AV>) THEN
        !                        R.NEW(TFS.CR.EXP.DATE)<1,AV> = EXP.DATE
        !                        FIELD.TO.DEF = TFS.CR.EXP.DATE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
        !                    END
        !                    IF NOT(R.NEW(TFS.DR.EXP.DATE)<1,AV>) THEN
        !                        R.NEW(TFS.DR.EXP.DATE)<1,AV> = EXP.DATE
        !                        FIELD.TO.DEF = TFS.DR.EXP.DATE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
        !                    END
        !                END
        !            END
        !        END ELSE
        !            E = 'EB-TFS.REC.MISS.FILE' :FM: UES.ID :VM: FN.UES
        !        END
        !    END ELSE
        !        E = 'EB-TFS.US.EXP.SCH.NOT.AVAIL'
        !    END
        ! 29 AUG 07 - Sathish PS /e
        RETURN
*-------------------------------------------------------------------------
DEFAULT.CHG.CODE:

        CHG.CODE = ''
        IF R.NEW(TFS.STANDING.ORDER)<1,AV> THEN
            GOSUB LOAD.STO.RECORD
        END
*
        IF NOT(E) AND TFS$MESSAGE EQ '' THEN
            IF TFS$R.TFS.TXN(AV)<TFS.TXN.CHARGE> THEN
                IF AF NE TFS.CHG.CODE THEN
                    R.NEW(TFS.CHG.CODE)<1,AV> = TFS$R.TFS.TXN(AV)<TFS.TXN.CHARGE>
                    FIELD.TO.DEF = TFS.CHG.CODE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                END ELSE
                    CHG.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.CHARGE>
                END
            END ELSE
                IF TFS$R.TFS.TXN(AV)<TFS.TXN.COMMISSION> THEN
                    IF AF NE TFS.CHG.CODE THEN
                        R.NEW(TFS.CHG.CODE)<1,AV> = TFS$R.TFS.TXN(AV)<TFS.TXN.COMMISSION>
                        FIELD.TO.DEF = TFS.CHG.CODE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                    END ELSE
                        CHG.CODE = TFS$R.TFS.TXN(AV)<TFS.TXN.COMMISSION>
                    END
                END
            END
        END

        RETURN
*------------------------------------------------------------------------
VALIDATE.CHG.CODE:

        IF NOT(E) THEN
            BEGIN CASE
                CASE TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'FT'
* Ok.Anything

                CASE TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'TT'
                    TT.TXN = TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.AS>
                    CALL F.READ(FN.TT.TXN,TT.TXN,R.TT.TXN,F.TT.TXN,ERR.TT.TXN)
                    IF NOT(COMI MATCHES R.TT.TXN<TT.TR.CHARGE.CODE>) THEN
                        E = 'EB-TFS.CHG.NOT.DEFINED.IN.TT.TXN'
                    END
            END CASE
        END

        RETURN
*-------------------------------------------------------------------------
TRY.TO.DEFAULT.CHG.AMT:

* Just take the first available customer a/c
        GOSUB GET.CR.DR.AC.CUS
        BEGIN CASE
            CASE CR.AC.CUS
                AC.CUS = CR.AC.CUS

            CASE DR.AC.CUS
                AC.CUS = DR.AC.CUS

            CASE OTHERWISE
                RETURN
        END CASE

        IF R.NEW(TFS.STANDING.ORDER)<1,AV> THEN
            GOSUB TRY.TO.DEFAULT.CHG.AMT.FROM.STO
        END ELSE
            IF AF EQ TFS.AMOUNT THEN
                DEAL.AMT = COMI
            END ELSE
                DEAL.AMT = R.NEW(TFS.AMOUNT)<1,AV>
            END
            DEAL.CCY = R.NEW(TFS.CURRENCY)<1,AV>
            CCY.MKT = 1 ; CROSS.RATE = '' ; CROSS.CCY = CHG.CCY ; T.DATA = CHG.CODE
            IF T.DATA THEN
                BEGIN CASE
                    CASE NOT(DEAL.AMT)
                        E = 'EB-INP.MISS.4' :@FM: 'AMOUNT'
                    CASE NOT(DEAL.CCY)
                        E = 'EB-INP.MISS.4' :@FM: 'CURRENCY'
                END CASE
                IF NOT(E) THEN
                    CHG.AMT.CCY = '' ; CHG.AMT.LCY = ''
                    CALL CALCULATE.CHARGE(AC.CUS, DEAL.AMT, DEAL.CCY, CCY.MKT, CROSS.RATE, CROSS.CCY, '', T.DATA, '', CHG.AMT.LCY, CHG.AMT.CCY)
                    IF CROSS.CCY EQ LCCY THEN
                        CHG.AMT.CCY = CHG.AMT.LCY
                    END
                    IF CHG.AMT.LCY THEN
                        IF AF NE TFS.CHG.AMT THEN
                            R.NEW(TFS.CHG.AMT)<1,AV> = CHG.AMT.CCY
                        END ELSE
                            COMI = CHG.AMT.CCY
                        END
                        R.NEW(TFS.CHG.AMT.LCY)<1,AV> = CHG.AMT.LCY
                        FIELD.TO.DEF = TFS.CHG.AMT :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                        FIELD.TO.DEF = TFS.CHG.AMT.LCY :'.': AV ; ENRI.TO.DEF = '' ; ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                    END ELSE
                        R.NEW(TFS.CHG.CODE)<1,AV> = ''
                        R.NEW(TFS.CHG.CCY)<1,AV> = ''
                        FIELD.TO.DEF = TFS.CHG.CODE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                        FIELD.TO.DEF = TFS.CHG.CCY :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                    END
                END
            END
        END

        RETURN
*-------------------------------------------------------------------------------------------------------------------------------------
TRY.TO.DEFAULT.CHG.AMT.FROM.STO:

        GOSUB LOAD.STO.RECORD
        IF R.STO THEN
            IF R.STO<STO.CHARGE.TYPE,1> THEN
                CHARGE.CCY = R.STO<STO.CHARGE.AMT,1>[1,3]
                CHARGE.AMT = R.STO<STO.CHARGE.AMT,1>
                CHARGE.AMT[1,3] = ''
                R.NEW(TFS.CHG.CCY)<1,AV> = CHARGE.CCY
                R.NEW(TFS.CHG.AMT)<1,AV> = CHARGE.AMT
            END ELSE
                IF R.STO<STO.COMMISSION.TYPE,1> THEN
                    CHARGE.CCY = R.STO<STO.COMMISSION.AMT,1>[1,3]
                    CHARGE.AMT = R.STO<STO.COMMISSION.AMT,1>
                    CHARGE.AMT[1,3] = ''
                    R.NEW(TFS.CHG.CCY)<1,AV> = CHARGE.CCY
                    R.NEW(TFS.CHG.AMT)<1,AV> = CHARGE.AMT
                END
            END
            IF CHARGE.CCY THEN
                IF CHARGE.CCY NE LCCY THEN
                    FCY = CHARGE.CCY ; AMOUNT.FCY = CHARGE.AMT
                    GOSUB FIND.AMOUNT.LCY
                    R.NEW(TFS.CHG.AMT.LCY)<1,AV> = AMOUNT.LCY
                END ELSE
                    R.NEW(TFS.CHG.AMT.LCY)<1,AV> = CHARGE.AMT
                END
            END
        END

        RETURN
*-------------------------------------------------------------------------------------------------------------------------------------
GET.CR.DR.AC.CUS:

        CR.AC.CUS = ''
        AC.ID = R.NEW(TFS.ACCOUNT.CR)<1,AV>
        CALL F.READ(FN.AC,AC.ID,R.AC,F.AC,ERR.AC)
        CR.AC.CUS = R.AC<AC.CUSTOMER>
*
        DR.AC.CUS = ''
        AC.ID = R.NEW(TFS.ACCOUNT.DR)<1,AV>
        CALL F.READ(FN.AC,AC.ID,R.AC,F.AC,ERR.AC)
        DR.AC.CUS = R.AC<AC.CUSTOMER>

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------
FIND.AMOUNT.LCY:
        IF FCY THEN
            YTFS.CR.AC = '' ; YTFS.CR.AC = R.NEW(TFS.ACCOUNT.CR)<1,AV>          ;* TESTING /S
            YTFS.DR.AC = '' ; YTFS.DR.AC = R.NEW(TFS.ACCOUNT.DR)<1,AV>
            ERR.PRI.AC = ''
            CALL CACHE.READ(FN.AC,PRIMARY.ACCOUNT,R.AC.PRIMARY,ERR.PRI.AC)
            IF R.AC.PRIMARY THEN
                PRIMARY.AC.CCY = '' ; PRIMARY.AC.CCY = R.AC.PRIMARY<AC.CURRENCY>
            END

            IF AMOUNT.FCY THEN
                TFS.TXN.CCY.MKT = '' ; TFS.TXN.CCY.MKT = TFS$R.TFS.TXN(AV)<TFS.TXN.LOCAL.REF,1>
                YTEMP.VAL = '' ; YTEMP.VAL = R.NEW(TFS.TRANSACTION)<1,AV>
                IF YTEMP.VAL NE "NET.ENTRY" AND (R.NEW(TFS.ACCOUNT.CR)<1,AV> EQ '') THEN
                    GOSUB CHECK.TELLER.ID
                    R.NEW(TFS.ACCOUNT.CR)<1,AV> = PRIMARY.AC.CCY:TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU>:TELLER.ID:'0001'
                END
                CCY1 = R.NEW(TFS.CURRENCY)<1,AV> ; CCY2 = PRIMARY.AC.CCY ; AMT1 = AMOUNT.FCY ; AMT2 = ''

* CHNG060608 S
                IF NOT(NUM(YTFS.CR.AC)) AND NOT(NUM(YTFS.DR.AC)) THEN
* Txn is b/n 2 internal a/cs, hence changing the CCY and AMT parameters.
                    CR.CATEG = YTFS.CR.AC[4,5]
                    LOCATE CR.CATEG IN TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU,1> SETTING WTHRU.POS THEN
* This is a Cash deposit or Cheque deposit txn
                        CCY1 = YTFS.DR.AC[1,3] ; AMT1 = AMOUNT.FCY ; CCY2 = YTFS.CR.AC[1,3] ; AMT2 = ''
                    END ELSE
* This is a Cash withdrawal txn
                        CCY1 = YTFS.DR.AC[1,3] ; AMT1 = '' ; CCY2 = YTFS.CR.AC[1,3] ; AMT2 = AMOUNT.FCY
                    END
                END
* CHNG060608 E

                TR.RATE = ''; LCY.AMT1 = '' ; LCY.AMT2 = '' ; CUST.SPREAD = '' ; SPREAD.PCT = '' ; CUST.RATE = '' ; RET.CODE = ''
                SAVE.AMT2 = '' ; SAVE.TR.RATE = '' ; SAVE.CUST.RATE = '' ; SAVE.LCY.AMT1 = '' ; SAVE.LCY.AMT2 = ''
                IF CCY1 NE CCY2 THEN    ;* Mar 17 2008 s/e

* Gap 40 - 10/07/2008 S
                    IF (AF EQ TFS.DEAL.RATE) AND COMI THEN
* Use the Deal rate entered by the user to calculate the Amount.Lcy since the same deal rate would be passed onto the Teller OFS version
                        CUST.RATE = COMI
                    END
* Gap 40 - 10/07/2008 E

                    CALL CUSTRATE(TFS.TXN.CCY.MKT,CCY1,AMT1,CCY2,AMT2,'',TR.RATE,CUST.RATE,CUST.SPREAD,SPREAD.PCT,LCY.AMT1,LCY.AMT2,RET.CODE)

                    SAVE.AMT2 = AMT2 ; SAVE.TR.RATE = TR.RATE ; SAVE.CUST.RATE = CUST.RATE ; SAVE.LCY.AMT1 = LCY.AMT1 ; SAVE.LCY.AMT2 = LCY.AMT2

* CHNG060608 S
* The following is done to get the calculated equivalent amount
                    IF AMT1 EQ AMOUNT.FCY THEN
                        AMOUNT.LCY = AMT2
                    END ELSE
                        AMOUNT.LCY = AMT1
                    END
* CHNG060608 E

                END ELSE      ;* Mar 17 2008 s/e
*S HD0908906 13/04/09
                    IF CCY2 NE LCCY THEN
                        GOSUB GET.LCCY.AMT
                    END
*E HD0908906 13/04/09
                    IF (R.NEW(TFS.AMOUNT.LCY)<1,AV> EQ '') THEN       ;* 08 Apr 08 /s
                        AMOUNT.LCY = AMOUNT.FCY
                    END       ;* 08 Apr 08 /e
                END ;* Mar 17 2008 s/e
                TR.RATE = ''; LCY.AMT1 = '' ; LCY.AMT2 = '' ; CUST.SPREAD = '' ; SPREAD.PCT = '' ; CUST.RATE = '' ; RET.CODE = ''
                AMOUNT.LCY.ENRI = C$R.LCCY<EB.CUR.CCY.NAME,U.LANG>
            END ELSE
                E = 'EB-TFS.AMOUNT.INP.MISS'
            END
        END ELSE
            E = 'EB-TFS.CURRENCY.INP.MISS'
        END
        RETURN
*-------------------------------------------------------------------------
*S HD0908906 13/04/09
GET.LCCY.AMT:
        CCY2=LCCY
        CALL CUSTRATE(TFS.TXN.CCY.MKT,CCY1,AMT1,CCY2,AMT2,'',TR.RATE,CUST.RATE,CUST.SPREAD,SPREAD.PCT,LCY.AMT1,LCY.AMT2,RET.CODE)
        AMOUNT.LCY=AMT2
        RETURN
*E HD0908906 13/04/09

CHECK.SUPPORT.FOR.REVERSAL:

        UL.TXN.ID = R.NEW(TFS.UNDERLYING)<1,AV>
        IF R.NEW(TFS.IMPORT.UL)<1,AV> THEN
            UL.TXN.ID = R.NEW(TFS.IMPORT.UL)<1,AV>
        END
        FN.UL.FILE = '' ; F.UL.FILE = '' ; FN.UL.FILE.HIS = '' ; F.UL.FILE.HIS = ''
        IF UL.TXN.ID THEN
            BEGIN CASE
                CASE UL.TXN.ID[1,2] EQ 'FT'
                    FN.UL.FILE = FN.FT ; F.UL.FILE = F.FT
                    FN.UL.FILE.HIS = FN.UL.FILE:'$HIS' ; F.UL.FILE.HIS = ''
                    RECORD.STATUS.FLD = FT.RECORD.STATUS

                CASE UL.TXN.ID[1,2] EQ 'TT'
                    FN.UL.FILE = FN.TT ; F.UL.FILE = F.TT
                    FN.UL.FILE.HIS = FN.UL.FILE:'$HIS' ; F.UL.FILE.HIS = ''
                    RECORD.STATUS.FLD = TT.TE.RECORD.STATUS

                CASE NUM(UL.TXN.ID) OR INDEX(UL.TXN.ID,'-',1)
                    FN.UL.FILE = FN.DC ; F.UL.FILE = F.DC
                    UL.TXN.ID = UL.TXN.ID['-',1,1] : STR(0,3-LEN(UL.TXN.ID['-',2,1])) : UL.TXN.ID['-',2,1]

            END CASE
            IF R.NEW(TFS.UL.STATUS)<1,AV> NE 'AUT' THEN
                FN.UL.FILE = FN.UL.FILE :'$NAU' ; F.UL.FILE = ''
            END

            CALL F.READ(FN.UL.FILE,UL.TXN.ID,R.UL.TXN,F.UL.FILE,ERR.UL.FILE)
            IF NOT(R.UL.TXN) THEN
                IF FN.UL.FILE.HIS THEN
                    CALL F.READ.HISTORY(FN.UL.FILE.HIS,UL.TXN.ID,R.UL.TXN,F.UL.FILE.HIS,ERR.UL.FILE.HIS)
                    IF R.UL.TXN<RECORD.STATUS.FLD> EQ 'REVE' THEN
                        E = 'EB-TFS.TXN.ALREADY.REVERSED'
                    END ELSE
* 10/30/03 - Sathish PS /s
* Changes made to handle History Reversal in FT
                        DC.REQD = 1
                        IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'FT' THEN
                            GOSUB CHECK.SUPPORT.FOR.FT.HIS.REVERSAL   ;* Check HIS.REVERSAL in FT.TXN.TYPE.CONDITION & ALLOW.FT.HIS.REV in TFS.PARAMETER
                        END
* 10/30/03 - Sathish PS /e
                        IF DC.REQD THEN
                            IF INDEX('IC',V$FUNCTION,1) AND TFS$AUTH.NO EQ 0 AND TFS$R.TFS.PAR<TFS.PAR.ALLOW.DC.ZERO.AUT> NE 'YES' THEN
                                E = 'EB-TFS.DC.ZERO.AUTH.RESTRICTION'
                            END
                        END
                    END
                END ELSE
                    E = 'EB-TFS.UNABLE.TO.READ.UL.CANNOT.REVERSE' :@FM: UL.TXN.ID
                END
            END
        END

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------
* 10/30/03 - Sathish PS /s
CHECK.SUPPORT.FOR.FT.HIS.REVERSAL:

        IF TFS$R.TFS.PAR<TFS.PAR.ALLOW.FT.HIS.REV> EQ 'YES' THEN      ;* And allowed by Parameter
            FT.TXN.ID = TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.AS>
            FT.TXN.FIELD = 'HIS.REVERSAL'
*
* Instead of using $Insert for the field, this is an easy method of determining whether we are in
* a release that supports Reversal of matured FT transaction.
*
            CALL EB.FIND.FIELD.NO('FT.TXN.TYPE.CONDITION',FT.TXN.FIELD)
            IF NUM(FT.TXN.FIELD) THEN
                CALL F.READV(FN.FT.TXN,FT.TXN.ID,HIS.REVERSAL,FT.TXN.FIELD,F.FT.TXN,ERR.FT.TXN)
                IF HIS.REVERSAL EQ 'YES' THEN
                    DC.REQD = 0
                END
            END
        END

        RETURN
* 10/30/03 - Sathish PS /e
*------------------------------------------------------------------------------------------------------------------------------------
CHECK.FOR.WASHTHRU.ACCOUNTS:

        TEMP.ACCOUNT = ''
        BEGIN CASE
            CASE ACCOUNT MATCHES '2A1N0X'   ;* PL
                TEMP.ACCOUNT = ACCOUNT[5]

            CASE NOT(NUM(ACCOUNT[1,3]))
                TEMP.ACCOUNT = ACCOUNT[4,5]
        END CASE
        IF TEMP.ACCOUNT THEN
            LOCATE TEMP.ACCOUNT IN TFS$R.TFS.PAR<TFS.PAR.WASHTHRU.CATEG,1> SETTING NET.THIS.AC THEN
                SAVE.ACCOUNT.ORIG = '' ; SAVE.ACCOUNT.ORIG = ACCOUNT  ;* 15 Apr -08 /s
                ACCOUNT = TEMP.ACCOUNT
                CALL F.READ(FN.CATEG,ACCOUNT,R.CATEG,F.CATEG,ERR.CATEG)
                AC.ENRI = R.CATEG<EB.CAT.DESCRIPTION,U.LANG>
                ACCOUNT = SAVE.ACCOUNT.ORIG       ;* 15 Apr 08 - /e
            END
        END

        RETURN
*-----------------------------------------------------------------------------------------------------------------------------------
GET.CHG.PL.ACCOUNT:

        CHG.CODE = R.NEW(TFS.CHG.CODE)<1,XX>
        IF CHG.CODE EQ TFS$R.TFS.TXN(XX)<TFS.TXN.CHARGE> THEN
            CALL F.READV(FN.FT.CHG,CHG.CODE,CHG.PL.ACCOUNT,FT5.CATEGORY.ACCOUNT,F.FT.CHG,ERR.FT.CHG)
        END ELSE
            CALL F.READV(FN.FT.COMM,CHG.CODE,CHG.PL.ACCOUNT,FT4.CATEGORY.ACCOUNT,F.FT.COMM,ERR.FT.COMM)
        END

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------
DETERMINE.WHAT.TO.DO.WITH.CHARGES:

        BEGIN CASE
            CASE TFS$R.TFS.TXN(XX)<TFS.TXN.INTERFACE.TO> EQ 'FT'
                SAVE.AV = AV ; AV = XX ; GOSUB GET.CR.DR.AC.CUS ; AV = SAVE.AV
                BEGIN CASE
                    CASE CR.AC.CUS AND NOT(DR.AC.CUS)
                        CHG.METHOD = 'CREDIT.LESS.CHARGES'
                    CASE OTHERWISE
                        CHG.METHOD = 'DEBIT.PLUS.CHARGES'
                END CASE
            CASE TFS$R.TFS.TXN(XX)<TFS.TXN.INTERFACE.TO> EQ 'TT'
                ID.TTXN = TFS$R.TFS.TXN(XX)<TFS.TXN.INTERFACE.AS>
                CR.TXN.CODE = TFS$R.TFS.TXN(XX)<TFS.TXN.CR.TXN.CODE>
                CALL F.READ(FN.TT.TXN,ID.TTXN,R.TTXN,F.TT.TXN,ERR.TTXN)
                IF R.TTXN THEN
                    TXN.CODE.2 = R.TTXN<TT.TR.TRANSACTION.CODE.2>
                    IF TXN.CODE.2 EQ CR.TXN.CODE THEN
                        CHG.METHOD = 'CREDIT.LESS.CHARGES'
                    END ELSE
                        CHG.METHOD = 'DEBIT.PLUS.CHARGES'
                    END
                END
        END CASE

        BEGIN CASE
            CASE CHG.METHOD = 'DEBIT.PLUS.CHARGES'
                IF SIGN EQ '-1' THEN
                    AMOUNT += CHG.AMT
                END ELSE
                    CHG.PL.AMT = CHG.AMT
                END

            CASE CHG.METHOD = 'CREDIT.LESS.CHARGES'
                IF SIGN EQ '1' THEN
                    AMOUNT = AMOUNT - CHG.AMT
                    CHG.PL.AMT = CHG.AMT
                END
        END CASE

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------------
LOAD.STO.RECORD:

        R.STO = '' ; STO.ID = ''
        STO.ID = R.NEW(TFS.STANDING.ORDER)<1,AV>
        IF STO.ID NE '' THEN  ;* 20100624 umar
            CALL F.READ(FN.STO,STO.ID,R.STO,F.STO,ERR.STO)
            IF R.STO THEN
                IF R.STO<STO.CHARGE.TYPE> THEN
                    TFS$R.TFS.TXN(AV)<TFS.TXN.CHARGE> = R.STO<STO.CHARGE.TYPE,1>
                END
                IF R.STO<STO.COMMISSION.TYPE> THEN
                    TFS$R.TFS.TXN(AV)<TFS.TXN.COMMISSION> = R.STO<STO.COMMISSION.TYPE,1>
                END
            END
        END         ;* 20100624 umar

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------------
IMPORT.UNDERLYING:
*
* This is a new validation to allow a user to enter the transaction in UNDERLYING field and then reverse it - thru DC if necessary or
* just plain reversal of the transaction.
*
        IF COMI[1,2] MATCHES 'FT' :@VM: 'TT' THEN
*            CALL TFS.IMPORT.UNDERLYING(DEFAULTED.FIELD,DEFAULTED.ENRI)
            APAP.TFS.tfsImportUnderlying(DEFAULTED.FIELD,DEFAULTED.ENRI) ;*R22 Manual Conversion
        END ELSE
            E = 'EB-TFS.INVALID.UNDERLYING'
        END

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------------
        ! 29 AUG 07 - Sathish PS /s
DEFAULT.FROM.SURROGATE.OR.WASHTHRU:

* 04 SEP 07 - Sathish PS /s
        BEGIN CASE
            CASE SURROGATE.AC
                IF  SURROGATE.AC NE R.NEW(TFS.PRIMARY.ACCOUNT) THEN
                    BEGIN CASE
                        CASE TFS$R.TFS.TXN(AV)<TFS.TXN.SURROGATE.AC> EQ 'ACCOUNT.DR'
                            IF OTHER.ACCOUNT EQ TFS.ACCOUNT.CR THEN
                                COMI = SURROGATE.AC
                            END
                        CASE TFS$R.TFS.TXN(AV)<TFS.TXN.SURROGATE.AC> EQ 'ACCOUNT.CR'
                            IF OTHER.ACCOUNT EQ TFS.ACCOUNT.DR THEN
                                COMI = SURROGATE.AC
                            END


                            ! 13 FEB 09 - Sathish PS /s
                            ! Moved this logic from down below, to be part of a new Case Statement...
                            ! Ideally Surrogate Account should only be driven by definition at TFS.TRANSACTION level but
                            ! in case its simply used to default the first account, then we just need to default whichever side hits first
                            !

                        CASE TFS$R.TFS.TXN(AV)<TFS.TXN.SURROGATE.AC> EQ ""
                    
                            IF SURROGATE.AC AND R.NEW(OTHER.ACCOUNT)<1,AV> NE SURROGATE.AC THEN
                                SURROGATE.AC = R.NEW(TFS.PRIMARY.ACCOUNT)
                                COMI = SURROGATE.AC
                            END
                            ! 13 FEB 09 - Sathish PS /e


                        CASE OTHERWISE

                    END CASE
                END ELSE
                    IF TFS$R.TFS.TXN(AV)<TFS.TXN.SURROGATE.AC> NE '' THEN
                        E = 'EB-TFS.SURROGATE.AC.CANT.BE.SAME.AS.PRIMARY'
                    END
                END

            CASE NOT(SURROGATE.AC)
                IF TFS$R.TFS.TXN(AV)<TFS.TXN.SURROGATE.AC> NE '' THEN
                    E = 'EB-TFS.SURROGATE.AC.MISSING'
                END

            CASE OTHERWISE
        END CASE
        ! 12 SEP 07 - Sathish PS /e
        IF NOT(COMI) AND NOT(E) THEN
* 04 SEP 07 - Sathish PS /e
            IF NOT(AC.CCY) THEN
                AC.CCY = R.NEW(TFS.CURRENCY)<1,AV>
            END
            IF R.NEW(TFS.NET.ENTRY) NE 'NO' THEN
                WTHRU.COND.1 = R.NEW(TFS.NET.ENTRY) EQ 'CREDIT' AND OTHER.ACCOUNT EQ TFS.ACCOUNT.DR ;* Which means we are now processing TFS.ACCOUNT.CR
                WTHRU.COND.2 = R.NEW(TFS.NET.ENTRY) EQ 'DEBIT' AND OTHER.ACCOUNT EQ TFS.ACCOUNT.CR  ;* Which means we are now processing TFS.ACCOUNT.DR
                WTHRU.COND.3 = R.NEW(TFS.NET.ENTRY) EQ 'BOTH'
                IF WTHRU.COND.1 OR WTHRU.COND.2 OR WTHRU.COND.3 THEN
                    IF TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU> THEN
                        NET.ENTRY.WTHRU.CATEG = TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU>
                        IF AC.CCY AND NET.ENTRY.WTHRU.CATEG THEN
                            COMI = AC.CCY : NET.ENTRY.WTHRU.CATEG
                            CALL IN2.ALLACCVAL('35','')
                            IF NOT(ETEXT) THEN
                                !                            IF TFS$R.TFS.TXN(AV)<TFS.TXN.INTERFACE.TO> EQ 'TT' THEN ;* 09 SEP 07 - Sathish PS s/e
                                GOSUB CHECK.TELLER.ID
                                IF COMI[9,4] NE TELLER.ID THEN
                                    COMI[9,4] = TELLER.ID
                                    !                            END ;* 09 SEP 07 - Sathish PS s/e
                                END
                            END
                        END
                    END
                END
            END
        END         ;* 04 SEP 07 - Sathish PS s/e
        IF NOT(COMI) AND NOT(E) THEN
* 05/17/05 - Sathish PS /s
* Give priority to Quick Account
            !        IF SURROGATE.AC AND R.NEW(OTHER.ACCOUNT)<1,AV> NE SURROGATE.AC THEN
            !            COMI = SURROGATE.AC
            !        END
* 05/17/05 - Sathish PS /e
        END

        RETURN
        ! 29 AUG 07 - Sathish PS /e
*---------------------------------------------------------------------------------------------------------------------------------------
APPEND.TO.DEFAULTED.FIELDS:

        IF UNASSIGNED(ENRI.TO.DEF) THEN
            ENRI.TO.DEF = ''
        END

        IF FIELD.TO.DEF THEN
            LOCATE FIELD.TO.DEF IN DEFAULTED.FIELD<1> SETTING FIELD.POS THEN
                DEFAULTED.ENRI<FIELD.POS> = ENRI.TO.DEF
            END ELSE
                DEFAULTED.FIELD<-1> = FIELD.TO.DEF
                LOCATE FIELD.TO.DEF IN DEFAULTED.FIELD<1> SETTING FIELD.POS THEN
                    DEFAULTED.ENRI<FIELD.POS> = ENRI.TO.DEF
                END
            END
            FIELD.TO.DEF = '' ; ENRI.TO.DEF = ''
        END

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------------
LOG.MESSAGE:

        LOG.MSG = '' ; E.MSG = '' ; R.NEW.MSG = ''
        IF LOG.MSG THEN
            CALL TXT(LOG.MSG)
            E.MSG = ' E=& ETEXT=& END.ERROR=& COMI=&' :@FM: E :@VM: ETEXT :@VM: END.ERROR :@VM: COMI
            CALL TXT(E.MSG)
            MATBUILD R.DYN.NEW FROM R.NEW
            CHANGE @FM TO '^' IN R.DYN.NEW
            CHANGE @VM TO ']' IN R.DYN.NEW
            CHANGE @SM TO '\' IN R.DYN.NEW
            R.NEW.MSG := 'R.NEW=&' :@FM: R.DYN.NEW ; CALL TXT(R.NEW.MSG)
            LOG.MSG := ' ':E.MSG
            LOG.MSG := ' ':R.NEW.MSG
            LOG.MSG = SYSTEM(40):' --> ':LOG.MSG
        END

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------------
    END
