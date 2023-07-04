* @ValidationCode : MjotNzMzNTUxNjMwOkNwMTI1MjoxNjg0ODU0MzkxNDE0OklUU1M6LTE6LTE6LTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:31
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
SUBROUTINE REDO.B.LY.PGEN.EXPROD.SELECT
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine selects all customers with current birthday ids
*  This routine is the SELECT routine of the batch REDO.B.LY.PGEN.EXPROD which updates
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
* 17-JUN-2013   RMONDRAGON        ODR-2011-06-0243      Initial Creation
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_REDO.B.LY.PGEN.EXPROD.COMMON

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    SEL.LIST = ''
    IF PRG.RECSEL EQ 'Y' THEN
        SEL.CUST.CMD = 'SELECT ':FN.CUSTOMER
        CALL EB.READLIST(SEL.CUST.CMD,SEL.LIST,'',ID.CNT,'')
    END
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
