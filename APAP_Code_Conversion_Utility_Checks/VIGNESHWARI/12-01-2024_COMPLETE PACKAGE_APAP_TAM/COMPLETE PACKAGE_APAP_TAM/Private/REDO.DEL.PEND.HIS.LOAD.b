* @ValidationCode : Mjo0MzM2NjEzMzA6Q3AxMjUyOjE2ODA2ODA2MDc5MDY6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:13:27
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

** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes

$PACKAGE APAP.TAM
SUBROUTINE REDO.DEL.PEND.HIS.LOAD
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is load file for the multithreaded routine REDO.DEL.PEND.HIS

* Input/Output:
*-------------
* IN :
* OUT :
*
* Dependencies:
*---------------
* CALLS :
* CALLED BY :
*
* Revision History:
*---------------------------------------------------------------------------
*   Date               who           Reference            Description
* 16-FEB-2010     SHANKAR RAJU     ODR-2009-10-0529     Initial Creation
*---------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEL.PEND.HIS.COMMON
    FN.PEND.CHG.HIS = 'F.REDO.PENDING.CHARGE$HIS'
    F.PEND.CHG.HIS = ''
    CALL OPF(FN.PEND.CHG.HIS,F.PEND.CHG.HIS)
RETURN
END
