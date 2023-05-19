* @ValidationCode : MjotMTc2MTM1ODU4MDpDcDEyNTI6MTY4MjQyMDkxNDA5NjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:38:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FC.S.OFS.FOR.AA (ID.APP.MAPPING, OFS.STR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.AUTHORISE
* Attached as     : ROUTINE
* Primary Purpose : Build OFS for AA
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
* Date            : 01 Julio 2011
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, I TO I.VAR
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.APP.MAPPING

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*=============
    CALL CACHE.READ(FN.REDO.APP.MAPPING, Y.IDAPP, R.REDO.APP.MAPPING, YERR)
    Y.APLICACION.FROM = R.REDO.APP.MAPPING<REDO.APP.APP.FROM>
    Y.APLICACION.TO = R.REDO.APP.MAPPING<REDO.APP.APP.TO>
    NRO.FIELDS = DCOUNT(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,@VM)

    GOSUB SET.OFS.HEADER
    FOR I.VAR =1 TO NRO.FIELDS ;*AUTO R22 CODE CONVERSION
        YFIELDFROM = R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM,I.VAR>
        YFIELDTO =  R.REDO.APP.MAPPING<REDO.APP.FIELD.TO,I.VAR>
        GOSUB SET.YFIELDFROM
        GOSUB SET.OFS.BODY
    NEXT
    OFS.STR = OFS.STR.HEAD:OFS.STR.BODY
RETURN

*------------------------
SET.YFIELDFROM:
*================
    YOP = FIELD(YFIELDFROM,"*",1)
    BEGIN CASE
        CASE YOP EQ "VAR"
            YREST = FIELD(YFIELDFROM,"*",2)
        CASE YOP EQ "STR"
            YREST = FIELD(YFIELDFROM,"*",2)
            YFIELDFROM = YREST
        CASE 1
            GOSUB SET.VALUE.FLD
    END CASE

RETURN
*------------------
SET.VALUE.FLD:
*===============
    GOSUB GETPOSVALFLD
    YFIELDFROM = R.NEW(Y.FIELD.NO)
RETURN
*----------------------
GETPOSVALFLD:
*===============
*Campos de la aplicacion
    Y.FIELD.NO = YFIELDFROM
    CALL EB.FIND.FIELD.NO(Y.APLICACION.FROM, Y.FIELD.NO)
RETURN
*------------------------
SET.OFS.HEADER:
*=============
    OFS.STR.HEAD  = Y.APLICACION.TO
    OFS.STR.HEAD := ",AA.APAP/I/PROCESS//0"
    OFS.STR.HEAD := ",/"
    OFS.STR.HEAD := ","
RETURN
*------------------------
SET.OFS.BODY:
*=============
    OFS.STR.BODY := ","
    OFS.STR.BODY := YFIELDTO
    OFS.STR.BODY := ":1:1="
    OFS.STR.BODY := YFIELDFROM
RETURN

*------------------------
INITIALISE:
*=========

    FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
    R.REDO.APP.MAPPING  = ''

    Y.IDAPP = ID.APP.MAPPING
    OFS.STR.BODY  = ''
    YERR = ''
    PROCESS.GOAHEAD = 1
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
