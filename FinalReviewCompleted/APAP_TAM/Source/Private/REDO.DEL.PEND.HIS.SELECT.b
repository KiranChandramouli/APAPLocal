* @ValidationCode : MjoxNDM2OTg4NTMyOkNwMTI1MjoxNjgwNzczNjY4MjYxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:04:28
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
SUBROUTINE REDO.DEL.PEND.HIS.SELECT
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is select file for the multithreaded routine REDO.DEL.PEND.HIS

* Input/Output:
*--------------
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

* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.DEL.PEND.HIS.COMMON
    SEL.PEND.CMD = "SELECT " :FN.PEND.CHG.HIS
    CALL EB.READLIST(SEL.PEND.CMD,LIST.PEND.CHARGES,'',NO.OF.REC,PEND.ERR)
    CALL BATCH.BUILD.LIST('',LIST.PEND.CHARGES)
RETURN
END
