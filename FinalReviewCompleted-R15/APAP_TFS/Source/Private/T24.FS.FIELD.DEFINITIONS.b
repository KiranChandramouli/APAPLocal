* @ValidationCode : MjotMTc2NzI5MzUyNzpDcDEyNTI6MTY5ODc1MDY3MzI1NDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>1372</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.FIELD.DEFINITIONS
*
* Field definition subroutine for T24.FUND.SERVICES template
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
* 10/05/04 - Sathish PS
*            Added new field - PRODUCT CATEGORY - now that we have started
*            handling DC
* 10/25/04 - Sathish PS
*            Added new field - STANDING.ORDER to facilitate Online, adhoc
*            Bill Payment.
*
* 02/10/05 - Sathish PS
*            New functionality to Support Cash Denominations
*            Added 6 new fields & 8 new Reserved Fields
*
* 03/24/05 - Sathish PS
*            New Common variable to store the T array - used by T24.FS.CHECK.RECORD
*
* 04/04/05 - Sathish PS
*            Added new field to hold the Cheque Number being Issued
*
* 05/17/05 - Sathish PS
*            Introduction of new functionality - SURROGATE.AC. The main problem with
*            TFS has been the need to display both Cr & Dr accounts on all the lines
*            whilst they are not actually needed - for instance, when one side will be
*            an internal account automatically defaulted by the system. Now, Just displa
*            ying QUICK Account would suffice. The system will assign Quick Account to
*            Dr or Cr a/c as applicable
* 06/09/05 - Sathish PS
*            Added new field IMPORT.UL to import a transaction that was not
*            originally input by TFS.
*
* 07/04/05 - Sathish PS
*            Total Restruturing of fields
*
* 07/09/05 - Ganesh Prasad
*            Added fields for coins dispensing/Additional reserved fields
*
* 07/15/05 - Sathish PS
*            Added new field STORE.MIX.WD.AMT to store the Mix Wd Amount, to
*            get around with Browser Issues.
*
* 07/20/05 - GP
*            Added one more field to store split amounts(Browser issue)
*
* 07/25/05 - GP
*            Added a CONCATFILE to IMPORT.UL to ensure the same record is not
*            reversed more than once.
*
* 08/03/05 - Sathish PS
*            Set T(Z)<1> to '.ALLACCVAL' for SURROGATE.AC and also add CHECKFILE
*
* 10 OCT 06 - Sathish PS
*             Added fields for Cash Back functionality
*
* 29 AUG 07 - Sathish PS
*             Set TFS.TRANSACTION to either CHECKFILE or VETTING TABLE based on
*             parameter in TFS.PARAMETER (TFST.LOOKUP).
*             Check TFST.LOOKUP in TFS.PARAMETER and see if we need to select and store in
*             new common variable TFS$TFS.TRANSACTIONS.
*
* 13 SEP 07 - Sathish PS
*             AMOUNT changed from HOT.VALIDATE to HOT.FIELD.
*
* 26 SEP 07 - Sathish PS
*             Store all AC.LOCKED.EVENT records in the TFS Line. New field for that.
*             Also, add a new option to CREATE.NET.ENTRY - 'REVERSE'.
*
* 04 OCT 07 - Sathish PS
*             Dont set NET.ENTRY to NOINPUT. Affects auto release and auto authorise using
*             BUILD.CONTROL
*
* 23 OCT 07 - Sathish PS
*             Currency market fix
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion             GLOBUS.BP File Removed, USPLATFORM.BP  File Removed, FM TO @FM, VM TO @VM
 
