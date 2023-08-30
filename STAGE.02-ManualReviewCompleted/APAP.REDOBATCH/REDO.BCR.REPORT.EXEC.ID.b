* @ValidationCode : MjotMTU2NjY3MTUxNDpDcDEyNTI6MTY4MTcwOTQxMjI1MjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:00:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BCR.REPORT.EXEC.ID
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - ! TO *
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*** FIELD definitions FOR REDO.BCR.REPORT.EXEC.ID
*!
* @author hpasquel@temenos.com
* @stereotype id
* @package REDO.BCR
* @uses E
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
* The ID must start with BCR
*-----------------------------------------------------------------------------
    IF ID.NEW[1,3] NE 'BCR' THEN
        E = 'ST-REDO.BCR.ID.NOT.VALID'
        E<2> = ID.NEW
    END

RETURN

END
