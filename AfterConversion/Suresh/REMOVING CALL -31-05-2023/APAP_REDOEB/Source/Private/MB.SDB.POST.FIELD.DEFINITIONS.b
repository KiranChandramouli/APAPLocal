* @ValidationCode : MjotODg2NTIzNjUyOkNwMTI1MjoxNjgxOTc5NTk2NDQ0OklUU1M6LTE6LTE6LTE4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -18
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.POST.FIELD.DEFINITIONS

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool   R22 Auto conversion         FM TO @FM
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.RELATION
    $INSERT I_F.MB.SDB.MAINT

    GOSUB INITIALISE

    GOSUB DEFINE.FIELDS

RETURN

*-----------------------------------------------------------------------------
DEFINE.FIELDS:

    ID.F = "SDB.POST.NO" ; ID.N = "14" ; ID.T = "A"

    Z=0

    Z+=1 ; F(Z) = "SDB.OPERATE" ; N(Z) = "15.2.C" ; T(Z)<2> = "OPEN_MODIFY_RESERVE_VISIT_CLOSE_MAINTAIN"
    Z+=1 ; F(Z) = "SDB.COMPANY" ; N(Z) = "20.1.C" ; T(Z) = "A"
    CHECKFILE(Z) = "COMPANY":@FM:EB.COM.COMPANY.NAME:@FM:'L'
    Z+=1 ; F(Z) = "SDB.NUMBER" ; N(Z) = "18.1.C" ; T(Z) = "A"; T(Z)<9> = 'HOT.FIELD'
    Z+=1 ; F(Z) = "CUSTOMER.NO" ; N(Z) = "10..C" ; T(Z) = "A"; T(Z)<1> = 'CUS'
    CHECKFILE(Z) = "CUSTOMER":@FM:EB.CUS.SHORT.NAME:@FM:"L"
    Z+=1 ; F(Z) = "RENEW.METHOD" ; N(Z) = "7" ; T(Z)<2> = "AUTO_MANUAL"
    Z+=1 ; F(Z) = "RENEW.FREQUENCY" ; N(Z) = "15" ; T(Z)<1> = "FQU"
    Z+=1 ; F(Z) = "PERIODIC.RENT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "DISCOUNT.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "VAT.AMOUNT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "DEPOSIT.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "INITIAL.OFFER.AMT" ; N(Z) = "19..C" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "VAT.OFFER.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "OFFER.EXPIRY.DATE" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "D"
    Z+=1 ; F(Z) = "CUSTOMER.ACCT" ; N(Z) = "16..C" ; T(Z) = "ACC"
    CHECKFILE(Z) = "ACCOUNT":@FM:AC.SHORT.TITLE:@FM:'L'
    Z+=1 ; F(Z) = "TOTAL.CHARGE.AMT" ; N(Z) = "19" ; T(Z) = "N"; T(Z)<1> = "AMT"; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "XX.ADD.ACCESS.CUST" ; N(Z) = "55" ; T(Z) = "A"; T(Z)<1> = "A"
    Z+=1 ; F(Z) = "ACCESS.NAME" ; N(Z) = "55" ; T(Z) = "A"; T(Z)<1> = "A"
    Z+=1 ; F(Z) = "ACCESS.DATE" ; N(Z) = "11..C" ; T(Z) = "A"; T(Z)<1> = "D"
    Z+=1 ; F(Z) = "ACCESS.TIME" ; N(Z) = "5..C" ; T(Z)<1> = "A" ; T(Z)<4> = "R##:##"
    Z+=1 ; F(Z) = "ACCESS.SLIP.NO" ; N(Z) = "15" ; T(Z)<1> = "A";
    Z+=1 ; F(Z) = "XX.NOTES" ; N(Z) = "60" ; T(Z)<1> = "A"
    Z+=1 ; F(Z) = "REFUND.METHOD" ; N(Z) = "10..C" ; T(Z)<2> = "AUTO_MANUAL"
    Z+=1 ; F(Z) = "NON.AMORT.AMT" ; N(Z) = "19" ; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "AMORTISED.AMT" ; N(Z) = "19" ; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "REFUND.AMT" ; N(Z) = "19..C" ; T(Z) = "N"; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "XX.LOCAL.REF" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "AMORT.Y.N" ; N(Z) = "1" ; T(Z)<2> = "Y_N"
    Z+=1 ; F(Z) = "HOLDER.NAME" ; N(Z) = "55" ; T(Z) = "A"
    Z+=1 ; F(Z) = "STATUS" ; N(Z) = "20" ; T(Z)<2> = "AVAILABLE_RENTED_RESERVED_REPAIR"
    Z+=1 ; F(Z) = "XX<JOINT.HOLDER" ; N(Z)="10"; T(Z) = ""
    CHECKFILE(Z) = "CUSTOMER":@FM:EB.CUS.SHORT.NAME:@FM:'L'
    Z+=1 ; F(Z) = "XX-RELATION.CODE" ; N(Z)="3"; T(Z) = ""
    CHECKFILE(Z) = "RELATION":@FM:EB.REL.DESCRIPTION:@FM:'L'
    Z+=1 ; F(Z) = "XX>XX.JOINT.NOTES" ; N(Z)="35"; T(Z) = "A"
    Z+=1 ; F(Z) = "XX.KEY.NUMBERS" ; N(Z) = "10" ; T(Z) = ""; T(Z)<1> = "A"
    Z+=1 ; F(Z) = "COLLECT.NEXT.P" ; N(Z) = "3..C" ; T(Z)<2> = "YES_NO"
    Z+=1 ; F(Z) = "MAINT.ACTION" ; N(Z) = "2" ; T(Z) = ""; T(Z)<1> = "A"
    CHECKFILE(Z) = "MB.SDB.MAINT":@FM:SDB.MNT.DESCRIPTION:@FM:'L'
    Z+=1 ; F(Z) = "NO.OF.SIGNERS" ; N(Z) = "2" ; T(Z) = ""
    Z+=1 ; F(Z) = "RESERVED.1" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "XX.OVERRIDE" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3> = "NOINPUT"

    V = Z + 9

RETURN

*-----------------------------------------------------------------------------
INITIALISE:

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

    CHK.ACCOUNT = "ACCOUNT":@FM:AC.SHORT.TITLE:@FM:"L"

RETURN

END
