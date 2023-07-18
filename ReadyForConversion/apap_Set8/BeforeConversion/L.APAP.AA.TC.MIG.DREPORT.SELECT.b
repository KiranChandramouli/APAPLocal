*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.AA.TC.MIG.DREPORT.SELECT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT LAPAP.BP I_L.APAP.AA.TC.MIG.DREPORT.COMMON


    GOSUB PROCESS
    RETURN

PROCESS:
*********
    YJUL.DAY = R.DATES(EB.DAT.JULIAN.DATE)
    YJUL.DAY = YJUL.DAY[3,5]
    CALL EB.CLEAR.FILE(FN.L.APAP.TC.MIG.WORKFILE,F.L.APAP.TC.MIG.WORKFILE)
    YDAY.PROCES = YLST.DAYS[3,6]
    SEL.CMD  = ''; SEL.AALST = ''; SEL.REC = ''; SEL.ERR = ''
    SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH @ID LIKE AA":YJUL.DAY:"..."
    CALL EB.READLIST(SEL.CMD,SEL.AALST,'',SEL.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.AALST)
    RETURN
END
