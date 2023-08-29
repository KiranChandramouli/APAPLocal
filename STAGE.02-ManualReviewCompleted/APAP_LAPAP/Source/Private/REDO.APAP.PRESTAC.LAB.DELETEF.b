* @ValidationCode : MjotMTk0NDQ2ODE1NTpDcDEyNTI6MTY5MzMxMTUyNTcyNjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 29 Aug 2023 17:48:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.PRESTAC.LAB.DELETEF
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - $INCLUDE TO $INSERT
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - PATH IS MODIFIED
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_F.DATES           ;** R22 Auto conversion - $INCLUDE TO $INSERT

*   EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/TRANSPRESTALAB PAGO.PRESTACIONES.LABORALES.TXT TO ../interface/FLAT.INTERFACE/TRANSPRESTALAB/TEMP OVERWRITING DELETING' ;*R22 Manual Conversion PATH IS MODIFIED
    EXECUTE 'SH -c cp  ../interface/FLAT.INTERFACE/TRANSPRESTALAB/PAGO.PRESTACIONES.LABORALES.TXT ../interface/FLAT.INTERFACE/TRANSPRESTALAB/TEMP OVERWRITING DELETING'
RETURN

END
