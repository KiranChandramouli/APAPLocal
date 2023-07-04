* @ValidationCode : MjoyMTM0MDA0MjY2OkNwMTI1MjoxNjgwNjc5MTk5NTUyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:49:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
$PACKAGE APAP.TAM
SUBROUTINE REDO.COS.RTN

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*****

    COS.NAME=''

    Y.APPLICATION = FIELD(O.DATA,'*',1)
    Y.CUST.ID = FIELD(O.DATA,'*',2)
    Y.ACCT.ID = FIELD(O.DATA,'*',3)
    Y.COS = "COS"
RETURN

PROCESS:
********

    BEGIN CASE
        CASE Y.APPLICATION EQ "ACC"
*COS.NAME = Y.COS:' ':'REDO.AC.COS':' ':Y.CUST.ID ;*// WK 12JAN2012
            COS.NAME = Y.COS:' ':'REDO.AC.COS':' ':Y.CUST.ID:' ':Y.ACCT.ID
        CASE Y.APPLICATION EQ "AZ"
            COS.NAME = Y.COS:' ':'REDO.AZ.COS':' ':Y.ACCT.ID
        CASE Y.APPLICATION EQ 'MM'
*COS.NAME = 'MM.MONEY.MARKET S ' :Y.ACCT.ID
            COS.NAME = Y.COS:' ':'REDO.MM.COS':' ':Y.ACCT.ID
    END CASE

    O.DATA = COS.NAME

RETURN
END
