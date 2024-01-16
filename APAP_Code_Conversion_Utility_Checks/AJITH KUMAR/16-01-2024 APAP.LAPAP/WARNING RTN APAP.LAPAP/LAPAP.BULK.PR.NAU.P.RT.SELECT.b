* @ValidationCode : MjotMTI0OTE0NjQ0NDpDcDEyNTI6MTY5MTY0ODgwNDQ1NjpJVFNTOi0xOi0xOi01OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Aug 2023 11:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE LAPAP.BULK.PR.NAU.P.RT.SELECT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 09-AUG-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.DATES
    $INSERT I_F.LAPAP.BULK.PAYROLL
    $INSERT I_F.ST.LAPAP.BULK.PAYROLL.DET
    $INSERT I_LAPAP.BULK.PR.NAU.P.RT.COMMON
   $USING EB.Service

    GOSUB GET.IHLD.FT

RETURN

GET.IHLD.FT:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.FTNAU : " WITH @ID LIKE FT" : Y.JULIAN.DATE : "... AND RECORD.STATUS EQ IHLD"

    CALL OCOMO("RUNNING WITH SELECT LIST : " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.REC)
EB.Service.BatchBuildList('',SEL.REC);* R22 UTILITY AUTO CONVERSION

RETURN
END
