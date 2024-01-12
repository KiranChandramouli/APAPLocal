* @ValidationCode : MjotMTY0NDE4MjI0MzpDcDEyNTI6MTY4MjQxMjMyOTU4MjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.ID.NO.NEW.RECORD
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to show an error if user clicks the new deal button in Modification version
* ------------------------------------------------------------------------
*   Date               who           Reference                       Description
* 26-APR-2011     SHANKAR RAJU    CR.007-CU Version Integration    Initial Creation
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------
INITIALISE:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    R.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
*-------------------------------------------------------------------------
PROCESS:

    CALL F.READ(FN.CUSTOMER,COMI,R.CUSTOMER,F.CUSTOMER,ERR.CUS)

    IF R.CUSTOMER EQ '' THEN
        E = 'EB-REDO.NO.NEW.RECORD'
    END
RETURN
*-------------------------------------------------------------------------
END
