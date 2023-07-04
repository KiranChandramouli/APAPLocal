* @ValidationCode : MjotMjAzMTM4ODMwODpDcDEyNTI6MTY4MjUyODQ3MzI1MzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:13
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
SUBROUTINE REDO.REINV.MATURITY.ACI.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.MATURITY.ACI.SELECT
*--------------------------------------------------------------------------------
* Description: This Batch routine is to create a ACI for interest Liq account
* for the deposit with zero rate.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO           REFERENCE          DESCRIPTION
* 18-Jul-2011    H GANESH      PACS00072695_N.11  INITIAL CREATION
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.REINV.MATURITY.ACI.COMMON


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    SEL.CMD = 'SELECT ':FN.AZ.ACCOUNT
    SEL.CMD := ' WITH ((MATURITY.DATE LE ':TODAY:')'
    SEL.CMD := ' OR (MIN.MAT.DATE AND MIN.MAT.DATE GE ':LAST.WORK.DAY:
    SEL.CMD := ' AND MIN.MAT.DATE LT ':TODAY: ')) AND L.TYPE.INT.PAY EQ Reinvested'

    LIST.PARAMETER = ''
    LIST.PARAMETER<3> = SEL.CMD
    CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')

RETURN
END