*-----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CURRENCY
    $INSERT I_GTS.COMMON

    $INSERT I_F.CHEQUE.TYPE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER

    $INSERT I_F.CATEGORY      ;* 10/05/04 - Sathish PS s/e
    $INSERT I_F.STANDING.ORDER          ;* 10/25/04 - Sathish PS s/e

    $INCLUDE I_F.TFS.TRANSACTION ;*R22 Manual Conversion  - START
    $INCLUDE I_F.T24.FUND.SERVICES

    $INCLUDE I_F.TELLER.DENOMINATION
    $INCLUDE I_T24.FS.COMMON        ;* 03/24/05 - Sathish PS s/e
    $INCLUDE I_F.TFS.PARAMETER      ;* 29 AUG 07 - Sathish PS s/e
    $INCLUDE I_F.TFS.EXPOSURE.SCHEDULE        ;* 29 AUG 07 - Sathish PS s/e ;*R22 Manual Conversion  - END
    C$NS.OPERATION='ALL'      ;*18 JUN 09 - lokesh s/e
    GOSUB INITIALISE          ;* 29 AUG 07 - Sathish PS s/e
    OBJ.ID = 'ACCOUNT' ; AC.LEN = ''
    CALL EB.GET.OBJECT.LENGTH(OBJ.ID,AC.LEN)
    IF NOT(AC.LEN) THEN AC.LEN = 16

    ID.F = '' ; ID.N = '' ; ID.T = ''
    MAT F = '' ; MAT N = '' ; MAT T = ''
    ID.CHECKFILE = '' ; ID.CONCATFILE = ''
    MAT CHECKFILE = '' ; MAT CONCATFILE = ''

    ID.F = 'TXN.REF' ; ID.N = '20..C' ; ID.T<1> = 'A'

    Z = 0
    Z += 1 ; F(Z) = 'BOOKING.DATE' ; N(Z) = '11..C' ; T(Z)<1> = 'D'

    Z += 1 ; F(Z) = 'ACCOUNTING.STYLE' ; N(Z) = '15..C' ; T(Z)<1> = '' ; T(Z)<2> = 'ATOMIC_INDEPENDENT'
    Z += 1 ; F(Z) = 'PRIMARY.CUSTOMER' ; N(Z) = '10..C' ; T(Z)<1> = 'CUS'
    CHECKFILE(Z) = 'CUSTOMER' :@FM: EB.CUS.SHORT.NAME :@FM: 'L' ;*R22 Manual Conversion
    Z += 1 ; F(Z) = 'PRIMARY.ACCOUNT' ; N(Z) = AC.LEN:'..C' ; T(Z)<1> = 'ACC' ; T(Z)<9> = 'HOT.FIELD'
    CHECKFILE(Z) = 'ACCOUNT' :@FM: AC.ACCOUNT.TITLE.1 :@FM: 'L'
* 07/09/05 - GP /s
    Z += 1 ; F(Z) = 'MIX.WD.AMOUNT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ;
    Z += 1 ; F(Z) = 'MIX.WD.CCY' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY'
    CHECKFILE(Z) = 'CURRENCY' :@FM: EB.CUR.CCY.NAME
    Z += 1 ; F(Z) = 'XX<MIX.WD.SRC.ACC' ; N(Z) = '16..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'ACCOUNT' :@FM: AC.SHORT.TITLE

    ADDNL.FIELDS = 5 ; FIELD.NAME = 'XX-MV.RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    !    Z += 1 ; F(Z) = 'XX>MIX.WD.SRC.AMT'; N(Z) = '15...C'; T(Z)<1> ='A' ;T(Z)<3> ='NOINPUT'
    Z += 1 ; F(Z) = 'XX>MIX.WD.SRC.AMT'; N(Z) = '15..C'; T(Z)<1> ='A' ;* 07/09/05 - Sathish PS s/e Dont make this NOINPUT
    ! 10 OCT 06 - Sathish PS /s
    Z += 1 ; F(Z) = 'DEPOSIT.CCY' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY'
    CHECKFILE(Z) = 'CURRENCY' :@FM: EB.CUR.CCY.NAME :@FM: 'L'
    Z += 1 ; F(Z) = 'DEPOSIT.AMOUNT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT'; T(Z)<2> = '':@VM:TFS.DEPOSIT.CCY
    Z += 1 ; F(Z) = 'ACTUAL.DEPOSIT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT'; T(Z)<2> = '':@VM:TFS.DEPOSIT.CCY
    Z += 1 ; F(Z) = 'CASH.BACK.CCY' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY'
    CHECKFILE(Z) = 'CURRENCY' :@FM: EB.CUR.CCY.NAME :@FM: 'L'
    Z += 1 ; F(Z) = 'CASH.BACK' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<2> = '':@VM:TFS.DEPOSIT.CCY ;*R22 Manual Conversion
    Z += 1 ; F(Z) = 'DO.CASH.BACK' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'
    Z += 1 ; F(Z) = 'STORE.CASH.BACK' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<3> = 'NOINPUT'

    !    ADDNL.FIELDS = 20 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    ! 29 AUG 07 - Sathish PS /s
    Z += 1 ; F(Z) = 'NET.ENTRY' ; N(Z) = '10..C' ; T(Z)<1> = '' ; T(Z)<2> = 'CREDIT_DEBIT_BOTH_NO' ; T(Z)<9> = 'HOT.FIELD'        ;* 29 AUG 07 - Sathish PS s/e (Default is NULL/NO)
    !    IF NOT(R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU>) THEN T(Z)<3> = 'NOINPUT' ;* 04 OCT 07 - Sathish PS s/e
    ADDNL.FIELDS = 12 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    ! 29 AUG 07 - Sathish PS /e
    ! 10 OCT 06 - Sathish PS /e
