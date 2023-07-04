* @ValidationCode : MjoxNDYzOTAxMjQzOkNwMTI1MjoxNjg0ODU0NDAwMzQ0OklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:40
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
SUBROUTINE REDO.B.UPD.LT.USER.LIMITS.SELECT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.UPD.LT.USER.LIMITS.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : The routine is the .SELECT routine for the multi threade cob routine
*                    REDO.B.UPD.LT.USER.LIMITS. The routine selects alll the records of
*                    REDO.APAP.USER.LIMITS application in this section
*In Parameter      : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  08/11/2010   Jeyachandran S                     ODR-2010-07-0075                Initial Creation
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANGES
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPD.LT.USER.LIMITS.COMMON
    $INSERT I_F.REDO.APAP.USER.LIMITS

    GOSUB SELECT.STMT
RETURN

*--------------------------------------------------------------------------------------------------------
SELECT.STMT:
*-------------
* The section calls the routine EB.READLIST  using the select command making select over
* REDO.APAP.USER.LIMITS

    SEL.CMD = "SELECT ":FN.REDO.APAP.USER.LIMITS
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN

*--------------------------------------------------------------------------------------------------------
END
