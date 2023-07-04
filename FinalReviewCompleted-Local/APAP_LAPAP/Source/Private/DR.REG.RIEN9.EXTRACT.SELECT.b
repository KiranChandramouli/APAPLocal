$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.RIEN9.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN9.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM and SEC.TRADE in DOP and non DOP.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 28-08-2014     V.P.Ashokkumar       PACS00313072- Filter to avoid ARC-IB records.
* 09-12-2014     V.P.Ashokkumar       PACS00313072- Removed the AUTH status.
* 10-02-2015     V.P.Ashokkumar       PACS00313072- Fixed the select problem
* 21-10-2016     V.P.Ashokkumar       R15 Upgrade
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE REGREP.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.RIEN9.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN9.PARAM


    GOSUB BUILD.CONTROL.LIST
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN9.WORKFILE, F.DR.REG.RIEN9.WORKFILE)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN9.WORKFILE.FCY, F.DR.REG.RIEN9.WORKFILE.FCY)
RETURN

SEL.PROCESS:
************
    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ 'LENDING'"

    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
RETURN

END
