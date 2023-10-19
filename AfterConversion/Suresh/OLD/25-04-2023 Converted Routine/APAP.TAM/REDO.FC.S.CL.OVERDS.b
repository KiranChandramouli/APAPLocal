* @ValidationCode : MjoxNjQyMjAwNjIxOkNwMTI1MjoxNjgyNDIwNzM0NjMxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:35:34
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
SUBROUTINE REDO.FC.S.CL.OVERDS
*------------------------------------------------------------------------------------------------------------------
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2011-11-23
* Description  : This routine validate if all Mandatory doc were recived
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.1              2011-11-23    Jorge Valarezo   First Version
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT


    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*==================
INITIALISE:
*==================

RETURN

*==================
OPENFILES:
*==================

RETURN
*==================
PROCESS:
*==================
    R.NEW(REDO.FC.OVERRIDE)=""
RETURN

END
