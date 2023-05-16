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
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.RIEN6.EXTRACT.COMMON

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN6.WORKFILE, F.DR.REG.RIEN6.WORKFILE)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN6.WORKFILE.FCY, F.DR.REG.RIEN6.WORKFILE.FCY)
    SEL.CMD = ''; Y.SEL.CNT = ''; Y.ERR = ''; BUILD.LIST = ''
    SEL.CMD = "SELECT ":FN.AZ.ACCOUNT
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    SEL.CMD = ''; Y.SEL.CNT = ''; Y.ERR = ''; ACCTCL.LIST = ''
    SEL.CMD = "SELECT ":FN.ACCOUNT.CLOSURE:" WITH DATE.TIME[1,6] EQ ":Y.DTE.SEL
    CALL EB.READLIST(SEL.CMD,ACCTCL.LIST,'',Y.SEL.CNT,Y.ERR)
    IF ACCTCL.LIST THEN
        BUILD.LIST<-1> = ACCTCL.LIST
    END
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN

END
