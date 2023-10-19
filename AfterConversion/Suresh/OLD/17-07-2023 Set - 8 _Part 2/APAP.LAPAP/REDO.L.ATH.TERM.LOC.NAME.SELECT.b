* @ValidationCode : MjotMjYwMDAzOTI3OkNwMTI1MjoxNjg5MzIxMzQ1ODUwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 13:25:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.L.ATH.TERM.LOC.NAME.SELECT

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.ATH.SETTLMENT
    $INSERT I_REDO.L.ATH.TERM.LOC.NAME.COMMON ;*R22 Auto Conversion - End

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    SEL.ATH = ''; SEL.LIST = ''; NO.OF.RECS = ''; SEL.ERR = ''
RETURN

PROCESS:
********
*   IF YSTART.DATE NE YEND.DATE THEN
*       SEL.ATH = "SELECT ":FN.REDO.ATH.SETTLMENT:" WITH PROCESS.DATE GE ":YSTART.DATE:" AND PROCESS.DATE LT ":YEND.DATE
*   END ELSE
* Updated to select and process all the record for extract purpose
    SEL.ATH = "SELECT ":FN.REDO.ATH.SETTLMENT:" WITH PROCESS.DATE GE ":YSTART.DATE
    CALL EB.READLIST(SEL.ATH,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
