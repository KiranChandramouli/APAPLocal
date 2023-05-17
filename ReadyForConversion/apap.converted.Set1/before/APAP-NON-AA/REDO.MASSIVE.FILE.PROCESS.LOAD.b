*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.MASSIVE.FILE.PROCESS.LOAD
*------------------------------------------------------------
* Description: This is single threaded routine to process the 
* massive rate file.

* Modification History :
*-----------------------
* DATE             WHO                REFERENCE              DESCRIPTION
* 10 Sep 2011     H Ganesh         Massive rate - B.16      INITIAL CREATION
* 10 Oct 2017     D Edwin Charles  Reprice(Interest Rate change)
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.MASSIVE.FILE.PROCESS.COMMON

    GOSUB PROCESS

    RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    FN.REDO.MASSIVE.FILE.PATH = 'F.REDO.MASSIVE.FILE.PATH'
    F.REDO.MASSIVE.FILE.PATH = ''
    CALL OPF(FN.REDO.MASSIVE.FILE.PATH,F.REDO.MASSIVE.FILE.PATH)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    LOC.REF.APPLICATION="AA.PRD.DES.INTEREST"
    LOC.REF.FIELDS='L.AA.LST.REV.DT':VM:'L.AA.NXT.REV.DT':VM:'L.AA.RT.RV.FREQ'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.LST.REV.DT = LOC.REF.POS<1,1>
    POS.L.AA.NXT.REV.DT = LOC.REF.POS<1,2>
    POS.L.AA.RT.RV.FREQ = LOC.REF.POS<1,3>

    Y.APPL = 'ACCOUNT'
    Y.FLD = 'L.OD.STATUS':VM:'L.OD.STATUS.2'
    POS.D = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,POS.D)
    Y.POS.OVR.1 = POS.D<1,1>
    Y.POS.OVR.2 = POS.D<1,2>

    * PACS00761324 START
    * -----------------------------------------------------------
    FN.REDO.MASSIVE.CONCAT = 'FBNK.REDO.MASSIVE.CONCAT'
    F.REDO.MASSIVE.CONCAT = ''
    CALL OPF(FN.REDO.MASSIVE.CONCAT, F.REDO.MASSIVE.CONCAT)

    FN.REDO.MASSIVE.CONCAT.EX = 'FBNK.REDO.MASSIVE.CONCAT.EX'
    F.REDO.MASSIVE.CONCAT.EX = ''
    CALL OPF(FN.REDO.MASSIVE.CONCAT.EX, F.REDO.MASSIVE.CONCAT.EX)
    * -----------------------------------------------------------
    * PACS00761324 END

    CALL CACHE.READ(FN.REDO.MASSIVE.FILE.PATH,'SYSTEM',R.FILE.DETAILS,Y.REDO.MASSIVE.FILE.PATH.ERR)

    RETURN
END
