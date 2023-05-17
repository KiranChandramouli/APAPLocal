*--------------------------------------------------------------------------------------------------------------------------------
* <Rating>-51</Rating>
*--------------------------------------------------------------------------------------------------------------------------------
    SUBROUTINE DR.REG.FD03.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date          Author                    Description
* ==========    ====================      ============
* 02-Aug-2014  Ashokkumar.V.P           PACS00316981 - Corrected the fields based on mapping.
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INCLUDE REGREP.BP I_F.DR.REG.FD03.PARAM
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

    FN.DR.REG.FD03.PARAM = 'F.DR.REG.FD03.PARAM'
    F.DR.REG.FD03.PARAM = ''
    CALL OPF(FN.DR.REG.FD03.PARAM, F.DR.REG.FD03.PARAM)

    FN.DR.REG.FD03.WORKFILE = "F.DR.REG.FD03.WORKFILE"
    FV.DR.REG.FD03.WORKFILE = ""
    CALL OPF(FN.DR.REG.FD03.WORKFILE, FV.DR.REG.FD03.WORKFILE)
*
    RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********
    LAST.WDAY = ''; REP.END.DATE = ''; R.DR.REG.FD03.PARAM = ''
    FN.CHK.DIR = ''; YFILE.NAME = '';DR.REG.FD03.PARAM.ERR = ''
    CALL CACHE.READ(FN.DR.REG.FD03.PARAM, "SYSTEM", R.DR.REG.FD03.PARAM, DR.REG.FD03.PARAM.ERR)
    REP.END.DATE = R.DR.REG.FD03.PARAM<DR.FD03.PARAM.REP.END.DATE>
    YFILE.NAME = R.DR.REG.FD03.PARAM<DR.FD03.PARAM.FILE.NAME>
    FN.CHK.DIR = R.DR.REG.FD03.PARAM<DR.FD03.PARAM.OUT.PATH>
    IF NOT(REP.END.DATE) THEN
        LAST.WDAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
        CALL CDT('',LAST.WDAY,'+1C')
        REP.END.DATE = LAST.WDAY
    END
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = ''; R.FIL = ''; READ.FIL.ERR = ''
    EXTRACT.FILE.ID = YFILE.NAME:'_':TODAY:'.txt' ;* Parameterise
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
    RETURN

*-------------------------------------------------------------------
PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.FD03.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        R.REC = ''; RD.ERR = ''
        CALL F.READ(FN.DR.REG.FD03.WORKFILE, REC.ID, R.REC, FV.DR.REG.FD03.WORKFILE, RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = R.REC
        END
    REPEAT

    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
*
    R.DR.REG.FD03.PARAM<DR.FD03.PARAM.REP.START.DATE> = ''
    R.DR.REG.FD03.PARAM<DR.FD03.PARAM.REP.END.DATE> = ''
    R.DR.REG.FD03.PARAM<DR.FD03.PARAM.LAST.RUN.DATE> = REP.END.DATE
    CALL F.WRITE(FN.DR.REG.FD03.PARAM,'SYSTEM',R.DR.REG.FD03.PARAM)
    RETURN
*-------------------------------------------------------------------
END
