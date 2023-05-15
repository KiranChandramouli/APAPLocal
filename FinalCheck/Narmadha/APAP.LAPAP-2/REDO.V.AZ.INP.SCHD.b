$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.AZ.INP.SCHD
****************************************************************
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name  : REDO.V.AZ.INP.SCHD
* Developed By  : V.P.Ashokkumar
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------
* Description :This input routine is attached to the VERSION.CONTROL record 'AZ.ACCOUNT'
* to avoid removing the value 'I'.
*
    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT ;*R22 AUTO CONVERSION END

    GOSUB PROCESS
RETURN

PROCESS:
********
    VAROLD.TYPE.OF.SCHDLE = ''; VARNEW.TYPE.OF.SCHDLE = ''
    VARNEW.SCH.FIXED.RATE.R = ''; VARNEW.TYPE.OF.SCHDLE.R = ''
    VAROLD.TYPE.OF.SCHDLE   = R.OLD(AZ.TYPE.OF.SCHDLE)<1,1>
    VARNEW.TYPE.OF.SCHDLE   = R.NEW(AZ.TYPE.OF.SCHDLE)<1,1>

    IF (VAROLD.TYPE.OF.SCHDLE EQ "I" AND VAROLD.TYPE.OF.SCHDLE NE VARNEW.TYPE.OF.SCHDLE) THEN
        AF = AZ.TYPE.OF.SCHDLE
        ETEXT ='AZ-TYP.SCHED.NOT.MATCH'
        CALL STORE.END.ERROR
        RETURN
    END

    VARNEW.TYPE.OF.SCHDLE.R  = R.NEW(AZ.TYPE.OF.SCHDLE)
    LOCATE 'R' IN VARNEW.TYPE.OF.SCHDLE.R<1,1> SETTING VR.POSN THEN
        VARNEW.SCH.FIXED.RATE.R = R.NEW(AZ.SCH.FIXED.RATE)<1,VR.POSN>
        IF NOT(VARNEW.SCH.FIXED.RATE.R) THEN
            AF = AZ.SCH.FIXED.RATE
            AV = VR.POSN
            ETEXT ='AZ-SCH.RATE.MANDATORY'
            CALL STORE.END.ERROR
            RETURN
        END
    END
RETURN
END
