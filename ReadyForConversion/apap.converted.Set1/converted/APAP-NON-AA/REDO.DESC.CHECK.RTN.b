SUBROUTINE REDO.DESC.CHECK.RTN
******************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.DESC.CHECK.RTN.DETAILS
*-----------------------------------------------------------------------------
*Description       : L.AC.OTHER.DETS can accept user input only when
*                   L.AC.PROP.USE is selected as OTHERS(SPECIFY).Otherwise
*                   this  Routine Returns Error Message to user
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*----------
INITIALISE:
*----------
    LREF.APP=''
    LREF.FIELDS=''
    LREF.POS=''
    L.AC.PROP.USE.POS=''
    L.AC.OTHER.DETS.POS=''
RETURN

*--------
PROCESS:
*--------

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.PROP.USE':@VM:'L.AC.OTHER.DETS'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.PROP.USE.POS = LREF.POS<1,1>
    L.AC.OTHER.DETS.POS=LREF.POS<1,2>

*Checks whether the value of OTHER.DETAILS field is Null or not
*When value of OTHER.DETAILS is not Null AND Value of PROPOSE.USE.ACC
*is not OTHERS THEN it Displays Error

    IF R.NEW(AC.LOCAL.REF)<1, L.AC.PROP.USE.POS> NE 'OTHERS(SPECIFY)' AND R.NEW(AC.LOCAL.REF)<1,L.AC.OTHER.DETS.POS> NE '' THEN

        AF=AC.LOCAL.REF
        AV=L.AC.OTHER.DETS.POS
        ETEXT="EB-REDO.DESC.NOT.REQUIRED"
        CALL STORE.END.ERROR
    END
    IF R.NEW(AC.LOCAL.REF)<1, L.AC.PROP.USE.POS> EQ 'OTHERS(SPECIFY)' AND R.NEW(AC.LOCAL.REF)<1,L.AC.OTHER.DETS.POS> EQ '' THEN
        AF=AC.LOCAL.REF
        AV=L.AC.OTHER.DETS.POS
        ETEXT="AC-INP.MAND"
        CALL STORE.END.ERROR
    END

RETURN
END
