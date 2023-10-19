* @ValidationCode : MjoxMTU5MDI2NTAwOkNwMTI1MjoxNjgxODEzMDU2Njg5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 15:47:36
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
SUBROUTINE REDO.VALIDATE.LOAN.STATUS
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to show an error if user gives any other value other than the defined for L.LOAN.STATUS.1 virtual table
* --------------------------------------------------------------------------------------------------------------------------
*   Date               who           Reference                       Description
*
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*---------------------------------------------------------------------------------------------------------------------------
*
* All File INSERTS done here
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------------------------------------------
* Initialise the required variables
*
INITIALISE:

    LOAN.POS = ''

    LOAN.STATUS = ""
    LOAN.STATUS = "L.LOAN.STATUS.1"
    CALL EB.LOOKUP.LIST(LOAN.STATUS)
    LOAN.STATUS = LOAN.STATUS<2>
    CHANGE '_' TO @FM IN LOAN.STATUS

    LOAN.ACC.STATUS = COMI

RETURN
*-----------------------------------------------------------------------------------------------------------------
* Check the value is valid ID in L.LOAN.STATUS.1 table
*
PROCESS:

    LOCATE LOAN.ACC.STATUS IN LOAN.STATUS SETTING LOAN.POS ELSE

        E = 'NOT A VALID STATUS'

    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*
END
