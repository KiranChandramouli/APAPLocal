$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.RATE.CHANGE
*----------------------------------------------------------
* Description: This routine is validation routine for the VERSION - REDO.RATE.CHANGE,MASSIVE.INPUT and ,EXTRACT.INPUT.
*----------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RATE.CHANGE


    GOSUB PROCESS
RETURN

*------------------------------------------------------
PROCESS:
*------------------------------------------------------

    Y.EXTRACT.TYPE = R.NEW(REDO.RT.EXTRACT.TYPE)

    IF Y.EXTRACT.TYPE EQ 'AUTOMATICA' THEN
        IF R.NEW(REDO.RT.FROM.DATE) ELSE
            AF = REDO.RT.FROM.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
        IF R.NEW(REDO.RT.TO.DATE) ELSE
            AF = REDO.RT.TO.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
    END

    IF Y.EXTRACT.TYPE EQ 'MANUAL' THEN
        IF R.NEW(REDO.RT.FROM.DATE) AND R.NEW(REDO.RT.TO.DATE) EQ '' THEN
            AF = REDO.RT.TO.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
        IF R.NEW(REDO.RT.FROM.DATE) EQ '' AND R.NEW(REDO.RT.TO.DATE) THEN
            AF = REDO.RT.FROM.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
    END
RETURN
END
