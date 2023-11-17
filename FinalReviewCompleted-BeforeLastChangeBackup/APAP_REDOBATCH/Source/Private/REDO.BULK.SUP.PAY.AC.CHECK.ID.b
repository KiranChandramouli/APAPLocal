* @ValidationCode : MjotNTc4ODIyNDYxOkNwMTI1MjoxNjg0ODU0NDA1NDYyOklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BULK.SUP.PAY.AC.CHECK.ID
************************************************************************
* ID level validations
************************************************************************
* 29/06/04 - EN_10002298
*            New Version
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*
************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE

* Validation and changes of the ID entered.  Set ERROR to 1 if in error
    E = ''

    ID.NEW = COMI
    CALL EB.FORMAT.ID("BKAC")   ;* Format to BKOTyydddNNNNN;NN

RETURN
END
