* @ValidationCode : MjotNTgwNDE5Njk5OkNwMTI1MjoxNzA0ODAxNTM0NzQ5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 17:28:54
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CHARGE.MIN.BAL.SELECT

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.CUSTOMER.ACCOUNT
   * $INSERT  I_TSA.COMMON
    $INSERT  I_AA.LOCAL.COMMON
    $INSERT  I_F.COMPANY
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.DATES
    $INSERT  I_F.AC.CHARGE.REQUEST
   $USING EB.Service
    $INCLUDE I_F.LAPAP.CHARGE.BAL.MIN.PARAM
    $INSERT  I_LAPAP.CHARGE.MIN.BAL.COMMON

    GOSUB SELECT

RETURN
********
SELECT:
********
    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.CUST = ''; CUS.POS = '';
    SEL.CMD = "SELECT ":FN.CUSTOMER:" WITH L.CU.TIPO.CL EQ 'PERSONA JURIDICA'";
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.COUNT.CUST = DCOUNT(SEL.LIST,@FM);
    IF Y.COUNT.CUST GT 0 THEN
        Y.DATA = SEL.LIST;
*        CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
    END
RETURN
END
