* @ValidationCode : MjoxNjY4NDU3MjM4OkNwMTI1MjoxNjkwMTY3NTM4NDUxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:58
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
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.VALID.CU.RES.SECTOR
*------------------------------------------------------------------------------------
* Technical report:
* -----------------
* Company Name   : APAP
* Program Name   : L.APAP.VALID.CU.RES.SECTOR
* Date           : 2017-12-13
* Item ID        : CN007785
*------------------------------------------------------------------------------------`
* Description :
* ------------
* This program allow close the requeriment when account has been close before
*------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2017-12-13     RichardHC                      Initial development
*
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Table name     : N/A
* Auto Increment : N/A
* Views/versions : REDO.ISSUE.REQUESTS,PROCESS
* EB record      : L.APAP.VALID.CU.RES.SECTOR
* Routine        : L.APAP.VALID.CU.RES.SECTOR
*------------------------------------------------------------------------------------
*Importing the neccessary libraries and tables.

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.CLOSE.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT

*Declaring variable with and asigning respective objects
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""

    FN.AZ.ARC = "FBNK.AZ.ACCOUNT"


    P.ACCOUNT.ID = COMI

*Opening table in the path
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

*Reading the table
    ERR.ACCOUNT = ''; R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,P.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)

*Validating the resultSet statement
    IF R.ACCOUNT<ACCOUNT.NUMBER> EQ "" THEN
        ACCOUNT.NUMBER = ''

*Sending blank the value that is validating
        COMI = ACCOUNT.NUMBER
        RETURN
    END

END
