* @ValidationCode : MjotMzEzNTE5OTcyOkNwMTI1MjoxNjg0NDkxMDMzNTc1OklUU1M6LTE6LTE6LTI0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -24
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FC.S.POPVALUES(ID.PARAMS.IN)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.RECORD
* Attached as     : ROUTINE
* Primary Purpose : Get defaults values from REDO.FC.PARAMS and populate them in R.NEW
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
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 30 Jun 2011
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, I TO I.VAR
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PARAMS

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*============

    CALL CACHE.READ (FN.REDO.FC.PARAMS,ID.PARAMS,R.REDO.FC.PARAMS, YERR)
    IF R.REDO.FC.PARAMS THEN
        YNRO = DCOUNT(R.REDO.FC.PARAMS<FC.PR.FIELD.NAME>,@VM)
        FOR I.VAR = 1 TO YNRO ;*AUTO R22 CODE CONVERSION
            YFIELD = R.REDO.FC.PARAMS<FC.PR.FIELD.NAME,I.VAR>
            YVALUE = R.REDO.FC.PARAMS<FC.PR.FIELD.VALUE,I.VAR>
            IF YVALUE EQ "TODAY" THEN
                YVALUE = TODAY
            END
            CALL EB.FIND.FIELD.NO(Y.APLICACION, YFIELD)
            IF NOT(R.NEW(YFIELD)) THEN
                R.NEW(YFIELD)= YVALUE
            END
        NEXT
    END

RETURN

*------------------------
INITIALISE:
*=========

    FN.REDO.FC.PARAMS = 'F.REDO.FC.PARAMS'
    ID.PARAMS = ID.PARAMS.IN
    R.REDO.FC.PARAMS = ''
    YERR = ''
    Y.APLICACION = "REDO.CREATE.ARRANGEMENT"

    PROCESS.GOAHEAD = 1
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
