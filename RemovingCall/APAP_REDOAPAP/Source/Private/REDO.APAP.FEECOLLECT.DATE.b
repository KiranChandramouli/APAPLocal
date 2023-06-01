* @ValidationCode : MjotMTUzODE5Njk1MjpDcDEyNTI6MTY4NDgzNjA0MDIyNDpJVFNTOi0xOi0xOjEwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:40
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
