* @ValidationCode : Mjo0ODk0MDk5Nzk6Q3AxMjUyOjE3MDI5ODgzNDQyNzc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     LAPAP.BP is Removed
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*15-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.AA.TC.MIG.DREPORT.SELECT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_L.APAP.AA.TC.MIG.DREPORT.COMMON ;*R22 Auto code conversion
    $USING EB.Service ;*R22 Manual Code Conversion_Utility Check


    GOSUB PROCESS
RETURN

PROCESS:
*********
    YJUL.DAY = R.DATES(EB.DAT.JULIAN.DATE)
    YJUL.DAY = YJUL.DAY[3,5]
*   CALL EB.CLEAR.FILE(FN.L.APAP.TC.MIG.WORKFILE,F.L.APAP.TC.MIG.WORKFILE)
    EB.Service.ClearFile(FN.L.APAP.TC.MIG.WORKFILE,F.L.APAP.TC.MIG.WORKFILE) ;*R22 Manual Code Conversion_Utility Check
    YDAY.PROCES = YLST.DAYS[3,6]
    SEL.CMD  = ''; SEL.AALST = ''; SEL.REC = ''; SEL.ERR = ''
    SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH @ID LIKE AA":YJUL.DAY:"..."
    CALL EB.READLIST(SEL.CMD,SEL.AALST,'',SEL.REC,SEL.ERR)
*   CALL BATCH.BUILD.LIST('',SEL.AALST)
    EB.Service.BatchBuildList('',SEL.AALST) ;*R22 Manual Code Conversion_Utility Check
RETURN
END
