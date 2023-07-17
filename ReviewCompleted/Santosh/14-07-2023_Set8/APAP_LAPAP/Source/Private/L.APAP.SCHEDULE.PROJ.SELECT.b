* @ValidationCode : Mjo5MzI4ODUwNDU6Q3AxMjUyOjE2ODkyNTE1ODEwMzA6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 18:03:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.SCHEDULE.PROJ.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : L.APAP.SCHEDULE.PROJ
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO               DESCRIPTION
*  20200530         ELMENDEZ              INITIAL CREATION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_L.APAP.SCHEDULE.PROJ.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.L.APAP.SCHEDULE.PROJET
*-----------------------------------------------------------------------------
*SEL.CMD = 'SELECT ' : FN.AA.ARRANGEMENT : " WITH PRODUCT.LINE EQ LENDING AND ARR.STATUS NE 'CLOSE' AND ARR.STATUS NE 'AUTH' AND ARR.STATUS NE 'PENDING.CLOSURE' AND ARR.STATUS NE 'UNAUTH'"
    SEL.CMD = 'SELECT ' : FN.AA.ARRANGEMENT : " WITH ARR.STATUS EQ 'CURRENT' 'EXPIRED'"
    CALL OCOMO("SEL.CMD>":SEL.CMD)

    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
*CALL BATCH.BUILD.LIST(SEL.COMMAND,SEL.LIST )

RETURN
END
