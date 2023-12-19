* @ValidationCode : MjotMTg0MDgyNDM4OTpDcDEyNTI6MTY4MTExMTg5NDY3MzpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LETTER.HLD.DEL.LOAD
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.B.LETTER.HLD.DEL.LOAD
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Load Routine  to delete the record that is in
*status HOLD



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE                 WHO           REFERENCE         DESCRIPTION
*18.03.2010          H GANESH     ODR-2009-10-0838   INITIAL CREATION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LETTER.ISSUE
    $INSERT I_REDO.B.LETTER.HLD.DEL.COMMON

    GOSUB INIT
RETURN


*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.REDO.LETTER.ISSUE='F.REDO.LETTER.ISSUE$NAU'
    F.REDO.LETTER.ISSUE=''

RETURN
END
