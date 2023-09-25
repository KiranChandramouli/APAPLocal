* @ValidationCode : MjotODg0NTQxMDM6Q3AxMjUyOjE2ODk3NDQ1Njk1NjI6SVRTUzotMTotMTotMTY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.L.ATH.TERM.LOC.NAME.SELECT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
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
