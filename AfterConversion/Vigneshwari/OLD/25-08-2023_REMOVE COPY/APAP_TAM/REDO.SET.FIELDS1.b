* @ValidationCode : Mjo2MzEzOTc1NDI6Q3AxMjUyOjE2ODEwNTY0ODYwMDc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SET.FIELDS1
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.SET.FIELDS
* Attached as     : ROUTINE
* Primary Purpose : Set default values for multivalues fields. This routine copy from one set of MV to the next
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
* Development by  : Santiago - TAM Latin America
* Date            : 29/07/2011
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, I TO I.VAR
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
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
    Y.CONT = DCOUNT(R.NEW(INS.DET.MON.POL.AMT),@VM)

    IF Y.CONT GT 1 THEN
        FOR I.VAR = 1 TO Y.CONT               ;** R22 Auto conversion - I TO I.VAR
            Y.CHARGE = R.NEW(INS.DET.CHARGE)<1,1>
            Y.CHARGE.EXT.AMT = R.NEW(INS.DET.CHARGE.EXTRA.AMT)<1,1>
            Y.PAYMENT.TYPE = R.NEW(INS.DET.PAYMENT.TYPE)<1,1>

            R.NEW(INS.DET.CHARGE)<1,I.VAR> = Y.CHARGE                ;** R22 Auto conversion - I TO I.VAR
            R.NEW(INS.DET.CHARGE.EXTRA.AMT)<1,I.VAR> = Y.CHARGE.EXT.AMT        ;** R22 Auto conversion - I TO I.VAR
            R.NEW(INS.DET.PAYMENT.TYPE)<1,I.VAR> = Y.PAYMENT.TYPE          ;** R22 Auto conversion - I TO I.VAR

            R.NEW(INS.DET.MON.TOT.PRE.AMT)<1,I.VAR> = R.NEW(INS.DET.MON.POL.AMT)<1,I.VAR> + R.NEW(INS.DET.EXTRA.AMT)<1,I.VAR>
        NEXT I.VAR           ;** R22 Auto conversion - I TO I.VAR
    END

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
*incializacion de variables

RETURN

*------------------------
OPEN.FILES:
*=========
*Abrir archivos

RETURN
*------------
END
