* @ValidationCode : MjotMzIyNzE2NTI0OkNwMTI1MjoxNjgwNjg3NjgzMTc5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:11:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.UPD.RLP.MAX.AMOUNT
*
*--------------------------------------------------------------------------------------------
* Company Name : Bank Name
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program reads the T24 account number for the
* corresponding IBAN number.
*
* Linked With:
*             ENQUIRY MB.ACCOUNT.DETAILS as Build Routine
*
* In Parameter:
*               ENQ.DATA
*
* Out Parameter:
*               ENQ.DATA
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 23/07/2009 - ODR-2009- XX-XXXX
*              Description of the development associated
*              johntompshon@temenos.com
*
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

*
*--------------------------------------------------------------------------------------------
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------


RETURN


*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------

RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT         = 1
    MAX.LOOPS        = 1
    PROCESS.GOAHEAD  = 1

RETURN


*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------


    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1


        END CASE

        LOOP.CNT +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------

END
