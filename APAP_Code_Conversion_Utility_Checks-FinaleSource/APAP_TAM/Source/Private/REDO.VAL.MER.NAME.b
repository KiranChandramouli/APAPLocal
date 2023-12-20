* @ValidationCode : Mjo2MzAxNzc5OTc6Q3AxMjUyOjE2OTQ3NTYwNzI5MjQ6SVRTUzotMTotMTotODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Sep 2023 11:04:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.MER.NAME
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.VAL.ACC.BUS.ID
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
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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
    Y.ACC.NAME = R.ATM.REVERSAL<AT.REV.ACCEPTOR.NAME>
    FIELD.VALUE = Y.ACC.NAME[1,25]
RETURN
*-------------------------------------------------------------------------------
END
