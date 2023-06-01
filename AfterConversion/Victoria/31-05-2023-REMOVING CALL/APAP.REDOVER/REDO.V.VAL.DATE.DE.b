* @ValidationCode : MjoxOTYyMzU2NDcxOkNwMTI1MjoxNjgyNDEyMzU5MDExOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.DATE.DE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DATE.DE
* Attached as     : ROUTINE
* Primary Purpose : VALIDATE DATES FOR EXTERNAL DEPOSITS
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
* Date            :
*
*------------------------------------------------------------------------------

*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*------------------------------------------------------------------------------

PROCESS:
*======

    Y.ACTUAL = R.NEW(COLL.VALUE.DATE)


*Get the values for the local fields (Granting Date)
    Y.FEC2 = R.NEW(COLL.LOCAL.REF)<1,WPOSCODA>

* CHECK THE DATE THAT NOT LOWER THAN THE ACTUAL DATE
    IF Y.FEC2 LT Y.ACTUAL THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'ST-REDO.COLLA.FEC.DIF'
        CALL STORE.END.ERROR
    END

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
    IF Y.FEC2 GT Y.ACTUAL THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'ST-REDO.COLLA.FEC.DIF'
        CALL STORE.END.ERROR
    END

*Get the values for the local fields (Granting Date)
    Y.FEC3 = R.NEW(COLL.LOCAL.REF)<1,WPOSFODA>

    IF  LEN( TRIM(Y.FEC3)) GT 0 THEN
* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC3 LT Y.ACTUAL THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,2>
            ETEXT = 'ST-REDO.COLLA.FEC.DIF'
            CALL STORE.END.ERROR
        END

* CHECK THE DATE THAT NOT GREAT THAN THE ACTUAL DATE
        IF Y.FEC3 GT TODAY THEN
            AF = COLL.LOCAL.REF
            AV = YPOS<1,2>
            ETEXT = 'ST-REDO.COLLA.FEC.DIF'
            CALL STORE.END.ERROR
        END
    END
RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========

    PROCESS.GOAHEAD = 1
*Set the local fild for read

    WCAMPO     = "L.COL.GT.DATE"
    WCAMPO<2>  = "L.COL.EXE.DATE"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
*Grating Date.   - Fecha de Constitucion
    WPOSCODA  = YPOS<1,1>
*Executing Date. - Fecha de Formalizacion
    WPOSFODA  = YPOS<1,2>

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
