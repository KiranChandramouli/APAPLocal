SUBROUTINE REDO.V.AUTH.TXN.REFER.IMAGE
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at Auth Level for the Following version of
* AA.ARRANGEMENT.ACTIVITY,APAP. This Routine is used store the arrangement id into the
* local template REDO.CREATE.ARRANGEMENT
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
* Linked : AA.ARRANGEMENT.ACTIVITY
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Arulprakasam P
* PROGRAM NAME : REDO.V.AUTH.TXN.REFER
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 07.01.2011      Marcelo G        ODR-2010-11-0067    INITIAL CREATION
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.IM.DOCUMENT.IMAGE


    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

**********
OPENFILES:
**********
    ID.IM = ID.NEW
    Y.IMG.ID = R.NEW(IM.DOC.SHORT.DESCRIPTION)
    Y.TXN.ID = R.NEW(IM.DOC.DESCRIPTION)

RETURN

********
PROCESS:
********

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)


*IM.DOCUMENT.UPLOAD
    Y.VERSION.NAME = "IM.DOCUMENT.UPLOAD,APAP"
    OFS.USER.PWD = ""
    Y.OFS.BODY =  ID.IM:',UPLOAD.ID=':ID.IM:',FILE.UPLOAD=':Y.IMG.ID
    GOSUB PROCESS.OFS.MESSAGE

    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,Y.TXN.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,REDO.CREATE.ARRANGEMENT.ERR)

    Y.IMG.IDS = R.REDO.CREATE.ARRANGEMENT<REDO.FC.IMG.ID>
    Y.COUNT.IMG = DCOUNT(Y.IMG.IDS,@VM)
* Create registers in IM.DOCUMENT.IMAGE and IM.DOCUMENT.UPDATE
    FOR Y.I = 1 TO Y.COUNT.IMG
        LOCATE Y.IMG.ID IN R.REDO.CREATE.ARRANGEMENT<REDO.FC.IMG.ID, Y.I> SETTING POS.IMG THEN
            R.REDO.CREATE.ARRANGEMENT<REDO.FC.IMG.ID, POS.IMG> = ID.IM
        END
    NEXT Y.I

    CALL F.WRITE(FN.REDO.CREATE.ARRANGEMENT,Y.TXN.ID,R.REDO.CREATE.ARRANGEMENT)

RETURN
******************
PROCESS.OFS.MESSAGE:
******************
    VERSION.NAME = Y.VERSION.NAME
    OFS.USER.PWD = ""
    OFS.MSG.HEADER = VERSION.NAME:'/I/PROCESS,/,'
    OFS.BODY = Y.OFS.BODY
    OFS.MSG = OFS.MSG.HEADER:OFS.BODY


    OFS.STR = OFS.MSG
    OFS.MSG.IDD = ''
    OFS.SRC = 'APAP.B.180.OFS'
    OPTIONS = ''

    CALL OFS.POST.MESSAGE(OFS.STR,OFS.MSG.IDD,OFS.SRC,OPTIONS)

RETURN


END
