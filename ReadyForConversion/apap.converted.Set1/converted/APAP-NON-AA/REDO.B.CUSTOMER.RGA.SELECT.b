SUBROUTINE REDO.B.CUSTOMER.RGA.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
**-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .SELECT Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CUSTOMER.RGA.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.DATES
    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:

    FN.CHK.DIR=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    R.FIL = ''; READ.FIL.ERR = ''
    Y.LWD = R.DATES(EB.DAT.LAST.WORKING.DAY)
    EXTRACT.FILE.ID=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:Y.LWD:'.txt'
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END

    SEL.CMD = "SELECT ":FN.CUSTOMER
    LIST.REC = ''
    NO.OF.CUS = ''
    CUS.ERR = ''
    CALL EB.READLIST(SEL.CMD,LIST.REC,'',NO.OF.CUS,CUS.ERR)

    CALL BATCH.BUILD.LIST("",LIST.REC)
RETURN
END
