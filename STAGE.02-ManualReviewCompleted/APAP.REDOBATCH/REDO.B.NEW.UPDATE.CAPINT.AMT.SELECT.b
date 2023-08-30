* @ValidationCode : MjotMzQ2MzEyNTQ6Q3AxMjUyOjE2ODEyODE5ODc3ODY6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:16:27
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
SUBROUTINE REDO.B.NEW.UPDATE.CAPINT.AMT.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.NEW.UPDATE.CAPINT.AMT.SELECT

*-----------------------------------------------------------------
* Description :
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017   23-Oct-2012            Wof Accounting - PACS00202156
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.NEW.UPDATE.CAPINT.AMT


    SEL.CMD = 'SELECT ':FN.REDO.ACCT.MRKWOF.HIST:' WITH STATUS EQ INITIATED'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,SEL.ERR)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
