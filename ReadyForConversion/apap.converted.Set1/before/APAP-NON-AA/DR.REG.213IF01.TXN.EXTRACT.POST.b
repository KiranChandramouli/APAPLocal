*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.213IF01.TXN.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 3-May-2013        Gangadhar.S.V.            Initial Version
* 28-Jul-2014        V.P.Ashokkumar            PACS00309079 - Updated the field format
* 14-Oct-2014        V.P.Ashokkumar            PACS00309079 - Updated to filter AML transaction
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INCLUDE REGREP.BP I_F.DR.REG.213IF01.PARAM
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB PROCESS.PARA
    RETURN

OPEN.FILES:
***********
    FN.DR.REG.213IF01.PARAM = 'F.DR.REG.213IF01.PARAM'
    F.DR.REG.213IF01.PARAM = ''
    CALL OPF(FN.DR.REG.213IF01.PARAM, F.DR.REG.213IF01.PARAM)

    FN.DR.REG.213IF01.WORKFILE = "F.DR.REG.213IF01.WORKFILE"
    F.DR.REG.213IF01.WORKFILE = ""
    CALL OPF(FN.DR.REG.213IF01.WORKFILE,F.DR.REG.213IF01.WORKFILE)
    RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********
    R.DR.REG.213IF01.PARAM = ''; DR.REG.213IF01.PARAM.ERR = ''
    CALL CACHE.READ(FN.DR.REG.213IF01.PARAM, "SYSTEM", R.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)
    FN.CHK.DIR = R.DR.REG.213IF01.PARAM<DR.213IF01.OUT.PATH>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    EXTRACT.FILE.ID = R.DR.REG.213IF01.PARAM<DR.213IF01.FILE.NAME>:Y.TODAY:'.txt'
    RETURN

PROCESS.PARA:
*************

    RETURN.ARR = ''
    SEL.CMD = "SELECT ":FN.DR.REG.213IF01.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        REC.ID = ''
        REC.ID = ID.LIST<ID.CTR>
        R.REC = ''; RD.ERR = ''
        CALL F.READ(FN.DR.REG.213IF01.WORKFILE, REC.ID, R.REC, F.DR.REG.213IF01.WORKFILE, RD.ERR)
        IF R.REC THEN
            SEQ.NO = FMT(ID.CTR,"R%7")
            RETURN.ARR<-1> = SEQ.NO:R.REC
*            WRITESEQ R.REC TO FV.EXTRACT.FILE ELSE NULL
        END
        ID.CTR += 1
    REPEAT
*
    CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILE.ID,RETURN.ARR)

    R.DR.REG.213IF01.PARAM<DR.213IF01.REP.END.DATE> = ''
    R.DR.REG.213IF01.PARAM<DR.213IF01.REP.START.DATE> = ''
    CALL F.WRITE(FN.DR.REG.213IF01.PARAM,"SYSTEM",R.DR.REG.213IF01.PARAM)
    RETURN
*-------------------------------------------------------------------
END
