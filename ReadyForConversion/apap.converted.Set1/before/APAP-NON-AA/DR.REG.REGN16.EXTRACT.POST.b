*--------------------------------------------------------------------------------------------------------------------------------
* <Rating>-43</Rating>
*--------------------------------------------------------------------------------------------------------------------------------
    SUBROUTINE DR.REG.REGN16.EXTRACT.POST
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 05-09-2014        Ashokkumar                PACS00366332- Updated to remove the date field in param file.
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INCLUDE REGREP.BP I_F.DR.REG.REGN16.EXT.PARAM
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB OPEN.EXTRACT.FILE
    GOSUB PROCESS.PARA
    RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.DR.REG.REGN16.EXT.PARAM = 'F.DR.REG.REGN16.EXT.PARAM'
    F.DR.REG.REGN16.EXT.PARAM = ''
    CALL OPF(FN.DR.REG.REGN16.EXT.PARAM,F.DR.REG.REGN16.EXT.PARAM)

    FN.DR.REG.REGN16.WORKFILE = "F.DR.REG.REGN16.WORKFILE"
    FV.DR.REG.REGN16.WORKFILE = ""
    CALL OPF(FN.DR.REG.REGN16.WORKFILE, FV.DR.REG.REGN16.WORKFILE)
    RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********

    ERR.DR.REG.REGN16.EXT.PARAM = ''; R.DR.REG.REGN16.EXT.PARAM = ''
    CALL CACHE.READ(FN.DR.REG.REGN16.EXT.PARAM,'SYSTEM',R.DR.REG.REGN16.EXT.PARAM,ERR.DR.REG.REGN16.EXT.PARAM)
    FN.CHK.DIR = R.DR.REG.REGN16.EXT.PARAM<DR.REGN16.OUT.PATH>
    RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = ''
    Y.DATE = TODAY
    REP.PERIOD = Y.DATE[5,2]:Y.DATE[1,4]
    EXTRACT.FILE.ID = R.DR.REG.REGN16.EXT.PARAM<DR.REGN16.FILE.NAME>:REP.PERIOD:'.txt'
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID THEN
        END ELSE
            NULL    ;* In case if it exisit DELETE, for Safer side
        END
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE    ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE THEN
            END ELSE
                OPEN.ERR = 1
            END
        END
    END ELSE
        CREATE FV.EXTRACT.FILE THEN
        END ELSE
            OPEN.ERR = 1
        END
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.REGN16.EXTRACT.POST")
    END
    RETURN

PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.DR.REG.REGN16.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)

    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        R.REC = ''
        CALL F.READ(FN.DR.REG.REGN16.WORKFILE, REC.ID, R.REC, FV.DR.REG.REGN16.WORKFILE, RD.ERR)
        IF R.REC THEN
            CRLF = CHARX(013):CHARX(010)
            CHANGE FM TO CRLF IN R.REC
            WRITESEQ R.REC TO FV.EXTRACT.FILE THEN
            END ELSE
                NULL
            END
        END
    REPEAT
*
    R.DR.REG.REGN16.EXT.PARAM<DR.REGN16.START.DATE> = ''
    R.DR.REG.REGN16.EXT.PARAM<DR.REGN16.END.DATE> = ''
    CALL F.WRITE(FN.DR.REG.REGN16.EXT.PARAM,'SYSTEM',R.DR.REG.REGN16.EXT.PARAM)
    RETURN
*-------------------------------------------------------------------
END
