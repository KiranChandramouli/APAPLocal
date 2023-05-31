* @ValidationCode : MjozNTE4NzM3ODQ6Q3AxMjUyOjE2ODExMjUyNzUxODA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 16:44:35
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
SUBROUTINE REDO.VAL.ACC.NO
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.VAL.ACC.NO
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is an internal call routine called by the Batch routine REDO.VISA.GEN.ACQ.REC
*IN PARAMETER : N/A
*OUT PARAMETER: N/A
*CALLED BY : REDO.VISA.GEN.ACQ.REC
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.09.2010  S SUDHARSANAN    ODR-2010-08-0469  INITIAL CREATION
*10.04.2023  Conversion Tool       R22          Auto Conversion     - No changes
*10.04.2023  Shanmugapriya M       R22          Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.GEN.ACQ.REC.COMMON
    $INSERT I_F.ATM.REVERSAL
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    FIELD.VALUE = FIELD(ATM.ID,'.',1)[1,16]
RETURN
*-------------------------------------------------------------------------------
END
