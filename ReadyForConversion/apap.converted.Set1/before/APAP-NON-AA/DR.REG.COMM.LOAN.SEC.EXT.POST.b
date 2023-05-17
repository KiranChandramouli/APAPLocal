*
*--------------------------------------------------------------------------------------------------------------------------------
* <Rating>-30</Rating>
*--------------------------------------------------------------------------------------------------------------------------------
    SUBROUTINE DR.REG.COMM.LOAN.SEC.EXT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 03-Oct-2014  Ashokkumar           PACS00305229:- Displaying Credit lines details
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INCLUDE TAM.BP I_F.REDO.H.REPORTS.PARAM
*
    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
*
    RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.COM.LOAN.SECTOR.WORKFILE = 'F.DR.REG.COM.LOAN.SECTOR.WORKFILE'
    F.DR.REG.COM.LOAN.SECTOR.WORKFILE = ''
    CALL OPF(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,F.DR.REG.COM.LOAN.SECTOR.WORKFILE)
    Y.REPORT.PARAM.ID = 'REDO.SEC.COMMERCIAL'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    END
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:TODAY:'.txt'          ;* Parameterise
    R.FILE.DATA = ''
*
    R.FIL = ''
    FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
*
    RETURN
*-------------------------------------------------------------------
PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.COM.LOAN.SECTOR.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        R.REC = ''
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE, REC.ID, R.REC, F.DR.REG.COM.LOAN.SECTOR.WORKFILE, RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = R.REC
        END
        ID.CTR += 1
    REPEAT
*
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
*
    RETURN
*-------------------------------------------------------------------
END