* 07/09/05 - GP /e
    Z += 1 ; F(Z) = 'XX<TRANSACTION' ; N(Z) = '15..C' ; T(Z)<1> = 'A'
    IF R.TFS.PAR<TFS.PAR.TFST.LOOKUP> EQ 'VETTING.TABLE' THEN
        T(Z)<1> = '' ; T(Z)<2> = TFS$TFS.TRANSACTIONS
    END ELSE
        CHECKFILE(Z) = 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION :@FM: 'L'
    END
    Z += 1 ; F(Z) = 'XX-IMPORT.UL' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOCHANGE'
    CONCATFILE(Z)= 'NEW' :@FM: 'TFS.UL.IMPORT.CONCAT'        ;* 07/25/05 GP s/e
    Z += 1 ; F(Z) = 'XX-SURROGATE.AC' ; N(Z) = AC.LEN :'..C' ; T(Z)<1> = '.ALLACCVAL'     ;* 05/17/05 Sathish PS s/e ; * 08/03/05 - Sathish PS s/e
    CHECKFILE(Z) = 'ACCOUNT' :@FM: AC.SHORT.TITLE  ;* 08/03/05 - Sathish PS s/e

    Z += 1 ; F(Z) = 'XX-ACCOUNT.DR' ; N(Z) = AC.LEN:'..C' ; T(Z)<1> = '.ALLACCVAL'
    Z += 1 ; F(Z) = 'XX-ACCOUNT.CR' ; N(Z) = AC.LEN:'..C' ; T(Z)<1> = '.ALLACCVAL'
    Z += 1 ; F(Z) = 'XX-CURRENCY' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY'
    CHECKFILE(Z) = 'CURRENCY' :@FM: EB.CUR.CCY.NAME :@FM: 'L'
    Z += 1 ; F(Z) = 'XX-AMOUNT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<2> = '':@VM:TFS.CURRENCY:".X" ; T(Z)<9> = 'HOT.FIELD'    ;* 13 SEP 07 - Sathish PS s/e
    Z += 1 ; F(Z) = 'XX-WAIVE.CHARGE' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'

    ADDNL.FIELDS = 4 ; FIELD.NAME = 'XX-RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'XX-CR.VALUE.DATE' ; N(Z) = '11..C' ; T(Z)<1> = 'D' ; T(Z)<9> = 'HOT.FIELD'
    Z += 1 ; F(Z) = 'XX-DR.VALUE.DATE' ; N(Z) = '11..C' ; T(Z)<1> = 'D' ; T(Z)<9> = 'HOT.FIELD'
    Z += 1 ; F(Z) = 'XX-RESERVED.':Z ; N(Z) = '15..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-CR.EXP.DATE' ; N(Z) = '11..C' ; T(Z)<1> = 'D'
    Z += 1 ; F(Z) = 'XX-DR.EXP.DATE' ; N(Z) = '11..C' ; T(Z)<1> = 'D'
