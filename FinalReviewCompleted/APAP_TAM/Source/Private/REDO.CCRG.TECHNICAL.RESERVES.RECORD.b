* @ValidationCode : MjoxMjkxNzkyMjEzOkNwMTI1MjoxNjg0ODQyMDg1MTY1OklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
