$PACKAGE APAP.TAM
*--------------------------------------------------------------------------------------------------------------------------------
* <Rating>-41</Rating>
*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.FD01.EXTRACT.NEW.POST
*-----------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*24/11/2023         Suresh             R22 Manual Conversion             T24.BP, REGREP.BP  File Removed, INCLUDE TO INSERT
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Manual Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.FD01.PARAM ;*R22 Manual Conversion - End
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

    FN.DR.REG.FD01.TDYWORKFILE = "F.DR.REG.FD01.TDYWORKFILE"
    F.DR.REG.FD01.TDYWORKFILE = ""
    CALL OPF(FN.DR.REG.FD01.TDYWORKFILE, F.DR.REG.FD01.TDYWORKFILE)
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
    EXTRACT.FILE.ID = R.DR.REG.FD01.PARAM<DR.FD01.PARAM.FILE.NAME>:'_':Y.DATE:'.MRI.txt'

    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN

PROCESS.PARA:
*************

    ID.LIST = ''; ID.POS = '' ;  ERR.SEL = ''; ID.CNT = '' ; R.REC = ''
    SEL.CMD = "SELECT ":FN.DR.REG.FD01.TDYWORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)

    SEQCOUNT = 0

    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        CALL F.READ(FN.DR.REG.FD01.TDYWORKFILE, REC.ID, R.REC, F.DR.REG.FD01.TDYWORKFILE, RD.ERR)
        IF R.REC THEN
            SEQCOUNT = 1 + SEQCOUNT

            R.FILE.DATA<-1> = SEQCOUNT :'|': R.REC



        END
    REPEAT
*
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END

RETURN
*-------------------------------------------------------------------
END
