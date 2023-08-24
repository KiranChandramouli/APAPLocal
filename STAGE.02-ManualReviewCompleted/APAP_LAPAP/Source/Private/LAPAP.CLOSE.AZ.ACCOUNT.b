$PACKAGE APAP.LAPAP
*                                              T E C H N I C A L  R E Q U E R I M E N T
*-------------------------------------------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------------------------------------------
*         Condiction                                                                  Acction
*-------------------------------------------------------                            -----------------------
* IF THE ACCOUNT IN FBNK.ACCOUNT TABLE HAVE IN CATEGORY FIELD
* THE VALUES IN RANGE BETWEEN 6601 AND 6699 AND ALSO EXIST THE
* SAME ACCOUNT IN FBNK.AZ.ACCOUNT TABLE THEN                                        -->>SHOW MESSAGE : EXIST OPEN ACCOUNT IN AZ.ACCOUNT


* IF THE ACCOUNT IN FBNK.ACCOUNT TABLE DON'T HAVE THE VALUE FOR
* CATEGORY FIELD IN THE RANGE BETWEEN 6601 AND  6699                                -->>SHOW MESSAGE : ISN'T A CERTIFICATE


* IF THE ACCOUNT IN FBNK.ACCOUNT TABLE HAVE IN CATEGORY FIELD
* THE VALUES IN RANGE BETWEEN 6601 AND 6699 AND DO NOT EXIST IN
* FBNK.AZ.ACCOUNT TABLE THEN                                                        -->>DELETE THE RECORD EXISTING IN FBNK.ACCOUNT.LIQUIDATION
*-------------------------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------
SUBROUTINE LAPAP.CLOSE.AZ.ACCOUNT
*------------------------------------------------------------------------------------
* Technical report:
* -----------------
* Company Name   : APAP
* Program Name   : LAPAP.CLOSE.AZ.ACCOUNT
* Date           : 2017-09-20
* Author         : RichardHC
* Item ID        : CN007283
*------------------------------------------------------------------------------------
* Description :
* ------------
* This program allow close AZ accounts with message "OPEN BASE ACCOUNT"
*------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
*
*------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Table name     : ST.LAPAP.CLOSE.AZ.ACCOUNT
* Auto Increment : ST.LAPAP.CLOSE.AZ.ACCOUNT
* Views/versions : ST.LAPAP.CLOSE.AZ.ACCOUNT,INPUT/,DETAIL
* EB record      : LAPAP.CLOSE.AZ.ACCOUNT /.VALID
* Routines       : LAPAP.CLOSE.AZ.ACCOUNT /.VALID
*------------------------------------------------------------------------------------

*Importing the neccessary libraries and tables.
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - <> to NE
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.CLOSE.AZ.ACCOUNT

*Declaring variable and asigning corresponding table name
    FN.AC.ARC = "FBNK.ACCOUNT.LIQUIDATION"

*Capturing data from browser
    P.ACCOUNT.ID = R.NEW(ST.LAP13.ACCOUNT.NUMBER)

*Creating the consult and executing with terminal output
    SEL.CMD = 'SELECT ': FN.AC.ARC :' WITH @ID EQ ':P.ACCOUNT.ID
    EXECUTE SEL.CMD CAPTURING OUTPUT

*Reading the previous list of data brought
    READLIST REC.LIST ELSE REC.LIST = ''

*validating if the list brought is empty or not;
*if bring something proceed to delete otherwise return again
    IF REC.LIST NE '' THEN		;*R22 Auto Conversion  - <> to NE
        EXECUTE 'DELETE FBNK.ACCOUNT.LIQUIDATION ':P.ACCOUNT.ID
    END

RETURN

END
