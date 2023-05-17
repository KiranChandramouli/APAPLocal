*
*--------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.AZ.REP1.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
*
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.RIEN4.PARAM
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

    FN.DR.REG.RIEN4.PARAM = 'F.DR.REG.RIEN4.PARAM'
    F.DR.REG.RIEN4.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN4.PARAM,F.DR.REG.RIEN4.PARAM)

    FN.DR.REG.RIEN4.REP1.WORKFILE = 'F.DR.REG.RIEN4.REP1.WORKFILE'
    F.DR.REG.RIEN4.REP1.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN4.REP1.WORKFILE,F.DR.REG.RIEN4.REP1.WORKFILE)
*
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********

*  CALL F.READ(FN.DR.REG.RIEN4.PARAM,'SYSTEM',R.DR.REG.RIEN4.PARAM,F.DR.REG.RIEN4.PARAM,DR.REG.RIEN4.PARAM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.DR.REG.RIEN4.PARAM,'SYSTEM',R.DR.REG.RIEN4.PARAM,DR.REG.RIEN4.PARAM.ERR) ; * Tus End
    FN.CHK.DIR = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.OUT.PATH>

RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************

    OPEN.ERR = ''
    Y.DATE = TODAY
    EXTRACT.FILE.ID = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.FILE.NAME>:'-':Y.DATE:'.csv'
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID ELSE NULL          ;* In case if it exisit DELETE, for Safer side
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE        ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
        END
    END ELSE
        CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.RIEN4.AZ.REP1.POST")
    END

RETURN

*-------------------------------------------------------------------
PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.RIEN4.REP1.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    REP.HEADER = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.HEADER,1>
    WRITESEQ REP.HEADER TO FV.EXTRACT.FILE ELSE NULL
    REP.NAME = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.NAME,1>
    WRITESEQ REP.NAME TO FV.EXTRACT.FILE ELSE NULL
    REP.DATE = 'FECHA Y HORA : ':TIMEDATE()
    WRITESEQ REP.DATE TO FV.EXTRACT.FILE ELSE NULL
    REP.FIELDS = R.DR.REG.RIEN4.PARAM<RIEN4.PARAM.REP.FIELDS>
    CHANGE @VM TO '|' IN REP.FIELDS
    WRITESEQ REP.FIELDS TO FV.EXTRACT.FILE ELSE NULL

    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        CALL F.READ(FN.DR.REG.RIEN4.REP1.WORKFILE,REC.ID,R.DR.REG.RIEN4.REP1.WORKFILE,F.DR.REG.RIEN4.REP1.WORKFILE,DR.REG.RIEN4.REP1.WORKFILE.ERR)
        IF R.DR.REG.RIEN4.REP1.WORKFILE THEN
            CRLF = CHARX(013):CHARX(010)
            CHANGE @FM TO CRLF IN R.DR.REG.RIEN4.REP1.WORKFILE
            WRITESEQ R.DR.REG.RIEN4.REP1.WORKFILE TO FV.EXTRACT.FILE ELSE NULL
        END
    REPEAT
*
RETURN
*-------------------------------------------------------------------
END
