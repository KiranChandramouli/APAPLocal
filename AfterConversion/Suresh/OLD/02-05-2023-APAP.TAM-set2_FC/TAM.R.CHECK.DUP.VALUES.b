* @ValidationCode : MjoxMTc2NTUyMzQ4OkNwMTI1MjoxNjgxODg5NjQwOTQwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:04:00
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
SUBROUTINE TAM.R.CHECK.DUP.VALUES(whatCheck, whereCheck, marker, result)
*-----------------------------------------------------------------------------
** Simple SUBROUTINE template
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
* @description Allows to located a duplicated values in the current string
* @parameters
*                 whatChek  (in)  the info to search
*                 whereCheck(in)  where the info is going to be checked
*                 marker    (in)  marker, the separator of the list (FM, VM, SM)
*                 result    (out) if dup is found, return the last position where the value is dup, else 0 is returned
* @examples
* a) vm duplicated
*           where = "FILE.FORMAT" : VM : "SECOND" : VM : "FILE.FORMATX" : VM : "FILE.FORMAT"
*           CALL TAM.R.CHECK.DUP.VALUES("FILE.FORMAT", where, VM, result)
*           CRT result ;* This must print 4
* b) fm duplicated
*           where = "ONE" : FM : "TWO" : FM : "THIRD"
*           CALL TAM.R.CHECK.DUP.VALUES("THIRD", where, FM, result)
*           CRT result ;* This must print 0
*
* if there are not dup 0 is returned into result
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:

    BEGIN CASE
        CASE marker EQ @FM
            LOCATE whatCheck IN whereCheck SETTING pos THEN
                pos += 1 ;*AUTO R22 CODE CONVERSION
                LOCATE whatCheck IN whereCheck<pos> SETTING pos THEN
                    result = pos
                END
            END

        CASE marker EQ @VM
            LOCATE whatCheck IN whereCheck<1,1> SETTING pos THEN
                pos += 1 ;*AUTO R22 CODE CONVERSION
                LOCATE whatCheck IN whereCheck<1,pos> SETTING pos THEN
                    result = pos
                END
            END

        CASE marker EQ @SM
            LOCATE whatCheck IN whereCheck<1,1,1> SETTING pos THEN
                pos += 1 ;*AUTO R22 CODE CONVERSION
                LOCATE whatCheck IN whereCheck<1,1,pos> SETTING pos THEN
                    result = pos
                END
            END
    END CASE
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
    result = 0
RETURN

*-----------------------------------------------------------------------------
END
