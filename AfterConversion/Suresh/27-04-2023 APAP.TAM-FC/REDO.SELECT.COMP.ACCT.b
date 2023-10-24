* @ValidationCode : MjotNTA4MzI1NDY0OkNwMTI1MjoxNjgxMzgxMTgwOTI1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 15:49:40
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
SUBROUTINE REDO.SELECT.COMP.ACCT(ENQ.DATA)
*----------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: TAM
* PROGRAM NAME: REDO.SELECT.COMP.ACCT
*----------------------------------------------------------------------
*DESCRIPTION  : This is a build routine used for selection of branch code
*LINKED WITH  : Enquiry REDO.LIST.NOSTRO.ACCTS
*IN PARAMETER : ENQ.DATA
*OUT PARAMETER: ENQ.DATA
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO                REFERENCE         DESCRIPTION
*26 MAY 2010  Mohammed Anies K   ODR-2010-03-0447  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*----------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------
PROCESS:
* Defaulting ID.COMPANY to selection field BRANCH.CODE

    ENQ.DATA<2,1>='BRANCH.CODE'
    ENQ.DATA<3,1>='EQ'
    ENQ.DATA<4,1>=ID.COMPANY

RETURN
*---------------------------------------------------------------------
END
