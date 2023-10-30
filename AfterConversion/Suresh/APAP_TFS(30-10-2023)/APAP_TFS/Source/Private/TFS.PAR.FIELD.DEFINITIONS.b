* @ValidationCode : MjotOTkyMTYxNDAzOkNwMTI1MjoxNjk4MzA5NzIwNjY4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 14:12:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-177</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.PAR.FIELD.DEFINITIONS
*
* Field definition subroutine for TFS.PARAMETER template.
*
*----------------------------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
* 10/23/04 - Sathish PS
*            Added new field - WASHTHRU.CATEG
*
* 03/25/05 - Sathish PS
*            Added a new multi valued field to define those fields that need to be
*            reset whenever the TRANSACTION field is changed in T24.FUND.SERVICES
*
* 04/12/05 - Sathish PS
*            Change to ID of the record - Not SYSTEM anymore.
*
* 07/09/05 - Ganesh Prasad
*            To handle coins dispense;Added additional fields
*
* 10 OCT 06 - Sathish PS
*             Added new fields for Cash Back functionality
*
* 29 AUG 07 - Sathish PS
*             Added new field to facilitate Entry netting on Customer account.
*             Field TFST.LOOKUP to indicate whether a checkfile is requried on TFS.TRANSACTION
*             or the list to be provided in a vetting table (Select will be done to
*             new common variable TFS$TFS.TRANSACTIONS in T24.FS.INITIALISE and pickedup
*             by T24.FS.FIELD.DEFINITIONS
*             Added field for handling exposure details
*
* 26 SEP 07 - Sathish PS
*             Ability to define whether to use AC.LOCKED.EVENTS or EXP.SPT.DAT in TELLER
*             to apply hold on deposits.
*----------------------------------------------------------------------------------------

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion                USPLATFORM.BP File is Removed >FM to @Fm
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER

    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.COMPANY
    $INSERT I_F.EB.PRODUCT
    $INSERT I_F.CATEGORY
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.FT.COMMISSION.TYPE

    $INCLUDE  I_F.TFS.TRANSACTION
    $INCLUDE  I_F.TFS.EXPOSURE.SCHEDULE  ;* R22 manual Code conversion       ;* 29 AUG 07 - Sathish PS s/e

    ID.F = '' ; ID.N = '' ; ID.T = ''
    MAT F = '' ; MAT N = '' ; MAT T = ''
    ID.CHECKFILE = '' ; ID.CONCATFILE = ''
    MAT CHECKFILE = '' ; MAT CONCATFILE = ''

    ID.F = 'PARAMETER.ID' ; ID.N = '6.1.C' ; ID.T<1> = 'COM'
    ID.CHECKFILE = 'COMPANY' :@FM: EB.COM.COMPANY.NAME :@FM: 'L'

    Z = 0
    Z += 1 ; F(Z) = 'XX.LL.DESCRIPTION' ; N(Z) = '35.1.C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX.DEF.TFS.TXNS' ; N(Z) = '15..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION
    Z += 1 ; F(Z) = 'OFS.SOURCE' ; N(Z) = '20.1.C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'OFS.SOURCE' :@FM: OFS.SRC.DESCRIPTION
    Z += 1 ; F(Z) = 'XX<APPLICATION' ; N(Z) = '5.1.C' ; T(Z)<1> = 'ANY'
    CHECKFILE(Z) = 'EB.PRODUCT' :@FM: EB.PRD.DESCRIPTION :@FM: 'L'
    Z += 1 ; F(Z) = 'XX-APPLICATION.API' ; N(Z) = '35..C' ; T(Z)<1> = 'ANY'

    ADDNL.FIELDS = 5 ; FIELD.NAME = 'XX-RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'XX>OFS.VERSION' ; N(Z) = '35.1.C' ; T(Z)<1> = 'A'
* 10/23/04 - Sathish PS/s
*
* If in T24.FUND.SERVICES, any of the suspense accounts belong to this category, then
* irrespective of the Currency, they will be netted and shown as 1 single net balance
* in the NET.TXN.AMT field.
*
    Z += 1 ; F(Z) = 'XX.WASHTHRU.CATEG' ; N(Z) = '20..C' ; T(Z)<1> = '' ; T(Z)<2> = '10000...19999'
    CHECKFILE(Z) = 'CATEGORY' :@FM: EB.CAT.DESCRIPTION :@FM: 'L'
* 10/23/04 - Sathish PS/e
    Z += 1 ; F(Z) = 'STO.ENRICHMENT' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    ADDNL.FIELDS = 1 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    Z += 1 ; F(Z) = 'XX.RESET.FIELDS' ; N(Z) = '35..C' ; T(Z)<1> = 'A'          ;* 03/25/05 - Sathish PS s/e

    ADDNL.FIELDS = 7 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'DEF.ACCNTG.STYLE' ; N(Z) = '15.1.C' ; T(Z)<1> = '' ; T(Z)<2> = 'ATOMIC_INDEPENDENT'
    Z += 1 ; F(Z) = 'DC.TXN.CODE.CR' ; N(Z) = '5.1.C' ; T(Z)<1> = ''
    CHECKFILE(Z) = 'TRANSACTION' :@FM: AC.TRA.NARRATIVE :@FM: 'L'
    Z += 1 ; F(Z) = 'DC.TXN.CODE.DR' ; N(Z) = '5.1.C' ; T(Z)<1> = ''
    CHECKFILE(Z) = 'TRANSACTION' :@FM: AC.TRA.NARRATIVE :@FM: 'L'

    Z += 1 ; F(Z) = 'DC.DEPT.IN.DC.ID' ; N(Z) = '10..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'DC.BATCH.IN.DC.ID' ; N(Z) = '10..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'DC.REV.ON.REV' ; N(Z) = '20..C' ; T(Z)<1> = '' ; T(Z)<2> = 'RETAIN.MARKER'
    Z += 1 ; F(Z) = 'ALLOW.DC.ZERO.AUT' ; N(Z) = '20..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'
    Z += 1 ; F(Z) = 'ALLOW.FT.HIS.REV' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'
    Z += 1 ; F(Z) = 'ASSIGN.DR.DENOM' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'
* 07/09/05 -GP /S
    Z += 1 ; F(Z) = 'MIX.WITHDRAWAL' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'

    Z += 1 ; F(Z) = 'XX<MIX.WD.SRC.CAT' ; N(Z) = '35..C'; T(Z)<1> ='A'
    CHECKFILE(Z) = 'CATEGORY' :@FM: EB.CAT.DESCRIPTION :@FM: 'L'

    Z += 1 ; F(Z) = 'XX>MIX.WD.TXN.TYPE' ; N(Z) = '35..C'; T(Z)<1> ='A'
    CHECKFILE(Z)= 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION

    !    Z += 1 ; F(Z) = 'MIX.WD.CURRENCY' ; N(Z) = '3'; T(Z)<1> ='A'
    !    CHECKFILE(Z)='CURRENCY'

    ADDNL.FIELDS = 1 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'MIX.WD.WASH.THRU' ; N(Z) = '35..C'; T(Z)<1> ='A'
    CHECKFILE(Z) = 'CATEGORY' :@FM: EB.CAT.DESCRIPTION :@FM: 'L'
    Z+= 1 ; F(Z) = 'MIX.WASH.TXN.TYPE' ; N(Z) ='35..C' ; T(Z)<1> ='A'
    CHECKFILE(Z)= 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION
    Z += 1 ; F(Z) = 'XX.MIX.WD.API'     ; N(Z) = '35..C';  T(Z)=  'RAD.API'
* 10 OCT 06 - Sathish PS /s
    Z += 1 ; F(Z) = 'CASH.BACK.WTHRU' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'CATEGORY' :@FM: EB.CAT.DESCRIPTION :@FM: 'L'
    Z += 1 ; F(Z) = 'CASH.BACK.TXN.1' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION :@FM: 'L'
    Z += 1 ; F(Z) = 'CASH.BACK.TXN.2' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION :@FM: 'L'
    Z += 1 ; F(Z) = 'CASH.BACK.TXN.3' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION :@FM: 'L'
    ! 29 AUG 07 - Sathish PS /s
    Z += 1 ; F(Z) = 'NET.ENTRY.WASHTHRU' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'CATEGORY' :@FM: EB.CAT.DESCRIPTION :@FM: 'L'
    Z += 1 ; F(Z) = 'NET.ENTRY.TXN' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'TFS.TRANSACTION' :@FM: TFS.TXN.DESCRIPTION :@FM: 'L'
    Z += 1 ; F(Z) = 'TFST.LOOKUP' ; N(Z) = '15..C' ; T(Z)<1> = '' ; T(Z)<2> = 'VETTING.TABLE_CHECKFILE'
    Z += 1 ; F(Z) = 'TFS.EXPOSURE' ; N(Z) = '10..C' ; T(Z)<1> = '' ; T(Z)<2> = 'NATIVE_REGCC'
    Z += 1 ; F(Z) = 'CASH.ITEM.CODE' ; N(Z) = '20..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'TFS.EXPOSURE.SCHEDULE' :@FM: TFS.EXP.SCH.DESCRIPTION :@FM: 'L'
    ! 29 AUG 07 - Sathish PS /e
    Z += 1 ; F(Z) = 'EXPOSURE.METHOD' ; N(Z) = '20..C' ; T(Z)<1> = '' ; T(Z)<2> = 'LOCK_FLOAT'      ;* 26 SEP 07 - Sathish PS s/e
    ADDNL.FIELDS = 10 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS
* 10 OCT 06 - Sathish PS /e

* 07/09/05 -GP /E
    Z += 1 ; F(Z) = 'XX.LOCAL.REF' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX.OVERRIDE' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'

    V = Z + 9

RETURN
*----------------------------------------------------------------------------------------
ADD.RESERVED.FIELDS:

    FOR XX = 1 TO ADDNL.FIELDS
        Z += 1 ; F(Z) = FIELD.NAME:'.':Z ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    NEXT XX

RETURN
*----------------------------------------------------------------------------------------------------------


















