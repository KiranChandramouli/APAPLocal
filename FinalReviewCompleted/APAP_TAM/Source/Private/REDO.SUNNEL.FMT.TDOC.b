* @ValidationCode : MjotMzUwODcyOTkzOkNwMTI1MjoxNjg0ODQyMTMzMTUzOklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SUNNEL.FMT.TDOC(IN.DATA,OUT.DATA)
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define generic parameter table for sunnel
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Ivan Roman
*Program   Name    :REDO.SUNNEL.FMT.TDOC
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference                           Description
* 30-11-2011        Ivan Roman        sunnel-CR                     Execute instruction
*18-04-2023       Conversion Tool     R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T           R22 Manual Code Conversion        No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    OUT.DATA = CHANGE(IN.DATA," ","")

RETURN
*-----------------------------------------------------------------------------
END
