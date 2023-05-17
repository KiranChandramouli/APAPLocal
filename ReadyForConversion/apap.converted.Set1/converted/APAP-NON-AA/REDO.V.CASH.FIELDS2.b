SUBROUTINE REDO.V.CASH.FIELDS2
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be called from VALIDATION ROUTINE
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : JOAQUIN COSTA C. - jcosta@temenos.com
* PROGRAM NAME : REDO.V.CASH.FIELDS
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*       DATE             WHO                REFERENCE         DESCRIPTION
*       16.JAN.2012      J.COSTA C.                           INITIAL CREATION
*
* -----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.TELLER
*
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*

*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
        R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS>  = COMI
        R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>   = R.NEW(TT.TE.NET.AMOUNT)
    END ELSE
        R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>  = COMI
        R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS> = R.NEW(TT.TE.NET.AMOUNT)
    END
*
RETURN
*
*----------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------
*
    PROCESS.GOAHEAD = "1"
*
    WAPP.LST  = "TELLER"
    WCAMPO    = "L.DEBIT.AMOUNT"
    WCAMPO<2> = "L.CREDIT.AMOUNT"

    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
*
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
*
    DEBIT.POS  = YPOS<1,1>
    CREDIT.POS = YPOS<1,2>
*
RETURN
*
*----------
OPEN.FILES:
*----------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
    LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF V$FUNCTION NE "I" THEN
                    PROCESS.GOAHEAD = ""
                END

        END CASE
*
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
