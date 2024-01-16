* @ValidationCode : MjotNDIyMjEyMDk1OkNwMTI1MjoxNjkwMTY3NTM5ODA3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ASA.L.V.RT.SELECT

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT I_LAPAP.ASA.L.V.COMMON
   $USING EB.Service

    GOSUB DO.SELECT
RETURN

DO.SELECT:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.PA

    CALL OCOMO("COMANDO SELECCION: " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.REC)
EB.Service.BatchBuildList('',SEL.REC);* R22 UTILITY AUTO CONVERSION

RETURN


END
