* @ValidationCode : Mjo4NTY3NzI3Mzg6Q3AxMjUyOjE2ODkyNDUxNjAwNjE6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 16:16:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.MASSIVE.FILE.PROCESS.LOAD
*------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       VM to @VM, BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON                                          ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_L.APAP.MASSIVE.FILE.PROCESS.COMMON               ;*R22 Auto conversion - End

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
    LOC.REF.FIELDS='L.AA.LST.REV.DT':@VM:'L.AA.NXT.REV.DT':@VM:'L.AA.RT.RV.FREQ'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.LST.REV.DT = LOC.REF.POS<1,1>
    POS.L.AA.NXT.REV.DT = LOC.REF.POS<1,2>
    POS.L.AA.RT.RV.FREQ = LOC.REF.POS<1,3>

    Y.APPL = 'ACCOUNT'
    Y.FLD = 'L.OD.STATUS':@VM:'L.OD.STATUS.2'
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
