* @ValidationCode : Mjo1NTU4ODA5NDY6Q3AxMjUyOjE2ODQ4MzYwMzE1MDQ6SVRTUzotMTotMTotMjc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -27
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
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
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , END STATEMENT ADDED , = to EQ
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



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
        VAR.EXTRA.AMT = 0  ;*R22 AUTO CODE CONVERSION
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