*
* THEIR.REFERENCE is not added because, except for THEIR.REFERENCE, there is no other
* place in FT that we can pass our id (ID.NEW), to the statement entry.
* So, in FT, TT and DC, THEIR.REF will be populated with ID.NEW by default.
*
    Z += 1 ; F(Z) = 'XX-OUR.REFERENCE' ; N(Z) = '16..C' ; T(Z)<1> = 'S'
    Z += 1 ; F(Z) = 'XX-NARRATIVE' ; N(Z) = '34..C' ; T(Z)<1> = 'S'
    Z += 1 ; F(Z) = 'XX-PRODUCT.CATEG' ; N(Z) = '10..C' ; T(Z)<1> = 'CAT'
    CHECKFILE(Z) = 'CATEGORY' :@FM: EB.CAT.DESCRIPTION :@FM: 'L'

    Z += 1 ; F(Z) = 'XX-STANDING.ORDER' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'STANDING.ORDER' :@FM: STO.BENEFICIARY :@FM: 1

    Z += 1 ; F(Z) = 'XX-CUSTOMER.NO' ; N(Z) = '20..C' ; T(Z)<1> = 'CUS'
    CHECKFILE(Z) = 'CUSTOMER' :@FM: EB.CUS.SHORT.NAME :@FM: 'L'

    Z += 1 ; F(Z) = 'XX-ACCOUNT.OFFICER' ; N(Z) = '20..C' ; T(Z)<1> = ''
    CHECKFILE(Z) = 'DEPT.ACCT.OFFICER' :@FM: EB.DAO.NAME
    Z += 1 ; F(Z) = 'XX-DC.REVERSE.MARK' ; N(Z) = '1..C' ; T(Z)<1> = '' ; T(Z)<2> = 'R'

    Z += 1 ; F(Z) = 'XX-AMOUNT.LCY' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<2,2> = LCCY
    Z += 1 ; F(Z) = 'XX-CHG.CODE' ; N(Z) = '20..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX-CHG.CCY' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY'
    Z += 1 ; F(Z) = 'XX-CHG.AMT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT'
    Z += 1 ; F(Z) = 'XX-CHG.AMT.LCY' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT'

    ADDNL.FIELDS = 5 ; FIELD.NAME = 'XX-RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'XX-CHQ.TYPE' ; N(Z) = '4..C' ; T(Z)<1> = 'SSS'
    CHECKFILE(Z) = 'CHEQUE.TYPE' :@FM: CHEQUE.TYPE.DESCRIPTION
    Z += 1 ; F(Z) = 'XX-CHEQUE.NUMBER' ; N(Z) = '14..C' ; T(Z)<1> = ''
    Z += 1 ; F(Z) = 'XX-CHEQUE.DRAWN' ; N(Z) = '14..C' ; T(Z)<1> = ''

    Z += 1 ; F(Z) = 'XX-XX<EXP.SCHEDULE' ; N(Z) = '20..C' ; T(Z)<1> = 'A' ; T(Z)<9> = 'HOT.FIELD'
    IF R.TFS.PAR<TFS.PAR.TFS.EXPOSURE> EQ 'NATIVE' THEN
        CHECKFILE(Z) = 'TFS.EXPOSURE.SCHEDULE' :@FM: TFS.EXP.SCH.DESCRIPTION :@FM: 'L'
    END

    Z += 1 ; F(Z) = 'XX-XX-EXP.DATE' ; N(Z) = '11..C' ; T(Z)<1> = 'D'
    Z += 1 ; F(Z) = 'XX-XX>EXP.AMT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT'
    ! 23 OCT 07 - Sathish PS /s
    Z += 1 ; F(Z) = 'XX-DR.CURR.MKT' ; N(Z) = '10..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'         ;* Dont need checkfile though...
    Z += 1 ; F(Z) = 'XX-CR.CURR.MKT' ; N(Z) = '10..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'         ;* Dont need checkfile though...
    !    ADDNL.FIELDS = 7 ; FIELD.NAME = 'XX-RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    ADDNL.FIELDS = 5 ; FIELD.NAME = 'XX-RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    ! 23 OCT 07 - Sathish PS /e

    Z += 1 ; F(Z) = 'XX-UNDERLYING' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-UL.STATUS' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-XX.UL.STMT.NO' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-UL.CHARGE.CCY' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-UL.CHARGE' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-R.UNDERLYING' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-XX.R.UL.STMT.NO' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-R.UL.STATUS' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-UL.COMPANY' ; N(Z) = '11..C' ; T(Z)<1> = 'COM' ; T(Z)<3> = 'NOINPUT'
    CHECKFILE(Z) = 'COMPANY' :@FM: EB.COM.COMPANY.NAME :@FM: 'L'

* 02/10/05 - Sathish PS /s
    Z += 1 ; F(Z) = 'XX-XX<CR.DENOM' ; N(Z) = '12..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    CHECKFILE(Z) = 'TELLER.DENOMINATION' :@FM: TT.DEN.DESC :@FM: 'L'
    Z += 1 ; F(Z) = 'XX-XX-CR.DEN.UNIT' ; N(Z) = '9..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX-XX>CR.SERIAL.NO' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX-XX<DR.DENOM' ; N(Z) = '12..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    CHECKFILE(Z) = 'TELLER.DENOMINATION' :@FM: TT.DEN.DESC :@FM: 'L'
    Z += 1 ; F(Z) = 'XX-XX-DR.DEN.UNIT' ; N(Z) = '9..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX-XX>DR.SERIAL.NO' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    ! 23 OCT 07 - Sathish PS /s
    Z += 1 ; F(Z) = 'XX-CURRENCY.DR' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-EXCH.RATE.DR' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-AMOUNT.DR' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-CURRENCY.CR' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-EXCH.RATE.CR' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-AMOUNT.CR' ; N(Z) = '3..C' ; T(Z)<1> = 'CCY' ; T(Z)<3> = 'NOINPUT'
    !    ADDNL.FIELDS = 6 ; FIELD.NAME = 'XX-RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    ! 23 OCT 07 - Sathish PS /e
    Z += 1 ; F(Z) = 'XX-XX.LOCK.REF' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'         ;* 26 SEP 07 - Sathish PS s/e
    Z += 1 ; F(Z) = 'XX-NETTED.ENTRY' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'

