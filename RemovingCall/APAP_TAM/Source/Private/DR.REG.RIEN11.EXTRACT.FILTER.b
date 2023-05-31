* @ValidationCode : MjoyMTAwMTk0ODAxOkNwMTI1MjoxNjg0NDkxMDI1ODY5OklUU1M6LTE6LTE6LTI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN11.EXTRACT.FILTER(REC.ID)
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.RIEN11.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transaction made over 1000 USD by individual Customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* Date                  who                   Reference
* 24-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT
* 24-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.RIEN11.EXTRACT.COMMON

    IF NOT(NUM(REC.ID)) THEN
        REC.ID = ""       ;* Return NULL if it is not a CUSTOMER Account
    END
RETURN
*-----------------------------------------------------------------------------
END
