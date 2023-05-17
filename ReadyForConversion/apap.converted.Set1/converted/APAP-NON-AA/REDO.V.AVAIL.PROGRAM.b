SUBROUTINE  REDO.V.AVAIL.PROGRAM
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.LY.PROGRAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.AVAIL.PROGRAM
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*23.06.2010      SUDHARSANAN S     ODR-2009-12-0276 INITIAL CREATION
*18.07.2011    RMONDRAGON          ODR-2011-06-0243 UPDATE
*28.11.2011    RMONDRAGON          ODR-2011-06-0243 UPDATE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        VAR.AVAILABILITY = R.NEW(REDO.PROG.AVAILABILITY)
    END ELSE
        VAR.AVAILABILITY = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    IF VAR.AVAILABILITY NE '4' THEN
        T(REDO.PROG.AVAIL.DATE)<3> = 'NOINPUT'
    END

RETURN

*------------------------------------------------------------------------------------
END
