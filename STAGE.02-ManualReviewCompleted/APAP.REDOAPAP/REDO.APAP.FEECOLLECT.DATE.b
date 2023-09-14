* @ValidationCode : MjotMTUzODE5Njk1MjpDcDEyNTI6MTY4MTM2NjEzMjk1OTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 11:38:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.FEECOLLECT.DATE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RIYAS
* PROGRAM NAME: REDO.APAP.FEECOLLECT.DATE
*----------------------------------------------------------------------
*IN PARAMETER : NA
*OUT PARAMETER: NA
*LINKED WITH  : REDO.APAP.FEECOLLECT.DATE
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO           REFERENCE         DESCRIPTION
*28.10.2011     RIYAS      ODR-2010-08-0017    INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.FEECOLLECT

    FN.REDO.FEECOLLECT = 'F.REDO.FEECOLLECT'
    F.REDO.FEECOLLECT = ''
    CALL OPF(FN.REDO.FEECOLLECT,F.REDO.FEECOLLECT)
    Y.TODAY= TODAY[5,4]
    R.NEW(REDO.FEE.EVENT.DATE)= Y.TODAY

RETURN
