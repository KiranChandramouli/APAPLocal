$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.PEPS.TXN.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.PEPS.TXN.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 10000 USD made by individual customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 15-Aug-2014     V.P.Ashokkumar       PACS00396224 - Initial Release
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND LAPAP.BP TO $INSERT AND $INSERT TAM.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON  ;*R22 AUTO CONVERSTION $INSERT T24.BP TO $INSERT
    $INSERT I_EQUATE  ;*R22 AUTO CONVERSTION $INSERT T24.BP TO $INSERT
    $INSERT I_BATCH.FILES ;*R22 AUTO CONVERSTION $INSERT T24.BP TO $INSERT
    $INSERT I_F.DATES  ;*R22 AUTO CONVERSTION $INSERT T24.BP TO $INSERT
    $INSERT I_DR.REG.PEPS.TXN.EXTRACT.COMMON  ;*R22 AUTO CONVERSTION $INSERT LAPAP.BP TO $INSERT
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*R22 AUTO CONVERSTION $INSERT TAM.BP TO $INSERT


    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*
* Clear workfile before build for this run.
    CALL EB.CLEAR.FILE(FN.DR.REG.PEPS.WORKFILE,F.DR.REG.PEPS.WORKFILE)
*
    SEL.CMD = "SELECT ":FN.DR.REG.213IF01.CONCAT:" WITH CUST.RELATION EQ 'PEP' AND WITH CR.DATE GE ":YST.DAT:" AND CR.DATE LE ":YED.DAT:" BY @ID"
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN

END
