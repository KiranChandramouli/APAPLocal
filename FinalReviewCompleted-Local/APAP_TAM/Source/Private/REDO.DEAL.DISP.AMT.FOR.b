* @ValidationCode : Mjo2NTE3NzYzMzY6Q3AxMjUyOjE2ODA3ODE5NDcxMzU6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:22:27
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
SUBROUTINE REDO.DEAL.DISP.AMT.FOR(Y.INP.DEAL)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of FT

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: FT  payement
*------------------------------------------------------------------------------------------------------------

*Modification Details:
*=====================
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

    Y.AMT.TOT = Y.INP.DEAL
    Y.AMT = Y.AMT.TOT[4,99]
    Y.COMI = COMI
    COMI = Y.AMT
    Y.A = 1
    Y.B = 1
    CALL IN2AMT(Y.A, Y.B)
    Y.AMT = V$DISPLAY
    COMI = Y.COMI
    Y.INP.DEAL = 'RD$':Y.AMT

RETURN
END
