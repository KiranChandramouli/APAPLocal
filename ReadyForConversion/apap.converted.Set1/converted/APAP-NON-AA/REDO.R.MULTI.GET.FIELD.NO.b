SUBROUTINE REDO.R.MULTI.GET.FIELD.NO(P.APPLICATION,P.FIELD.NAME, R.STANDARD.SELECTION, P.FIELD.NO)
*-----------------------------------------------------------------------------
*
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package REDO.AA
* This routines allows to get a field number for the given application and field names
*
* Parameters
* ------------------
* P.APPLICATION (in) It must be a valid entry from STANDARD.SELECTION
* P.FIELD.NAME (in) The list of fields' names to be searched
* R.STANDARD.SELECTION (in) Standard Selection record. optional. If left blank, the routine try to load it
* P.FIELD.NO (out) The list of fields' numbers found,
* If the field was not found then an emtpy entry was returned
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION
*-----------------------------------------------------------------------------


    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
    IF R.STANDARD.SELECTION EQ '' THEN
        CALL GET.STANDARD.SELECTION.DETS( P.APPLICATION, R.STANDARD.SELECTION )
    END
    Y.TOT.FIELDS = DCOUNT(P.FIELD.NAME,@FM)
    FOR I.VAR=1 TO Y.TOT.FIELDS
        FIELD.NAME = P.FIELD.NAME<I.VAR>
        FIELD.NO = ''
        GOSUB FIND.FIELD
        P.FIELD.NO<I.VAR> = FIELD.NO
    NEXT I.VAR
RETURN
*-----------------------------------------------------------------------------
FIND.FIELD:
*-----------------------------------------------------------------------------
    FIELD.NO = ''
    NOT.FINISHED = 1
    LOCATE FIELD.NAME IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING FOUND.POS THEN
        LOOP
        WHILE NOT.FINISHED
            BEGIN CASE
                CASE NUM(R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,FOUND.POS>) ;* Points to a field
                    FIELD.NO = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,FOUND.POS>
                    NOT.FINISHED = ''
                CASE OTHERWISE
*< APAP - B.5
                    IF NOT(FIELD.NO) THEN
                        CALL GET.LOC.REF(P.APPLICATION,FIELD.NAME,FIELD.NO)

                    END
*> APAP - B.5
                    FIELD.NAME = R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,FOUND.POS>
            END CASE
            LOCATE FIELD.NAME IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING FOUND.POS ELSE
                NOT.FINISHED = ''
            END
        REPEAT
    END


RETURN
*-----------------------------------------------------------------------------
END
