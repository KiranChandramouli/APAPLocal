* @ValidationCode : MjoxMjc4MDAzMTUxOkNwMTI1MjoxNjgyMzMxNTY0ODE3OklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
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
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_F.DATES           ;** R22 Auto conversion - $INCLUDE TO $INSERT

    EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/TRANSPRESTALAB PAGO.PRESTACIONES.LABORALES.TXT TO ../interface/FLAT.INTERFACE/TRANSPRESTALAB/TEMP OVERWRITING DELETING'

RETURN

END
