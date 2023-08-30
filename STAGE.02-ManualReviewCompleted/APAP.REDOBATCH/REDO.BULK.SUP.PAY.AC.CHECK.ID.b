* @ValidationCode : MjotNTc4ODIyNDYxOkNwMTI1MjoxNjgxNzk0NDA3MDIwOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:36:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
