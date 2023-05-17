SUBROUTINE APAP.H.INSURANCE.MONTH.TOT.AMT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : APAP.H.INSURANCE.MONTH.TOT.AMT
* Attached as     : ROUTINE
* Primary Purpose : Compute the total amount for insuranse
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------

PROCESS:
*======

    MONTHLY.AMT = R.NEW(INS.DET.MON.POL.AMT)
    MONTH.COUNT = DCOUNT(MONTHLY.AMT,@VM)

*reCORRE LOD REGISTROS
    FOR CNT = 1 TO MONTH.COUNT
        TOTAL.AMT = TOTAL.AMT + MONTHLY.AMT<CNT>
    NEXT CNT

*SET THE COMPUTE TOTAL OF VALUES
    VAR.EXTRA.AMT =  R.NEW(INS.DET.EXTRA.AMT)
    IF VAR.EXTRA.AMT  EQ '' THEN
        VAR.EXTRA.AMT = 0
    END
    R.NEW(INS.DET.MON.TOT.PRE.AMT) = TOTAL.AMT + VAR.EXTRA.AMT

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
*incializacion de variables
    TOTAL.AMT = 0
RETURN

*------------------------
OPEN.FILES:
*=========


RETURN
*------------
END
