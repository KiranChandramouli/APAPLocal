* @ValidationCode : MjotNjgyMzgwOTU3OkNwMTI1MjoxNjg0ODU0MzgxMDc1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:21
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AZ.MIG.PERIOD.END.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUJITHA S
* Program Name : REDO.B.AZ.MIG.PERIOD.END.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job
*
* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.AZ.ACCOUNT.LIST
*--------------------------------------------------------------------------------
* Modification History :
* Date                  who                   Reference              
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_REDO.B.AZ.MIG.PERIOD.END.COMMON

    Y.DATE              = TODAY
    Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

    SEL.CMD = "SELECT ":FN.AZACCOUNT:" WITH ROLLOVER.DATE GT ":Y.LAST.WORKING.DATE:" AND ROLLOVER.DATE LE ":Y.DATE:" AND L.AZ.REF.NO LIKE AZ-..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,CK.ERR)
    CALL BATCH.BUILD.LIST('', SEL.LIST)
RETURN

END
