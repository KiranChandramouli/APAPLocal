* @ValidationCode : MjotMjA3NTQzNDg2OTpDcDEyNTI6MTY4MTM3MzE4ODM5MDpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:36:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.CAL.FEC.MES
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.CAL.FEC.MES
* Attached as     : ROUTINE
* Primary Purpose :
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
*------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : Calculate the next date from VALUATION.DUE.DATE
*
*------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,Y.ANI.N + 1 TO +=1
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------
PROCESS:
*======


*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
    WPOSBLDA  = YPOS<1,1>
    WPOSBLDV  = YPOS<1,2>
    WPOSRMES  = YPOS<1,3>

*READ THE BEGIN DATE
    Y.ACTUAL   = R.NEW(COLL.LOCAL.REF)<1,WPOSBLDV>

*READ THE MONTH NUMBER
    Y.MESES    = COMI

*GET THE YEAR, MONTH AND DAY FOR THE DATE
    Y.ANIO   = LEFT(Y.ACTUAL,4)
    Y.AUX    = RIGHT(Y.ACTUAL,4)
    Y.MES    = LEFT(Y.AUX,2)
    Y.DIA    = RIGHT(Y.AUX,2)

*GET THE NUMBER OF YEARS OF THE NUMBER OF MONTH SET IN
    Y.ANI.I  = INT(Y.MESES/12)
    Y.ANI.N  = Y.ANIO + Y.ANI.I

*GET THE MES NUMBER THAT HAVE THE DIFERENCE
    Y.MES.D  = Y.MESES - (Y.ANI.I * 12)

*IF THE SUM OF MONTH IS GREATER THAN 12 ADD 1 YEAR
    IF (Y.MES.D + Y.MES ) GT 12 THEN
        Y.ANI.N += 1
        Y.MES.N =  (Y.MES.D + Y.MES) - 12
    END
    ELSE
        Y.MES.N = Y.MES.D + Y.MES
    END

*iF THE MONTH IS LOW TO 10 SET 0 ON BEGIN
    IF  10 GT Y.MES.N THEN
        Y.AUX = Y.MES.N
        Y.MES.N = '0':Y.AUX
    END

    IF ((Y.MES.N EQ 4) OR (Y.MES.N EQ 6) OR (Y.MES.N EQ 9) OR (Y.MES.N EQ 11)) THEN
        IF Y.DIA GT 30 THEN
            Y.DIA = 30
        END
    END

    IF  Y.MES.N EQ 2  THEN
        IF Y.DIA GT 28 THEN
            Y.DIA = 28
        END
    END

*BUILD THE NEW DATE
    Y.NEW.FEC = Y.ANI.N:Y.MES.N:Y.DIA

*Get the position for all fields
*  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
*  WPOSBLDA  = YPOS<1,1>
    R.NEW(COLL.LOCAL.REF)<1,WPOSBLDA> = Y.NEW.FEC


RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    WCAMPO     = "L.COL.VA.DUE.DT"
    WCAMPO<2>  = "L.COL.VAL.DATE"
    WCAMPO<3>  = "L.COL.REVIEW.DT"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

RETURN

*---------------------------------------------------------------------------
OPEN.FILES:
*=========

RETURN
*---------------------------------------------------------------------------
END
