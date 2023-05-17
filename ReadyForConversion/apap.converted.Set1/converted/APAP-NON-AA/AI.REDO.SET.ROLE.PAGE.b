SUBROUTINE AI.REDO.SET.ROLE.PAGE(ENQ.DATA)
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : AI.REDO.SET.ROLE.PAGE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_System

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*---------------
INITIALISE:
*---------------

    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.USR.VAR = ""
    END

    LOC.REF.APPLICATION="EB.EXTERNAL.USER"
    LOC.REF.FIELDS='PROD.USED':@VM
    Y.ROLE.PAGE = 'COS AI.REDO.ARC.CUSTOMER.POSITION'

RETURN

*---------------
OPEN.FILES:
*---------------

    FN.EXT.USER = 'F.EB.EXTERNAL.USER'
    F.EXT.USER = ''
    CALL OPF(FN.EXT.USER,F.EXT.USER)

RETURN

*---------------
PROCESS:
*---------------

    CALL CACHE.READ(FN.EXT.USER, Y.USR.VAR, R.EXT.USER, EXT.USER.ERR)

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.PROD.USED = LOC.REF.POS<1,1>
    Y.L.PROD.USED = R.EXT.USER<EB.XU.LOCAL.REF><1,POS.L.PROD.USED>

    IF Y.L.PROD.USED EQ 'CORPINPUT' THEN
        Y.ROLE.PAGE = 'COS AI.REDO.CORP.INP.MAIN.PAGE'
    END

    CALL System.setVariable("CURRENT.ROLE.PAGE",Y.ROLE.PAGE)

RETURN
END
