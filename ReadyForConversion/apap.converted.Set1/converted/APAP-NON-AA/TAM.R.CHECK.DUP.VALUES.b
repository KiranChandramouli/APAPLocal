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
                pos += 1
                LOCATE whatCheck IN whereCheck<pos> SETTING pos THEN
                    result = pos
                END
            END

        CASE marker EQ @VM
            LOCATE whatCheck IN whereCheck<1,1> SETTING pos THEN
                pos += 1
                LOCATE whatCheck IN whereCheck<1,pos> SETTING pos THEN
                    result = pos
                END
            END

        CASE marker EQ @SM
            LOCATE whatCheck IN whereCheck<1,1,1> SETTING pos THEN
                pos += 1
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
