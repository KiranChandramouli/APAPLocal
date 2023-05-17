SUBROUTINE DR.REG.FD01.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 2-June-2013       Gangadhar.S.V.            Initial version.
* 14-May-2015       Ashokkumar.V.P            PACS00309078 - New field added FLD15 & 16.
*-------------------------------------------------------------------------

    $INSERT I_COMMON
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

    FN.DR.REG.FD01.WORKFILE = "F.DR.REG.FD01.WORKFILE"
    F.DR.REG.FD01.WORKFILE = ""
    CALL OPF(FN.DR.REG.FD01.WORKFILE, F.DR.REG.FD01.WORKFILE)
*
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********

    R.DR.REG.FD01.PARAM = ''; DR.REG.FD01.PARAM.ERR = ''
    CALL CACHE.READ(FN.DR.REG.FD01.PARAM,'SYSTEM',R.DR.REG.FD01.PARAM,DR.REG.FD01.PARAM.ERR)

    FN.CHK.DIR = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.OUT.PATH>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    R.FILE.DATA = ''
RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = '' ; EXTRACT.FILE.ID = '' ; READ.FIL.ERR = '' ; R.FIL = ''
    Y.DATE = TODAY
    EXTRACT.FILE.ID = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.FILE.NAME>:'_':Y.DATE:'.txt'

    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN

PROCESS.PARA:
*************

    ID.LIST = ''; ID.POS = '' ;  ERR.SEL = ''; ID.CNT = '' ; R.REC = ''
    SEL.CMD = "SELECT ":FN.DR.REG.FD01.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        CALL F.READ(FN.DR.REG.FD01.WORKFILE, REC.ID, R.REC, F.DR.REG.FD01.WORKFILE, RD.ERR)
        IF R.REC THEN
**           CRLF = CHARX(013):CHARX(010)
**            CHANGE FM TO CRLF IN R.REC
            R.FILE.DATA<-1> = R.REC
        END
    REPEAT
*
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END

RETURN
*-------------------------------------------------------------------
END
