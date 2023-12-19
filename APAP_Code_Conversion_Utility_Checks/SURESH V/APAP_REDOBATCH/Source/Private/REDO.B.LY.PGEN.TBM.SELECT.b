* @ValidationCode : Mjo5NjkzNzEyMzE6Q3AxMjUyOjE2ODQ4NTQzOTE3NjQ6SVRTUzotMTotMTotMTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.PGEN.TBM.SELECT
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine selects REDO.LY.MODALITY ids
*  This routine is the SELECT routine of the batch REDO.B.LY.PGEN.TBM which updates
*   REDO.LY.POINTS table based on the data defined in the parameter table
*   REDO.LY.MODALITY & REDO.LY.PROGRAM
* ------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 06-SEP-2013       RMONDRAGON   ODR-2011-06-0243         First Version
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_REDO.B.LY.PGEN.TBM.COMMON

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------
*----------------------------------
* This section selects the txns ids
*----------------------------------

    TBM.CMD = ''
    TBM.CMD = 'SSELECT ':FN.REDO.LY.TXN.BY.MOD:' LIKE ...':TODAY
    TBM.ID.LST = ''
    CALL EB.READLIST(TBM.CMD,TBM.ID.LST,'',TBM.CNT,TBM.ERR)
    CALL BATCH.BUILD.LIST('',TBM.ID.LST)

END
