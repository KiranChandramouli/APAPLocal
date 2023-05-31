* @ValidationCode : MjotMTg2NTI2MzU3MzpDcDEyNTI6MTY4NTUzNjA0MzQxNTp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.IDGARA.FS

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.IDGARA.FS
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
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,= TO EQ
*17-04-2023              Samaran T                R22 Manual Code conversion                         CALL ROUTINE FORMAT MODIFIED
*------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

**** FOR VALIDATE INFORMATION OTHER COLLATERALS 06/09/2012***
    IF PGM.VERSION EQ ',REDO.INGRESO.OG' THEN
        IF COMI EQ '' THEN
            RETURN
        END
    END
**** END VALIDATE INFORMATION



    APAP.REDOVER.redoVValIdGara();*R22 MANUAL CODE CONVERSION


    GUAR.CUS.ID = COMI


    VAR.CUS.ID      = R.NEW(COLL.LOCAL.REF)<1,WPOSLEGID>
    IF GUAR.CUS.ID NE VAR.CUS.ID THEN
        AF = COLL.LOCAL.REF
        AV = ZPOS<1,1>
        ETEXT = 'ST-CLIE-GARA'
        CALL STORE.END.ERROR
    END

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    ZPOS= 0

    FN.COLLATERAL   = 'F.COLLATERAL'
    F.COLLATERAL    = ''
    R.COLLATERAL    = ''

    WCAMPO ="L.COL.SEC.HOLD"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,ZPOS)
    WPOSLEGID=ZPOS<1,1>


RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
RETURN
*------------
END