* 02/10/05 - Sathish PS /e
* 10 OCT 06 - Sathish PS /s
    Z += 1 ; F(Z) = 'XX-CASH.BACK.DIR' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'IN_OUT'          ;* IN or OUT from Washthru Perspective
    Z += 1 ; F(Z) = 'XX-CASH.BACK.TXN' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'
* 10 OCT 06 - Sathish PS /e

    Z += 1 ; F(Z) = 'XX-MIX.WITHDRAWAL' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'
    Z += 1 ; F(Z) = 'XX-VAL.ERROR' ; N(Z) = '35..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX-REVERSAL.MARK' ; N(Z) = '1..C' ; T(Z)<1> = '' ; T(Z)<2> = 'R'
    Z += 1 ; F(Z) = 'XX>RETRY' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'

    Z += 1 ; F(Z) = 'STORE.MIX.WD.AMT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX.STORE.SPLIT.AMT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<3> = 'NOINPUT'

    ! 29 AUG 07 - Sathish PS /e
    Z += 1 ; F(Z) = 'CREATE.NET.ENTRY' ; N(Z) = '10..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO_REVERSE' ; T(Z)<9> = 'HOT.VALIDATE'    ;* 29 AUG 07 - Sathish PS s/e trigger to create the entry ;* 13 SEP 07 - Sathish PS s/e
    IF NOT(R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU>) THEN T(Z)<3> = 'NOINPUT'
    ! 29 AUG 07 - Sathish PS /s
    ADDNL.FIELDS = 7 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'XX<ACCOUNT.NUMBER' ; N(Z) = AC.LEN:'..C' ; T(Z)<1> = '.ALLACCVAL' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX>NET.TXN.AMT' ; N(Z) = '19..C' ; T(Z)<1> = 'AMT' ; T(Z)<2,2> = LCCY ; T(Z)<3> = 'NOINPUT'

    ADDNL.FIELDS = 10 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    Z += 1 ; F(Z) = 'XX.LOCAL.REF' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX.OVERRIDE' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'

    V = Z + 9

    MAT TFS$T = MAT T         ;* 03/24/05 - Sathish PS s/e

RETURN
*------------------------------------------------------------------------------------------
ADD.RESERVED.FIELDS:

    FOR XX = 1 TO ADDNL.FIELDS
        Z += 1 ; F(Z) = FIELD.NAME:'.':Z ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    NEXT XX

RETURN
*-------------------------------------------------------------------------------------------
* 29 AUG 07 - Sathish PS /s
INITIALISE:

    PROCESS.GOAHEAD = 1
    FN.TFSP = 'F.TFS.PARAMETER' ; F.TFSP = '' ; ID.TFSP = ID.COMPANY
    FN.TFST = 'F.TFS.TRANSACTION' ; F.TFST = '' ; CALL OPF(FN.TFST,F.TFST)
    CALL EB.READ.PARAMETER(FN.TFSP,'N','',R.TFS.PAR,ID.TFSP,F.TFSP,ERR.TFSP)    ;* 04/12/05 - Sathish PS s/e
    IF R.TFS.PAR THEN
        GOSUB BUILD.TFS.TRANSACTION.LIST          ;* 29 AUG 07 - Sathish PS s/e
    END

RETURN
*-------------------------------------------------------------------------------------------
BUILD.TFS.TRANSACTION.LIST:
 
    IF R.TFS.PAR<TFS.PAR.TFST.LOOKUP> EQ 'VETTING.TABLE' THEN
        IF NOT(TFS$TFS.TRANSACTIONS) OR OFS$BROWSER THEN
* 20100624 umar - start
*            SEL.TFST = 'SSELECT ':FN.TFST
*            CALL EB.READLIST(SEL.TFST,TFS$TFS.TRANSACTIONS,'','','')
            CALL CACHE.READ(FN.TFST,'SSelectIDs',TFS$TFS.TRANSACTIONS,'')
* 20100624 umar - end
            CONVERT @FM TO '_' IN TFS$TFS.TRANSACTIONS       ;* So can be used in T(Z)<2>.
        END
    END

RETURN
* 29 AUG 07 - Sathish PS /e
*----------------------------------------------------------------------------------


END











