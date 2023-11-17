* @ValidationCode : Mjo4MDQ1NDg4OTY6Q3AxMjUyOjE2ODMwMjQzMzY3ODI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:36
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
SUBROUTINE REDO.VAL.PORC.MX.PRESTAR
* ====================================================================================
*
*    -VALIDATE IF PORCENTAJE MAXIMO A PRESTAR IS LESS THAN 100
*
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
* NA
* Outgoing:
* ---------
* NA
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Jorge Valarezo
* Date            : 08 APR 2013
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_GTS.COMMON

*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB PROCESS


*
RETURN


*
* =========
INITIALISE:
* =========
*
    Y.LN.MX.PER.NAME = 'L.COL.LN.MX.PER'
    Y.LN.MX.PER.POS = ''
    Y.APPLICATION = 'COLLATERAL'

    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.LN.MX.PER.NAME,Y.LN.MX.PER.POS)

RETURN

*
* ======
PROCESS:
* ======
    IF OFS$HOT.FIELD NE Y.LN.MX.PER.NAME THEN
        MAX.PER.VALUE = R.NEW(COLL.LOCAL.REF)<1,Y.LN.MX.PER.POS>
    END
    ELSE
        MAX.PER.VALUE = COMI
    END
    IF MAX.PER.VALUE GT 100 THEN
        AV = Y.LN.MX.PER.POS
        ETEXT = 'EB-COL.MX.PER.EXCEED.MAX'
        CALL STORE.END.ERROR
    END

RETURN
END
