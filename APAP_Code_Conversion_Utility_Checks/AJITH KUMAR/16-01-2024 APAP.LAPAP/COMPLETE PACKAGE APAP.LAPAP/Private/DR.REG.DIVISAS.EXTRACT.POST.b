* @ValidationCode : MjotNDMzNDg5OTkyOkNwMTI1MjoxNzAyOTg4MzQxNDIwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:01
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
SUBROUTINE DR.REG.DIVISAS.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 05-Dec-2017  Ashokkumar.V.P      CN007023 - Initial Version.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FMto@FM , T24.BP is removed,REGREP.BP is removed
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14-12-2023       Santosh C                   MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------

*-------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.FD01.PARAM
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB OPEN.EXTRACT.FILE
    GOSUB PROCESS.PARA
*
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.DR.REG.FD01.PARAM = 'F.DR.REG.FD01.PARAM'
    F.DR.REG.FD01.PARAM = ''
    CALL OPF(FN.DR.REG.FD01.PARAM,F.DR.REG.FD01.PARAM)

    FN.DR.REG.DIVIAS.WORKFILE = "F.DR.REG.DIVIAS.WORKFILE"
    F.DR.REG.DIVIAS.WORKFILE = ""
    CALL OPF(FN.DR.REG.DIVIAS.WORKFILE, F.DR.REG.DIVIAS.WORKFILE)
*
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********

    R.DR.REG.FD01.PARAM = ''; DR.REG.FD01.PARAM.ERR = ''
*   CALL CACHE.READ(FN.DR.REG.FD01.PARAM,'SYSTEM',R.DR.REG.FD01.PARAM,DR.REG.FD01.PARAM.ERR)
    Y.SYS.ID = 'SYSTEM' ;*R22 Manual Code Conversion_Utility Check
    CALL CACHE.READ(FN.DR.REG.FD01.PARAM, Y.SYS.ID,R.DR.REG.FD01.PARAM,DR.REG.FD01.PARAM.ERR)

    FN.CHK.DIR = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.OUT.PATH>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    R.FILE.DATA = ''
RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = '' ; EXTRACT.FILE.ID = '' ; READ.FIL.ERR = '' ; R.FIL = ''
    Y.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.DATE = Y.DATE[7,2]:Y.DATE[5,2]:Y.DATE[1,4]
    EXTRACT.FILE.ID = 'AR012':Y.DATE:'.txt'

    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN

PROCESS.PARA:
*************

    ID.LIST = ''; ID.POS = '' ;  ERR.SEL = ''; ID.CNT = ''
    R.REC = ''; YSEQ.FLAG = 1
    SEL.CMD = "SELECT ":FN.DR.REG.DIVIAS.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        CALL F.READ(FN.DR.REG.DIVIAS.WORKFILE, REC.ID, R.REC, F.DR.REG.DIVIAS.WORKFILE, RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = YSEQ.FLAG:'|':R.REC:'|'
            YSEQ.FLAG += 1
        END
    REPEAT
*
    CRLF = CHARX(013):CHARX(010)
    CHANGE @FM TO CRLF IN R.FILE.DATA
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END

RETURN
*-------------------------------------------------------------------
END
