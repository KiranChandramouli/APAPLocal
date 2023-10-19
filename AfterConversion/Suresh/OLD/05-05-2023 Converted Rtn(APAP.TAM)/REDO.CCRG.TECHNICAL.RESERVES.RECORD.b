* @ValidationCode : MjoxMjkxNzkyMjEzOkNwMTI1MjoxNjgwNjg3NjE4MTQ4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:10:18
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
* Version 9 16/05/01  GLOBUS Release No. 200511 31/10/05
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.TECHNICAL.RESERVES.RECORD
*-----------------------------------------------------------------------------
*** Simple SUBROUTINE REDO.CCRG.TECHNICAL.RESERVES, RECORD STAGE
* @author hpasquel@temenos.com
* @stereotype recordcheck
* @package REDO.CCRG
* @uses E
* @uses AF
*!
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES

* Check if the record is okay to input to...
    GOSUB CHECK.RECORD

RETURN
*-----------------------------------------------------------------------------
CHECK.RECORD:
*-----------------------------------------------------------------------------
* Input not allowed for matured contracts!
* Allows to update the field LOCAL.CCY
    IF R.NEW(REDO.CCRG.TR.LOCAL.CCY) NE LCCY THEN
        R.NEW(REDO.CCRG.TR.LOCAL.CCY) = LCCY
    END
RETURN
*-----------------------------------------------------------------------------
END
