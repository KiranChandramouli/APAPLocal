* @ValidationCode : MjoxNzA3NDUyNTEyOkNwMTI1MjoxNzAyOTg4MzQyNzg2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:02
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
SUBROUTINE DR.REG.RIEN6.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN6.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AZ.ACCOUNT in DOP and non DOP
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 15/09/2014    V.P.Ashokkumar        PACS00312508 - Removed the filter check
* 15/10/2014    V.P.Ashokkumar        PACS00312508 - Replaced the ACCOUNT with AZ.ACCOUNT file.
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023         Santosh C             MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_DR.REG.RIEN6.EXTRACT.COMMON
    $USING EB.Service

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*R22 Manual Code Conversion_Utility Check-Start
*   CALL EB.CLEAR.FILE(FN.DR.REG.RIEN6.WORKFILE, F.DR.REG.RIEN6.WORKFILE)
*   CALL EB.CLEAR.FILE(FN.DR.REG.RIEN6.WORKFILE.FCY, F.DR.REG.RIEN6.WORKFILE.FCY)
    EB.Service.ClearFile(FN.DR.REG.RIEN6.WORKFILE, F.DR.REG.RIEN6.WORKFILE)
    EB.Service.ClearFile(FN.DR.REG.RIEN6.WORKFILE.FCY, F.DR.REG.RIEN6.WORKFILE.FCY)
*R22 Manual Code Conversion_Utility Check-End

    SEL.CMD = ''; Y.SEL.CNT = ''; Y.ERR = ''; BUILD.LIST = ''
    SEL.CMD = "SELECT ":FN.AZ.ACCOUNT
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    SEL.CMD = ''; Y.SEL.CNT = ''; Y.ERR = ''; ACCTCL.LIST = ''
    SEL.CMD = "SELECT ":FN.ACCOUNT.CLOSURE:" WITH DATE.TIME[1,6] EQ ":Y.DTE.SEL
    CALL EB.READLIST(SEL.CMD,ACCTCL.LIST,'',Y.SEL.CNT,Y.ERR)
    IF ACCTCL.LIST THEN
        BUILD.LIST<-1> = ACCTCL.LIST
    END
*   CALL BATCH.BUILD.LIST('',BUILD.LIST)
    EB.Service.BatchBuildList('',BUILD.LIST) ;*R22 Manual Code Conversion_Utility Check
RETURN

END
